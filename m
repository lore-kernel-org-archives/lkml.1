Return-Path: <linux-kernel-owner+w=401wt.eu-S1764405AbYESWJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764405AbYESWJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765100AbYESWGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:06:11 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:45062 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765122AbYESWGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:06:01 -0400
Date: Tue, 20 May 2008 01:03:52 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] MTD/JFFS2: remove CVS keywords
Message-ID: <20080519220352.GI17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, the MTD repository was using CVS.

This patch therefore removes all usages of the no longer updated CVS
keywords from the MTD code.

This also includes code that printed them to the user.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/mtd/Kconfig                 |    2 --
 drivers/mtd/afs.c                   |    2 --
 drivers/mtd/chips/cfi_cmdset_0001.c |    2 --
 drivers/mtd/chips/cfi_cmdset_0002.c |    3 ---
 drivers/mtd/chips/cfi_cmdset_0020.c |    2 --
 drivers/mtd/chips/cfi_probe.c       |    1 -
 drivers/mtd/chips/cfi_util.c        |    3 ---
 drivers/mtd/chips/chipreg.c         |    2 --
 drivers/mtd/chips/gen_probe.c       |    1 -
 drivers/mtd/chips/jedec_probe.c     |    1 -
 drivers/mtd/chips/map_absent.c      |    1 -
 drivers/mtd/chips/map_ram.c         |    1 -
 drivers/mtd/chips/map_rom.c         |    1 -
 drivers/mtd/cmdlinepart.c           |    2 --
 drivers/mtd/devices/Kconfig         |    1 -
 drivers/mtd/devices/Makefile        |    1 -
 drivers/mtd/devices/block2mtd.c     |    6 ------
 drivers/mtd/devices/doc2000.c       |    2 --
 drivers/mtd/devices/doc2001.c       |    2 --
 drivers/mtd/devices/doc2001plus.c   |    2 --
 drivers/mtd/devices/docecc.c        |    2 --
 drivers/mtd/devices/docprobe.c      |    3 ---
 drivers/mtd/devices/lart.c          |    2 --
 drivers/mtd/devices/ms02-nv.c       |    2 --
 drivers/mtd/devices/ms02-nv.h       |    2 --
 drivers/mtd/devices/mtdram.c        |    1 -
 drivers/mtd/devices/phram.c         |    2 --
 drivers/mtd/devices/pmc551.c        |    2 --
 drivers/mtd/devices/slram.c         |    2 --
 drivers/mtd/ftl.c                   |    3 ---
 drivers/mtd/inftlcore.c             |    5 -----
 drivers/mtd/inftlmount.c            |    4 ----
 drivers/mtd/maps/Kconfig            |    1 -
 drivers/mtd/maps/Makefile           |    1 -
 drivers/mtd/maps/amd76xrom.c        |    1 -
 drivers/mtd/maps/autcpu12-nvram.c   |    2 --
 drivers/mtd/maps/bast-flash.c       |    2 --
 drivers/mtd/maps/cdb89712.c         |    1 -
 drivers/mtd/maps/ceiva.c            |    1 -
 drivers/mtd/maps/cfi_flagadm.c      |    2 --
 drivers/mtd/maps/dbox2-flash.c      |    2 --
 drivers/mtd/maps/dc21285.c          |    2 --
 drivers/mtd/maps/dilnetpc.c         |    2 --
 drivers/mtd/maps/dmv182.c           |    2 --
 drivers/mtd/maps/ebony.c            |    2 --
 drivers/mtd/maps/edb7312.c          |    2 --
 drivers/mtd/maps/fortunet.c         |    1 -
 drivers/mtd/maps/h720x-flash.c      |    2 --
 drivers/mtd/maps/ichxrom.c          |    1 -
 drivers/mtd/maps/impa7.c            |    2 --
 drivers/mtd/maps/integrator-flash.c |    2 --
 drivers/mtd/maps/ipaq-flash.c       |    2 --
 drivers/mtd/maps/ixp2000.c          |    2 --
 drivers/mtd/maps/ixp4xx.c           |    2 --
 drivers/mtd/maps/l440gx.c           |    2 --
 drivers/mtd/maps/map_funcs.c        |    2 --
 drivers/mtd/maps/mbx860.c           |    2 --
 drivers/mtd/maps/mtx-1_flash.c      |    2 --
 drivers/mtd/maps/netsc520.c         |    2 --
 drivers/mtd/maps/nettel.c           |    2 --
 drivers/mtd/maps/octagon-5066.c     |    1 -
 drivers/mtd/maps/omap-toto-flash.c  |    2 --
 drivers/mtd/maps/pci.c              |    2 --
 drivers/mtd/maps/pcmciamtd.c        |    5 +----
 drivers/mtd/maps/physmap.c          |    2 --
 drivers/mtd/maps/plat-ram.c         |    2 --
 drivers/mtd/maps/redwood.c          |    2 --
 drivers/mtd/maps/rpxlite.c          |    2 --
 drivers/mtd/maps/sa1100-flash.c     |    2 --
 drivers/mtd/maps/sbc8240.c          |    3 ---
 drivers/mtd/maps/sbc_gxx.c          |    2 --
 drivers/mtd/maps/sc520cdp.c         |    2 --
 drivers/mtd/maps/scb2_flash.c       |    1 -
 drivers/mtd/maps/scx200_docflash.c  |    2 --
 drivers/mtd/maps/sharpsl-flash.c    |    2 --
 drivers/mtd/maps/solutionengine.c   |    2 --
 drivers/mtd/maps/sun_uflash.c       |    2 +-
 drivers/mtd/maps/tqm8xxl.c          |    2 --
 drivers/mtd/maps/ts5500_flash.c     |    2 --
 drivers/mtd/maps/tsunami_flash.c    |    1 -
 drivers/mtd/maps/uclinux.c          |    2 --
 drivers/mtd/maps/vmax301.c          |    1 -
 drivers/mtd/maps/walnut.c           |    2 --
 drivers/mtd/maps/wr_sbc82xx_flash.c |    2 --
 drivers/mtd/mtd_blkdevs.c           |    2 --
 drivers/mtd/mtdblock.c              |    2 --
 drivers/mtd/mtdblock_ro.c           |    2 --
 drivers/mtd/mtdchar.c               |    2 --
 drivers/mtd/mtdconcat.c             |    2 --
 drivers/mtd/mtdcore.c               |    2 --
 drivers/mtd/mtdpart.c               |    2 --
 drivers/mtd/nand/Kconfig            |    1 -
 drivers/mtd/nand/Makefile           |    1 -
 drivers/mtd/nand/au1550nd.c         |    2 --
 drivers/mtd/nand/autcpu12.c         |    2 --
 drivers/mtd/nand/diskonchip.c       |    2 --
 drivers/mtd/nand/edb7312.c          |    2 --
 drivers/mtd/nand/h1910.c            |    2 --
 drivers/mtd/nand/nand_bbt.c         |    2 --
 drivers/mtd/nand/nand_ecc.c         |    2 --
 drivers/mtd/nand/nand_ids.c         |    2 --
 drivers/mtd/nand/nandsim.c          |    2 --
 drivers/mtd/nand/ppchameleonevb.c   |    2 --
 drivers/mtd/nand/rtc_from4.c        |    2 --
 drivers/mtd/nand/s3c2410.c          |    2 --
 drivers/mtd/nand/sharpsl.c          |    2 --
 drivers/mtd/nand/spia.c             |    2 --
 drivers/mtd/nand/toto.c             |    2 --
 drivers/mtd/nand/ts7250.c           |    2 --
 drivers/mtd/nftlcore.c              |    5 -----
 drivers/mtd/nftlmount.c             |    4 ----
 drivers/mtd/redboot.c               |    2 --
 drivers/mtd/rfd_ftl.c               |    2 --
 include/linux/jffs2.h               |    3 ---
 include/linux/mtd/blktrans.h        |    2 --
 include/linux/mtd/cfi.h             |    1 -
 include/linux/mtd/cfi_endian.h      |    5 -----
 include/linux/mtd/concat.h          |    2 --
 include/linux/mtd/doc2000.h         |    2 --
 include/linux/mtd/flashchip.h       |    3 ---
 include/linux/mtd/ftl.h             |    2 --
 include/linux/mtd/gen_probe.h       |    1 -
 include/linux/mtd/inftl.h           |    4 ----
 include/linux/mtd/map.h             |    1 -
 include/linux/mtd/mtd.h             |    2 --
 include/linux/mtd/nand.h            |    2 --
 include/linux/mtd/nand_ecc.h        |    2 --
 include/linux/mtd/nftl.h            |    2 --
 include/linux/mtd/partitions.h      |    2 --
 include/linux/mtd/physmap.h         |    2 --
 include/linux/mtd/plat-ram.h        |    2 --
 include/linux/mtd/pmc551.h          |    4 +---
 include/linux/mtd/xip.h             |    2 --
 include/mtd/inftl-user.h            |    2 --
 include/mtd/jffs2-user.h            |    2 --
 include/mtd/mtd-abi.h               |    2 --
 include/mtd/mtd-user.h              |    2 --
 include/mtd/nftl-user.h             |    2 --
 138 files changed, 3 insertions(+), 279 deletions(-)

77cc90a95ebae346e26f26388bc513aef7939fc9 diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
index eed06d0..14f11f8 100644
--- a/drivers/mtd/Kconfig
+++ b/drivers/mtd/Kconfig
@@ -1,5 +1,3 @@
-# $Id: Kconfig,v 1.11 2005/11/07 11:14:19 gleixner Exp $
-
 menuconfig MTD
 	tristate "Memory Technology Device (MTD) support"
 	depends on HAS_IOMEM
diff --git a/drivers/mtd/afs.c b/drivers/mtd/afs.c
index 52d51eb..d072ca5 100644
--- a/drivers/mtd/afs.c
+++ b/drivers/mtd/afs.c
@@ -21,8 +21,6 @@
    This is access code for flashes using ARM's flash partitioning
    standards.
 
-   $Id: afs.c,v 1.15 2005/11/07 11:14:19 gleixner Exp $
-
 ======================================================================*/
 
 #include <linux/module.h>
diff --git a/drivers/mtd/chips/cfi_cmdset_0001.c b/drivers/mtd/chips/cfi_cmdset_0001.c
index fcd1aec..b48066e 100644
--- a/drivers/mtd/chips/cfi_cmdset_0001.c
+++ b/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -4,8 +4,6 @@
  *
  * (C) 2000 Red Hat. GPL'd
  *
- * $Id: cfi_cmdset_0001.c,v 1.186 2005/11/23 22:07:52 nico Exp $
- *
  *
  * 10/10/2000	Nicolas Pitre <nico@cam.org>
  * 	- completely revamped method functions so they are aware and
diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index f7fcc63..a972cc6 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -16,9 +16,6 @@
  * Occasionally maintained by Thayne Harbaugh tharbaugh at lnxi dot com
  *
  * This code is GPL
