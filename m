Return-Path: <linux-kernel-owner+w=401wt.eu-S1754331AbXFVNMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbXFVNMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 09:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbXFVNMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 09:12:31 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38981 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750898AbXFVNMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 09:12:30 -0400
Date: Fri, 22 Jun 2007 14:17:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: jeff@garzik.org, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] HPT374 is UDMA100 not UDMA133
Message-ID: <20070622141728.34b1b91c@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Propogate change from drivers/ide

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc4-mm2/drivers/ata/pata_hpt37x.c linux-2.6.22-rc4-mm2/drivers/ata/pata_hpt37x.c
--- linux.vanilla-2.6.22-rc4-mm2/drivers/ata/pata_hpt37x.c	2007-06-07 14:26:08.000000000 +0100
+++ linux-2.6.22-rc4-mm2/drivers/ata/pata_hpt37x.c	2007-06-14 12:58:22.000000000 +0100
@@ -931,13 +931,13 @@
 		.udma_mask = 0x7f,
 		.port_ops = &hpt372_port_ops
 	};
-	/* HPT374 - UDMA133 */
+	/* HPT374 - UDMA100 */
 	static const struct ata_port_info info_hpt374 = {
 		.sht = &hpt37x_sht,
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x7f,
+		.udma_mask = 0x3f,
 		.port_ops = &hpt374_port_ops
 	};
 
