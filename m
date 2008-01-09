Return-Path: <linux-kernel-owner+w=401wt.eu-S1759293AbYAIXkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293AbYAIXkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758642AbYAIXho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:37:44 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:64712 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758425AbYAIXhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:37:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Mbi0bVso+dgHnaT84xVS2FfwhtHc28Opf/TgcwMYiHZk6BafpwXil/HRAf02DzyMQLU13qTi6HK06t1oVPMOrgXHc9n5p4McA2Vnk0BoF5vMQlXOWRKsMJPM5dakssC7u+zCUyjRKYSJbz/SOMQsL321hQBuLybPXiHS1w045fw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: remove needless includes from PCI host drivers
Date: Thu, 10 Jan 2008 00:48:56 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801100048.56192.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/aec62xx.c      |    1 -
 drivers/ide/pci/alim15x3.c     |    1 -
 drivers/ide/pci/amd74xx.c      |    3 ---
 drivers/ide/pci/atiixp.c       |    4 ----
 drivers/ide/pci/cmd640.c       |    4 ----
 drivers/ide/pci/cmd64x.c       |    1 -
 drivers/ide/pci/cs5520.c       |   10 ----------
 drivers/ide/pci/cs5530.c       |    8 +-------
 drivers/ide/pci/cy82c693.c     |    1 -
 drivers/ide/pci/delkin_cb.c    |    5 ++---
 drivers/ide/pci/generic.c      |    7 -------
 drivers/ide/pci/hpt34x.c       |    7 -------
 drivers/ide/pci/hpt366.c       |    5 -----
 drivers/ide/pci/it8213.c       |    3 ---
 drivers/ide/pci/it821x.c       |    3 ---
 drivers/ide/pci/jmicron.c      |    3 ---
 drivers/ide/pci/ns87415.c      |    4 ----
 drivers/ide/pci/opti621.c      |    5 -----
 drivers/ide/pci/pdc202xx_new.c |    6 ------
 drivers/ide/pci/pdc202xx_old.c |    5 -----
 drivers/ide/pci/piix.c         |    2 --
 drivers/ide/pci/rz1000.c       |    7 -------
 drivers/ide/pci/sc1200.c       |    8 +-------
 drivers/ide/pci/serverworks.c  |    2 --
 drivers/ide/pci/sgiioc4.c      |    2 --
 drivers/ide/pci/siimage.c      |    1 -
 drivers/ide/pci/sis5513.c      |    9 ---------
 drivers/ide/pci/sl82c105.c     |    6 ------
 drivers/ide/pci/slc90e66.c     |    4 ----
 drivers/ide/pci/triflex.c      |    5 -----
 drivers/ide/pci/trm290.c       |    2 --
 drivers/ide/pci/via82cxxx.c    |    4 ----
 32 files changed, 4 insertions(+), 134 deletions(-)

Index: b/drivers/ide/pci/aec62xx.c
===================================================================
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -7,7 +7,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/pci.h>
-#include <linux/delay.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -31,7 +31,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
-#include <linux/delay.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
Index: b/drivers/ide/pci/amd74xx.c
===================================================================
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -17,12 +17,9 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
-#include <asm/io.h>
 
 #include "ide-timing.h"
 
Index: b/drivers/ide/pci/atiixp.c
===================================================================
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -6,15 +6,11 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/ioport.h>
 #include <linux/pci.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
-#include <linux/delay.h>
 #include <linux/init.h>
 
-#include <asm/io.h>
-
 #define ATIIXP_IDE_PIO_TIMING		0x40
 #define ATIIXP_IDE_MDMA_TIMING		0x44
 #define ATIIXP_IDE_PIO_CONTROL		0x48
Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -103,10 +103,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -13,7 +13,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/pci.h>
-#include <linux/delay.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
Index: b/drivers/ide/pci/cs5520.c
===================================================================
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -35,22 +35,12 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
 #include <linux/hdreg.h>
-
-#include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/ide.h>
 #include <linux/dma-mapping.h>
 