- *
- * $Id: cfi_cmdset_0002.c,v 1.122 2005/11/07 11:14:22 gleixner Exp $
- *
  */
 
 #include <linux/module.h>
diff --git a/drivers/mtd/chips/cfi_cmdset_0020.c b/drivers/mtd/chips/cfi_cmdset_0020.c
index 1b720cc..d4714dd 100644
--- a/drivers/mtd/chips/cfi_cmdset_0020.c
+++ b/drivers/mtd/chips/cfi_cmdset_0020.c
@@ -4,8 +4,6 @@
  *
  * (C) 2000 Red Hat. GPL'd
  *
- * $Id: cfi_cmdset_0020.c,v 1.22 2005/11/07 11:14:22 gleixner Exp $
- *
  * 10/10/2000	Nicolas Pitre <nico@cam.org>
  * 	- completely revamped method functions so they are aware and
  * 	  independent of the flash geometry (buswidth, interleave, etc.)
diff --git a/drivers/mtd/chips/cfi_probe.c b/drivers/mtd/chips/cfi_probe.c
index a4463a9..c418e92 100644
--- a/drivers/mtd/chips/cfi_probe.c
+++ b/drivers/mtd/chips/cfi_probe.c
@@ -1,7 +1,6 @@
 /*
    Common Flash Interface probe code.
    (C) 2000 Red Hat. GPL'd.
-   $Id: cfi_probe.c,v 1.86 2005/11/29 14:48:31 gleixner Exp $
 */
 
 #include <linux/module.h>
diff --git a/drivers/mtd/chips/cfi_util.c b/drivers/mtd/chips/cfi_util.c
index 72e0022..0ee4570 100644
--- a/drivers/mtd/chips/cfi_util.c
+++ b/drivers/mtd/chips/cfi_util.c
@@ -6,9 +6,6 @@
  * Copyright (C) 2003 STMicroelectronics Limited
  *
  * This code is covered by the GPL.
- *
- * $Id: cfi_util.c,v 1.10 2005/11/07 11:14:23 gleixner Exp $
- *
  */
 
 #include <linux/module.h>
diff --git a/drivers/mtd/chips/chipreg.c b/drivers/mtd/chips/chipreg.c
index 2174c97..c857609 100644
--- a/drivers/mtd/chips/chipreg.c
+++ b/drivers/mtd/chips/chipreg.c
@@ -1,6 +1,4 @@
 /*
- * $Id: chipreg.c,v 1.17 2004/11/16 18:29:00 dwmw2 Exp $
- *
  * Registration for chip drivers
  *
  */
diff --git a/drivers/mtd/chips/gen_probe.c b/drivers/mtd/chips/gen_probe.c
index d338b8c..e53a58a 100644
--- a/drivers/mtd/chips/gen_probe.c
+++ b/drivers/mtd/chips/gen_probe.c
@@ -2,7 +2,6 @@
  * Routines common to all CFI-type probes.
  * (C) 2001-2003 Red Hat, Inc.
  * GPL'd
- * $Id: gen_probe.c,v 1.24 2005/11/07 11:14:23 gleixner Exp $
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/mtd/chips/jedec_probe.c b/drivers/mtd/chips/jedec_probe.c
index aa07575..76436df 100644
--- a/drivers/mtd/chips/jedec_probe.c
+++ b/drivers/mtd/chips/jedec_probe.c
@@ -1,7 +1,6 @@
 /*
    Common Flash Interface probe code.
    (C) 2000 Red Hat. GPL'd.
-   $Id: jedec_probe.c,v 1.66 2005/11/07 11:14:23 gleixner Exp $
    See JEDEC (http://www.jedec.org/) standard JESD21C (section 3.5)
    for the standard this probe goes back to.
 
diff --git a/drivers/mtd/chips/map_absent.c b/drivers/mtd/chips/map_absent.c
index fc478c0..494d30d 100644
--- a/drivers/mtd/chips/map_absent.c
+++ b/drivers/mtd/chips/map_absent.c
@@ -1,7 +1,6 @@
 /*
  * Common code to handle absent "placeholder" devices
  * Copyright 2001 Resilience Corporation <ebrower@resilience.com>
- * $Id: map_absent.c,v 1.6 2005/11/07 11:14:23 gleixner Exp $
  *
  * This map driver is used to allocate "placeholder" MTD
  * devices on systems that have socketed/removable media.
diff --git a/drivers/mtd/chips/map_ram.c b/drivers/mtd/chips/map_ram.c
index 5cb6d52..072dd8a 100644
--- a/drivers/mtd/chips/map_ram.c
+++ b/drivers/mtd/chips/map_ram.c
@@ -1,7 +1,6 @@
 /*
  * Common code to handle map devices which are simple RAM
  * (C) 2000 Red Hat. GPL'd.
- * $Id: map_ram.c,v 1.22 2005/01/05 18:05:12 dwmw2 Exp $
  */
 
 #include <linux/module.h>
diff --git a/drivers/mtd/chips/map_rom.c b/drivers/mtd/chips/map_rom.c
index cb27f85..821d0ed 100644
--- a/drivers/mtd/chips/map_rom.c
+++ b/drivers/mtd/chips/map_rom.c
@@ -1,7 +1,6 @@
 /*
  * Common code to handle map devices which are simple ROM
  * (C) 2000 Red Hat. GPL'd.
- * $Id: map_rom.c,v 1.23 2005/01/05 18:05:12 dwmw2 Exp $
  */
 
 #include <linux/module.h>
diff --git a/drivers/mtd/cmdlinepart.c b/drivers/mtd/cmdlinepart.c
index e472a0e..68782ab 100644
--- a/drivers/mtd/cmdlinepart.c
+++ b/drivers/mtd/cmdlinepart.c
@@ -1,6 +1,4 @@
 /*
- * $Id: cmdlinepart.c,v 1.19 2005/11/07 11:14:19 gleixner Exp $
- *
  * Read flash partition table from command line
  *
  * Copyright 2002 SYSGO Real-Time Solutions GmbH
diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
index 35ed110..9c613f0 100644
--- a/drivers/mtd/devices/Kconfig
+++ b/drivers/mtd/devices/Kconfig
@@ -1,5 +1,4 @@
 # drivers/mtd/maps/Kconfig
-# $Id: Kconfig,v 1.18 2005/11/07 11:14:24 gleixner Exp $
 
 menu "Self-contained MTD device drivers"
 	depends on MTD!=n
diff --git a/drivers/mtd/devices/Makefile b/drivers/mtd/devices/Makefile
index 0f788d5..0993d5c 100644
--- a/drivers/mtd/devices/Makefile
+++ b/drivers/mtd/devices/Makefile
@@ -1,7 +1,6 @@
 #
 # linux/drivers/devices/Makefile
 #
-# $Id: Makefile.common,v 1.7 2004/12/22 17:51:15 joern Exp $
 
 obj-$(CONFIG_MTD_DOC2000)	+= doc2000.o
 obj-$(CONFIG_MTD_DOC2001)	+= doc2001.o
diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
index 519d942..303ea9b 100644
--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -1,6 +1,4 @@
 /*
- * $Id: block2mtd.c,v 1.30 2005/11/29 14:48:32 gleixner Exp $
- *
  * block2mtd.c - create an mtd from a block device
  *
  * Copyright (C) 2001,2002	Simon Evans <spse@secret.org.uk>
@@ -20,9 +18,6 @@
 #include <linux/mutex.h>
 #include <linux/mount.h>
 
-#define VERSION "$Revision: 1.30 $"
-
-
 #define ERROR(fmt, args...) printk(KERN_ERR "block2mtd: " fmt "\n" , ## args)
 #define INFO(fmt, args...) printk(KERN_INFO "block2mtd: " fmt "\n" , ## args)
 
@@ -451,7 +446,6 @@ MODULE_PARM_DESC(block2mtd, "Device to use. \"block2mtd=<dev>[,<erasesize>]\"");
 static int __init block2mtd_init(void)
 {
 	int ret = 0;
-	INFO("version " VERSION);
 
 #ifndef MODULE
 	if (strlen(block2mtd_paramline))
diff --git a/drivers/mtd/devices/doc2000.c b/drivers/mtd/devices/doc2000.c
index 846989f..50de839 100644
--- a/drivers/mtd/devices/doc2000.c
+++ b/drivers/mtd/devices/doc2000.c
@@ -3,8 +3,6 @@
  * Linux driver for Disk-On-Chip 2000 and Millennium
  * (c) 1999 Machine Vision Holdings, Inc.
  * (c) 1999, 2000 David Woodhouse <dwmw2@infradead.org>
- *
- * $Id: doc2000.c,v 1.67 2005/11/07 11:14:24 gleixner Exp $
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/mtd/devices/doc2001.c b/drivers/mtd/devices/doc2001.c
index 6413efc..e32c568 100644
--- a/drivers/mtd/devices/doc2001.c
+++ b/drivers/mtd/devices/doc2001.c
@@ -3,8 +3,6 @@
  * Linux driver for Disk-On-Chip Millennium
  * (c) 1999 Machine Vision Holdings, Inc.
  * (c) 1999, 2000 David Woodhouse <dwmw2@infradead.org>
- *
- * $Id: doc2001.c,v 1.49 2005/11/07 11:14:24 gleixner Exp $
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/mtd/devices/doc2001plus.c b/drivers/mtd/devices/doc2001plus.c
index 83be346..d853f89 100644
--- a/drivers/mtd/devices/doc2001plus.c
+++ b/drivers/mtd/devices/doc2001plus.c
@@ -6,8 +6,6 @@
  * (c) 1999 Machine Vision Holdings, Inc.
  * (c) 1999, 2000 David Woodhouse <dwmw2@infradead.org>
  *
- * $Id: doc2001plus.c,v 1.14 2005/11/07 11:14:24 gleixner Exp $
- *
  * Released under GPL
  */
 
diff --git a/drivers/mtd/devices/docecc.c b/drivers/mtd/devices/docecc.c
index fd8a8da..874e51b 100644
--- a/drivers/mtd/devices/docecc.c
+++ b/drivers/mtd/devices/docecc.c
@@ -7,8 +7,6 @@
  * Author: Fabrice Bellard (fabrice.bellard@netgem.com)
  * Copyright (C) 2000 Netgem S.A.
  *
- * $Id: docecc.c,v 1.7 2005/11/07 11:14:25 gleixner Exp $
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
diff --git a/drivers/mtd/devices/docprobe.c b/drivers/mtd/devices/docprobe.c
index d8cc94e..6e5d811 100644
--- a/drivers/mtd/devices/docprobe.c
+++ b/drivers/mtd/devices/docprobe.c
@@ -4,9 +4,6 @@
 /* (C) 1999 Machine Vision Holdings, Inc.			*/
 /* (C) 1999-2003 David Woodhouse <dwmw2@infradead.org>		*/
 
