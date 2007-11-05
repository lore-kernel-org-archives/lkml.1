Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbXKEWun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbXKEWun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 17:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbXKEWuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 17:50:35 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48609 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751019AbXKEWuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 17:50:35 -0500
Date: Mon, 5 Nov 2007 22:51:09 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: jeff@garzik.org, torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ata_piix: Add additional PCI identifier for 40 wire short
 cable
Message-ID: <20071105225109.016be25f@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keeping the list in sync with the old IDE driver

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc1/drivers/ata/ata_piix.c linux-2.6.24-rc1/drivers/ata/ata_piix.c
--- linux.vanilla-2.6.24-rc1/drivers/ata/ata_piix.c	2007-11-01 11:41:54.000000000 +0000
+++ linux-2.6.24-rc1/drivers/ata/ata_piix.c	2007-11-05 22:25:32.879377872 +0000
@@ -621,6 +621,7 @@
 static const struct ich_laptop ich_laptop[] = {
 	/* devid, subvendor, subdev */
 	{ 0x27DF, 0x0005, 0x0280 },	/* ICH7 on Acer 5602WLMi */
+	{ 0x27DF, 0x1025, 0x0102 },	/* ICH7 on Acer 5602aWLMi */
 	{ 0x27DF, 0x1025, 0x0110 },	/* ICH7 on Acer 3682WLMi */
 	{ 0x27DF, 0x1043, 0x1267 },	/* ICH7 on Asus W5F */
 	{ 0x27DF, 0x103C, 0x30A1 },	/* ICH7 on HP Compaq nc2400 */
