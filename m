Return-Path: <linux-kernel-owner+w=401wt.eu-S1757175AbYCJWKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175AbYCJWKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbYCJWKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:10:37 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47352 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751316AbYCJWKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:10:36 -0400
Date: Mon, 10 Mar 2008 21:57:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, jeff@garzik.org, linux-kernel@vger.kernel.org
Subject: [PATCH] 3c501: Further coding style fixes
Message-ID: <20080310215720.4e2c3aca@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc3-mm1/drivers/net/3c501.c linux-2.6.25-rc3-mm1/drivers/net/3c501.c
--- linux.vanilla-2.6.25-rc3-mm1/drivers/net/3c501.c	2008-03-10 12:55:42.000000000 +0000
+++ linux-2.6.25-rc3-mm1/drivers/net/3c501.c	2008-03-10 13:28:16.000000000 +0000
@@ -485,9 +485,7 @@
 			printk(KERN_DEBUG "%s: burped during tx load.\n",
 				dev->name);
 		spin_lock_irqsave(&lp->lock, flags);
-	}
-	while (1);
-
+	} while (1);
 }
 
 /**
@@ -612,7 +610,8 @@
 			dev->stats.tx_packets++;
 			if (el_debug > 6)
 				printk(KERN_DEBUG " Tx succeeded %s\n",
-					(txsr & TX_RDY) ? "." : "but tx is busy!");
+					(txsr & TX_RDY) ? "." :
+							"but tx is busy!");
 			/*
 			 *	This is safe the interrupt is atomic WRT itself.
 			 */
@@ -693,7 +692,8 @@
 
 	if (pkt_len < 60 || pkt_len > 1536) {
 		if (el_debug)
-			printk(KERN_DEBUG "%s: bogus packet, length=%d\n", dev->name, pkt_len);
+			printk(KERN_DEBUG "%s: bogus packet, length=%d\n",
+						dev->name, pkt_len);
 		dev->stats.rx_over_errors++;
 		return;
 	}
@@ -711,7 +711,8 @@
 
 	outw(0x00, GP_LOW);
 	if (skb == NULL) {
-		printk(KERN_INFO "%s: Memory squeeze, dropping packet.\n", dev->name);
+		printk(KERN_INFO "%s: Memory squeeze, dropping packet.\n",
+								dev->name);
 		dev->stats.rx_dropped++;
 		return;
 	} else {
@@ -748,7 +749,8 @@
 	if (el_debug > 2)
 		printk(KERN_INFO "3c501 reset...");
 	outb(AX_RESET, AX_CMD);		/* Reset the chip */
-	outb(AX_LOOP, AX_CMD);		/* Aux control, irq and loopback enabled */
+	/* Aux control, irq and loopback enabled */
+	outb(AX_LOOP, AX_CMD);
 	{
 		int i;
 		for (i = 0; i < 6; i++)	/* Set the station address. */