-/* $Id: docprobe.c,v 1.46 2005/11/07 11:14:25 gleixner Exp $	*/
-
-
 
 /* DOC_PASSIVE_PROBE:
    In order to ensure that the BIOS checksum is correct at boot time, and
diff --git a/drivers/mtd/devices/lart.c b/drivers/mtd/devices/lart.c
index 1d324e5..f4bda4c 100644
--- a/drivers/mtd/devices/lart.c
+++ b/drivers/mtd/devices/lart.c
@@ -2,8 +2,6 @@
 /*
  * MTD driver for the 28F160F3 Flash Memory (non-CFI) on LART.
  *
- * $Id: lart.c,v 1.9 2005/11/07 11:14:25 gleixner Exp $
- *
  * Author: Abraham vd Merwe <abraham@2d3d.co.za>
  *
  * Copyright (c) 2001, 2d3D, Inc.
diff --git a/drivers/mtd/devices/ms02-nv.c b/drivers/mtd/devices/ms02-nv.c
index 9cff119..6a9a24a 100644
--- a/drivers/mtd/devices/ms02-nv.c
+++ b/drivers/mtd/devices/ms02-nv.c
@@ -5,8 +5,6 @@
  *	modify it under the terms of the GNU General Public License
  *	as published by the Free Software Foundation; either version
  *	2 of the License, or (at your option) any later version.
- *
- *	$Id: ms02-nv.c,v 1.11 2005/11/14 13:41:47 macro Exp $
  */
 
 #include <linux/init.h>
diff --git a/drivers/mtd/devices/ms02-nv.h b/drivers/mtd/devices/ms02-nv.h
index 8a6eef7..04deafd 100644
--- a/drivers/mtd/devices/ms02-nv.h
+++ b/drivers/mtd/devices/ms02-nv.h
@@ -9,8 +9,6 @@
  *	modify it under the terms of the GNU General Public License
  *	as published by the Free Software Foundation; either version
  *	2 of the License, or (at your option) any later version.
- *
- *	$Id: ms02-nv.h,v 1.3 2003/08/19 09:25:36 dwmw2 Exp $
  */
 
 #include <linux/ioport.h>
diff --git a/drivers/mtd/devices/mtdram.c b/drivers/mtd/devices/mtdram.c
index 0399be1..3aaca88 100644
--- a/drivers/mtd/devices/mtdram.c
+++ b/drivers/mtd/devices/mtdram.c
@@ -1,6 +1,5 @@
 /*
  * mtdram - a test mtd device
- * $Id: mtdram.c,v 1.37 2005/04/21 03:42:11 joern Exp $
  * Author: Alexander Larsson <alex@cendio.se>
  *
  * Copyright (c) 1999 Alexander Larsson <alex@cendio.se>
diff --git a/drivers/mtd/devices/phram.c b/drivers/mtd/devices/phram.c
index c7987b1..088fbb7 100644
--- a/drivers/mtd/devices/phram.c
+++ b/drivers/mtd/devices/phram.c
@@ -1,6 +1,4 @@
 /**
- * $Id: phram.c,v 1.16 2005/11/07 11:14:25 gleixner Exp $
- *
  * Copyright (c) ????		Jochen Schäuble <psionic@psionic.de>
  * Copyright (c) 2003-2004	Joern Engel <joern@wh.fh-wedel.de>
  *
diff --git a/drivers/mtd/devices/pmc551.c b/drivers/mtd/devices/pmc551.c
index bc99817..d38bca6 100644
--- a/drivers/mtd/devices/pmc551.c
+++ b/drivers/mtd/devices/pmc551.c
@@ -1,6 +1,4 @@
 /*
- * $Id: pmc551.c,v 1.32 2005/11/07 11:14:25 gleixner Exp $
- *
  * PMC551 PCI Mezzanine Ram Device
  *
  * Author:
diff --git a/drivers/mtd/devices/slram.c b/drivers/mtd/devices/slram.c
index cb86db7..a425d09 100644
--- a/drivers/mtd/devices/slram.c
+++ b/drivers/mtd/devices/slram.c
@@ -1,7 +1,5 @@
 /*======================================================================
 
-  $Id: slram.c,v 1.36 2005/11/07 11:14:25 gleixner Exp $
-
   This driver provides a method to access memory not used by the kernel
   itself (i.e. if the kernel commandline mem=xxx is used). To actually
   use slram at least mtdblock or mtdchar is required (for block or
diff --git a/drivers/mtd/ftl.c b/drivers/mtd/ftl.c
index 4a79b18..3fed8f9 100644
--- a/drivers/mtd/ftl.c
+++ b/drivers/mtd/ftl.c
@@ -1,5 +1,4 @@
 /* This version ported to the Linux-MTD system by dwmw2@infradead.org
- * $Id: ftl.c,v 1.59 2005/11/29 14:48:31 gleixner Exp $
  *
  * Fixes: Arnaldo Carvalho de Melo <acme@conectiva.com.br>
  * - fixes some leaks on failure in build_maps and ftl_notify_add, cleanups
@@ -1082,8 +1081,6 @@ static struct mtd_blktrans_ops ftl_tr = {
 
 static int init_ftl(void)
 {
-	DEBUG(0, "$Id: ftl.c,v 1.59 2005/11/29 14:48:31 gleixner Exp $\n");
-
 	return register_mtd_blktrans(&ftl_tr);
 }
 
diff --git a/drivers/mtd/inftlcore.c b/drivers/mtd/inftlcore.c
index b0e3965..c4f9d33 100644
--- a/drivers/mtd/inftlcore.c
+++ b/drivers/mtd/inftlcore.c
@@ -7,8 +7,6 @@
  * (c) 1999 Machine Vision Holdings, Inc.
  * Author: David Woodhouse <dwmw2@infradead.org>
  *
- * $Id: inftlcore.c,v 1.19 2005/11/07 11:14:20 gleixner Exp $
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -953,9 +951,6 @@ static struct mtd_blktrans_ops inftl_tr = {
 
 static int __init init_inftl(void)
 {
-	printk(KERN_INFO "INFTL: inftlcore.c $Revision: 1.19 $, "
-		"inftlmount.c %s\n", inftlmountrev);
-
 	return register_mtd_blktrans(&inftl_tr);
 }
 
diff --git a/drivers/mtd/inftlmount.c b/drivers/mtd/inftlmount.c
index c551d2f..9113628 100644
--- a/drivers/mtd/inftlmount.c
+++ b/drivers/mtd/inftlmount.c
@@ -8,8 +8,6 @@
  * Author: Fabrice Bellard (fabrice.bellard@netgem.com)
  * Copyright (C) 2000 Netgem S.A.
  *
- * $Id: inftlmount.c,v 1.18 2005/11/07 11:14:20 gleixner Exp $
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -39,8 +37,6 @@
 #include <linux/mtd/inftl.h>
 #include <linux/mtd/compatmac.h>
 
-char inftlmountrev[]="$Revision: 1.18 $";
-
 /*
  * find_boot_record: Find the INFTL Media Header and its Spare copy which
  *	contains the various device information of the INFTL partition and
diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index 17bc87a..bba8b0d 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -1,5 +1,4 @@
 # drivers/mtd/maps/Kconfig
-# $Id: Kconfig,v 1.61 2005/11/07 11:14:26 gleixner Exp $
 
 menu "Mapping drivers for chip access"
 	depends on MTD!=n
diff --git a/drivers/mtd/maps/Makefile b/drivers/mtd/maps/Makefile
index 957fb5f..110a86e 100644
--- a/drivers/mtd/maps/Makefile
+++ b/drivers/mtd/maps/Makefile
@@ -1,7 +1,6 @@
 #
 # linux/drivers/maps/Makefile
 #
-# $Id: Makefile.common,v 1.34 2005/11/07 11:14:26 gleixner Exp $
 
 ifeq ($(CONFIG_MTD_COMPLEX_MAPPINGS),y)
 obj-$(CONFIG_MTD)		+= map_funcs.o
diff --git a/drivers/mtd/maps/amd76xrom.c b/drivers/mtd/maps/amd76xrom.c
index 728aed6..948b86f 100644
--- a/drivers/mtd/maps/amd76xrom.c
+++ b/drivers/mtd/maps/amd76xrom.c
@@ -2,7 +2,6 @@
  * amd76xrom.c
  *
  * Normal mappings of chips in physical memory
- * $Id: amd76xrom.c,v 1.21 2005/11/07 11:14:26 gleixner Exp $
  */
 
 #include <linux/module.h>
diff --git a/drivers/mtd/maps/autcpu12-nvram.c b/drivers/mtd/maps/autcpu12-nvram.c
index 7ed3424..cf32267 100644
--- a/drivers/mtd/maps/autcpu12-nvram.c
+++ b/drivers/mtd/maps/autcpu12-nvram.c
@@ -2,8 +2,6 @@
  * NV-RAM memory access on autcpu12
  * (C) 2002 Thomas Gleixner (gleixner@autronix.de)
  *
- * $Id: autcpu12-nvram.c,v 1.9 2005/11/07 11:14:26 gleixner Exp $
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
diff --git a/drivers/mtd/maps/bast-flash.c b/drivers/mtd/maps/bast-flash.c
index 1f49206..ca54148 100644
--- a/drivers/mtd/maps/bast-flash.c
+++ b/drivers/mtd/maps/bast-flash.c
@@ -9,8 +9,6 @@
  *	20-Sep-2004  BJD  Initial version
  *	17-Jan-2005  BJD  Add whole device if no partitions found
  *
- * $Id: bast-flash.c,v 1.5 2005/11/07 11:14:26 gleixner Exp $
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
diff --git a/drivers/mtd/maps/cdb89712.c b/drivers/mtd/maps/cdb89712.c
index 9f17bb6..cb507da 100644
--- a/drivers/mtd/maps/cdb89712.c
+++ b/drivers/mtd/maps/cdb89712.c
@@ -1,7 +1,6 @@
 /*
  * Flash on Cirrus CDB89712
  *
- * $Id: cdb89712.c,v 1.11 2005/11/07 11:14:26 gleixner Exp $
  */
 
 #include <linux/module.h>
diff --git a/drivers/mtd/maps/ceiva.c b/drivers/mtd/maps/ceiva.c
index 629e6e2..6464d48 100644
--- a/drivers/mtd/maps/ceiva.c
+++ b/drivers/mtd/maps/ceiva.c
@@ -11,7 +11,6 @@
  *
  * (C) 2000 Nicolas Pitre <nico@cam.org>
  *
- * $Id: ceiva.c,v 1.11 2004/09/16 23:27:12 gleixner Exp $
  */
 
 #include <linux/module.h>
