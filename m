Return-Path: <linux-kernel-owner+w=401wt.eu-S933011Ab0AFXEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011Ab0AFXEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932984Ab0AFXEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:04:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55308 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932974Ab0AFXED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:04:03 -0500
From: Stefan Weil <weil@mail.berlios.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-doc@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linuxppc-dev@ozlabs.org, linux-mtd@lists.infradead.org
Cc: Stefan Weil <weil@mail.berlios.de>
Subject: [PATCH] Fix spelling in comments and documentation
Date: Thu,  7 Jan 2010 00:03:52 +0100
Message-Id: <1262819032-16644-1-git-send-email-weil@mail.berlios.de>
X-Mailer: git-send-email 1.6.5
X-Provags-ID: V01U2FsdGVkX1/VCUJweBwu6T3F8/+U02WTTSSLNTApWyyFKhE
 wC+1nFLVIB+nkIRpHyd6SebrBCghID9crlAIKW+G6TSUYS5F4Z
 cyDD5E0qiXvEh5oLi5FIYOUu01uJyLu6ti506L6a/yDsk5cRH/
 6Uw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace platfrom -> platform.

This is a frequent spelling bug.

Signed-off-by: Stefan Weil <weil@mail.berlios.de>
---
 Documentation/driver-model/platform.txt       |    2 +-
 arch/arm/mach-davinci/include/mach/i2c.h      |    2 +-
 arch/arm/mach-s3c2410/include/mach/spi-gpio.h |    2 +-
 arch/arm/plat-s3c/include/plat/nand.h         |    2 +-
 arch/blackfin/include/asm/nand.h              |    4 ++--
 arch/powerpc/kernel/legacy_serial.c           |    2 +-
 drivers/mtd/maps/plat-ram.c                   |    2 +-
 drivers/net/cxgb3/sge.c                       |    4 ++--
 drivers/video/mbx/mbxfb.c                     |    2 +-
 include/linux/dm9000.h                        |    2 +-
 10 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/driver-model/platform.txt b/Documentation/driver-model/platform.txt
index 2e2c2ea..41f4163 100644
--- a/Documentation/driver-model/platform.txt
+++ b/Documentation/driver-model/platform.txt
@@ -192,7 +192,7 @@ command line. This will execute all matching early_param() callbacks.
 User specified early platform devices will be registered at this point.
 For the early serial console case the user can specify port on the
 kernel command line as "earlyprintk=serial.0" where "earlyprintk" is
-the class string, "serial" is the name of the platfrom driver and
+the class string, "serial" is the name of the platform driver and
 0 is the platform device id. If the id is -1 then the dot and the
 id can be omitted.
 
diff --git a/arch/arm/mach-davinci/include/mach/i2c.h b/arch/arm/mach-davinci/include/mach/i2c.h
index c248e9b..44bdea1 100644
--- a/arch/arm/mach-davinci/include/mach/i2c.h
+++ b/arch/arm/mach-davinci/include/mach/i2c.h
@@ -1,5 +1,5 @@
 /*
- * DaVinci I2C controller platfrom_device info
+ * DaVinci I2C controller platform_device info
  *
  * Author: Vladimir Barinov, MontaVista Software, Inc. <source@mvista.com>
  *
diff --git a/arch/arm/mach-s3c2410/include/mach/spi-gpio.h b/arch/arm/mach-s3c2410/include/mach/spi-gpio.h
index 980a099..dcef228 100644
--- a/arch/arm/mach-s3c2410/include/mach/spi-gpio.h
+++ b/arch/arm/mach-s3c2410/include/mach/spi-gpio.h
@@ -3,7 +3,7 @@
  * Copyright (c) 2006 Simtec Electronics
  *	Ben Dooks <ben@simtec.co.uk>
  *
- * S3C2410 - SPI Controller platfrom_device info
+ * S3C2410 - SPI Controller platform_device info
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/arch/arm/plat-s3c/include/plat/nand.h b/arch/arm/plat-s3c/include/plat/nand.h
index 226147b..b64115f 100644
--- a/arch/arm/plat-s3c/include/plat/nand.h
+++ b/arch/arm/plat-s3c/include/plat/nand.h
@@ -3,7 +3,7 @@
  * Copyright (c) 2004 Simtec Electronics
  *	Ben Dooks <ben@simtec.co.uk>
  *
- * S3C2410 - NAND device controller platfrom_device info
+ * S3C2410 - NAND device controller platform_device info
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/arch/blackfin/include/asm/nand.h b/arch/blackfin/include/asm/nand.h
index 3ae8b56..3a1e79d 100644
--- a/arch/blackfin/include/asm/nand.h
+++ b/arch/blackfin/include/asm/nand.h
@@ -1,5 +1,5 @@
 /*
- * BF5XX - NAND flash controller platfrom_device info
+ * BF5XX - NAND flash controller platform_device info
  *
  * Copyright 2007-2008 Analog Devices, Inc.
  *
@@ -8,7 +8,7 @@
 
 /* struct bf5xx_nand_platform
  *
- * define a interface between platfrom board specific code and
+ * define a interface between platform board specific code and
  * bf54x NFC driver.
  *
  * nr_partitions = number of partitions pointed to be partitoons (or zero)
diff --git a/arch/powerpc/kernel/legacy_serial.c b/arch/powerpc/kernel/legacy_serial.c
index 9ddfaef..035ada5 100644
--- a/arch/powerpc/kernel/legacy_serial.c
+++ b/arch/powerpc/kernel/legacy_serial.c
@@ -469,7 +469,7 @@ static int __init serial_dev_init(void)
 		return -ENODEV;
 
 	/*
-	 * Before we register the platfrom serial devices, we need
+	 * Before we register the platform serial devices, we need
 	 * to fixup their interrupts and their IO ports.
 	 */
 	DBG("Fixing serial ports interrupts and IO ports ...\n");
