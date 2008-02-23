Return-Path: <linux-kernel-owner+w=401wt.eu-S1760659AbYBWRix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760659AbYBWRix (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 12:38:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759993AbYBWRi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 12:38:26 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:23524 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758880AbYBWRiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 12:38:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=tl+eoFsA2KpAOp61wF8Z/iyJaEvpX5S9PRpcv49VQvNkiOMFaVljaC4BQthQdtXyA9nwUMr+KZfSvvQlfQp0RVMLjFSKlmVXsmPSypiksSPeol+dwqb3e0HDv+6koOZt0kfxSvlVeJhzXdTOwnUvhiB3WpV1qrj1jCtL89EaLTA=
Date: Sat, 23 Feb 2008 18:38:19 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: [PATCH 1/6] IDE: Coding Style fixes to drivers/ide/pci/opti621.c
Message-ID: <20080223183819.0f431e3b@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile tested.

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 drivers/ide/pci/opti621.c |   50 ++++++++++++++++++++++----------------------
 1 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/ide/pci/opti621.c b/drivers/ide/pci/opti621.c
index cfd46ae..3df74b7 100644
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -57,9 +57,9 @@
  * (use idebus=xx to select PCI bus speed).
  *
  * Version 0.1, Nov 8, 1996
- * by Jaromir Koutek, for 2.1.8. 
+ * by Jaromir Koutek, for 2.1.8.
  * Initial version of driver.
- * 
+ *
  * Version 0.2
  * Number 0.2 skipped.
  *
@@ -75,7 +75,7 @@
  * by Jaromir Koutek
  * Updates for use with (again) new IDE block driver.
  * Update of documentation.
- * 
+ *
  * Version 0.6, Jan 2, 1999
  * by Jaromir Koutek
  * Reversed to version 0.3 of the driver, because
@@ -208,29 +208,29 @@ typedef struct pio_clocks_s {
 
 static void compute_clocks(int pio, pio_clocks_t *clks)
 {
-        if (pio != PIO_NOT_EXIST) {
-        	int adr_setup, data_pls;
+	if (pio != PIO_NOT_EXIST) {
+		int adr_setup, data_pls;
 		int bus_speed = system_bus_clock();
 
- 	       	adr_setup = ide_pio_timings[pio].setup_time;
-  	      	data_pls = ide_pio_timings[pio].active_time;
-	  	clks->address_time = cmpt_clk(adr_setup, bus_speed);
-	     	clks->data_time = cmpt_clk(data_pls, bus_speed);
-     		clks->recovery_time = cmpt_clk(ide_pio_timings[pio].cycle_time
-     			- adr_setup-data_pls, bus_speed);
-     		if (clks->address_time<1) clks->address_time = 1;
-     		if (clks->address_time>4) clks->address_time = 4;
-     		if (clks->data_time<1) clks->data_time = 1;
-     		if (clks->data_time>16) clks->data_time = 16;
-     		if (clks->recovery_time<2) clks->recovery_time = 2;
-     		if (clks->recovery_time>17) clks->recovery_time = 17;
+		adr_setup = ide_pio_timings[pio].setup_time;
+		data_pls = ide_pio_timings[pio].active_time;
+		clks->address_time = cmpt_clk(adr_setup, bus_speed);
+		clks->data_time = cmpt_clk(data_pls, bus_speed);
+		clks->recovery_time = cmpt_clk(ide_pio_timings[pio].cycle_time
+			- adr_setup-data_pls, bus_speed);
+		if (clks->address_time < 1) clks->address_time = 1;
+		if (clks->address_time > 4) clks->address_time = 4;
+		if (clks->data_time < 1) clks->data_time = 1;
+		if (clks->data_time > 16) clks->data_time = 16;
+		if (clks->recovery_time < 2) clks->recovery_time = 2;
+		if (clks->recovery_time > 17) clks->recovery_time = 17;
 	} else {
 		clks->address_time = 1;
 		clks->data_time = 1;
 		clks->recovery_time = 2;
 		/* minimal values */
 	}
- 
+
 }
 
 static void opti621_set_pio_mode(ide_drive_t *drive, const u8 pio)
@@ -247,8 +247,8 @@ static void opti621_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 	/* sets drive->drive_data for both drives */
 	compute_pios(drive, pio);
- 	pio1 = hwif->drives[0].drive_data;
- 	pio2 = hwif->drives[1].drive_data;
+	pio1 = hwif->drives[0].drive_data;
+	pio2 = hwif->drives[1].drive_data;
 
 	compute_clocks(pio1, &first);
 	compute_clocks(pio2, &second);
@@ -275,7 +275,7 @@ static void opti621_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 	spin_lock_irqsave(&opti621_lock, flags);
 
-     	reg_base = hwif->io_ports[IDE_DATA_OFFSET];
+	reg_base = hwif->io_ports[IDE_DATA_OFFSET];
 
 	/* allow Register-B */
 	outb(0xc0, reg_base + CNTRL_REG);
@@ -324,7 +324,7 @@ static void __devinit opti621_port_init_devs(ide_hwif_t *hwif)
 /*
  * init_hwif_opti621() is called once for each hwif found at boot.
  */
-static void __devinit init_hwif_opti621 (ide_hwif_t *hwif)
+static void __devinit init_hwif_opti621(ide_hwif_t *hwif)
 {
 	hwif->port_init_devs = opti621_port_init_devs;
 	hwif->set_pio_mode = &opti621_set_pio_mode;
@@ -334,15 +334,15 @@ static const struct ide_port_info opti621_chipsets[] __devinitdata = {
 	{	/* 0 */
 		.name		= "OPTI621",
 		.init_hwif	= init_hwif_opti621,
-		.enablebits	= {{0x45,0x80,0x00}, {0x40,0x08,0x00}},
+		.enablebits	= { {0x45, 0x80, 0x00}, {0x40, 0x08, 0x00} },
 		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 		.pio_mask	= ATA_PIO3,
 		.swdma_mask	= ATA_SWDMA2,
 		.mwdma_mask	= ATA_MWDMA2,
-	},{	/* 1 */
+	}, {	/* 1 */
 		.name		= "OPTI621X",
 		.init_hwif	= init_hwif_opti621,
-		.enablebits	= {{0x45,0x80,0x00}, {0x40,0x08,0x00}},
+		.enablebits	= { {0x45, 0x80, 0x00}, {0x40, 0x08, 0x00} },
 		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA,
 		.pio_mask	= ATA_PIO3,
 		.swdma_mask	= ATA_SWDMA2,
-- 
1.5.4.2.316.gf7a7