-#include <asm/io.h>
-#include <asm/irq.h>
-
 struct pio_clocks
 {
 	int address;
Index: b/drivers/ide/pci/cs5530.c
===================================================================
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -15,18 +15,12 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
 #include <linux/hdreg.h>
-#include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
+
 #include <asm/io.h>
-#include <asm/irq.h>
 
 /*
  * Here are the standard PIO mode 0-4 timings for each "format".
Index: b/drivers/ide/pci/cy82c693.c
===================================================================
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -45,7 +45,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/pci.h>
-#include <linux/delay.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
Index: b/drivers/ide/pci/delkin_cb.c
===================================================================
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -16,15 +16,14 @@
  *  License.  See the file COPYING in the main directory of this archive for
  *  more details.
  */
-#include <linux/autoconf.h>
+
 #include <linux/types.h>
 #include <linux/module.h>
-#include <linux/mm.h>
-#include <linux/blkdev.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 #include <linux/pci.h>
+
 #include <asm/io.h>
 
 /*
Index: b/drivers/ide/pci/generic.c
===================================================================
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -22,18 +22,11 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
 #include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
-#include <asm/io.h>
-
 static int ide_generic_all;		/* Set to claim all devices */
 
 /*
Index: b/drivers/ide/pci/hpt34x.c
===================================================================
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -26,20 +26,13 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
 #include <linux/ioport.h>
-#include <linux/blkdev.h>
 #include <linux/hdreg.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
 
-#include <asm/io.h>
-#include <asm/irq.h>
-
 #define HPT343_DEBUG_DRIVE_INFO		0
 
 static void hpt34x_set_mode(ide_drive_t *drive, const u8 speed)
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -121,12 +121,8 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
 #include <linux/blkdev.h>
 #include <linux/hdreg.h>
-
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/init.h>
@@ -134,7 +130,6 @@
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/irq.h>
 
 /* various tuning parameters */
 #define HPT_RESET_STATE_ENGINE
Index: b/drivers/ide/pci/it8213.c
===================================================================
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -10,13 +10,10 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/delay.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
-#include <asm/io.h>
-
 /**
  *	it8213_set_pio_mode	-	set host controller for PIO mode
  *	@drive: drive
Index: b/drivers/ide/pci/it821x.c
===================================================================
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -63,13 +63,10 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/delay.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
-#include <asm/io.h>
-
 struct it821x_dev
 {
 	unsigned int smart:1,		/* Are we in smart raid mode */
Index: b/drivers/ide/pci/jmicron.c
===================================================================
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -8,13 +8,10 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/delay.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
-#include <asm/io.h>
-
 typedef enum {
 	PORT_PATA0 = 0,
 	PORT_PATA1 = 1,
Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -10,11 +10,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
 #include <linux/interrupt.h>
-#include <linux/blkdev.h>
 #include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
Index: b/drivers/ide/pci/opti621.c
===================================================================
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -87,11 +87,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
 #include <linux/pci.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
Index: b/drivers/ide/pci/pdc202xx_new.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -19,18 +19,12 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
 #include <linux/hdreg.h>
-#include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
 
 #include <asm/io.h>
-#include <asm/irq.h>
 
 #ifdef CONFIG_PPC_PMAC
 #include <asm/prom.h>
Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -32,18 +32,13 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
 #include <linux/blkdev.h>
 #include <linux/hdreg.h>
-#include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
 
 #include <asm/io.h>
-#include <asm/irq.h>
 
 #define PDC202XX_DEBUG_DRIVE_INFO	0
 
Index: b/drivers/ide/pci/piix.c
===================================================================
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -47,11 +47,9 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/ioport.h>
 #include <linux/pci.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
-#include <linux/delay.h>
 #include <linux/init.h>
 
 #include <asm/io.h>
Index: b/drivers/ide/pci/rz1000.c
===================================================================
--- a/drivers/ide/pci/rz1000.c
+++ b/drivers/ide/pci/rz1000.c
@@ -16,18 +16,11 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
 #include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/ide.h>
 #include <linux/init.h>
 
-#include <asm/io.h>
-
 static void __devinit init_hwif_rz1000 (ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
Index: b/drivers/ide/pci/sc1200.c
===================================================================
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -14,19 +14,13 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
 #include <linux/hdreg.h>
-#include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
 #include <linux/pm.h>
+
 #include <asm/io.h>
-#include <asm/irq.h>
 
 #define SC1200_REV_A	0x00
 #define SC1200_REV_B1	0x01
Index: b/drivers/ide/pci/serverworks.c
===================================================================
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -31,12 +31,10 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/ioport.h>
 #include <linux/pci.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
-#include <linux/delay.h>
 
 #include <asm/io.h>
 
Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -25,8 +25,6 @@
 #include <linux/hdreg.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
 #include <linux/ioport.h>
 #include <linux/blkdev.h>
 #include <linux/scatterlist.h>
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -39,7 +39,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/delay.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
Index: b/drivers/ide/pci/sis5513.c
===================================================================
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -47,20 +47,11 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
 #include <linux/hdreg.h>
-
-#include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
 
-#include <asm/irq.h>
-
 #include "ide-timing.h"
 
 /* registers layout and init values are chipset family dependant */
Index: b/drivers/ide/pci/sl82c105.c
===================================================================
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -17,17 +17,11 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/interrupt.h>
-#include <linux/blkdev.h>
 #include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/ide.h>
 
 #include <asm/io.h>
-#include <asm/dma.h>
 
 #undef DEBUG
 
Index: b/drivers/ide/pci/slc90e66.c
===================================================================
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -10,15 +10,11 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/ioport.h>
 #include <linux/pci.h>
 #include <linux/hdreg.h>
 #include <linux/ide.h>
-#include <linux/delay.h>
 #include <linux/init.h>
 
-#include <asm/io.h>
-
 static DEFINE_SPINLOCK(slc90e66_lock);
 
 static void slc90e66_set_pio_mode(ide_drive_t *drive, const u8 pio)
Index: b/drivers/ide/pci/triflex.c
===================================================================
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -28,11 +28,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/mm.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
 #include <linux/hdreg.h>
 #include <linux/pci.h>
 #include <linux/ide.h>
Index: b/drivers/ide/pci/trm290.c
===================================================================
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -131,14 +131,12 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/mm.h>
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
 #include <linux/init.h>
 #include <linux/hdreg.h>
 #include <linux/pci.h>
-#include <linux/delay.h>
 #include <linux/ide.h>
 
 #include <asm/io.h>
Index: b/drivers/ide/pci/via82cxxx.c
===================================================================
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -26,15 +26,11 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
 #include <linux/dmi.h>
 
-#include <asm/io.h>
-
 #ifdef CONFIG_PPC_CHRP
 #include <asm/processor.h>
 #endif