diff --git a/drivers/mtd/maps/cfi_flagadm.c b/drivers/mtd/maps/cfi_flagadm.c
index 65e5ee5..0ecc3f6 100644
--- a/drivers/mtd/maps/cfi_flagadm.c
+++ b/drivers/mtd/maps/cfi_flagadm.c
@@ -1,8 +1,6 @@
 /*
  *  Copyright © 2001 Flaga hf. Medical Devices, Kári Davíðsson <kd@flaga.is>
  *
- *  $Id: cfi_flagadm.c,v 1.15 2005/11/07 11:14:26 gleixner Exp $
- *
  *  This program is free software; you can redistribute  it and/or modify it
  *  under  the terms of  the GNU General  Public License as published by the
  *  Free Software Foundation;  either version 2 of the  License, or (at your
diff --git a/drivers/mtd/maps/dbox2-flash.c b/drivers/mtd/maps/dbox2-flash.c
index 92a9c7f..e115667 100644
--- a/drivers/mtd/maps/dbox2-flash.c
+++ b/drivers/mtd/maps/dbox2-flash.c
@@ -1,6 +1,4 @@
 /*
- * $Id: dbox2-flash.c,v 1.14 2005/11/07 11:14:26 gleixner Exp $
- *
  * D-Box 2 flash driver
  */
 
diff --git a/drivers/mtd/maps/dc21285.c b/drivers/mtd/maps/dc21285.c
index b32bb93..3aa018c 100644
--- a/drivers/mtd/maps/dc21285.c
+++ b/drivers/mtd/maps/dc21285.c
@@ -4,8 +4,6 @@
  * (C) 2000  Nicolas Pitre <nico@cam.org>
  *
  * This code is GPL
- *
- * $Id: dc21285.c,v 1.24 2005/11/07 11:14:26 gleixner Exp $
  */
 #include <linux/module.h>
 #include <linux/types.h>
diff --git a/drivers/mtd/maps/dilnetpc.c b/drivers/mtd/maps/dilnetpc.c
index 1c3b34a..0713e3a 100644
--- a/drivers/mtd/maps/dilnetpc.c
+++ b/drivers/mtd/maps/dilnetpc.c
@@ -14,8 +14,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
  *
- * $Id: dilnetpc.c,v 1.20 2005/11/07 11:14:26 gleixner Exp $
- *
  * The DIL/Net PC is a tiny embedded PC board made by SSV Embedded Systems
  * featuring the AMD Elan SC410 processor. There are two variants of this
  * board: DNP/1486 and ADNP/1486. The DNP version has 2 megs of flash
diff --git a/drivers/mtd/maps/dmv182.c b/drivers/mtd/maps/dmv182.c
index e0558b0..d171674 100644
--- a/drivers/mtd/maps/dmv182.c
+++ b/drivers/mtd/maps/dmv182.c
@@ -4,8 +4,6 @@
  *
  * Flash map driver for the Dy4 SVME182 board
  *
- * $Id: dmv182.c,v 1.6 2005/11/07 11:14:26 gleixner Exp $
- *
  * Copyright 2003-2004, TimeSys Corporation
  *
  * Based on the SVME181 flash map, by Tom Nelson, Dot4, Inc. for TimeSys Corp.
diff --git a/drivers/mtd/maps/ebony.c b/drivers/mtd/maps/ebony.c
index 1488bb9..d92b7c7 100644
--- a/drivers/mtd/maps/ebony.c
+++ b/drivers/mtd/maps/ebony.c
@@ -1,6 +1,4 @@
 /*
- * $Id: ebony.c,v 1.16 2005/11/07 11:14:26 gleixner Exp $
- *
  * Mapping for Ebony user flash
  *
  * Matt Porter <mporter@kernel.crashing.org>
diff --git a/drivers/mtd/maps/edb7312.c b/drivers/mtd/maps/edb7312.c
index 1c5b97c..9433738 100644
--- a/drivers/mtd/maps/edb7312.c
+++ b/drivers/mtd/maps/edb7312.c
@@ -1,6 +1,4 @@
 /*
- * $Id: edb7312.c,v 1.14 2005/11/07 11:14:27 gleixner Exp $
- *
  * Handle mapping of the NOR flash on Cogent EDB7312 boards
  *
  * Copyright 2002 SYSGO Real-Time Solutions GmbH
diff --git a/drivers/mtd/maps/fortunet.c b/drivers/mtd/maps/fortunet.c
index 7c50c27..a8e3fde 100644
--- a/drivers/mtd/maps/fortunet.c
+++ b/drivers/mtd/maps/fortunet.c
@@ -1,6 +1,5 @@
 /* fortunet.c memory map
  *
- * $Id: fortunet.c,v 1.11 2005/11/07 11:14:27 gleixner Exp $
  */
 
 #include <linux/module.h>
diff --git a/drivers/mtd/maps/h720x-flash.c b/drivers/mtd/maps/h720x-flash.c
index 6dde318..ef89154 100644
--- a/drivers/mtd/maps/h720x-flash.c
+++ b/drivers/mtd/maps/h720x-flash.c
@@ -2,8 +2,6 @@
  * Flash memory access on Hynix GMS30C7201/HMS30C7202 based
  * evaluation boards
  *
- * $Id: h720x-flash.c,v 1.12 2005/11/07 11:14:27 gleixner Exp $
- *
  * (C) 2002 Jungjun Kim <jungjun.kim@hynix.com>
  *     2003 Thomas Gleixner <tglx@linutronix.de>
  */
diff --git a/drivers/mtd/maps/ichxrom.c b/drivers/mtd/maps/ichxrom.c
index 2c884c4..aeb6c91 100644
--- a/drivers/mtd/maps/ichxrom.c
+++ b/drivers/mtd/maps/ichxrom.c
@@ -2,7 +2,6 @@
  * ichxrom.c
  *
  * Normal mappings of chips in physical memory
- * $Id: ichxrom.c,v 1.19 2005/11/07 11:14:27 gleixner Exp $
  */
 
 #include <linux/module.h>
diff --git a/drivers/mtd/maps/impa7.c b/drivers/mtd/maps/impa7.c
index a0b4dc7..2682ab5 100644
--- a/drivers/mtd/maps/impa7.c
+++ b/drivers/mtd/maps/impa7.c
@@ -1,6 +1,4 @@
 /*
- * $Id: impa7.c,v 1.14 2005/11/07 11:14:27 gleixner Exp $
- *
  * Handle mapping of the NOR flash on implementa A7 boards
  *
  * Copyright 2002 SYSGO Real-Time Solutions GmbH
diff --git a/drivers/mtd/maps/integrator-flash.c b/drivers/mtd/maps/integrator-flash.c
index 325c888..ee361aa 100644
--- a/drivers/mtd/maps/integrator-flash.c
+++ b/drivers/mtd/maps/integrator-flash.c
@@ -22,8 +22,6 @@
    This is access code for flashes using ARM's flash partitioning
    standards.
 
-   $Id: integrator-flash.c,v 1.20 2005/11/07 11:14:27 gleixner Exp $
-
 ======================================================================*/
 
 #include <linux/module.h>
diff --git a/drivers/mtd/maps/ipaq-flash.c b/drivers/mtd/maps/ipaq-flash.c
index f27c132..a806119 100644
--- a/drivers/mtd/maps/ipaq-flash.c
+++ b/drivers/mtd/maps/ipaq-flash.c
@@ -4,8 +4,6 @@
  * (C) 2000 Nicolas Pitre <nico@cam.org>
  * (C) 2002 Hewlett-Packard Company <jamey.hicks@hp.com>
  * (C) 2003 Christian Pellegrin <chri@ascensit.com>, <chri@infis.univ.ts.it>: concatenation of multiple flashes
- *
- * $Id: ipaq-flash.c,v 1.5 2005/11/07 11:14:27 gleixner Exp $
  */
 
 #include <linux/module.h>
diff --git a/drivers/mtd/maps/ixp2000.c b/drivers/mtd/maps/ixp2000.c
index c8396b8..c226479 100644
--- a/drivers/mtd/maps/ixp2000.c
+++ b/drivers/mtd/maps/ixp2000.c
@@ -1,6 +1,4 @@
 /*
- * $Id: ixp2000.c,v 1.9 2005/11/07 11:14:27 gleixner Exp $
- *
  * drivers/mtd/maps/ixp2000.c
  *
  * Mapping for the Intel XScale IXP2000 based systems
diff --git a/drivers/mtd/maps/ixp4xx.c b/drivers/mtd/maps/ixp4xx.c
index 01f19a4..9c7a5fb 100644
--- a/drivers/mtd/maps/ixp4xx.c
+++ b/drivers/mtd/maps/ixp4xx.c
@@ -1,6 +1,4 @@
 /*
- * $Id: ixp4xx.c,v 1.13 2005/11/16 16:23:21 dvrabel Exp $
- *
  * drivers/mtd/maps/ixp4xx.c
  *
  * MTD Map file for IXP4XX based systems. Please do not make per-board
diff --git a/drivers/mtd/maps/l440gx.c b/drivers/mtd/maps/l440gx.c
index 67620ad..9e05450 100644
--- a/drivers/mtd/maps/l440gx.c
+++ b/drivers/mtd/maps/l440gx.c
@@ -1,6 +1,4 @@
 /*
- * $Id: l440gx.c,v 1.18 2005/11/07 11:14:27 gleixner Exp $
- *
  * BIOS Flash chip on Intel 440GX board.
  *
  * Bugs this currently does not work under linuxBIOS.
diff --git a/drivers/mtd/maps/map_funcs.c b/drivers/mtd/maps/map_funcs.c
index 9105e6c..3f26837 100644
--- a/drivers/mtd/maps/map_funcs.c
+++ b/drivers/mtd/maps/map_funcs.c
@@ -1,6 +1,4 @@
 /*
- * $Id: map_funcs.c,v 1.10 2005/06/06 23:04:36 tpoynor Exp $
- *
  * Out-of-line map I/O functions for simple maps when CONFIG_COMPLEX_MAPPINGS
  * is enabled.
  */
diff --git a/drivers/mtd/maps/mbx860.c b/drivers/mtd/maps/mbx860.c
index 06b1187..706f673 100644
--- a/drivers/mtd/maps/mbx860.c
+++ b/drivers/mtd/maps/mbx860.c
@@ -1,6 +1,4 @@
 /*
- * $Id: mbx860.c,v 1.9 2005/11/07 11:14:27 gleixner Exp $
- *
  * Handle mapping of the flash on MBX860 boards
  *
  * Author:	Anton Todorov
diff --git a/drivers/mtd/maps/mtx-1_flash.c b/drivers/mtd/maps/mtx-1_flash.c
index 2a8fde9..a3b6519 100644
--- a/drivers/mtd/maps/mtx-1_flash.c
+++ b/drivers/mtd/maps/mtx-1_flash.c
@@ -1,8 +1,6 @@
 /*
  * Flash memory access on 4G Systems MTX-1 boards
  *
- * $Id: mtx-1_flash.c,v 1.2 2005/11/07 11:14:27 gleixner Exp $
- *
  * (C) 2005 Bruno Randolf <bruno.randolf@4g-systems.biz>
  * (C) 2005 Joern Engel <joern@wohnheim.fh-wedel.de>
  *
diff --git a/drivers/mtd/maps/netsc520.c b/drivers/mtd/maps/netsc520.c
index 95dcab2..c0cb319 100644
--- a/drivers/mtd/maps/netsc520.c
+++ b/drivers/mtd/maps/netsc520.c
@@ -3,8 +3,6 @@
  * Copyright (C) 2001 Mark Langsdorf (mark.langsdorf@amd.com)
  *	based on sc520cdp.c by Sysgo Real-Time Solutions GmbH
  *
- * $Id: netsc520.c,v 1.14 2005/11/07 11:14:27 gleixner Exp $
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
diff --git a/drivers/mtd/maps/nettel.c b/drivers/mtd/maps/nettel.c
index 0c9b305..965e6c6 100644
--- a/drivers/mtd/maps/nettel.c
+++ b/drivers/mtd/maps/nettel.c
@@ -5,8 +5,6 @@
  *
  *      (C) Copyright 2000-2001, Greg Ungerer (gerg@snapgear.com)
  *      (C) Copyright 2001-2002, SnapGear (www.snapgear.com)
- *
- *	$Id: nettel.c,v 1.12 2005/11/29 14:30:00 gleixner Exp $
  */
 
 /****************************************************************************/
