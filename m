Return-Path: <linux-kernel-owner+w=401wt.eu-S1758492AbYLEKXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492AbYLEKXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 05:23:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbYLEKVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 05:21:00 -0500
Received: from vps1.tull.net ([66.180.172.116]:47112 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752949AbYLEKU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 05:20:58 -0500
Mail-From: nobody Fri Dec  5 14:08:04 2008
From: Nick Andrew <nick@nick-andrew.net>
Subject: [PATCH] Fix incorrect use of loose in mpc52xx_uart.c
To: Grant Likely <grant.likely@secretlab.ca>,
       John Rigby <jrigby@freescale.com>, Nick Andrew <nick@nick-andrew.net>,
       Paul Mackerras <paulus@samba.org>, Takashi Iwai <tiwai@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Nick Andrew <nick@nick-andrew.net>
Date: Fri, 05 Dec 2008 14:08:04 +1100
Message-ID: <20081205030804.32141.44485.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix incorrect use of loose in mpc52xx_uart.c

It should be 'lose', not 'loose'. Also fix a spelling error on
the next line.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 drivers/serial/mpc52xx_uart.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/serial/mpc52xx_uart.c b/drivers/serial/mpc52xx_uart.c
index 6117d3d..28c00c3 100644
--- a/drivers/serial/mpc52xx_uart.c
+++ b/drivers/serial/mpc52xx_uart.c
@@ -591,8 +591,8 @@ mpc52xx_uart_set_termios(struct uart_port *port, struct ktermios *new,
 	/* Update the per-port timeout */
 	uart_update_timeout(port, new->c_cflag, baud);
 
-	/* Do our best to flush TX & RX, so we don't loose anything */
-	/* But we don't wait indefinitly ! */
+	/* Do our best to flush TX & RX, so we don't lose anything */
+	/* But we don't wait indefinitely ! */
 	j = 5000000;	/* Maximum wait */
 	/* FIXME Can't receive chars since set_termios might be called at early
 	 * boot for the console, all stuff is not yet ready to receive at that


