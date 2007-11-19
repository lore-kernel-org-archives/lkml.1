Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbXKSPKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbXKSPKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:10:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbXKSPJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:09:35 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45739 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755281AbXKSPJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:09:34 -0500
Date: Mon, 19 Nov 2007 15:07:51 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] 8250_gsc: Coding style
Message-ID: <20071119150751.60c2df48@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc2-mm1/drivers/serial/8250_gsc.c linux-2.6.24-rc2-mm1/drivers/serial/8250_gsc.c
--- linux.vanilla-2.6.24-rc2-mm1/drivers/serial/8250_gsc.c	2007-11-16 17:20:48.000000000 +0000
+++ linux-2.6.24-rc2-mm1/drivers/serial/8250_gsc.c	2007-11-16 18:35:39.000000000 +0000
@@ -25,8 +25,7 @@
 
 #include "8250.h"
 
-static int __init 
-serial_init_chip(struct parisc_device *dev)
+static int __init serial_init_chip(struct parisc_device *dev)
 {
 	struct uart_port port;
 	unsigned long address;
@@ -38,18 +37,17 @@
 		 * what we have here is a missing parent device, so tell
 		 * the user what they're missing.
 		 */
-		if (parisc_parent(dev)->id.hw_type != HPHW_IOA) {
-			printk(KERN_INFO "Serial: device 0x%lx not configured.\n"
+		if (parisc_parent(dev)->id.hw_type != HPHW_IOA)
+			printk(KERN_INFO
+				"Serial: device 0x%lx not configured.\n"
 				"Enable support for Wax, Lasi, Asp or Dino.\n",
 				dev->hpa.start);
-		}
 		return -ENODEV;
 	}
 
 	address = dev->hpa.start;
-	if (dev->id.sversion != 0x8d) {
+	if (dev->id.sversion != 0x8d)
 		address += 0x800;
-	}
 
 	memset(&port, 0, sizeof(port));
 	port.iotype	= UPIO_MEM;
@@ -63,11 +61,12 @@
 
 	err = serial8250_register_port(&port);
 	if (err < 0) {
-		printk(KERN_WARNING "serial8250_register_port returned error %d\n", err);
+		printk(KERN_WARNING
+			"serial8250_register_port returned error %d\n", err);
 		iounmap(port.membase);
 		return err;
 	}
-        
+
 	return 0;
 }
 