diff --git a/drivers/mtd/maps/octagon-5066.c b/drivers/mtd/maps/octagon-5066.c
index a6642db..43e04c1 100644
--- a/drivers/mtd/maps/octagon-5066.c
+++ b/drivers/mtd/maps/octagon-5066.c
@@ -1,4 +1,3 @@
-// $Id: octagon-5066.c,v 1.28 2005/11/07 11:14:27 gleixner Exp $
 /* ######################################################################
 
    Octagon 5066 MTD Driver.
diff --git a/drivers/mtd/maps/omap-toto-flash.c b/drivers/mtd/maps/omap-toto-flash.c
index e6e391e..0a60ebb 100644
--- a/drivers/mtd/maps/omap-toto-flash.c
+++ b/drivers/mtd/maps/omap-toto-flash.c
@@ -4,8 +4,6 @@
  * jzhang@ti.com (C) 2003 Texas Instruments.
  *
  *  (C) 2002 MontVista Software, Inc.
- *
- * $Id: omap-toto-flash.c,v 1.5 2005/11/07 11:14:27 gleixner Exp $
  */
 
 #include <linux/module.h>
diff --git a/drivers/mtd/maps/pci.c b/drivers/mtd/maps/pci.c
index d2ab1ba..5c6a25c 100644
--- a/drivers/mtd/maps/pci.c
+++ b/drivers/mtd/maps/pci.c
@@ -7,8 +7,6 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
- *  $Id: pci.c,v 1.14 2005/11/17 08:20:27 dwmw2 Exp $
- *
  * Generic PCI memory map driver.  We support the following boards:
  *  - Intel IQ80310 ATU.
  *  - Intel EBSA285 (blank rom programming mode). Tested working 27/09/2001
diff --git a/drivers/mtd/maps/pcmciamtd.c b/drivers/mtd/maps/pcmciamtd.c
index 1912d96..8f7ca86 100644
--- a/drivers/mtd/maps/pcmciamtd.c
+++ b/drivers/mtd/maps/pcmciamtd.c
@@ -1,6 +1,4 @@
 /*
- * $Id: pcmciamtd.c,v 1.55 2005/11/07 11:14:28 gleixner Exp $
- *
  * pcmciamtd.c - MTD driver for PCMCIA flash memory cards
  *
  * Author: Simon Evans <spse@secret.org.uk>
@@ -48,7 +46,6 @@ static const int debug = 0;
 
 
 #define DRIVER_DESC	"PCMCIA Flash memory card driver"
-#define DRIVER_VERSION	"$Revision: 1.55 $"
 
 /* Size of the PCMCIA address space: 26 bits = 64 MB */
 #define MAX_PCMCIA_ADDR	0x4000000
