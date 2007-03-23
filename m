Return-Path: <linux-kernel-owner+w=401wt.eu-S933879AbXCWRwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933879AbXCWRwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 13:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933899AbXCWRwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 13:52:50 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35165 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933879AbXCWRwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 13:52:49 -0400
Date: Fri, 23 Mar 2007 18:54:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com
Subject: [PATCH] libata: Misc minor merge fixups
Message-ID: <20070323185440.5544c04d@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing terribly exciting here just odd glitches from the merge

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc4-mm1/drivers/ata/pata_hpt366.c linux-2.6.21-rc4-mm1/drivers/ata/pata_hpt366.c
--- linux.vanilla-2.6.21-rc4-mm1/drivers/ata/pata_hpt366.c	2007-03-23 11:49:49.000000000 +0000
+++ linux-2.6.21-rc4-mm1/drivers/ata/pata_hpt366.c	2007-03-23 13:07:13.000000000 +0000
@@ -169,7 +169,6 @@
 
 /**
  *	hpt366_filter	-	mode selection filter
- *	@ap: ATA interface
  *	@adev: ATA device
  *
  *	Block UDMA on devices that cause trouble with this controller.
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc4-mm1/drivers/ata/pata_serverworks.c linux-2.6.21-rc4-mm1/drivers/ata/pata_serverworks.c
--- linux.vanilla-2.6.21-rc4-mm1/drivers/ata/pata_serverworks.c	2007-03-23 11:49:49.000000000 +0000
+++ linux-2.6.21-rc4-mm1/drivers/ata/pata_serverworks.c	2007-03-23 13:22:56.000000000 +0000
@@ -139,7 +139,6 @@
 /**
  *	serverworks_cable_detect	-	cable detection
  *	@ap: ATA port
- *	@deadline: deadline jiffies for the operation
  *
  *	Perform cable detection according to the device and subvendor
  *	identifications
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc4-mm1/drivers/ata/pata_sis.c linux-2.6.21-rc4-mm1/drivers/ata/pata_sis.c
--- linux.vanilla-2.6.21-rc4-mm1/drivers/ata/pata_sis.c	2007-03-23 11:49:49.000000000 +0000
+++ linux-2.6.21-rc4-mm1/drivers/ata/pata_sis.c	2007-03-23 13:24:23.000000000 +0000
@@ -88,7 +88,6 @@
 /**
  *	sis_133_cable_detect	-	check for 40/80 pin
  *	@ap: Port
- *	@deadline: deadline jiffies for the operation
  *
  *	Perform cable detection for the later UDMA133 capable
  *	SiS chipset.
@@ -109,7 +108,6 @@
 /**
  *	sis_66_cable_detect	-	check for 40/80 pin
  *	@ap: Port
- *	@deadline: deadline jiffies for the operation
  *
  *	Perform cable detection on the UDMA66, UDMA100 and early UDMA133
  *	SiS IDE controllers.
