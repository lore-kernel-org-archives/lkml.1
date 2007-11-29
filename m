Return-Path: <linux-kernel-owner+w=401wt.eu-S933106AbXK2SSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106AbXK2SSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932969AbXK2SRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:17:12 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:59915 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932965AbXK2SRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:17:09 -0500
Date: Thu, 29 Nov 2007 19:17:04 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC update
Message-ID: <20071129191704.6151294a@poseidon.drzeus.cx>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.2; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus

to receive the following updates:

 drivers/mmc/card/sdio_uart.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Andre Haupt (1):
      sdio_uart: fix sign of paramter status in sdio_uart_receive_chars()

diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index d552de6..eeea84c 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -386,7 +386,7 @@ static void sdio_uart_stop_rx(struct sdio_uart_port *port)
        sdio_out(port, UART_IER, port->ier);
 }
 
-static void sdio_uart_receive_chars(struct sdio_uart_port *port, int *status)
+static void sdio_uart_receive_chars(struct sdio_uart_port *port, unsigned int *status)
 {
        struct tty_struct *tty = port->tty;
        unsigned int ch, flag;



-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
