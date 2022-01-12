FROM alpine:3.14

RUN apk update && \
    apk add bash openssh && \
    ssh-keygen -A && \
    rm -rf /var/cache/apk/*

EXPOSE 22

RUN addgroup -S x && \
    adduser -D -S -G x -s /bin/ash x && \
    sed -i -e "s/^x:!:/x:*:/" /etc/shadow

USER x

RUN mkdir -p ~/.ssh && chmod 700 ~/.ssh/

RUN echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC41FuYVyNRFqwoEt90QlU1huJDJh9/r+wVrb+KfjXf9XbwPX2FyXRSCLWw/nAutx53oZ6xWGVQNkwmIdeXgVqLJX2cXGwIlGxigiz1cnBq8glpXWki/n5zNdHvvGYK9GYTdgQ4wJdZRaFkxGekJkCdbosfavcvRk0xl64sic+yu+cQ11JLTaiUvxz+hnU6aQd+L1sq3MMY/sD5tZQI/cAsRIi/nXeISqk9kdXziQZ5du3//BTgdkxxWwEwUvGoRnNCiibetsSID+/jgDkSRv2VpHpTWlLJe7gTmAmRFI7bPa+IKZ0byfWC4UFeFLErrfWnJxY5w9Dm+f8CwjCDt19kQx9dH94qKpoQ58VY1E/TnZFvigsiSxDGDi/2LevQA6eEJqoqYtPcotBKmryvskOWReKElYkn5T4j/NDbHu4KP2CeeYEvCyI2ABLKh3dNHXGe12ywv3Fs8Twys18KaZL5RBrQDEjrjX9wRTEYfACLdVffvG8PNR3ogLnHAnpoljs= jack@x' > ~/.ssh/authorized_keys

USER root

COPY entry.sh /entry.sh

ENTRYPOINT ["/entry.sh"]
CMD ["/usr/sbin/sshd", "-D", "-e"]
