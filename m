Return-Path: <linux-kernel-owner+w=401wt.eu-S1757742AbXKTCHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbXKTCHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758610AbXKTBxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:53:52 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2197 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759507AbXKTBxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:53:48 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 45/59] drivers/serial: Add missing "space"
Date: Mon, 19 Nov 2007 17:53:32 -0800
Message-Id: <1195523627-15389-3-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523627-15389-2-git-send-email-joe@perches.com>
References: 1234567
 <1195523627-15389-1-git-send-email-joe@perches.com>
 <1195523627-15389-2-git-send-email-joe@perches.com>
Message-Id: <03356091a4d026aa495102d7da9509feffa4b2d8.1195454436.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/serial/mpc52xx_uart.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/mpc52xx_uart.c b/drivers/serial/mpc52xx_uart.c
index ec36ad7..2fe8a7d 100644
--- a/drivers/serial/mpc52xx_uart.c
+++ b/drivers/serial/mpc52xx_uart.c
@@ -333,7 +333,7 @@ mpc52xx_uart_set_termios(struct uart_port *port, struct ktermios *new,
 
 	if (!j)
 		printk(	KERN_ERR "mpc52xx_uart.c: "
-			"Unable to flush RX & TX fifos in-time in set_termios."
+			"Unable to flush RX & TX fifos in-time in set_termios. "
 			"Some chars may have been lost.\n" );
 
 	/* Reset the TX & RX */
-- 
1.5.3.5.652.gf192c

