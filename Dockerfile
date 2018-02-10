FROM alpine

MAINTAINER xuqplus

RUN apk --update add bash openvpn && \
        cd /etc/openvpn && \
        openvpn --genkey --secret secret.key && \
        echo -e 'dev tun\nport 1194\nproto tcp-server\nifconfig 10.8.0.1 10.8.0.2\nsecret secret.key\n\
cipher AES-256-CBC\nkeepalive 10 60\npersist-key\npersist-tun\ncomp-lzo\nstatus /etc/openvpn/openvpn-status.log\nverb 3' > server.conf && \
        echo -e 'dev tun\nproto tcp-client\nifconfig 10.8.0.2 10.8.0.1\nremote vpn.xuqplus.space 1194\n\
auth-nocache\nsecret secret.key\ncipher AES-256-CBC\ncomp-lzo\nverb 3\n#redirect-gateway def1\n#dhcp-option DNS 8.8.8.8\n#dhcp-option DNS 8.8.4.4' > client.conf && \
        rm -rf /var/cache/apk/*

COPY source/start /

EXPOSE 1194

CMD /bin/bash /start