diff --git a/drivers/mtd/maps/plat-ram.c b/drivers/mtd/maps/plat-ram.c
index dafb919..76a76be 100644
--- a/drivers/mtd/maps/plat-ram.c
+++ b/drivers/mtd/maps/plat-ram.c
@@ -4,7 +4,7 @@
  *	http://www.simtec.co.uk/products/SWLINUX/
  *	Ben Dooks <ben@simtec.co.uk>
  *
- * Generic platfrom device based RAM map
+ * Generic platform device based RAM map
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/net/cxgb3/sge.c b/drivers/net/cxgb3/sge.c
index bdbd147..5dbc125 100644
--- a/drivers/net/cxgb3/sge.c
+++ b/drivers/net/cxgb3/sge.c
@@ -196,13 +196,13 @@ static inline void refill_rspq(struct adapter *adapter,
 /**
  *	need_skb_unmap - does the platform need unmapping of sk_buffs?
  *
- *	Returns true if the platfrom needs sk_buff unmapping.  The compiler
+ *	Returns true if the platform needs sk_buff unmapping.  The compiler
  *	optimizes away unecessary code if this returns true.
  */
 static inline int need_skb_unmap(void)
 {
 	/*
-	 * This structure is used to tell if the platfrom needs buffer
+	 * This structure is used to tell if the platform needs buffer
 	 * unmapping by checking if DECLARE_PCI_UNMAP_ADDR defines anything.
 	 */
 	struct dummy {
diff --git a/drivers/video/mbx/mbxfb.c b/drivers/video/mbx/mbxfb.c
index 01f77bc..afea9ab 100644
--- a/drivers/video/mbx/mbxfb.c
+++ b/drivers/video/mbx/mbxfb.c
@@ -693,7 +693,7 @@ static void __devinit setup_memc(struct fb_info *fbi)
 	unsigned long tmp;
 	int i;
 
-	/* FIXME: use platfrom specific parameters */
+	/* FIXME: use platform specific parameters */
 	/* setup SDRAM controller */
 	write_reg_dly((LMCFG_LMC_DS | LMCFG_LMC_TS | LMCFG_LMD_TS |
 		LMCFG_LMA_TS),
diff --git a/include/linux/dm9000.h b/include/linux/dm9000.h
index c30879c..96e8769 100644
--- a/include/linux/dm9000.h
+++ b/include/linux/dm9000.h
@@ -23,7 +23,7 @@
 #define DM9000_PLATF_NO_EEPROM	(0x0010)
 #define DM9000_PLATF_SIMPLE_PHY (0x0020)  /* Use NSR to find LinkStatus */
 
-/* platfrom data for platfrom device structure's platfrom_data field */
+/* platform data for platform device structure's platform_data field */
 
 struct dm9000_plat_data {
 	unsigned int	flags;
-- 
1.5.6.5