@@ -790,7 +787,7 @@ static struct pcmcia_driver pcmciamtd_driver = {
 
 static int __init init_pcmciamtd(void)
 {
-	info(DRIVER_DESC " " DRIVER_VERSION);
+	info(DRIVER_DESC);
 
 	if(bankwidth && bankwidth != 1 && bankwidth != 2) {
 		info("bad bankwidth (%d), using default", bankwidth);
diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
index 183255f..1f6b906 100644
--- a/drivers/mtd/maps/physmap.c
+++ b/drivers/mtd/maps/physmap.c
@@ -1,6 +1,4 @@
 /*
- * $Id: physmap.c,v 1.39 2005/11/29 14:49:36 gleixner Exp $
- *
  * Normal mappings of chips in physical memory
  *
  * Copyright (C) 2003 MontaVista Software Inc.
diff --git a/drivers/mtd/maps/plat-ram.c b/drivers/mtd/maps/plat-ram.c
index 3eb2643..e7dd9c8 100644
--- a/drivers/mtd/maps/plat-ram.c
+++ b/drivers/mtd/maps/plat-ram.c
@@ -6,8 +6,6 @@
  *
  * Generic platfrom device based RAM map
  *
- * $Id: plat-ram.c,v 1.7 2005/11/07 11:14:28 gleixner Exp $
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
diff --git a/drivers/mtd/maps/redwood.c b/drivers/mtd/maps/redwood.c
index 4d858b3..de002eb 100644
--- a/drivers/mtd/maps/redwood.c
+++ b/drivers/mtd/maps/redwood.c
@@ -1,6 +1,4 @@
 /*
- * $Id: redwood.c,v 1.11 2005/11/07 11:14:28 gleixner Exp $
- *
  * drivers/mtd/maps/redwood.c
  *
  * FLASH map for the IBM Redwood 4/5/6 boards.
diff --git a/drivers/mtd/maps/rpxlite.c b/drivers/mtd/maps/rpxlite.c
index 809a0c8..14d90ed 100644
--- a/drivers/mtd/maps/rpxlite.c
+++ b/drivers/mtd/maps/rpxlite.c
@@ -1,6 +1,4 @@
 /*
- * $Id: rpxlite.c,v 1.22 2004/11/04 13:24:15 gleixner Exp $
- *
  * Handle mapping of the flash on the RPX Lite and CLLF boards
  */
 
diff --git a/drivers/mtd/maps/sa1100-flash.c b/drivers/mtd/maps/sa1100-flash.c
index c7d5a52..e177a43 100644
--- a/drivers/mtd/maps/sa1100-flash.c
+++ b/drivers/mtd/maps/sa1100-flash.c
@@ -2,8 +2,6 @@
  * Flash memory access on SA11x0 based devices
  *
  * (C) 2000 Nicolas Pitre <nico@cam.org>
- *
- * $Id: sa1100-flash.c,v 1.51 2005/11/07 11:14:28 gleixner Exp $
  */
 #include <linux/module.h>
 #include <linux/types.h>
diff --git a/drivers/mtd/maps/sbc8240.c b/drivers/mtd/maps/sbc8240.c
index b8c1331..6e1e99c 100644
--- a/drivers/mtd/maps/sbc8240.c
+++ b/drivers/mtd/maps/sbc8240.c
@@ -4,9 +4,6 @@
  * Carolyn Smith, Tektronix, Inc.
  *
  * This code is GPLed
- *
- * $Id: sbc8240.c,v 1.5 2005/11/07 11:14:28 gleixner Exp $
- *
  */
 
 /*
diff --git a/drivers/mtd/maps/sbc_gxx.c b/drivers/mtd/maps/sbc_gxx.c
index 7cc4041..1b1c0b7 100644
--- a/drivers/mtd/maps/sbc_gxx.c
+++ b/drivers/mtd/maps/sbc_gxx.c
@@ -17,8 +17,6 @@
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
 
-   $Id: sbc_gxx.c,v 1.35 2005/11/07 11:14:28 gleixner Exp $
-
 The SBC-MediaGX / SBC-GXx has up to 16 MiB of
 Intel StrataFlash (28F320/28F640) in x8 mode.
 
diff --git a/drivers/mtd/maps/sc520cdp.c b/drivers/mtd/maps/sc520cdp.c
index 4045e37..85c1e56 100644
--- a/drivers/mtd/maps/sc520cdp.c
+++ b/drivers/mtd/maps/sc520cdp.c
@@ -16,8 +16,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
  *
- * $Id: sc520cdp.c,v 1.23 2005/11/17 08:20:27 dwmw2 Exp $
- *
  *
  * The SC520CDP is an evaluation board for the Elan SC520 processor available
  * from AMD. It has two banks of 32-bit Flash ROM, each 8 Megabytes in size,
diff --git a/drivers/mtd/maps/scb2_flash.c b/drivers/mtd/maps/scb2_flash.c
index 0fc5584..21169e6 100644
--- a/drivers/mtd/maps/scb2_flash.c
+++ b/drivers/mtd/maps/scb2_flash.c
@@ -1,6 +1,5 @@
 /*
  * MTD map driver for BIOS Flash on Intel SCB2 boards
- * $Id: scb2_flash.c,v 1.12 2005/03/18 14:04:35 gleixner Exp $
  * Copyright (C) 2002 Sun Microsystems, Inc.
  * Tim Hockin <thockin@sun.com>
  *
diff --git a/drivers/mtd/maps/scx200_docflash.c b/drivers/mtd/maps/scx200_docflash.c
index 5e2bce2..b5391eb 100644
--- a/drivers/mtd/maps/scx200_docflash.c
+++ b/drivers/mtd/maps/scx200_docflash.c
@@ -2,8 +2,6 @@
 
    Copyright (c) 2001,2002 Christer Weinigel <wingel@nano-system.com>
 
-   $Id: scx200_docflash.c,v 1.12 2005/11/07 11:14:28 gleixner Exp $
-
    National Semiconductor SCx200 flash mapped with DOCCS
 */
 
diff --git a/drivers/mtd/maps/sharpsl-flash.c b/drivers/mtd/maps/sharpsl-flash.c
index 917dc77..026eab0 100644
--- a/drivers/mtd/maps/sharpsl-flash.c
+++ b/drivers/mtd/maps/sharpsl-flash.c
@@ -4,8 +4,6 @@
  * Copyright (C) 2001 Lineo Japan, Inc.
  * Copyright (C) 2002  SHARP
  *
- * $Id: sharpsl-flash.c,v 1.7 2005/11/07 11:14:28 gleixner Exp $
- *
  * based on rpxlite.c,v 1.15 2001/10/02 15:05:14 dwmw2 Exp
  *          Handle mapping of the flash on the RPX Lite and CLLF boards
  *
diff --git a/drivers/mtd/maps/solutionengine.c b/drivers/mtd/maps/solutionengine.c
index d76ceef..0eb41d9 100644
--- a/drivers/mtd/maps/solutionengine.c
+++ b/drivers/mtd/maps/solutionengine.c
@@ -1,6 +1,4 @@
 /*
- * $Id: solutionengine.c,v 1.15 2005/11/07 11:14:28 gleixner Exp $
- *
  * Flash and EPROM on Hitachi Solution Engine and similar boards.
  *
  * (C) 2001 Red Hat, Inc.
diff --git a/drivers/mtd/maps/sun_uflash.c b/drivers/mtd/maps/sun_uflash.c
index 001af7f..0d7c883 100644
--- a/drivers/mtd/maps/sun_uflash.c
+++ b/drivers/mtd/maps/sun_uflash.c
@@ -1,4 +1,4 @@
-/* $Id: sun_uflash.c,v 1.13 2005/11/07 11:14:28 gleixner Exp $
+/*
  *
  * sun_uflash - Driver implementation for user-programmable flash
  * present on many Sun Microsystems SME boardsets.
diff --git a/drivers/mtd/maps/tqm8xxl.c b/drivers/mtd/maps/tqm8xxl.c
index 5217340..a5d3d85 100644
--- a/drivers/mtd/maps/tqm8xxl.c
+++ b/drivers/mtd/maps/tqm8xxl.c
@@ -2,8 +2,6 @@
  * Handle mapping of the flash memory access routines
  * on TQM8xxL based devices.
  *
- * $Id: tqm8xxl.c,v 1.15 2005/11/07 11:14:28 gleixner Exp $
- *
  * based on rpxlite.c
  *
  * Copyright(C) 2001 Kirk Lee <kirk@hpc.ee.ntu.edu.tw>
diff --git a/drivers/mtd/maps/ts5500_flash.c b/drivers/mtd/maps/ts5500_flash.c
index b47270e..e2147bf 100644
--- a/drivers/mtd/maps/ts5500_flash.c
+++ b/drivers/mtd/maps/ts5500_flash.c
@@ -22,8 +22,6 @@
  * - Drive A and B use the resident flash disk (RFD) flash translation layer.
  * - If you have created your own jffs file system and the bios overwrites
  *   it during boot, try disabling Drive A: and B: in the boot order.
- *
- * $Id: ts5500_flash.c,v 1.5 2005/11/07 11:14:28 gleixner Exp $
  */
 
 #include <linux/init.h>
diff --git a/drivers/mtd/maps/tsunami_flash.c b/drivers/mtd/maps/tsunami_flash.c
index 0f915ac..77a8bfc 100644
--- a/drivers/mtd/maps/tsunami_flash.c
+++ b/drivers/mtd/maps/tsunami_flash.c
@@ -2,7 +2,6 @@
  * tsunami_flash.c
  *
  * flash chip on alpha ds10...
- * $Id: tsunami_flash.c,v 1.10 2005/11/07 11:14:29 gleixner Exp $
  */
 #include <asm/io.h>
 #include <asm/core_tsunami.h>
diff --git a/drivers/mtd/maps/uclinux.c b/drivers/mtd/maps/uclinux.c
index c42f4b8..bac000a 100644
--- a/drivers/mtd/maps/uclinux.c
+++ b/drivers/mtd/maps/uclinux.c
@@ -4,8 +4,6 @@
  *	uclinux.c -- generic memory mapped MTD driver for uclinux
  *
  *	(C) Copyright 2002, Greg Ungerer (gerg@snapgear.com)
- *
- * 	$Id: uclinux.c,v 1.12 2005/11/07 11:14:29 gleixner Exp $
  */
 
 /****************************************************************************/
diff --git a/drivers/mtd/maps/vmax301.c b/drivers/mtd/maps/vmax301.c
index b3e4873..5a0c9a3 100644
--- a/drivers/mtd/maps/vmax301.c
+++ b/drivers/mtd/maps/vmax301.c
@@ -1,4 +1,3 @@
-// $Id: vmax301.c,v 1.32 2005/11/07 11:14:29 gleixner Exp $
 /* ######################################################################
 
    Tempustech VMAX SBC301 MTD Driver.
diff --git a/drivers/mtd/maps/walnut.c b/drivers/mtd/maps/walnut.c
index ca93212..e243476 100644
--- a/drivers/mtd/maps/walnut.c
+++ b/drivers/mtd/maps/walnut.c
@@ -1,6 +1,4 @@
 /*
- * $Id: walnut.c,v 1.3 2005/11/07 11:14:29 gleixner Exp $
- *
  * Mapping for Walnut flash
  * (used ebony.c as a "framework")
  *
diff --git a/drivers/mtd/maps/wr_sbc82xx_flash.c b/drivers/mtd/maps/wr_sbc82xx_flash.c
index ac5b810..413b0cf 100644
--- a/drivers/mtd/maps/wr_sbc82xx_flash.c
+++ b/drivers/mtd/maps/wr_sbc82xx_flash.c
@@ -1,6 +1,4 @@
 /*
- * $Id: wr_sbc82xx_flash.c,v 1.8 2005/11/07 11:14:29 gleixner Exp $
- *
  * Map for flash chips on Wind River PowerQUICC II SBC82xx board.
  *
  * Copyright (C) 2004 Red Hat, Inc.
diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 839eed8..a0ada45 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -1,6 +1,4 @@
 /*
- * $Id: mtd_blkdevs.c,v 1.27 2005/11/07 11:14:20 gleixner Exp $
- *
  * (C) 2003 David Woodhouse <dwmw2@infradead.org>
  *
  * Interface to Linux 2.5 block layer for MTD 'translation layers'.
diff --git a/drivers/mtd/mtdblock.c b/drivers/mtd/mtdblock.c
index 952da30..208c6fa 100644
--- a/drivers/mtd/mtdblock.c
+++ b/drivers/mtd/mtdblock.c
@@ -1,8 +1,6 @@
 /*
  * Direct MTD block device access
  *
- * $Id: mtdblock.c,v 1.68 2005/11/07 11:14:20 gleixner Exp $
- *
  * (C) 2000-2003 Nicolas Pitre <nico@cam.org>
  * (C) 1999-2003 David Woodhouse <dwmw2@infradead.org>
  */
diff --git a/drivers/mtd/mtdblock_ro.c b/drivers/mtd/mtdblock_ro.c
index f79dbb4..852165f 100644
--- a/drivers/mtd/mtdblock_ro.c
+++ b/drivers/mtd/mtdblock_ro.c
@@ -1,6 +1,4 @@
 /*
- * $Id: mtdblock_ro.c,v 1.19 2004/11/16 18:28:59 dwmw2 Exp $
- *
  * (C) 2003 David Woodhouse <dwmw2@infradead.org>
  *
  * Simple read-only (writable only for RAM) mtdblock driver
diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 5d3ac51..4b3156f 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -1,6 +1,4 @@
 /*
- * $Id: mtdchar.c,v 1.76 2005/11/07 11:14:20 gleixner Exp $
- *
  * Character-device access to raw MTD devices.
  *
  */
diff --git a/drivers/mtd/mtdconcat.c b/drivers/mtd/mtdconcat.c
index d563dcd..2972a5e 100644
--- a/drivers/mtd/mtdconcat.c
+++ b/drivers/mtd/mtdconcat.c
@@ -6,8 +6,6 @@
  * NAND support by Christian Gan <cgan@iders.ca>
  *
  * This code is GPL
- *
- * $Id: mtdconcat.c,v 1.11 2005/11/07 11:14:20 gleixner Exp $
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index f7e7890..61d3cff 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -1,6 +1,4 @@
 /*
- * $Id: mtdcore.c,v 1.47 2005/11/07 11:14:20 gleixner Exp $
- *
  * Core registration and callback routines for MTD
  * drivers and users.
  *
diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index 07c7011..11b803c 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -5,8 +5,6 @@
  *
  * This code is GPL
  *
- * $Id: mtdpart.c,v 1.55 2005/11/07 11:14:20 gleixner Exp $
- *
  * 	02-21-2002	Thomas Gleixner <gleixner@autronix.de>
  *			added support for read_oob, write_oob
  */
diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 5076faf..7dea6c3 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -1,5 +1,4 @@
 # drivers/mtd/nand/Kconfig
-# $Id: Kconfig,v 1.35 2005/11/07 11:14:30 gleixner Exp $
 
 menuconfig MTD_NAND
 	tristate "NAND Device Support"
diff --git a/drivers/mtd/nand/Makefile b/drivers/mtd/nand/Makefile
index a6e74a4..d95a10c 100644
--- a/drivers/mtd/nand/Makefile
+++ b/drivers/mtd/nand/Makefile
@@ -1,7 +1,6 @@
 #
 # linux/drivers/nand/Makefile
 #
-# $Id: Makefile.common,v 1.15 2004/11/26 12:28:22 dedekind Exp $
 
 obj-$(CONFIG_MTD_NAND)			+= nand.o nand_ecc.o
 obj-$(CONFIG_MTD_NAND_IDS)		+= nand_ids.o
diff --git a/drivers/mtd/nand/au1550nd.c b/drivers/mtd/nand/au1550nd.c
index 09e421a..22ad9f3 100644
--- a/drivers/mtd/nand/au1550nd.c
+++ b/drivers/mtd/nand/au1550nd.c
@@ -3,8 +3,6 @@
  *
  *  Copyright (C) 2004 Embedded Edge, LLC
  *
- * $Id: au1550nd.c,v 1.13 2005/11/07 11:14:30 gleixner Exp $
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
diff --git a/drivers/mtd/nand/autcpu12.c b/drivers/mtd/nand/autcpu12.c
index dd38011..553dd7e 100644
--- a/drivers/mtd/nand/autcpu12.c
+++ b/drivers/mtd/nand/autcpu12.c
@@ -6,8 +6,6 @@
  *  Derived from drivers/mtd/spia.c
  *	 Copyright (C) 2000 Steven J. Hill (sjhill@realitydiluted.com)
  *
- * $Id: autcpu12.c,v 1.23 2005/11/07 11:14:30 gleixner Exp $
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
diff --git a/drivers/mtd/nand/diskonchip.c b/drivers/mtd/nand/diskonchip.c
index 0e72153..cd4393c 100644
--- a/drivers/mtd/nand/diskonchip.c
+++ b/drivers/mtd/nand/diskonchip.c
@@ -15,8 +15,6 @@
  * converted to the generic Reed-Solomon library by Thomas Gleixner <tglx@linutronix.de>
  *
  * Interface to generic NAND code for M-Systems DiskOnChip devices
- *
- * $Id: diskonchip.c,v 1.55 2005/11/07 11:14:30 gleixner Exp $
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/mtd/nand/edb7312.c b/drivers/mtd/nand/edb7312.c
index ba67bbe..387e435 100644
--- a/drivers/mtd/nand/edb7312.c
+++ b/drivers/mtd/nand/edb7312.c
@@ -6,8 +6,6 @@
  *  Derived from drivers/mtd/nand/autcpu12.c
  *       Copyright (c) 2001 Thomas Gleixner (gleixner@autronix.de)
  *
- * $Id: edb7312.c,v 1.12 2005/11/07 11:14:30 gleixner Exp $
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
diff --git a/drivers/mtd/nand/h1910.c b/drivers/mtd/nand/h1910.c
index 2d585d2..9e59de5 100644
--- a/drivers/mtd/nand/h1910.c
+++ b/drivers/mtd/nand/h1910.c
@@ -7,8 +7,6 @@
  *       Copyright (C) 2002 Marius Gröger (mag@sysgo.de)
  *       Copyright (c) 2001 Thomas Gleixner (gleixner@autronix.de)
  *
- * $Id: h1910.c,v 1.6 2005/11/07 11:14:30 gleixner Exp $
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
diff --git a/drivers/mtd/nand/nand_bbt.c b/drivers/mtd/nand/nand_bbt.c
index 5e121ce..0b1c485 100644
--- a/drivers/mtd/nand/nand_bbt.c
+++ b/drivers/mtd/nand/nand_bbt.c
@@ -6,8 +6,6 @@
  *
  *  Copyright (C) 2004 Thomas Gleixner (tglx@linutronix.de)
  *
- * $Id: nand_bbt.c,v 1.36 2005/11/07 11:14:30 gleixner Exp $
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
diff --git a/drivers/mtd/nand/nand_ecc.c b/drivers/mtd/nand/nand_ecc.c
index 9003a13..918a806 100644
--- a/drivers/mtd/nand/nand_ecc.c
+++ b/drivers/mtd/nand/nand_ecc.c
@@ -9,8 +9,6 @@
  *
  * Copyright (C) 2006 Thomas Gleixner <tglx@linutronix.de>
  *
- * $Id: nand_ecc.c,v 1.15 2005/11/07 11:14:30 gleixner Exp $
- *
  * This file is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
  * Free Software Foundation; either version 2 or (at your option) any
diff --git a/drivers/mtd/nand/nand_ids.c b/drivers/mtd/nand/nand_ids.c
index a3e3ab0..69ee2c9 100644
--- a/drivers/mtd/nand/nand_ids.c
+++ b/drivers/mtd/nand/nand_ids.c
@@ -3,8 +3,6 @@
  *
  *  Copyright (C) 2002 Thomas Gleixner (tglx@linutronix.de)
  *
- * $Id: nand_ids.c,v 1.16 2005/11/07 11:14:31 gleixner Exp $
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
diff --git a/drivers/mtd/nand/nandsim.c b/drivers/mtd/nand/nandsim.c
index bb885d1..e8840b4 100644
--- a/drivers/mtd/nand/nandsim.c
+++ b/drivers/mtd/nand/nandsim.c
@@ -21,8 +21,6 @@
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA
- *
- * $Id: nandsim.c,v 1.8 2005/03/19 15:33:56 dedekind Exp $
  */
 
 #include <linux/init.h>
diff --git a/drivers/mtd/nand/ppchameleonevb.c b/drivers/mtd/nand/ppchameleonevb.c
index 082073a..cc86584 100644
--- a/drivers/mtd/nand/ppchameleonevb.c
+++ b/drivers/mtd/nand/ppchameleonevb.c
@@ -6,8 +6,6 @@
  *  Derived from drivers/mtd/nand/edb7312.c
  *
  *
- * $Id: ppchameleonevb.c,v 1.7 2005/11/07 11:14:31 gleixner Exp $
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
diff --git a/drivers/mtd/nand/rtc_from4.c b/drivers/mtd/nand/rtc_from4.c
index 26f8821..a033c4c 100644
--- a/drivers/mtd/nand/rtc_from4.c
+++ b/drivers/mtd/nand/rtc_from4.c
@@ -6,8 +6,6 @@
  *  Derived from drivers/mtd/nand/spia.c
  *       Copyright (C) 2000 Steven J. Hill (sjhill@realitydiluted.com)
  *
- * $Id: rtc_from4.c,v 1.10 2005/11/07 11:14:31 gleixner Exp $
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
diff --git a/drivers/mtd/nand/s3c2410.c b/drivers/mtd/nand/s3c2410.c
index b34a460..91f42e4 100644
--- a/drivers/mtd/nand/s3c2410.c
+++ b/drivers/mtd/nand/s3c2410.c
@@ -20,8 +20,6 @@
  *	20-Oct-2005  BJD  Fix timing calculation bug
  *	14-Jan-2006  BJD  Allow clock to be stopped when idle
  *
- * $Id: s3c2410.c,v 1.23 2006/04/01 18:06:29 bjd Exp $
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
diff --git a/drivers/mtd/nand/sharpsl.c b/drivers/mtd/nand/sharpsl.c
index 033f880..6dba2fb 100644
--- a/drivers/mtd/nand/sharpsl.c
+++ b/drivers/mtd/nand/sharpsl.c
@@ -3,8 +3,6 @@
  *
  *  Copyright (C) 2004 Richard Purdie
  *
- *  $Id: sharpsl.c,v 1.7 2005/11/07 11:14:31 gleixner Exp $
- *
  *  Based on Sharp's NAND driver sharp_sl.c
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/mtd/nand/spia.c b/drivers/mtd/nand/spia.c
index 1f6d429..0cc6d0a 100644
--- a/drivers/mtd/nand/spia.c
+++ b/drivers/mtd/nand/spia.c
@@ -8,8 +8,6 @@
  *			to controllines	(due to change in nand.c)
  *			page_cache added
  *
- * $Id: spia.c,v 1.25 2005/11/07 11:14:31 gleixner Exp $
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
diff --git a/drivers/mtd/nand/toto.c b/drivers/mtd/nand/toto.c
index f9e2d4a..bbf492e 100644
--- a/drivers/mtd/nand/toto.c
+++ b/drivers/mtd/nand/toto.c
@@ -14,8 +14,6 @@
  *  Overview:
  *   This is a device driver for the NAND flash device found on the
  *   TI fido board. It supports 32MiB and 64MiB cards
- *
- * $Id: toto.c,v 1.5 2005/11/07 11:14:31 gleixner Exp $
  */
 
 #include <linux/slab.h>
diff --git a/drivers/mtd/nand/ts7250.c b/drivers/mtd/nand/ts7250.c
index f400810..807a727 100644
--- a/drivers/mtd/nand/ts7250.c
+++ b/drivers/mtd/nand/ts7250.c
@@ -9,8 +9,6 @@
  * Derived from drivers/mtd/nand/autcpu12.c
  *   Copyright (c) 2001 Thomas Gleixner (gleixner@autronix.de)
  *
- * $Id: ts7250.c,v 1.4 2004/12/30 22:02:07 joff Exp $
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
diff --git a/drivers/mtd/nftlcore.c b/drivers/mtd/nftlcore.c
index 0c9ce19..320b929 100644
--- a/drivers/mtd/nftlcore.c
+++ b/drivers/mtd/nftlcore.c
@@ -1,7 +1,6 @@
 /* Linux driver for NAND Flash Translation Layer      */
 /* (c) 1999 Machine Vision Holdings, Inc.             */
 /* Author: David Woodhouse <dwmw2@infradead.org>      */
-/* $Id: nftlcore.c,v 1.98 2005/11/07 11:14:21 gleixner Exp $ */
 
 /*
   The contents of this file are distributed under the GNU General
@@ -803,12 +802,8 @@ static struct mtd_blktrans_ops nftl_tr = {
 	.owner		= THIS_MODULE,
 };
 
-extern char nftlmountrev[];
-
 static int __init init_nftl(void)
 {
-	printk(KERN_INFO "NFTL driver: nftlcore.c $Revision: 1.98 $, nftlmount.c %s\n", nftlmountrev);
-
 	return register_mtd_blktrans(&nftl_tr);
 }
 
diff --git a/drivers/mtd/nftlmount.c b/drivers/mtd/nftlmount.c
index 345e6ef..ccc4f20 100644
--- a/drivers/mtd/nftlmount.c
+++ b/drivers/mtd/nftlmount.c
@@ -4,8 +4,6 @@
  * Author: Fabrice Bellard (fabrice.bellard@netgem.com)
  * Copyright (C) 2000 Netgem S.A.
  *
- * $Id: nftlmount.c,v 1.41 2005/11/07 11:14:21 gleixner Exp $
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -31,8 +29,6 @@
 
 #define SECTORSIZE 512
 
-char nftlmountrev[]="$Revision: 1.41 $";
-
 /* find_boot_record: Find the NFTL Media Header and its Spare copy which contains the
  *	various device information of the NFTL partition and Bad Unit Table. Update
  *	the ReplUnitTable[] table accroding to the Bad Unit Table. ReplUnitTable[]
diff --git a/drivers/mtd/redboot.c b/drivers/mtd/redboot.c
index 4747490..5afa268 100644
--- a/drivers/mtd/redboot.c
+++ b/drivers/mtd/redboot.c
@@ -1,6 +1,4 @@
 /*
- * $Id: redboot.c,v 1.21 2006/03/30 18:34:37 bjd Exp $
- *
  * Parse RedBoot-style Flash Image System (FIS) tables and
  * produce a Linux partition array to match.
  */
diff --git a/drivers/mtd/rfd_ftl.c b/drivers/mtd/rfd_ftl.c
index c84e454..e538c0a 100644
--- a/drivers/mtd/rfd_ftl.c
+++ b/drivers/mtd/rfd_ftl.c
@@ -3,8 +3,6 @@
  *
  * Copyright (C) 2005  Sean Young <sean@mess.org>
  *
- * $Id: rfd_ftl.c,v 1.8 2006/01/15 12:51:44 sean Exp $
- *
  * This type of flash translation layer (FTL) is used by the Embedded BIOS
  * by General Software. It is known as the Resident Flash Disk (RFD), see:
  *
diff --git a/include/linux/jffs2.h b/include/linux/jffs2.h
index 6b563ca..da720bc 100644
--- a/include/linux/jffs2.h
+++ b/include/linux/jffs2.h
@@ -7,9 +7,6 @@
  *
  * For licensing information, see the file 'LICENCE' in the
  * jffs2 directory.
- *
- * $Id: jffs2.h,v 1.38 2005/09/26 11:37:23 havasi Exp $
- *
  */
 
 #ifndef __LINUX_JFFS2_H__
diff --git a/include/linux/mtd/blktrans.h b/include/linux/mtd/blktrans.h
index 9a6e2f9..310e616 100644
--- a/include/linux/mtd/blktrans.h
+++ b/include/linux/mtd/blktrans.h
@@ -1,6 +1,4 @@
 /*
- * $Id: blktrans.h,v 1.6 2005/11/07 11:14:54 gleixner Exp $
- *
  * (C) 2003 David Woodhouse <dwmw2@infradead.org>
  *
  * Interface to Linux block layer for MTD 'translation layers'.
diff --git a/include/linux/mtd/cfi.h b/include/linux/mtd/cfi.h
index b0ddf4b..d6fb115 100644
--- a/include/linux/mtd/cfi.h
+++ b/include/linux/mtd/cfi.h
@@ -1,7 +1,6 @@
 
 /* Common Flash Interface structures
  * See http://support.intel.com/design/flash/technote/index.htm
- * $Id: cfi.h,v 1.57 2005/11/15 23:28:17 tpoynor Exp $
  */
 
 #ifndef __MTD_CFI_H__
diff --git a/include/linux/mtd/cfi_endian.h b/include/linux/mtd/cfi_endian.h
index 25724f7..d802f77 100644
--- a/include/linux/mtd/cfi_endian.h
+++ b/include/linux/mtd/cfi_endian.h
@@ -1,8 +1,3 @@
-/*
- * $Id: cfi_endian.h,v 1.11 2002/01/30 23:20:48 awozniak Exp $
- *
- */
-
 #include <asm/byteorder.h>
 
 #ifndef CONFIG_MTD_CFI_ADV_OPTIONS
diff --git a/include/linux/mtd/concat.h b/include/linux/mtd/concat.h
index ed8dc67..c02f3d2 100644
--- a/include/linux/mtd/concat.h
+++ b/include/linux/mtd/concat.h
@@ -4,8 +4,6 @@
  * (C) 2002 Robert Kaiser <rkaiser@sysgo.de>
  *
  * This code is GPL
- *
- * $Id: concat.h,v 1.1 2002/03/08 16:34:36 rkaiser Exp $
  */
 
 #ifndef MTD_CONCAT_H
diff --git a/include/linux/mtd/doc2000.h b/include/linux/mtd/doc2000.h
index 9addd07..0a6d516 100644
--- a/include/linux/mtd/doc2000.h
+++ b/include/linux/mtd/doc2000.h
@@ -6,8 +6,6 @@
  * Copyright (C) 2002-2003 Greg Ungerer <gerg@snapgear.com>
  * Copyright (C) 2002-2003 SnapGear Inc
  *
- * $Id: doc2000.h,v 1.25 2005/11/07 11:14:54 gleixner Exp $
- *
  * Released under GPL
  */
 
diff --git a/include/linux/mtd/flashchip.h b/include/linux/mtd/flashchip.h
index 39e7d2a..08dd131 100644
--- a/include/linux/mtd/flashchip.h
+++ b/include/linux/mtd/flashchip.h
@@ -5,9 +5,6 @@
  * Contains information about the location and state of a given flash device
  *
  * (C) 2000 Red Hat. GPLd.
- *
- * $Id: flashchip.h,v 1.18 2005/11/07 11:14:54 gleixner Exp $
- *
  */
 
 #ifndef __MTD_FLASHCHIP_H__
diff --git a/include/linux/mtd/ftl.h b/include/linux/mtd/ftl.h
index d996091..0be442f 100644
--- a/include/linux/mtd/ftl.h
+++ b/include/linux/mtd/ftl.h
@@ -1,6 +1,4 @@
 /*
- * $Id: ftl.h,v 1.7 2005/11/07 11:14:54 gleixner Exp $
- *
  * Derived from (and probably identical to):
  * ftl.h 1.7 1999/10/25 20:23:17
  *
diff --git a/include/linux/mtd/gen_probe.h b/include/linux/mtd/gen_probe.h
index 256e734..df362dd 100644
--- a/include/linux/mtd/gen_probe.h
+++ b/include/linux/mtd/gen_probe.h
@@ -1,7 +1,6 @@
 /*
  * (C) 2001, 2001 Red Hat, Inc.
  * GPL'd
- * $Id: gen_probe.h,v 1.4 2005/11/07 11:14:54 gleixner Exp $
  */
 
 #ifndef __LINUX_MTD_GEN_PROBE_H__
diff --git a/include/linux/mtd/inftl.h b/include/linux/mtd/inftl.h
index 85fd041..64ee53c 100644
--- a/include/linux/mtd/inftl.h
+++ b/include/linux/mtd/inftl.h
@@ -2,8 +2,6 @@
  *	inftl.h -- defines to support the Inverse NAND Flash Translation Layer
  *
  *	(C) Copyright 2002, Greg Ungerer (gerg@snapgear.com)
- *
- *	$Id: inftl.h,v 1.7 2005/06/13 13:08:45 sean Exp $
  */
 
 #ifndef __MTD_INFTL_H__
@@ -52,8 +50,6 @@ struct INFTLrecord {
 int INFTL_mount(struct INFTLrecord *s);
 int INFTL_formatblock(struct INFTLrecord *s, int block);
 
-extern char inftlmountrev[];
-
 void INFTL_dumptables(struct INFTLrecord *s);
 void INFTL_dumpVUchains(struct INFTLrecord *s);
 
diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
index a9fae03..85e3939 100644
--- a/include/linux/mtd/map.h
+++ b/include/linux/mtd/map.h
@@ -1,6 +1,5 @@
 
 /* Overhauled routines for dealing with different mmap regions of flash */
-/* $Id: map.h,v 1.54 2005/11/07 11:14:54 gleixner Exp $ */
 
 #ifndef __LINUX_MTD_MAP_H__
 #define __LINUX_MTD_MAP_H__
diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
index 245f909..31ed234 100644
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -1,6 +1,4 @@
 /*
- * $Id: mtd.h,v 1.61 2005/11/07 11:14:54 gleixner Exp $
- *
  * Copyright (C) 1999-2003 David Woodhouse <dwmw2@infradead.org> et al.
  *
  * Released under GPL
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index c42bc7f..1288be7 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -5,8 +5,6 @@
  *                     Steven J. Hill <sjhill@realitydiluted.com>
  *		       Thomas Gleixner <tglx@linutronix.de>
  *
- * $Id: nand.h,v 1.74 2005/09/15 13:58:50 vwool Exp $
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
diff --git a/include/linux/mtd/nand_ecc.h b/include/linux/mtd/nand_ecc.h
index 12c5bc3..090da50 100644
--- a/include/linux/mtd/nand_ecc.h
+++ b/include/linux/mtd/nand_ecc.h
@@ -3,8 +3,6 @@
  *
  *  Copyright (C) 2000 Steven J. Hill (sjhill@realitydiluted.com)
  *
- * $Id: nand_ecc.h,v 1.4 2004/06/17 02:35:02 dbrown Exp $
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
diff --git a/include/linux/mtd/nftl.h b/include/linux/mtd/nftl.h
index 001eec5..dcaf611 100644
--- a/include/linux/mtd/nftl.h
+++ b/include/linux/mtd/nftl.h
@@ -1,6 +1,4 @@
 /*
- * $Id: nftl.h,v 1.16 2004/06/30 14:49:00 dbrown Exp $
- *
  * (C) 1999-2003 David Woodhouse <dwmw2@infradead.org>
  */
 
diff --git a/include/linux/mtd/partitions.h b/include/linux/mtd/partitions.h
index 7c37d7e..5014f7a 100644
--- a/include/linux/mtd/partitions.h
+++ b/include/linux/mtd/partitions.h
@@ -4,8 +4,6 @@
  * (C) 2000 Nicolas Pitre <nico@cam.org>
  *
  * This code is GPL
- *
- * $Id: partitions.h,v 1.17 2005/11/07 11:14:55 gleixner Exp $
  */
 
 #ifndef MTD_PARTITIONS_H
diff --git a/include/linux/mtd/physmap.h b/include/linux/mtd/physmap.h
index 0dc07d5..c8e63a5 100644
--- a/include/linux/mtd/physmap.h
+++ b/include/linux/mtd/physmap.h
@@ -2,8 +2,6 @@
  * For boards with physically mapped flash and using
  * drivers/mtd/maps/physmap.c mapping driver.
  *
- * $Id: physmap.h,v 1.4 2005/11/07 11:14:55 gleixner Exp $
- *
  * Copyright (C) 2003 MontaVista Software Inc.
  * Author: Jun Sun, jsun@mvista.com or jsun@junsun.net
  *
diff --git a/include/linux/mtd/plat-ram.h b/include/linux/mtd/plat-ram.h
index 0e37ad0..e07890a 100644
--- a/include/linux/mtd/plat-ram.h
+++ b/include/linux/mtd/plat-ram.h
@@ -6,8 +6,6 @@
  *
  * Generic platform device based RAM map
  *
- * $Id: plat-ram.h,v 1.2 2005/01/24 00:37:40 bjd Exp $
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
diff --git a/include/linux/mtd/pmc551.h b/include/linux/mtd/pmc551.h
index 5cc070c..27ad40a 100644
--- a/include/linux/mtd/pmc551.h
+++ b/include/linux/mtd/pmc551.h
@@ -1,6 +1,4 @@
 /*
- * $Id: pmc551.h,v 1.6 2005/11/07 11:14:55 gleixner Exp $
- *
  * PMC551 PCI Mezzanine Ram Device
  *
  * Author:
@@ -17,7 +15,7 @@
 
 #include <linux/mtd/mtd.h>
 
-#define PMC551_VERSION "$Id: pmc551.h,v 1.6 2005/11/07 11:14:55 gleixner Exp $\n"\
+#define PMC551_VERSION \
        "Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel Networks.\n"
 
 /*
diff --git a/include/linux/mtd/xip.h b/include/linux/mtd/xip.h
index e9d40bd..36efcba 100644
--- a/include/linux/mtd/xip.h
+++ b/include/linux/mtd/xip.h
@@ -11,8 +11,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
- *
- * $Id: xip.h,v 1.5 2005/11/07 11:14:55 gleixner Exp $
  */
 
 #ifndef __LINUX_MTD_XIP_H__
diff --git a/include/mtd/inftl-user.h b/include/mtd/inftl-user.h
index 9b1e252..e17eda3 100644
--- a/include/mtd/inftl-user.h
+++ b/include/mtd/inftl-user.h
@@ -1,6 +1,4 @@
 /*
- * $Id: inftl-user.h,v 1.2 2005/11/07 11:14:56 gleixner Exp $
- *
  * Parts of INFTL headers shared with userspace
  *
  */
diff --git a/include/mtd/jffs2-user.h b/include/mtd/jffs2-user.h
index d508ef0..001685d 100644
--- a/include/mtd/jffs2-user.h
+++ b/include/mtd/jffs2-user.h
@@ -1,6 +1,4 @@
 /*
- * $Id: jffs2-user.h,v 1.1 2004/05/05 11:57:54 dwmw2 Exp $
- *
  * JFFS2 definitions for use in user space only
  */
 
diff --git a/include/mtd/mtd-abi.h b/include/mtd/mtd-abi.h
index 615072c..c6c61cd 100644
--- a/include/mtd/mtd-abi.h
+++ b/include/mtd/mtd-abi.h
@@ -1,6 +1,4 @@
 /*
- * $Id: mtd-abi.h,v 1.13 2005/11/07 11:14:56 gleixner Exp $
- *
  * Portions of MTD ABI definition which are shared by kernel and user space
  */
 
diff --git a/include/mtd/mtd-user.h b/include/mtd/mtd-user.h
index 713f34d..170ceca 100644
--- a/include/mtd/mtd-user.h
+++ b/include/mtd/mtd-user.h
@@ -1,6 +1,4 @@
 /*
- * $Id: mtd-user.h,v 1.2 2004/05/05 14:44:57 dwmw2 Exp $
- *
  * MTD ABI header for use by user space only.
  */
 
diff --git a/include/mtd/nftl-user.h b/include/mtd/nftl-user.h
index b2bca18..390d21c 100644
--- a/include/mtd/nftl-user.h
+++ b/include/mtd/nftl-user.h
@@ -1,6 +1,4 @@
 /*
- * $Id: nftl-user.h,v 1.2 2005/11/07 11:14:56 gleixner Exp $
- *
  * Parts of NFTL headers shared with userspace
  *
  */

