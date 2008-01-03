Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbYACQz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbYACQz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 11:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbYACQzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 11:55:15 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54525 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751690AbYACQzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 11:55:13 -0500
Date: Thu, 3 Jan 2008 16:53:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] serial: Coding style
Message-ID: <20080103165338.4c5a3043@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
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

Coding style tweaks and printk levels


diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/drivers/serial/8250.c linux-2.6.24-rc6-mm1/drivers/serial/8250.c
--- linux.vanilla-2.6.24-rc6-mm1/drivers/serial/8250.c	2008-01-02 16:04:23.000000000 +0000
+++ linux-2.6.24-rc6-mm1/drivers/serial/8250.c	2008-01-02 16:17:50.000000000 +0000
@@ -2048,7 +2048,7 @@
 	 * Oxford Semi 952 rev B workaround
 	 */
 	if (up->bugs & UART_BUG_QUOT && (quot & 0xff) == 0)
-		quot ++;
+		quot++;
 
 	if (up->capabilities & UART_CAP_FIFO && up->port.fifosize > 1) {
 		if (baud < 2400)
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/drivers/serial/8250_pnp.c linux-2.6.24-rc6-mm1/drivers/serial/8250_pnp.c
--- linux.vanilla-2.6.24-rc6-mm1/drivers/serial/8250_pnp.c	2008-01-02 16:04:05.000000000 +0000
+++ linux-2.6.24-rc6-mm1/drivers/serial/8250_pnp.c	2008-01-02 16:17:50.000000000 +0000
@@ -414,8 +414,9 @@
  */
 static int __devinit serial_pnp_guess_board(struct pnp_dev *dev, int *flags)
 {
-	if (!(check_name(pnp_dev_name(dev)) || (dev->card && check_name(dev->card->name))))
-		return -ENODEV;
+	if (!(check_name(pnp_dev_name(dev)) ||
+		(dev->card && check_name(dev->card->name))))
+			return -ENODEV;
 
 	if (check_resources(dev->independent))
 		return 0;
@@ -452,8 +453,9 @@
 		return -ENODEV;
 
 #ifdef SERIAL_DEBUG_PNP
-	printk("Setup PNP port: port %x, mem 0x%lx, irq %d, type %d\n",
-	       port.iobase, port.mapbase, port.irq, port.iotype);
+	printk(KERN_DEBUG
+		"Setup PNP port: port %x, mem 0x%lx, irq %d, type %d\n",
+		       port.iobase, port.mapbase, port.irq, port.iotype);
 #endif
 
 	port.flags |= UPF_SKIP_TEST | UPF_BOOT_AUTOCONF;
