Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbZLBQvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbZLBQvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 11:51:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbZLBQvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 11:51:11 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:55138 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455AbZLBQvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 11:51:04 -0500
Date: Wed, 2 Dec 2009 15:35:35 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: linux-mips@linux-mips.org, Thomas Koeller <thomas.koeller@baslerweb.com>,
       David Woodhouse <dwmw2@infradead.org>, Wim Van Sebroeck <wim@iguana.be>,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: [PATCH] eXcite: Remove platform support and drivers.
Message-ID: <20091202153534.GA10692@linux-mips.org>
References: <20091202153016.GA9892@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091202153016.GA9892@linux-mips.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform has never been fully merged.  Remove it including MTD and
watchdog drivers.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
---
I'd like acks from the watchdog and MTD maintainers please.

 arch/mips/Kconfig                                         |   18 
 arch/mips/Makefile                                        |    7 
 arch/mips/basler/excite/Kconfig                           |    9 
 arch/mips/basler/excite/Makefile                          |    8 
 arch/mips/basler/excite/excite_device.c                   |  403 ----
 arch/mips/basler/excite/excite_iodev.c                    |  178 -
 arch/mips/basler/excite/excite_iodev.h                    |   10 
 arch/mips/basler/excite/excite_irq.c                      |  122 -
 arch/mips/basler/excite/excite_procfs.c                   |   92 
 arch/mips/basler/excite/excite_prom.c                     |  144 -
 arch/mips/basler/excite/excite_setup.c                    |  302 ---
 arch/mips/configs/ar7_defconfig                           |    1 
 arch/mips/configs/bcm47xx_defconfig                       |    1 
 arch/mips/configs/bcm63xx_defconfig                       |    1 
 arch/mips/configs/bigsur_defconfig                        |    1 
 arch/mips/configs/capcella_defconfig                      |    1 
 arch/mips/configs/cavium-octeon_defconfig                 |    1 
 arch/mips/configs/cobalt_defconfig                        |    1 
 arch/mips/configs/db1000_defconfig                        |    1 
 arch/mips/configs/db1100_defconfig                        |    1 
 arch/mips/configs/db1200_defconfig                        |    1 
 arch/mips/configs/db1500_defconfig                        |    1 
 arch/mips/configs/db1550_defconfig                        |    1 
 arch/mips/configs/decstation_defconfig                    |    1 
 arch/mips/configs/e55_defconfig                           |    1 
 arch/mips/configs/excite_defconfig                        | 1335 --------------
 arch/mips/configs/fuloong2e_defconfig                     |    1 
 arch/mips/configs/ip22_defconfig                          |    1 
 arch/mips/configs/ip27_defconfig                          |    1 
 arch/mips/configs/ip28_defconfig                          |    1 
 arch/mips/configs/ip32_defconfig                          |    1 
 arch/mips/configs/jazz_defconfig                          |    1 
 arch/mips/configs/jmr3927_defconfig                       |    1 
 arch/mips/configs/lasat_defconfig                         |    1 
 arch/mips/configs/lemote2f_defconfig                      |    1 
 arch/mips/configs/malta_defconfig                         |    1 
 arch/mips/configs/markeins_defconfig                      |    1 
 arch/mips/configs/mipssim_defconfig                       |    1 
 arch/mips/configs/mpc30x_defconfig                        |    1 
 arch/mips/configs/msp71xx_defconfig                       |    1 
 arch/mips/configs/mtx1_defconfig                          |    1 
 arch/mips/configs/pb1100_defconfig                        |    1 
 arch/mips/configs/pb1500_defconfig                        |    1 
 arch/mips/configs/pb1550_defconfig                        |    1 
 arch/mips/configs/pnx8335-stb225_defconfig                |    1 
 arch/mips/configs/pnx8550-jbs_defconfig                   |    1 
 arch/mips/configs/pnx8550-stb810_defconfig                |    1 
 arch/mips/configs/powertv_defconfig                       |    1 
 arch/mips/configs/rb532_defconfig                         |    1 
 arch/mips/configs/rbtx49xx_defconfig                      |    1 
 arch/mips/configs/rm200_defconfig                         |    1 
 arch/mips/configs/sb1250-swarm_defconfig                  |    1 
 arch/mips/configs/tb0219_defconfig                        |    1 
 arch/mips/configs/tb0226_defconfig                        |    1 
 arch/mips/configs/tb0287_defconfig                        |    1 
 arch/mips/configs/workpad_defconfig                       |    1 
 arch/mips/configs/wrppmc_defconfig                        |    1 
 arch/mips/configs/yosemite_defconfig                      |    1 
 arch/mips/include/asm/mach-excite/cpu-feature-overrides.h |   48 
 arch/mips/include/asm/mach-excite/excite.h                |  154 -
 arch/mips/include/asm/mach-excite/excite_fpga.h           |   80 
 arch/mips/include/asm/mach-excite/excite_nandflash.h      |    7 
 arch/mips/include/asm/mach-excite/rm9k_eth.h              |   23 
 arch/mips/include/asm/mach-excite/rm9k_wdt.h              |   12 
 arch/mips/include/asm/mach-excite/rm9k_xicap.h            |   16 
 arch/mips/include/asm/mach-excite/war.h                   |   25 
 arch/mips/pci/Makefile                                    |    1 
 arch/mips/pci/fixup-excite.c                              |   36 
 arch/mips/pci/pci-excite.c                                |  149 -
 drivers/mtd/nand/Kconfig                                  |    8 
 drivers/mtd/nand/Makefile                                 |    1 
 drivers/mtd/nand/excite_nandflash.c                       |  248 --
 drivers/watchdog/Kconfig                                  |   10 
 drivers/watchdog/Makefile                                 |    1 
 drivers/watchdog/rm9k_wdt.c                               |  419 ----
 75 files changed, 3912 deletions(-)

Index: linux-queue/arch/mips/Kconfig
===================================================================
--- linux-queue.orig/arch/mips/Kconfig
+++ linux-queue/arch/mips/Kconfig
@@ -50,23 +50,6 @@ config AR7
 	  Support for the Texas Instruments AR7 System-on-a-Chip
 	  family: TNETD7100, 7200 and 7300.
 
-config BASLER_EXCITE
-	bool "Basler eXcite smart camera"
-	select CEVT_R4K
-	select CSRC_R4K
-	select DMA_COHERENT
-	select HW_HAS_PCI
-	select IRQ_CPU
-	select IRQ_CPU_RM7K
-	select IRQ_CPU_RM9K
-	select MIPS_RM9122
-	select SYS_HAS_CPU_RM9000
-	select SYS_SUPPORTS_32BIT_KERNEL
-	select SYS_SUPPORTS_BIG_ENDIAN
-	help
-	  The eXcite is a smart camera platform manufactured by
-	  Basler Vision Technologies AG.
-
 config BCM47XX
 	bool "BCM47XX based boards"
 	select CEVT_R4K
@@ -701,7 +684,6 @@ config CAVIUM_OCTEON_REFERENCE_BOARD
 endchoice
 
 source "arch/mips/alchemy/Kconfig"
-source "arch/mips/basler/excite/Kconfig"
 source "arch/mips/bcm63xx/Kconfig"
 source "arch/mips/jazz/Kconfig"
 source "arch/mips/lasat/Kconfig"
Index: linux-queue/arch/mips/basler/excite/Kconfig
===================================================================
--- linux-queue.orig/arch/mips/basler/excite/Kconfig
+++ /dev/null
@@ -1,9 +0,0 @@
-config BASLER_EXCITE_PROTOTYPE
-	bool "Support for pre-release units"
-	depends on BASLER_EXCITE
-	default n
-	help
-	  Pre-series (prototype) units are different from later ones in
-	  some ways. Select this option if you have one of these. Please
-	  note that a kernel built with this option selected will not be
-	  able to run on normal units.
Index: linux-queue/arch/mips/basler/excite/Makefile
===================================================================
--- linux-queue.orig/arch/mips/basler/excite/Makefile
+++ /dev/null
@@ -1,8 +0,0 @@
-#
-# Makefile for Basler eXcite
-#
-
-obj-$(CONFIG_BASLER_EXCITE)	+= excite_irq.o excite_prom.o excite_setup.o \
-				   excite_device.o excite_procfs.o
-
-obj-m				+= excite_iodev.o
Index: linux-queue/arch/mips/basler/excite/excite_device.c
===================================================================
--- linux-queue.orig/arch/mips/basler/excite/excite_device.c
+++ /dev/null
@@ -1,403 +0,0 @@
-/*
- *  Copyright (C) 2004 by Basler Vision Technologies AG
- *  Author: Thomas Koeller <thomas.koeller@baslerweb.com>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/ioport.h>
-#include <linux/err.h>
-#include <linux/jiffies.h>
-#include <linux/sched.h>
-#include <asm/types.h>
-#include <asm/rm9k-ocd.h>
-
-#include <excite.h>
-#include <rm9k_eth.h>
-#include <rm9k_wdt.h>
-#include <rm9k_xicap.h>
-#include <excite_nandflash.h>
-
-#include "excite_iodev.h"
-
-#define RM9K_GE_UNIT	0
-#define XICAP_UNIT	0
-#define NAND_UNIT	0
-
-#define DLL_TIMEOUT	3		/* seconds */
-
-
-#define RINIT(__start__, __end__, __name__, __parent__) {	\
-	.name	= __name__ "_0",				\
-	.start	= (__start__),					\
-	.end	= (__end__),					\
-	.flags	= 0,						\
-	.parent	= (__parent__)					\
-}
-
-#define RINIT_IRQ(__irq__, __name__) {	\
-	.name	= __name__ "_0",	\
-	.start	= (__irq__),		\
-	.end	= (__irq__),		\
-	.flags	= IORESOURCE_IRQ,	\
-	.parent	= NULL			\
-}
-
-
-
-enum {
-	slice_xicap,
-	slice_eth
-};
-
-
-
-static struct resource
-	excite_ctr_resource __maybe_unused = {
-		.name		= "GPI counters",
-		.start		= 0,
-		.end		= 5,
-		.flags		= 0,
-		.parent		= NULL,
-		.sibling	= NULL,
-		.child		= NULL
-	},
-	excite_gpislice_resource __maybe_unused = {
-		.name		= "GPI slices",
-		.start		= 0,
-		.end		= 1,
-		.flags		= 0,
-		.parent		= NULL,
-		.sibling	= NULL,
-		.child		= NULL
-	},
-	excite_mdio_channel_resource __maybe_unused = {
-		.name		= "MDIO channels",
-		.start		= 0,
-		.end		= 1,
-		.flags		= 0,
-		.parent		= NULL,
-		.sibling	= NULL,
-		.child		= NULL
-	},
-	excite_fifomem_resource __maybe_unused = {
-		.name		= "FIFO memory",
-		.start		= 0,
-		.end		= 767,
-		.flags		= 0,
-		.parent		= NULL,
-		.sibling	= NULL,
-		.child		= NULL
-	},
-	excite_scram_resource __maybe_unused = {
-		.name		= "Scratch RAM",
-		.start		= EXCITE_PHYS_SCRAM,
-		.end		= EXCITE_PHYS_SCRAM + EXCITE_SIZE_SCRAM - 1,
-		.flags		= IORESOURCE_MEM,
-		.parent		= NULL,
-		.sibling	= NULL,
-		.child		= NULL
-	},
-	excite_fpga_resource __maybe_unused = {
-		.name		= "System FPGA",
-		.start		= EXCITE_PHYS_FPGA,
-		.end		= EXCITE_PHYS_FPGA + EXCITE_SIZE_FPGA - 1,
-		.flags		= IORESOURCE_MEM,
-		.parent		= NULL,
-		.sibling	= NULL,
-		.child		= NULL
-	},
-	excite_nand_resource __maybe_unused = {
-		.name		= "NAND flash control",
-		.start		= EXCITE_PHYS_NAND,
-		.end		= EXCITE_PHYS_NAND + EXCITE_SIZE_NAND - 1,
-		.flags		= IORESOURCE_MEM,
-		.parent		= NULL,
-		.sibling	= NULL,
-		.child		= NULL
-	},
-	excite_titan_resource __maybe_unused = {
-		.name		= "TITAN registers",
-		.start		= EXCITE_PHYS_TITAN,
-		.end		= EXCITE_PHYS_TITAN + EXCITE_SIZE_TITAN - 1,
-		.flags		= IORESOURCE_MEM,
-		.parent		= NULL,
-		.sibling	= NULL,
-		.child		= NULL
-	};
-
-
-
-static void adjust_resources(struct resource *res, unsigned int n)
-{
-	struct resource *p;
-	const unsigned long mask = IORESOURCE_IO | IORESOURCE_MEM
-				   | IORESOURCE_IRQ | IORESOURCE_DMA;
-
-	for (p = res; p < res + n; p++) {
-		const struct resource * const parent = p->parent;
-		if (parent) {
-			p->start += parent->start;
-			p->end   += parent->start;
-			p->flags =  parent->flags & mask;
-		}
-	}
-}
-
-
-
-#if defined(CONFIG_EXCITE_FCAP_GPI) || defined(CONFIG_EXCITE_FCAP_GPI_MODULE)
-static struct resource xicap_rsrc[] = {
-	RINIT(0x4840, 0x486f, XICAP_RESOURCE_FIFO_RX, &excite_titan_resource),
-	RINIT(0x4940, 0x494b, XICAP_RESOURCE_FIFO_TX, &excite_titan_resource),
-	RINIT(0x5040, 0x5127, XICAP_RESOURCE_XDMA, &excite_titan_resource),
-	RINIT(0x1000, 0x112f, XICAP_RESOURCE_PKTPROC, &excite_titan_resource),
-	RINIT(0x1100, 0x110f, XICAP_RESOURCE_PKT_STREAM, &excite_fpga_resource),
-	RINIT(0x0800, 0x0bff, XICAP_RESOURCE_DMADESC, &excite_scram_resource),
-	RINIT(slice_xicap, slice_xicap, XICAP_RESOURCE_GPI_SLICE, &excite_gpislice_resource),
-	RINIT(0x0100, 0x02ff, XICAP_RESOURCE_FIFO_BLK, &excite_fifomem_resource),
-	RINIT_IRQ(TITAN_IRQ,  XICAP_RESOURCE_IRQ)
-};
-
-static struct platform_device xicap_pdev = {
-	.name		= XICAP_NAME,
-	.id		= XICAP_UNIT,
-	.num_resources	= ARRAY_SIZE(xicap_rsrc),
-	.resource	= xicap_rsrc
-};
-
-/*
- * Create a platform device for the GPI port that receives the
- * image data from the embedded camera.
- */
-static int __init xicap_devinit(void)
-{
-	unsigned long tend;
-	u32 reg;
-	int retval;
-
-	adjust_resources(xicap_rsrc, ARRAY_SIZE(xicap_rsrc));
-
-	/* Power up the slice and configure it. */
-	reg = titan_readl(CPTC1R);
-	reg &= ~(0x11100 << slice_xicap);
-	titan_writel(reg, CPTC1R);
-
-	/* Enable slice & DLL. */
-	reg= titan_readl(CPRR);
-	reg &= ~(0x00030003 << (slice_xicap * 2));
-	titan_writel(reg, CPRR);
-
-	/* Wait for DLLs to lock */
-	tend = jiffies + DLL_TIMEOUT * HZ;
-	while (time_before(jiffies, tend)) {
-		if (!(~titan_readl(CPDSR) & (0x1 << (slice_xicap * 4))))
-			break;
-		yield();
-	}
-
-	if (~titan_readl(CPDSR) & (0x1 << (slice_xicap * 4))) {
-		printk(KERN_ERR "%s: DLL not locked after %u seconds\n",
-		       xicap_pdev.name, DLL_TIMEOUT);
-		retval = -ETIME;
-	} else {
-		/* Register platform device */
-		retval = platform_device_register(&xicap_pdev);
-	}
-
-	return retval;
-}
-
-device_initcall(xicap_devinit);
-#endif /* defined(CONFIG_EXCITE_FCAP_GPI) || defined(CONFIG_EXCITE_FCAP_GPI_MODULE) */
-
-
-
-#if defined(CONFIG_WDT_RM9K_GPI) || defined(CONFIG_WDT_RM9K_GPI_MODULE)
-static struct resource wdt_rsrc[] = {
-	RINIT(0, 0, WDT_RESOURCE_COUNTER, &excite_ctr_resource),
-	RINIT(0x0084, 0x008f, WDT_RESOURCE_REGS, &excite_titan_resource),
-	RINIT_IRQ(TITAN_IRQ,  WDT_RESOURCE_IRQ)
-};
-
-static struct platform_device wdt_pdev = {
-	.name		= WDT_NAME,
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(wdt_rsrc),
-	.resource	= wdt_rsrc
-};
-
-/*
- * Create a platform device for the GPI port that receives the
- * image data from the embedded camera.
- */
-static int __init wdt_devinit(void)
-{
-	adjust_resources(wdt_rsrc, ARRAY_SIZE(wdt_rsrc));
-	return platform_device_register(&wdt_pdev);
-}
-
-device_initcall(wdt_devinit);
-#endif /* defined(CONFIG_WDT_RM9K_GPI) || defined(CONFIG_WDT_RM9K_GPI_MODULE) */
-
-
-
-static struct resource excite_nandflash_rsrc[] = {
- 	RINIT(0x2000, 0x201f, EXCITE_NANDFLASH_RESOURCE_REGS,  &excite_nand_resource)
-};
-
-static struct platform_device excite_nandflash_pdev = {
-	.name		= "excite_nand",
-	.id		= NAND_UNIT,
-	.num_resources	= ARRAY_SIZE(excite_nandflash_rsrc),
-	.resource	= excite_nandflash_rsrc
-};
-
-/*
- * Create a platform device for the access to the nand-flash
- * port
- */
-static int __init excite_nandflash_devinit(void)
-{
-	adjust_resources(excite_nandflash_rsrc, ARRAY_SIZE(excite_nandflash_rsrc));
-
-        /* nothing to be done here */
-
-        /* Register platform device */
-	return platform_device_register(&excite_nandflash_pdev);
-}
-
-device_initcall(excite_nandflash_devinit);
-
-
-
-static struct resource iodev_rsrc[] = {
-	RINIT_IRQ(FPGA1_IRQ,  IODEV_RESOURCE_IRQ)
-};
-
-static struct platform_device io_pdev = {
-	.name		= IODEV_NAME,
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(iodev_rsrc),
-	.resource	= iodev_rsrc
-};
-
-/*
- * Create a platform device for the external I/O ports.
- */
-static int __init io_devinit(void)
-{
-	adjust_resources(iodev_rsrc, ARRAY_SIZE(iodev_rsrc));
-	return platform_device_register(&io_pdev);
-}
-
-device_initcall(io_devinit);
-
-
-
-
-#if defined(CONFIG_RM9K_GE) || defined(CONFIG_RM9K_GE_MODULE)
-static struct resource rm9k_ge_rsrc[] = {
-	RINIT(0x2200, 0x27ff, RM9K_GE_RESOURCE_MAC, &excite_titan_resource),
-	RINIT(0x1800, 0x1fff, RM9K_GE_RESOURCE_MSTAT, &excite_titan_resource),
-	RINIT(0x2000, 0x212f, RM9K_GE_RESOURCE_PKTPROC, &excite_titan_resource),
-	RINIT(0x5140, 0x5227, RM9K_GE_RESOURCE_XDMA, &excite_titan_resource),
-	RINIT(0x4870, 0x489f, RM9K_GE_RESOURCE_FIFO_RX, &excite_titan_resource),
-	RINIT(0x494c, 0x4957, RM9K_GE_RESOURCE_FIFO_TX, &excite_titan_resource),
-	RINIT(0x0000, 0x007f, RM9K_GE_RESOURCE_FIFOMEM_RX, &excite_fifomem_resource),
-	RINIT(0x0080, 0x00ff, RM9K_GE_RESOURCE_FIFOMEM_TX, &excite_fifomem_resource),
-	RINIT(0x0180, 0x019f, RM9K_GE_RESOURCE_PHY, &excite_titan_resource),
-	RINIT(0x0000, 0x03ff, RM9K_GE_RESOURCE_DMADESC_RX, &excite_scram_resource),
-	RINIT(0x0400, 0x07ff, RM9K_GE_RESOURCE_DMADESC_TX, &excite_scram_resource),
-	RINIT(slice_eth, slice_eth, RM9K_GE_RESOURCE_GPI_SLICE, &excite_gpislice_resource),
-	RINIT(0, 0, RM9K_GE_RESOURCE_MDIO_CHANNEL, &excite_mdio_channel_resource),
-	RINIT_IRQ(TITAN_IRQ,  RM9K_GE_RESOURCE_IRQ_MAIN),
-	RINIT_IRQ(PHY_IRQ, RM9K_GE_RESOURCE_IRQ_PHY)
-};
-
-static struct platform_device rm9k_ge_pdev = {
-	.name		= RM9K_GE_NAME,
-	.id		= RM9K_GE_UNIT,
-	.num_resources	= ARRAY_SIZE(rm9k_ge_rsrc),
-	.resource	= rm9k_ge_rsrc
-};
-
-
-
-/*
- * Create a platform device for the Ethernet port.
- */
-static int __init rm9k_ge_devinit(void)
-{
-	u32 reg;
-
-	adjust_resources(rm9k_ge_rsrc, ARRAY_SIZE(rm9k_ge_rsrc));
-
-	/* Power up the slice and configure it. */
-	reg = titan_readl(CPTC1R);
-	reg &= ~(0x11000 << slice_eth);
-	reg |= 0x100 << slice_eth;
-	titan_writel(reg, CPTC1R);
-
-	/* Take the MAC out of reset, reset the DLLs. */
-	reg = titan_readl(CPRR);
-	reg &= ~(0x00030000 << (slice_eth * 2));
-	reg |= 0x3 << (slice_eth * 2);
-	titan_writel(reg, CPRR);
-
-	return platform_device_register(&rm9k_ge_pdev);
-}
-
-device_initcall(rm9k_ge_devinit);
-#endif /* defined(CONFIG_RM9K_GE) || defined(CONFIG_RM9K_GE_MODULE) */
-
-
-
-static int __init excite_setup_devs(void)
-{
-	int res;
-	u32 reg;
-
-	/* Enable xdma and fifo interrupts */
-	reg = titan_readl(0x0050);
-	titan_writel(reg | 0x18000000, 0x0050);
-
-	res = request_resource(&iomem_resource, &excite_titan_resource);
-	if (res)
-		return res;
-	res = request_resource(&iomem_resource, &excite_scram_resource);
-	if (res)
-		return res;
-	res = request_resource(&iomem_resource, &excite_fpga_resource);
-	if (res)
-		return res;
-	res = request_resource(&iomem_resource, &excite_nand_resource);
-	if (res)
-		return res;
-	excite_fpga_resource.flags = excite_fpga_resource.parent->flags &
-				   ( IORESOURCE_IO | IORESOURCE_MEM
-				   | IORESOURCE_IRQ | IORESOURCE_DMA);
-	excite_nand_resource.flags = excite_nand_resource.parent->flags &
-				   ( IORESOURCE_IO | IORESOURCE_MEM
-				   | IORESOURCE_IRQ | IORESOURCE_DMA);
-
-	return 0;
-}
-
-arch_initcall(excite_setup_devs);
-
Index: linux-queue/arch/mips/basler/excite/excite_iodev.c
===================================================================
--- linux-queue.orig/arch/mips/basler/excite/excite_iodev.c
+++ /dev/null
@@ -1,178 +0,0 @@
-/*
- *  Copyright (C) 2005 by Basler Vision Technologies AG
- *  Author: Thomas Koeller <thomas.koeller@baslerweb.com>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-#include <linux/compiler.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/wait.h>
-#include <linux/poll.h>
-#include <linux/interrupt.h>
-#include <linux/platform_device.h>
-#include <linux/miscdevice.h>
-#include <linux/smp_lock.h>
-
-#include "excite_iodev.h"
-
-
-
-static const struct resource *iodev_get_resource(struct platform_device *, const char *, unsigned int);
-static int __init iodev_probe(struct platform_device *);
-static int __devexit iodev_remove(struct platform_device *);
-static int iodev_open(struct inode *, struct file *);
-static int iodev_release(struct inode *, struct file *);
-static ssize_t iodev_read(struct file *, char __user *, size_t s, loff_t *);
-static unsigned int iodev_poll(struct file *, struct poll_table_struct *);
-static irqreturn_t iodev_irqhdl(int, void *);
-
-
-
-static const char iodev_name[] = "iodev";
-static unsigned int iodev_irq;
-static DECLARE_WAIT_QUEUE_HEAD(wq);
-
-
-
-static const struct file_operations fops =
-{
-	.owner		= THIS_MODULE,
-	.open		= iodev_open,
-	.release	= iodev_release,
-	.read		= iodev_read,
-	.poll		= iodev_poll
-};
-
-static struct miscdevice miscdev =
-{
-	.minor		= MISC_DYNAMIC_MINOR,
-	.name		= iodev_name,
-	.fops		= &fops
-};
-
-static struct platform_driver iodev_driver = {
-	.driver = {
-		.name		= iodev_name,
-		.owner		= THIS_MODULE,
-	},
-	.probe		= iodev_probe,
-	.remove		= __devexit_p(iodev_remove),
-};
-
-
-
-static const struct resource *
-iodev_get_resource(struct platform_device *pdv, const char *name,
-		     unsigned int type)
-{
-	char buf[80];
-	if (snprintf(buf, sizeof buf, "%s_0", name) >= sizeof buf)
-		return NULL;
-	return platform_get_resource_byname(pdv, type, buf);
-}
-
-
-
-/* No hotplugging on the platform bus - use __init */
-static int __init iodev_probe(struct platform_device *dev)
-{
-	const struct resource * const ri =
-		iodev_get_resource(dev, IODEV_RESOURCE_IRQ, IORESOURCE_IRQ);
-
-	if (unlikely(!ri))
-		return -ENXIO;
-
-	iodev_irq = ri->start;
-	return misc_register(&miscdev);
-}
-
-
-
-static int __devexit iodev_remove(struct platform_device *dev)
-{
-	return misc_deregister(&miscdev);
-}
-
-static int iodev_open(struct inode *i, struct file *f)
-{
-	int ret;
-
-	ret = request_irq(iodev_irq, iodev_irqhdl, IRQF_DISABLED,
-			   iodev_name, &miscdev);
-
-	return ret;
-}
-
-static int iodev_release(struct inode *i, struct file *f)
-{
-	free_irq(iodev_irq, &miscdev);
-	return 0;
-}
-
-
-
-
-static ssize_t
-iodev_read(struct file *f, char __user *d, size_t s, loff_t *o)
-{
-	ssize_t ret;
-	DEFINE_WAIT(w);
-
-	prepare_to_wait(&wq, &w, TASK_INTERRUPTIBLE);
-	if (!signal_pending(current))
-		schedule();
-	ret = signal_pending(current) ? -ERESTARTSYS : 0;
-	finish_wait(&wq, &w);
-	return ret;
-}
-
-
-static unsigned int iodev_poll(struct file *f, struct poll_table_struct *p)
-{
-	poll_wait(f, &wq, p);
-	return POLLOUT | POLLWRNORM;
-}
-
-static irqreturn_t iodev_irqhdl(int irq, void *ctxt)
-{
-	wake_up(&wq);
-
-	return IRQ_HANDLED;
-}
-
-static int __init iodev_init_module(void)
-{
-	return platform_driver_register(&iodev_driver);
-}
-
-
-
-static void __exit iodev_cleanup_module(void)
-{
-	platform_driver_unregister(&iodev_driver);
-}
-
-module_init(iodev_init_module);
-module_exit(iodev_cleanup_module);
-
-
-
-MODULE_AUTHOR("Thomas Koeller <thomas.koeller@baslerweb.com>");
-MODULE_DESCRIPTION("Basler eXcite i/o interrupt handler");
-MODULE_VERSION("0.0");
-MODULE_LICENSE("GPL");
Index: linux-queue/arch/mips/basler/excite/excite_iodev.h
===================================================================
--- linux-queue.orig/arch/mips/basler/excite/excite_iodev.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef __EXCITE_IODEV_H__
-#define __EXCITE_IODEV_H__
-
-/* Device name */
-#define IODEV_NAME		"iodev"
-
-/* Resource names */
-#define IODEV_RESOURCE_IRQ	"excite_iodev_irq"
-
-#endif /* __EXCITE_IODEV_H__ */
Index: linux-queue/arch/mips/basler/excite/excite_irq.c
===================================================================
--- linux-queue.orig/arch/mips/basler/excite/excite_irq.c
+++ /dev/null
@@ -1,122 +0,0 @@
-/*
- *  Copyright (C) by Basler Vision Technologies AG
- *  Author: Thomas Koeller <thomas.koeller@baslereb.com>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-#include <linux/errno.h>
-#include <linux/init.h>
-#include <linux/kernel_stat.h>
-#include <linux/module.h>
-#include <linux/signal.h>
-#include <linux/sched.h>
-#include <linux/types.h>
-#include <linux/interrupt.h>
-#include <linux/ioport.h>
-#include <linux/timex.h>
-#include <linux/slab.h>
-#include <linux/random.h>
-#include <linux/bitops.h>
-#include <asm/bootinfo.h>
-#include <asm/io.h>
-#include <asm/irq.h>
-#include <asm/irq_cpu.h>
-#include <asm/mipsregs.h>
-#include <asm/system.h>
-#include <asm/rm9k-ocd.h>
-
-#include <excite.h>
-
-extern asmlinkage void excite_handle_int(void);
-
-/*
- * Initialize the interrupt handler
- */
-void __init arch_init_irq(void)
-{
-	mips_cpu_irq_init();
-	rm7k_cpu_irq_init();
-	rm9k_cpu_irq_init();
-}
-
-asmlinkage void plat_irq_dispatch(void)
-{
-	const u32
-		interrupts = read_c0_cause() >> 8,
-		mask = ((read_c0_status() >> 8) & 0x000000ff) |
-		       (read_c0_intcontrol() & 0x0000ff00),
-		pending = interrupts & mask;
-	u32 msgintflags, msgintmask, msgint;
-
-	/* process timer interrupt */
-	if (pending & (1 << TIMER_IRQ)) {
-		do_IRQ(TIMER_IRQ);
-		return;
-	}
-
-	/* Process PCI interrupts */
-#if USB_IRQ < 10
-	msgintflags = ocd_readl(INTP0Status0 + (USB_MSGINT / 0x20 * 0x10));
-	msgintmask  = ocd_readl(INTP0Mask0 + (USB_MSGINT / 0x20 * 0x10));
-	msgint	    = msgintflags & msgintmask & (0x1 << (USB_MSGINT % 0x20));
-	if ((pending & (1 << USB_IRQ)) && msgint) {
-#else
-	if (pending & (1 << USB_IRQ)) {
-#endif
-		do_IRQ(USB_IRQ);
-		return;
-	}
-
-	/* Process TITAN interrupts */
-	msgintflags = ocd_readl(INTP0Status0 + (TITAN_MSGINT / 0x20 * 0x10));
-	msgintmask  = ocd_readl(INTP0Mask0 + (TITAN_MSGINT / 0x20 * 0x10));
-	msgint	    = msgintflags & msgintmask & (0x1 << (TITAN_MSGINT % 0x20));
-	if ((pending & (1 << TITAN_IRQ)) && msgint) {
-		ocd_writel(msgint, INTP0Clear0 + (TITAN_MSGINT / 0x20 * 0x10));
-		do_IRQ(TITAN_IRQ);
-		return;
-	}
-
-	/* Process FPGA line #0 interrupts */
-	msgintflags = ocd_readl(INTP0Status0 + (FPGA0_MSGINT / 0x20 * 0x10));
-	msgintmask  = ocd_readl(INTP0Mask0 + (FPGA0_MSGINT / 0x20 * 0x10));
-	msgint	    = msgintflags & msgintmask & (0x1 << (FPGA0_MSGINT % 0x20));
-	if ((pending & (1 << FPGA0_IRQ)) && msgint) {
-		do_IRQ(FPGA0_IRQ);
-		return;
-	}
-
-	/* Process FPGA line #1 interrupts */
-	msgintflags = ocd_readl(INTP0Status0 + (FPGA1_MSGINT / 0x20 * 0x10));
-	msgintmask  = ocd_readl(INTP0Mask0 + (FPGA1_MSGINT / 0x20 * 0x10));
-	msgint	    = msgintflags & msgintmask & (0x1 << (FPGA1_MSGINT % 0x20));
-	if ((pending & (1 << FPGA1_IRQ)) && msgint) {
-		do_IRQ(FPGA1_IRQ);
-		return;
-	}
-
-	/* Process PHY interrupts */
-	msgintflags = ocd_readl(INTP0Status0 + (PHY_MSGINT / 0x20 * 0x10));
-	msgintmask  = ocd_readl(INTP0Mask0 + (PHY_MSGINT / 0x20 * 0x10));
-	msgint	    = msgintflags & msgintmask & (0x1 << (PHY_MSGINT % 0x20));
-	if ((pending & (1 << PHY_IRQ)) && msgint) {
-		do_IRQ(PHY_IRQ);
-		return;
-	}
-
-	/* Process spurious interrupts */
-	spurious_interrupt();
-}
Index: linux-queue/arch/mips/basler/excite/excite_procfs.c
===================================================================
--- linux-queue.orig/arch/mips/basler/excite/excite_procfs.c
+++ /dev/null
@@ -1,92 +0,0 @@
-/*
- *  Copyright (C) 2004, 2005 by Basler Vision Technologies AG
- *  Author: Thomas Koeller <thomas.koeller@baslerweb.com>
- *
- *  Procfs support for Basler eXcite
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-#include <linux/module.h>
-#include <linux/proc_fs.h>
-#include <linux/seq_file.h>
-#include <linux/stat.h>
-#include <asm/page.h>
-#include <asm/io.h>
-#include <asm/system.h>
-#include <asm/rm9k-ocd.h>
-
-#include <excite.h>
-
-static int excite_unit_id_proc_show(struct seq_file *m, void *v)
-{
-	seq_printf(m, "%06x", unit_id);
-	return 0;
-}
-
-static int excite_unit_id_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, excite_unit_id_proc_show, NULL);
-}
-
-static const struct file_operations excite_unit_id_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= excite_unit_id_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static int
-excite_bootrom_read(char *page, char **start, off_t off, int count,
-		  int *eof, void *data)
-{
-	void __iomem * src;
-
-	if (off >= EXCITE_SIZE_BOOTROM) {
-		*eof = 1;
-		return 0;
-	}
-
-	if ((off + count) > EXCITE_SIZE_BOOTROM)
-		count = EXCITE_SIZE_BOOTROM - off;
-
-	src = ioremap(EXCITE_PHYS_BOOTROM + off, count);
-	if (src) {
-		memcpy_fromio(page, src, count);
-		iounmap(src);
-		*start = page;
-	} else {
-		count = -ENOMEM;
-	}
-
-	return count;
-}
-
-void excite_procfs_init(void)
-{
-	/* Create & populate /proc/excite */
-	struct proc_dir_entry * const pdir = proc_mkdir("excite", NULL);
-	if (pdir) {
-		struct proc_dir_entry * e;
-
-		e = proc_create("unit_id", S_IRUGO, pdir,
-				&excite_unit_id_proc_fops);
-		if (e) e->size = 6;
-
-		e = create_proc_read_entry("bootrom", S_IRUGO, pdir,
-					   excite_bootrom_read, NULL);
-		if (e) e->size = EXCITE_SIZE_BOOTROM;
-	}
-}
Index: linux-queue/arch/mips/basler/excite/excite_prom.c
===================================================================
--- linux-queue.orig/arch/mips/basler/excite/excite_prom.c
+++ /dev/null
@@ -1,144 +0,0 @@
-/*
- *  Copyright (C) 2004, 2005 by Thomas Koeller (thomas.koeller@baslerweb.com)
- *  Based on the PMC-Sierra Yosemite board support by Ralf Baechle and
- *  Manish Lachwani.
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-#include <linux/init.h>
-#include <linux/sched.h>
-#include <linux/mm.h>
-#include <linux/delay.h>
-#include <linux/smp.h>
-#include <linux/module.h>
-#include <asm/io.h>
-#include <asm/pgtable.h>
-#include <asm/processor.h>
-#include <asm/reboot.h>
-#include <asm/system.h>
-#include <asm/bootinfo.h>
-#include <asm/string.h>
-
-#include <excite.h>
-
-/* This struct is used by Redboot to pass arguments to the kernel */
-typedef struct
-{
-	char *name;
-	char *val;
-} t_env_var;
-
-struct parmblock {
-	t_env_var memsize;
-	t_env_var modetty0;
-	t_env_var ethaddr;
-	t_env_var env_end;
-	char *argv[2];
-	char text[0];
-};
-
-static unsigned int prom_argc;
-static const char ** prom_argv;
-static const t_env_var * prom_env;
-
-static void prom_halt(void) __attribute__((noreturn));
-static void prom_exit(void) __attribute__((noreturn));
-
-
-
-const char *get_system_type(void)
-{
-	return "Basler eXcite";
-}
-
-/*
- * Halt the system
- */
-static void prom_halt(void)
-{
-	printk(KERN_NOTICE "\n** System halted.\n");
-	while (1)
-		asm volatile (
-			"\t.set\tmips3\n"
-			"\twait\n"
-			"\t.set\tmips0\n"
-		);
-}
-
-/*
- * Reset the CPU and re-enter Redboot
- */
-static void prom_exit(void)
-{
-	unsigned int i;
-	volatile unsigned char * const flg =
-		(volatile unsigned char *) (EXCITE_ADDR_FPGA + EXCITE_FPGA_DPR);
-
-	/* Clear the watchdog reset flag, set the reboot flag */
-	*flg &= ~0x01;
-	*flg |= 0x80;
-
-	for (i = 0; i < 10; i++) {
-		*(volatile unsigned char *)  (EXCITE_ADDR_FPGA + EXCITE_FPGA_SYSCTL) = 0x02;
-		iob();
-		mdelay(1000);
-	}
-
-	printk(KERN_NOTICE "Reset failed\n");
-	prom_halt();
-}
-
-static const char __init *prom_getenv(char *name)
-{
-	const t_env_var * p;
-	for (p = prom_env; p->name != NULL; p++)
-		if(strcmp(name, p->name) == 0)
-			break;
-	return p->val;
-}
-
-/*
- * Init routine which accepts the variables from Redboot
- */
-void __init prom_init(void)
-{
-	const struct parmblock * const pb = (struct parmblock *) fw_arg2;
-
-	prom_argc = fw_arg0;
-	prom_argv = (const char **) fw_arg1;
-	prom_env = &pb->memsize;
-
-	/* Callbacks for halt, restart */
-	_machine_restart = (void (*)(char *)) prom_exit;
-	_machine_halt = prom_halt;
-
-#ifdef CONFIG_32BIT
-	/* copy command line */
-	strcpy(arcs_cmdline, prom_argv[1]);
-	memsize = simple_strtol(prom_getenv("memsize"), NULL, 16);
-	strcpy(modetty, prom_getenv("modetty0"));
-#endif /* CONFIG_32BIT */
-
-#ifdef CONFIG_64BIT
-#	error 64 bit support not implemented
-#endif /* CONFIG_64BIT */
-}
-
-/* This is called from free_initmem(), so we need to provide it */
-void __init prom_free_prom_memory(void)
-{
-	/* Nothing to do */
-}
Index: linux-queue/arch/mips/basler/excite/excite_setup.c
===================================================================
--- linux-queue.orig/arch/mips/basler/excite/excite_setup.c
+++ /dev/null
@@ -1,302 +0,0 @@
-/*
- *  Copyright (C) 2004, 2005 by Basler Vision Technologies AG
- *  Author: Thomas Koeller <thomas.koeller@baslerweb.com>
- *  Based on the PMC-Sierra Yosemite board support by Ralf Baechle and
- *  Manish Lachwani.
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/string.h>
-#include <linux/tty.h>
-#include <linux/serial_core.h>
-#include <linux/serial.h>
-#include <linux/serial_8250.h>
-#include <linux/ioport.h>
-#include <linux/spinlock.h>
-#include <asm/bootinfo.h>
-#include <asm/mipsregs.h>
-#include <asm/pgtable-32.h>
-#include <asm/io.h>
-#include <asm/time.h>
-#include <asm/rm9k-ocd.h>
-
-#include <excite.h>
-
-#define TITAN_UART_CLK	25000000
-
-#if 1
-/* normal serial port assignment */
-#define REGBASE_SER0	0x0208
-#define REGBASE_SER1	0x0238
-#define MASK_SER0	0x1
-#define MASK_SER1	0x2
-#else
-/* serial ports swapped */
-#define REGBASE_SER0	0x0238
-#define REGBASE_SER1	0x0208
-#define MASK_SER0	0x2
-#define MASK_SER1	0x1
-#endif
-
-unsigned long memsize;
-char modetty[30];
-unsigned int titan_irq = TITAN_IRQ;
-static void __iomem * ctl_regs;
-u32 unit_id;
-
-volatile void __iomem * const ocd_base = (void *) (EXCITE_ADDR_OCD);
-volatile void __iomem * const titan_base = (void *) (EXCITE_ADDR_TITAN);
-
-/* Protect access to shared GPI registers */
-DEFINE_SPINLOCK(titan_lock);
-int titan_irqflags;
-
-
-/*
- * The eXcite platform uses the alternate timer interrupt
- *
- * Fixme: At the time of this writing cevt-r4k.c doesn't yet know about how
- * to handle the alternate timer interrupt of the RM9000.
- */
-void __init plat_time_init(void)
-{
-	const u32 modebit5 = ocd_readl(0x00e4);
-	unsigned int mult = ((modebit5 >> 11) & 0x1f) + 2;
-	unsigned int div = ((modebit5 >> 16) & 0x1f) + 2;
-
-	if (div == 33)
-		div = 1;
-	mips_hpt_frequency = EXCITE_CPU_EXT_CLOCK * mult / div / 2;
-}
-
-static int __init excite_init_console(void)
-{
-#if defined(CONFIG_SERIAL_8250)
-	static __initdata char serr[] =
-		KERN_ERR "Serial port #%u setup failed\n";
-	struct uart_port up;
-
-	/* Take the DUART out of reset */
-	titan_writel(0x00ff1cff, CPRR);
-
-#if (CONFIG_SERIAL_8250_NR_UARTS > 1)
-	/* Enable both ports */
-	titan_writel(MASK_SER0 | MASK_SER1, UACFG);
-#else
-	/* Enable port #0 only */
-	titan_writel(MASK_SER0, UACFG);
-#endif
-
- 	/*
-	 * Set up serial port #0. Do not use autodetection; the result is
-	 * not what we want.
- 	 */
-	memset(&up, 0, sizeof(up));
-	up.membase	= (char *) titan_addr(REGBASE_SER0);
-	up.irq		= TITAN_IRQ;
-	up.uartclk	= TITAN_UART_CLK;
-	up.regshift	= 0;
-	up.iotype	= UPIO_RM9000;
-	up.type		= PORT_RM9000;
-	up.flags	= UPF_SHARE_IRQ;
-	up.line		= 0;
-	if (early_serial_setup(&up))
-		printk(serr, up.line);
-
-#if CONFIG_SERIAL_8250_NR_UARTS > 1
-	/* And now for port #1. */
-	up.membase	= (char *) titan_addr(REGBASE_SER1);
-	up.line		= 1;
- 	if (early_serial_setup(&up))
-		printk(serr, up.line);
-#endif /* CONFIG_SERIAL_8250_NR_UARTS > 1 */
-#else
-	/* Leave the DUART in reset */
-	titan_writel(0x00ff3cff, CPRR);
-#endif  /* defined(CONFIG_SERIAL_8250) */
-
-	return 0;
-}
-
-static int __init excite_platform_init(void)
-{
-	unsigned int i;
-	unsigned char buf[3];
-	u8 reg;
-	void __iomem * dpr;
-
-	/* BIU buffer allocations */
-	ocd_writel(8, CPURSLMT);	/* CPU */
-	titan_writel(4, CPGRWL);	/* GPI / Ethernet */
-
-	/* Map control registers located in FPGA */
-	ctl_regs = ioremap_nocache(EXCITE_PHYS_FPGA + EXCITE_FPGA_SYSCTL, 16);
-	if (!ctl_regs)
-		panic("eXcite: failed to map platform control registers\n");
-	memcpy_fromio(buf, ctl_regs + 2, ARRAY_SIZE(buf));
-	unit_id = buf[0] | (buf[1] << 8) | (buf[2] << 16);
-
-	/* Clear the reboot flag */
-	dpr = ioremap_nocache(EXCITE_PHYS_FPGA + EXCITE_FPGA_DPR, 1);
-	reg = __raw_readb(dpr);
-	__raw_writeb(reg & 0x7f, dpr);
-	iounmap(dpr);
-
-	/* Interrupt controller setup */
-	for (i = INTP0Status0; i < INTP0Status0 + 0x80; i += 0x10) {
-		ocd_writel(0x00000000, i + 0x04);
-		ocd_writel(0xffffffff, i + 0x0c);
-	}
-	ocd_writel(0x2, NMICONFIG);
-
-	ocd_writel(0x1 << (TITAN_MSGINT % 0x20),
-		   INTP0Mask0 + (0x10 * (TITAN_MSGINT / 0x20)));
-	ocd_writel((0x1 << (FPGA0_MSGINT % 0x20))
-		   | ocd_readl(INTP0Mask0 + (0x10 * (FPGA0_MSGINT / 0x20))),
-		   INTP0Mask0 + (0x10 * (FPGA0_MSGINT / 0x20)));
-	ocd_writel((0x1 << (FPGA1_MSGINT % 0x20))
-		   | ocd_readl(INTP0Mask0 + (0x10 * (FPGA1_MSGINT / 0x20))),
-		   INTP0Mask0 + (0x10 * (FPGA1_MSGINT / 0x20)));
-	ocd_writel((0x1 << (PHY_MSGINT % 0x20))
-		   | ocd_readl(INTP0Mask0 + (0x10 * (PHY_MSGINT / 0x20))),
-		   INTP0Mask0 + (0x10 * (PHY_MSGINT / 0x20)));
-#if USB_IRQ < 10
-	ocd_writel((0x1 << (USB_MSGINT % 0x20))
-		   | ocd_readl(INTP0Mask0 + (0x10 * (USB_MSGINT / 0x20))),
-		   INTP0Mask0 + (0x10 * (USB_MSGINT / 0x20)));
-#endif
-	/* Enable the packet FIFO, XDMA and XDMA arbiter */
-	titan_writel(0x00ff18ff, CPRR);
-
-	/*
-	 * Set up the PADMUX. Power down all ethernet slices,
-	 * they will be powered up and configured at device startup.
-	 */
-	titan_writel(0x00878206, CPTC1R);
-	titan_writel(0x00001100, CPTC0R); /* latch PADMUX, enable WCIMODE */
-
-	/* Reset and enable the FIFO block */
-	titan_writel(0x00000001, SDRXFCIE);
-	titan_writel(0x00000001, SDTXFCIE);
-	titan_writel(0x00000100, SDRXFCIE);
-	titan_writel(0x00000000, SDTXFCIE);
-
-	/*
-	 * Initialize the common interrupt shared by all components of
-	 * the GPI/Ethernet subsystem.
-	 */
-	titan_writel((EXCITE_PHYS_OCD >> 12), CPCFG0);
-	titan_writel(TITAN_MSGINT, CPCFG1);
-
-	/*
-	 * XDMA configuration.
-	 * In order for the XDMA to be sharable among multiple drivers,
-	 * the setup must be done here in the platform. The reason is that
-	 * this setup can only be done while the XDMA is in reset. If this
-	 * were done in a driver, it would interrupt all other drivers
-	 * using the XDMA.
-	 */
-	titan_writel(0x80021dff, GXCFG);	/* XDMA reset */
-	titan_writel(0x00000000, CPXCISRA);
-	titan_writel(0x00000000, CPXCISRB);	/* clear pending interrupts */
-#if defined(CONFIG_HIGHMEM)
-#	error change for HIGHMEM support!
-#else
-	titan_writel(0x00000000, GXDMADRPFX);	/* buffer address prefix */
-#endif
-	titan_writel(0, GXDMA_DESCADR);
-
-	for (i = 0x5040; i <= 0x5300; i += 0x0040)
-		titan_writel(0x80080000, i);	/* reset channel */
-
-	titan_writel((0x1 << 29)			/* no sparse tx descr. */
-		     | (0x1 << 28)			/* no sparse rx descr. */
-		     | (0x1 << 23) | (0x1 << 24)	/* descriptor coherency */
-		     | (0x1 << 21) | (0x1 << 22)	/* data coherency */
-		     | (0x1 << 17)
-		     | 0x1dff,
-		     GXCFG);
-
-#if defined(CONFIG_SMP)
-#	error No SMP support
-#else
-	/* All interrupts go to core #0 only. */
-	titan_writel(0x1f007fff, CPDST0A);
-	titan_writel(0x00000000, CPDST0B);
-	titan_writel(0x0000ff3f, CPDST1A);
-	titan_writel(0x00000000, CPDST1B);
-	titan_writel(0x00ffffff, CPXDSTA);
-	titan_writel(0x00000000, CPXDSTB);
-#endif
-
-	/* Enable DUART interrupts, disable everything else. */
-	titan_writel(0x04000000, CPGIG0ER);
-	titan_writel(0x000000c0, CPGIG1ER);
-
-	excite_procfs_init();
-	return 0;
-}
-
-void __init plat_mem_setup(void)
-{
-	volatile u32 * const boot_ocd_base = (u32 *) 0xbf7fc000;
-
-	/* Announce RAM to system */
-	add_memory_region(0x00000000, memsize, BOOT_MEM_RAM);
-
-	/* Set up the peripheral address map */
-	*(boot_ocd_base + (LKB9 / sizeof(u32))) = 0;
-	*(boot_ocd_base + (LKB10 / sizeof(u32))) = 0;
-	*(boot_ocd_base + (LKB11 / sizeof(u32))) = 0;
-	*(boot_ocd_base + (LKB12 / sizeof(u32))) = 0;
-	wmb();
-	*(boot_ocd_base + (LKB0 / sizeof(u32))) = EXCITE_PHYS_OCD >> 4;
-	wmb();
-
-	ocd_writel((EXCITE_PHYS_TITAN >> 4) | 0x1UL, LKB5);
-	ocd_writel(((EXCITE_SIZE_TITAN >> 4) & 0x7fffff00) - 0x100, LKM5);
-	ocd_writel((EXCITE_PHYS_SCRAM >> 4) | 0x1UL, LKB13);
-	ocd_writel(((EXCITE_SIZE_SCRAM >> 4) & 0xffffff00) - 0x100, LKM13);
-
-	/* Local bus slot #0 */
-	ocd_writel(0x00040510, LDP0);
-	ocd_writel((EXCITE_PHYS_BOOTROM >> 4) | 0x1UL, LKB9);
-	ocd_writel(((EXCITE_SIZE_BOOTROM >> 4) & 0x03ffff00) - 0x100, LKM9);
-
-	/* Local bus slot #2 */
-	ocd_writel(0x00000330, LDP2);
-	ocd_writel((EXCITE_PHYS_FPGA >> 4) | 0x1, LKB11);
-	ocd_writel(((EXCITE_SIZE_FPGA >> 4) - 0x100) & 0x03ffff00, LKM11);
-
-	/* Local bus slot #3 */
-	ocd_writel(0x00123413, LDP3);
-	ocd_writel((EXCITE_PHYS_NAND >> 4) | 0x1, LKB12);
-	ocd_writel(((EXCITE_SIZE_NAND >> 4) - 0x100) & 0x03ffff00, LKM12);
-}
-
-
-
-console_initcall(excite_init_console);
-arch_initcall(excite_platform_init);
-
-EXPORT_SYMBOL(titan_lock);
-EXPORT_SYMBOL(titan_irqflags);
-EXPORT_SYMBOL(titan_irq);
-EXPORT_SYMBOL(ocd_base);
-EXPORT_SYMBOL(titan_base);
Index: linux-queue/arch/mips/include/asm/mach-excite/cpu-feature-overrides.h
===================================================================
--- linux-queue.orig/arch/mips/include/asm/mach-excite/cpu-feature-overrides.h
+++ /dev/null
@@ -1,48 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2004 Thomas Koeller <thomas.koeller@baslerweb.com>
- * Copyright (C) 2007 Ralf Baechle (ralf@linux-mips.org)
- */
-#ifndef __ASM_MACH_EXCITE_CPU_FEATURE_OVERRIDES_H
-#define __ASM_MACH_EXCITE_CPU_FEATURE_OVERRIDES_H
-
-/*
- * Basler eXcite has an RM9122 processor.
- */
-#define cpu_has_watch		1
-#define cpu_has_mips16		0
-#define cpu_has_divec		0
-#define cpu_has_vce		0
-#define cpu_has_cache_cdex_p	0
-#define cpu_has_cache_cdex_s	0
-#define cpu_has_prefetch	1
-#define cpu_has_mcheck		0
-#define cpu_has_ejtag		0
-
-#define cpu_has_llsc		1
-#define cpu_has_vtag_icache	0
-#define cpu_has_dc_aliases	0
-#define cpu_has_ic_fills_f_dc	0
-#define cpu_has_dsp		0
-#define cpu_icache_snoops_remote_store	0
-#define cpu_has_mipsmt		0
-#define cpu_has_userlocal	0
-
-#define cpu_has_nofpuex		0
-#define cpu_has_64bits		1
-
-#define cpu_has_mips32r1	0
-#define cpu_has_mips32r2	0
-#define cpu_has_mips64r1	0
-#define cpu_has_mips64r2	0
-
-#define cpu_has_inclusive_pcaches	0
-
-#define cpu_dcache_line_size()	32
-#define cpu_icache_line_size()	32
-#define cpu_scache_line_size()	32
-
-#endif /* __ASM_MACH_EXCITE_CPU_FEATURE_OVERRIDES_H */
Index: linux-queue/arch/mips/include/asm/mach-excite/excite.h
===================================================================
--- linux-queue.orig/arch/mips/include/asm/mach-excite/excite.h
+++ /dev/null
@@ -1,154 +0,0 @@
-#ifndef __EXCITE_H__
-#define __EXCITE_H__
-
-#include <linux/init.h>
-#include <asm/addrspace.h>
-#include <asm/types.h>
-
-#define EXCITE_CPU_EXT_CLOCK 100000000
-
-#if !defined(__ASSEMBLY__)
-void __init excite_kgdb_init(void);
-void excite_procfs_init(void);
-extern unsigned long memsize;
-extern char modetty[];
-extern u32 unit_id;
-#endif
-
-/* Base name for XICAP devices */
-#define XICAP_NAME	"xicap_gpi"
-
-/* OCD register offsets */
-#define LKB0		0x0038
-#define LKB5		0x0128
-#define LKM5		0x012C
-#define LKB7		0x0138
-#define LKM7		0x013c
-#define LKB8		0x0140
-#define LKM8		0x0144
-#define LKB9		0x0148
-#define LKM9		0x014c
-#define LKB10		0x0150
-#define LKM10		0x0154
-#define LKB11		0x0158
-#define LKM11		0x015c
-#define LKB12		0x0160
-#define LKM12		0x0164
-#define LKB13		0x0168
-#define LKM13		0x016c
-#define LDP0		0x0200
-#define LDP1		0x0210
-#define LDP2		0x0220
-#define LDP3		0x0230
-#define INTPIN0		0x0A40
-#define INTPIN1		0x0A44
-#define INTPIN2		0x0A48
-#define INTPIN3		0x0A4C
-#define INTPIN4		0x0A50
-#define INTPIN5		0x0A54
-#define INTPIN6		0x0A58
-#define INTPIN7		0x0A5C
-
-
-
-
-/* TITAN register offsets */
-#define CPRR		0x0004
-#define CPDSR		0x0008
-#define CPTC0R		0x000c
-#define CPTC1R		0x0010
-#define CPCFG0		0x0020
-#define CPCFG1		0x0024
-#define CPDST0A		0x0028
-#define CPDST0B		0x002c
-#define CPDST1A		0x0030
-#define CPDST1B		0x0034
-#define CPXDSTA		0x0038
-#define CPXDSTB		0x003c
-#define CPXCISRA	0x0048
-#define CPXCISRB	0x004c
-#define CPGIG0ER	0x0050
-#define CPGIG1ER	0x0054
-#define CPGRWL		0x0068
-#define CPURSLMT	0x00f8
-#define UACFG		0x0200
-#define UAINTS		0x0204
-#define SDRXFCIE	0x4828
-#define SDTXFCIE	0x4928
-#define INTP0Status0	0x1B00
-#define INTP0Mask0	0x1B04
-#define INTP0Set0	0x1B08
-#define INTP0Clear0	0x1B0C
-#define GXCFG		0x5000
-#define GXDMADRPFX	0x5018
-#define GXDMA_DESCADR	0x501c
-#define GXCH0TDESSTRT	0x5054
-
-/* IRQ definitions */
-#define NMICONFIG		0xac0
-#define TITAN_MSGINT	0xc4
-#define TITAN_IRQ	((TITAN_MSGINT / 0x20) + 2)
-#define FPGA0_MSGINT	0x5a
-#define FPGA0_IRQ	((FPGA0_MSGINT / 0x20) + 2)
-#define FPGA1_MSGINT	0x7b
-#define FPGA1_IRQ	((FPGA1_MSGINT / 0x20) + 2)
-#define PHY_MSGINT	0x9c
-#define PHY_IRQ		((PHY_MSGINT   / 0x20) + 2)
-
-#if defined(CONFIG_BASLER_EXCITE_PROTOTYPE)
-/* Pre-release units used interrupt pin #9 */
-#define USB_IRQ		11
-#else
-/* Re-designed units use interrupt pin #1 */
-#define USB_MSGINT	0x39
-#define USB_IRQ		((USB_MSGINT / 0x20) + 2)
-#endif
-#define TIMER_IRQ	12
-
-
-/* Device address ranges */
-#define EXCITE_OFFS_OCD		0x1fffc000
-#define	EXCITE_SIZE_OCD		(16 * 1024)
-#define EXCITE_PHYS_OCD		CPHYSADDR(EXCITE_OFFS_OCD)
-#define EXCITE_ADDR_OCD		CKSEG1ADDR(EXCITE_OFFS_OCD)
-
-#define EXCITE_OFFS_SCRAM 	0x1fffa000
-#define	EXCITE_SIZE_SCRAM	(8 << 10)
-#define EXCITE_PHYS_SCRAM 	CPHYSADDR(EXCITE_OFFS_SCRAM)
-#define EXCITE_ADDR_SCRAM 	CKSEG1ADDR(EXCITE_OFFS_SCRAM)
-
-#define EXCITE_OFFS_PCI_IO	0x1fff8000
-#define	EXCITE_SIZE_PCI_IO	(8 << 10)
-#define EXCITE_PHYS_PCI_IO	CPHYSADDR(EXCITE_OFFS_PCI_IO)
-#define EXCITE_ADDR_PCI_IO 	CKSEG1ADDR(EXCITE_OFFS_PCI_IO)
-
-#define EXCITE_OFFS_TITAN	0x1fff0000
-#define EXCITE_SIZE_TITAN	(32 << 10)
-#define EXCITE_PHYS_TITAN	CPHYSADDR(EXCITE_OFFS_TITAN)
-#define EXCITE_ADDR_TITAN	CKSEG1ADDR(EXCITE_OFFS_TITAN)
-
-#define EXCITE_OFFS_PCI_MEM	0x1ffe0000
-#define EXCITE_SIZE_PCI_MEM	(64 << 10)
-#define EXCITE_PHYS_PCI_MEM	CPHYSADDR(EXCITE_OFFS_PCI_MEM)
-#define EXCITE_ADDR_PCI_MEM	CKSEG1ADDR(EXCITE_OFFS_PCI_MEM)
-
-#define EXCITE_OFFS_FPGA	0x1ffdc000
-#define EXCITE_SIZE_FPGA	(16 << 10)
-#define EXCITE_PHYS_FPGA	CPHYSADDR(EXCITE_OFFS_FPGA)
-#define EXCITE_ADDR_FPGA	CKSEG1ADDR(EXCITE_OFFS_FPGA)
-
-#define EXCITE_OFFS_NAND	0x1ffd8000
-#define EXCITE_SIZE_NAND	(16 << 10)
-#define EXCITE_PHYS_NAND	CPHYSADDR(EXCITE_OFFS_NAND)
-#define EXCITE_ADDR_NAND	CKSEG1ADDR(EXCITE_OFFS_NAND)
-
-#define EXCITE_OFFS_BOOTROM	0x1f000000
-#define EXCITE_SIZE_BOOTROM	(8 << 20)
-#define EXCITE_PHYS_BOOTROM	CPHYSADDR(EXCITE_OFFS_BOOTROM)
-#define EXCITE_ADDR_BOOTROM	CKSEG1ADDR(EXCITE_OFFS_BOOTROM)
-
-/* FPGA address offsets */
-#define EXCITE_FPGA_DPR		0x0104	/* dual-ported ram */
-#define EXCITE_FPGA_SYSCTL	0x0200	/* system control register block */
-
-#endif /* __EXCITE_H__ */
Index: linux-queue/arch/mips/include/asm/mach-excite/excite_fpga.h
===================================================================
--- linux-queue.orig/arch/mips/include/asm/mach-excite/excite_fpga.h
+++ /dev/null
@@ -1,80 +0,0 @@
-#ifndef EXCITE_FPGA_H_INCLUDED
-#define EXCITE_FPGA_H_INCLUDED
-
-
-/**
- * Address alignment of the individual FPGA bytes.
- * The address arrangement of the individual bytes of the FPGA is two
- * byte aligned at the embedded MK2 platform.
- */
-#ifdef EXCITE_CCI_FPGA_MK2
-typedef unsigned char excite_cci_fpga_align_t __attribute__ ((aligned(2)));
-#else
-typedef unsigned char excite_cci_fpga_align_t;
-#endif
-
-
-/**
- * Size of Dual Ported RAM.
- */
-#define EXCITE_DPR_SIZE 263
-
-
-/**
- * Size of Reserved Status Fields in Dual Ported RAM.
- */
-#define EXCITE_DPR_STATUS_SIZE 7
-
-
-
-/**
- * FPGA.
- * Hardware register layout of the FPGA interface. The FPGA must accessed
- * byte wise solely.
- * @see EXCITE_CCI_DPR_MK2
- */
-typedef struct excite_fpga {
-
-	/**
-	 * Dual Ported RAM.
-	 */
-	excite_cci_fpga_align_t dpr[EXCITE_DPR_SIZE];
-
-	/**
-	 * Status.
-	 */
-	excite_cci_fpga_align_t status[EXCITE_DPR_STATUS_SIZE];
-
-#ifdef EXCITE_CCI_FPGA_MK2
-	/**
-	 * RM9000 Interrupt.
-	 * Write access initiates interrupt at the RM9000 (MIPS) processor of the eXcite.
-	 */
-	excite_cci_fpga_align_t rm9k_int;
-#else
-	/**
-	 * MK2 Interrupt.
-	 * Write access initiates interrupt at the ARM processor of the MK2.
-	 */
-	excite_cci_fpga_align_t mk2_int;
-
-	excite_cci_fpga_align_t gap[0x1000-0x10f];
-
-	/**
-	 * IRQ Source/Acknowledge.
-	 */
-	excite_cci_fpga_align_t rm9k_irq_src;
-
-	/**
-	 * IRQ Mask.
-	 * Set bits enable the related interrupt.
-	 */
-	excite_cci_fpga_align_t rm9k_irq_mask;
-#endif
-
-
-} excite_fpga;
-
-
-
-#endif	/* ndef EXCITE_FPGA_H_INCLUDED */
Index: linux-queue/arch/mips/include/asm/mach-excite/excite_nandflash.h
===================================================================
--- linux-queue.orig/arch/mips/include/asm/mach-excite/excite_nandflash.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef __EXCITE_NANDFLASH_H__
-#define __EXCITE_NANDFLASH_H__
-
-/* Resource names */
-#define EXCITE_NANDFLASH_RESOURCE_REGS	"excite_nandflash_regs"
-
-#endif /* __EXCITE_NANDFLASH_H__ */
Index: linux-queue/arch/mips/include/asm/mach-excite/rm9k_eth.h
===================================================================
--- linux-queue.orig/arch/mips/include/asm/mach-excite/rm9k_eth.h
+++ /dev/null
@@ -1,23 +0,0 @@
-#if !defined(__RM9K_ETH_H__)
-#define __RM9K_ETH_H__
-
-#define RM9K_GE_NAME			"rm9k_ge"
-
-/* Resource names */
-#define RM9K_GE_RESOURCE_MAC      	"rm9k_ge_mac"
-#define RM9K_GE_RESOURCE_MSTAT      	"rm9k_ge_mstat"
-#define RM9K_GE_RESOURCE_PKTPROC	"rm9k_ge_pktproc"
-#define RM9K_GE_RESOURCE_XDMA		"rm9k_ge_xdma"
-#define RM9K_GE_RESOURCE_FIFO_RX  	"rm9k_ge_fifo_rx"
-#define RM9K_GE_RESOURCE_FIFO_TX  	"rm9k_ge_fifo_tx"
-#define RM9K_GE_RESOURCE_FIFOMEM_RX  	"rm9k_ge_fifo_memory_rx"
-#define RM9K_GE_RESOURCE_FIFOMEM_TX  	"rm9k_ge_fifo_memory_tx"
-#define RM9K_GE_RESOURCE_PHY      	"rm9k_ge_phy"
-#define RM9K_GE_RESOURCE_DMADESC_RX  	"rm9k_ge_dmadesc_rx"
-#define RM9K_GE_RESOURCE_DMADESC_TX  	"rm9k_ge_dmadesc_tx"
-#define RM9K_GE_RESOURCE_IRQ_MAIN	"rm9k_ge_irq_main"
-#define RM9K_GE_RESOURCE_IRQ_PHY	"rm9k_ge_irq_phy"
-#define RM9K_GE_RESOURCE_GPI_SLICE	"rm9k_ge_gpi_slice"
-#define RM9K_GE_RESOURCE_MDIO_CHANNEL	"rm9k_ge_mdio_channel"
-
-#endif /* !defined(__RM9K_ETH_H__) */
Index: linux-queue/arch/mips/include/asm/mach-excite/rm9k_wdt.h
===================================================================
--- linux-queue.orig/arch/mips/include/asm/mach-excite/rm9k_wdt.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef __RM9K_WDT_H__
-#define __RM9K_WDT_H__
-
-/* Device name */
-#define WDT_NAME		"wdt_gpi"
-
-/* Resource names */
-#define WDT_RESOURCE_REGS	"excite_watchdog_regs"
-#define WDT_RESOURCE_IRQ	"excite_watchdog_irq"
-#define WDT_RESOURCE_COUNTER	"excite_watchdog_counter"
-
-#endif /* __RM9K_WDT_H__ */
Index: linux-queue/arch/mips/include/asm/mach-excite/rm9k_xicap.h
===================================================================
--- linux-queue.orig/arch/mips/include/asm/mach-excite/rm9k_xicap.h
+++ /dev/null
@@ -1,16 +0,0 @@
-#ifndef __EXCITE_XICAP_H__
-#define __EXCITE_XICAP_H__
-
-
-/* Resource names */
-#define XICAP_RESOURCE_FIFO_RX		"xicap_fifo_rx"
-#define XICAP_RESOURCE_FIFO_TX		"xicap_fifo_tx"
-#define XICAP_RESOURCE_XDMA 		"xicap_xdma"
-#define XICAP_RESOURCE_DMADESC		"xicap_dmadesc"
-#define XICAP_RESOURCE_PKTPROC  	"xicap_pktproc"
-#define XICAP_RESOURCE_IRQ		"xicap_irq"
-#define XICAP_RESOURCE_GPI_SLICE	"xicap_gpi_slice"
-#define XICAP_RESOURCE_FIFO_BLK		"xicap_fifo_blocks"
-#define XICAP_RESOURCE_PKT_STREAM	"xicap_pkt_stream"
-
-#endif /* __EXCITE_XICAP_H__ */
Index: linux-queue/arch/mips/include/asm/mach-excite/war.h
===================================================================
--- linux-queue.orig/arch/mips/include/asm/mach-excite/war.h
+++ /dev/null
@@ -1,25 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2002, 2004, 2007 by Ralf Baechle <ralf@linux-mips.org>
- */
-#ifndef __ASM_MIPS_MACH_EXCITE_WAR_H
-#define __ASM_MIPS_MACH_EXCITE_WAR_H
-
-#define R4600_V1_INDEX_ICACHEOP_WAR	0
-#define R4600_V1_HIT_CACHEOP_WAR	0
-#define R4600_V2_HIT_CACHEOP_WAR	0
-#define R5432_CP0_INTERRUPT_WAR		0
-#define BCM1250_M3_WAR			0
-#define SIBYTE_1956_WAR			0
-#define MIPS4K_ICACHE_REFILL_WAR	0
-#define MIPS_CACHE_SYNC_WAR		0
-#define TX49XX_ICACHE_INDEX_INV_WAR	0
-#define RM9000_CDEX_SMP_WAR		1
-#define ICACHE_REFILLS_WORKAROUND_WAR   1
-#define R10000_LLSC_WAR			0
-#define MIPS34K_MISSED_ITLB_WAR	0
-
-#endif /* __ASM_MIPS_MACH_EXCITE_WAR_H */
Index: linux-queue/drivers/mtd/nand/Makefile
===================================================================
--- linux-queue.orig/drivers/mtd/nand/Makefile
+++ linux-queue/drivers/mtd/nand/Makefile
@@ -27,7 +27,6 @@ obj-$(CONFIG_MTD_NAND_ATMEL)		+= atmel_n
 obj-$(CONFIG_MTD_NAND_GPIO)		+= gpio.o
 obj-$(CONFIG_MTD_NAND_OMAP2) 		+= omap2.o
 obj-$(CONFIG_MTD_NAND_CM_X270)		+= cmx270_nand.o
-obj-$(CONFIG_MTD_NAND_BASLER_EXCITE)	+= excite_nandflash.o
 obj-$(CONFIG_MTD_NAND_PXA3xx)		+= pxa3xx_nand.o
 obj-$(CONFIG_MTD_NAND_TMIO)		+= tmio_nand.o
 obj-$(CONFIG_MTD_NAND_PLATFORM)		+= plat_nand.o
Index: linux-queue/drivers/mtd/nand/excite_nandflash.c
===================================================================
--- linux-queue.orig/drivers/mtd/nand/excite_nandflash.c
+++ /dev/null
@@ -1,248 +0,0 @@
-/*
-*  Copyright (C) 2005 - 2007 by Basler Vision Technologies AG
-*  Author: Thomas Koeller <thomas.koeller.qbaslerweb.com>
-*  Original code by Thies Moeller <thies.moeller@baslerweb.com>
-*
-*  This program is free software; you can redistribute it and/or modify
-*  it under the terms of the GNU General Public License as published by
-*  the Free Software Foundation; either version 2 of the License, or
-*  (at your option) any later version.
-*
-*  This program is distributed in the hope that it will be useful,
-*  but WITHOUT ANY WARRANTY; without even the implied warranty of
-*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-*  GNU General Public License for more details.
-*
-*  You should have received a copy of the GNU General Public License
-*  along with this program; if not, write to the Free Software
-*  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
-*/
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/ioport.h>
-#include <linux/platform_device.h>
-#include <linux/delay.h>
-#include <linux/err.h>
-
-#include <linux/mtd/mtd.h>
-#include <linux/mtd/nand.h>
-#include <linux/mtd/nand_ecc.h>
-#include <linux/mtd/partitions.h>
-
-#include <asm/io.h>
-#include <asm/rm9k-ocd.h>
-
-#include <excite_nandflash.h>
-
-#define EXCITE_NANDFLASH_VERSION "0.1"
-
-/* I/O register offsets */
-#define EXCITE_NANDFLASH_DATA_BYTE   0x00
-#define EXCITE_NANDFLASH_STATUS_BYTE 0x0c
-#define EXCITE_NANDFLASH_ADDR_BYTE   0x10
-#define EXCITE_NANDFLASH_CMD_BYTE    0x14
-
-/* prefix for debug output */
-static const char module_id[] = "excite_nandflash";
-
-/*
- * partition definition
- */
-static const struct mtd_partition partition_info[] = {
-	{
-		.name = "eXcite RootFS",
-		.offset = 0,
-		.size = MTDPART_SIZ_FULL
-	}
-};
-
-static inline const struct resource *
-excite_nand_get_resource(struct platform_device *d, unsigned long flags,
-			 const char *basename)
-{
-	char buf[80];
-
-	if (snprintf(buf, sizeof buf, "%s_%u", basename, d->id) >= sizeof buf)
-		return NULL;
-	return platform_get_resource_byname(d, flags, buf);
-}
-
-static inline void __iomem *
-excite_nand_map_regs(struct platform_device *d, const char *basename)
-{
-	void *result = NULL;
-	const struct resource *const r =
-	    excite_nand_get_resource(d, IORESOURCE_MEM, basename);
-
-	if (r)
-		result = ioremap_nocache(r->start, r->end + 1 - r->start);
-	return result;
-}
-
-/* controller and mtd information */
-struct excite_nand_drvdata {
-	struct mtd_info board_mtd;
-	struct nand_chip board_chip;
-	void __iomem *regs;
-	void __iomem *tgt;
-};
-
-/* Control function */
-static void excite_nand_control(struct mtd_info *mtd, int cmd,
-				       unsigned int ctrl)
-{
-	struct excite_nand_drvdata * const d =
-	    container_of(mtd, struct excite_nand_drvdata, board_mtd);
-
-	switch (ctrl) {
-	case NAND_CTRL_CHANGE | NAND_CTRL_CLE:
-		d->tgt = d->regs + EXCITE_NANDFLASH_CMD_BYTE;
-		break;
-	case NAND_CTRL_CHANGE | NAND_CTRL_ALE:
-		d->tgt = d->regs + EXCITE_NANDFLASH_ADDR_BYTE;
-		break;
-	case NAND_CTRL_CHANGE | NAND_NCE:
-		d->tgt = d->regs + EXCITE_NANDFLASH_DATA_BYTE;
-		break;
-	}
-
-	if (cmd != NAND_CMD_NONE)
-		__raw_writeb(cmd, d->tgt);
-}
-
-/* Return 0 if flash is busy, 1 if ready */
-static int excite_nand_devready(struct mtd_info *mtd)
-{
-	struct excite_nand_drvdata * const drvdata =
-	    container_of(mtd, struct excite_nand_drvdata, board_mtd);
-
-	return __raw_readb(drvdata->regs + EXCITE_NANDFLASH_STATUS_BYTE);
-}
-
-/*
- * Called by device layer to remove the driver.
- * The binding to the mtd and all allocated
- * resources are released.
- */
-static int __exit excite_nand_remove(struct platform_device *dev)
-{
-	struct excite_nand_drvdata * const this = platform_get_drvdata(dev);
-
-	platform_set_drvdata(dev, NULL);
-
-	if (unlikely(!this)) {
-		printk(KERN_ERR "%s: called %s without private data!!",
-		       module_id, __func__);
-		return -EINVAL;
-	}
-
-	/* first thing we need to do is release our mtd
-	 * then go through freeing the resource used
-	 */
-	nand_release(&this->board_mtd);
-
-	/* free the common resources */
-	iounmap(this->regs);
-	kfree(this);
-
-	DEBUG(MTD_DEBUG_LEVEL1, "%s: removed\n", module_id);
-	return 0;
-}
-
-/*
- * Called by device layer when it finds a device matching
- * one our driver can handle. This code checks to see if
- * it can allocate all necessary resources then calls the
- * nand layer to look for devices.
-*/
-static int __init excite_nand_probe(struct platform_device *pdev)
-{
-	struct excite_nand_drvdata *drvdata;	/* private driver data */
-	struct nand_chip *board_chip;	/* private flash chip data */
-	struct mtd_info *board_mtd;	/* mtd info for this board */
-	int scan_res;
-
-	drvdata = kzalloc(sizeof(*drvdata), GFP_KERNEL);
-	if (unlikely(!drvdata)) {
-		printk(KERN_ERR "%s: no memory for drvdata\n",
-		       module_id);
-		return -ENOMEM;
-	}
-
-	/* bind private data into driver */
-	platform_set_drvdata(pdev, drvdata);
-
-	/* allocate and map the resource */
-	drvdata->regs =
-		excite_nand_map_regs(pdev, EXCITE_NANDFLASH_RESOURCE_REGS);
-
-	if (unlikely(!drvdata->regs)) {
-		printk(KERN_ERR "%s: cannot reserve register region\n",
-		       module_id);
-		kfree(drvdata);
-		return -ENXIO;
-	}
-	
-	drvdata->tgt = drvdata->regs + EXCITE_NANDFLASH_DATA_BYTE;
-
-	/* initialise our chip */
-	board_chip = &drvdata->board_chip;
-	board_chip->IO_ADDR_R = board_chip->IO_ADDR_W =
-		drvdata->regs + EXCITE_NANDFLASH_DATA_BYTE;
-	board_chip->cmd_ctrl = excite_nand_control;
-	board_chip->dev_ready = excite_nand_devready;
-	board_chip->chip_delay = 25;
-	board_chip->ecc.mode = NAND_ECC_SOFT;
-
-	/* link chip to mtd */
-	board_mtd = &drvdata->board_mtd;
-	board_mtd->priv = board_chip;
-
-	DEBUG(MTD_DEBUG_LEVEL2, "%s: device scan\n", module_id);
-	scan_res = nand_scan(&drvdata->board_mtd, 1);
-
-	if (likely(!scan_res)) {
-		DEBUG(MTD_DEBUG_LEVEL2, "%s: register partitions\n", module_id);
-		add_mtd_partitions(&drvdata->board_mtd, partition_info,
-				   ARRAY_SIZE(partition_info));
-	} else {
-		iounmap(drvdata->regs);
-		kfree(drvdata);
-		printk(KERN_ERR "%s: device scan failed\n", module_id);
-		return -EIO;
-	}
-	return 0;
-}
-
-static struct platform_driver excite_nand_driver = {
-	.driver = {
-		.name = "excite_nand",
-		.owner		= THIS_MODULE,
-	},
-	.probe = excite_nand_probe,
-	.remove = __devexit_p(excite_nand_remove)
-};
-
-static int __init excite_nand_init(void)
-{
-	pr_info("Basler eXcite nand flash driver Version "
-		EXCITE_NANDFLASH_VERSION "\n");
-	return platform_driver_register(&excite_nand_driver);
-}
-
-static void __exit excite_nand_exit(void)
-{
-	platform_driver_unregister(&excite_nand_driver);
-}
-
-module_init(excite_nand_init);
-module_exit(excite_nand_exit);
-
-MODULE_AUTHOR("Thomas Koeller <thomas.koeller@baslerweb.com>");
-MODULE_DESCRIPTION("Basler eXcite NAND-Flash driver");
-MODULE_LICENSE("GPL");
-MODULE_VERSION(EXCITE_NANDFLASH_VERSION)
Index: linux-queue/drivers/mtd/nand/Kconfig
===================================================================
--- linux-queue.orig/drivers/mtd/nand/Kconfig
+++ linux-queue/drivers/mtd/nand/Kconfig
@@ -277,14 +277,6 @@ config MTD_NAND_SHARPSL
 	tristate "Support for NAND Flash on Sharp SL Series (C7xx + others)"
 	depends on ARCH_PXA
 
-config MTD_NAND_BASLER_EXCITE
-	tristate  "Support for NAND Flash on Basler eXcite"
-	depends on BASLER_EXCITE
-	help
-          This enables the driver for the NAND flash device found on the
-          Basler eXcite Smart Camera. If built as a module, the driver
-          will be named excite_nandflash.
-
 config MTD_NAND_CAFE
 	tristate "NAND support for OLPC CAFÉ chip"
 	depends on PCI
Index: linux-queue/arch/mips/configs/ar7_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/ar7_defconfig
+++ linux-queue/arch/mips/configs/ar7_defconfig
@@ -10,7 +10,6 @@ CONFIG_MIPS=y
 #
 # CONFIG_MACH_ALCHEMY is not set
 CONFIG_AR7=y
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_BCM47XX is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
Index: linux-queue/arch/mips/configs/bcm47xx_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/bcm47xx_defconfig
+++ linux-queue/arch/mips/configs/bcm47xx_defconfig
@@ -9,7 +9,6 @@ CONFIG_MIPS=y
 # Machine selection
 #
 # CONFIG_MACH_ALCHEMY is not set
-# CONFIG_BASLER_EXCITE is not set
 CONFIG_BCM47XX=y
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
Index: linux-queue/arch/mips/configs/bcm63xx_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/bcm63xx_defconfig
+++ linux-queue/arch/mips/configs/bcm63xx_defconfig
@@ -9,7 +9,6 @@ CONFIG_MIPS=y
 # Machine selection
 #
 # CONFIG_MACH_ALCHEMY is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_BCM47XX is not set
 CONFIG_BCM63XX=y
 # CONFIG_MIPS_COBALT is not set
Index: linux-queue/arch/mips/configs/bigsur_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/bigsur_defconfig
+++ linux-queue/arch/mips/configs/bigsur_defconfig
@@ -9,7 +9,6 @@ CONFIG_MIPS=y
 # Machine selection
 #
 # CONFIG_MACH_ALCHEMY is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_BCM47XX is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
Index: linux-queue/arch/mips/configs/capcella_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/capcella_defconfig
+++ linux-queue/arch/mips/configs/capcella_defconfig
@@ -9,7 +9,6 @@ CONFIG_MIPS=y
 # Machine selection
 #
 # CONFIG_MACH_ALCHEMY is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
 # CONFIG_MACH_JAZZ is not set
Index: linux-queue/arch/mips/configs/cavium-octeon_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/cavium-octeon_defconfig
+++ linux-queue/arch/mips/configs/cavium-octeon_defconfig
@@ -9,7 +9,6 @@ CONFIG_MIPS=y
 # Machine selection
 #
 # CONFIG_MACH_ALCHEMY is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_BCM47XX is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
Index: linux-queue/arch/mips/configs/cobalt_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/cobalt_defconfig
+++ linux-queue/arch/mips/configs/cobalt_defconfig
@@ -9,7 +9,6 @@ CONFIG_MIPS=y
 # Machine selection
 #
 # CONFIG_MACH_ALCHEMY is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_BCM47XX is not set
 CONFIG_MIPS_COBALT=y
 # CONFIG_MACH_DECSTATION is not set
Index: linux-queue/arch/mips/configs/db1000_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/db1000_defconfig
+++ linux-queue/arch/mips/configs/db1000_defconfig
@@ -23,7 +23,6 @@ CONFIG_MIPS_DB1000=y
 # CONFIG_MIPS_DB1550 is not set
 # CONFIG_MIPS_DB1200 is not set
 # CONFIG_MIPS_MIRAGE is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
 # CONFIG_MACH_JAZZ is not set
Index: linux-queue/arch/mips/configs/db1100_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/db1100_defconfig
+++ linux-queue/arch/mips/configs/db1100_defconfig
@@ -23,7 +23,6 @@ CONFIG_MIPS_DB1100=y
 # CONFIG_MIPS_DB1550 is not set
 # CONFIG_MIPS_DB1200 is not set
 # CONFIG_MIPS_MIRAGE is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
 # CONFIG_MACH_JAZZ is not set
Index: linux-queue/arch/mips/configs/db1200_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/db1200_defconfig
+++ linux-queue/arch/mips/configs/db1200_defconfig
@@ -10,7 +10,6 @@ CONFIG_MIPS=y
 #
 CONFIG_MACH_ALCHEMY=y
 # CONFIG_AR7 is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_BCM47XX is not set
 # CONFIG_BCM63XX is not set
 # CONFIG_MIPS_COBALT is not set
Index: linux-queue/arch/mips/configs/db1500_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/db1500_defconfig
+++ linux-queue/arch/mips/configs/db1500_defconfig
@@ -23,7 +23,6 @@ CONFIG_MIPS_DB1500=y
 # CONFIG_MIPS_DB1550 is not set
 # CONFIG_MIPS_DB1200 is not set
 # CONFIG_MIPS_MIRAGE is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
 # CONFIG_MACH_JAZZ is not set
Index: linux-queue/arch/mips/configs/db1550_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/db1550_defconfig
+++ linux-queue/arch/mips/configs/db1550_defconfig
@@ -23,7 +23,6 @@ CONFIG_MACH_ALCHEMY=y
 CONFIG_MIPS_DB1550=y
 # CONFIG_MIPS_DB1200 is not set
 # CONFIG_MIPS_MIRAGE is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
 # CONFIG_MACH_JAZZ is not set
Index: linux-queue/arch/mips/configs/decstation_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/decstation_defconfig
+++ linux-queue/arch/mips/configs/decstation_defconfig
@@ -22,7 +22,6 @@ CONFIG_ZONE_DMA=y
 # CONFIG_MIPS_DB1550 is not set
 # CONFIG_MIPS_DB1200 is not set
 # CONFIG_MIPS_MIRAGE is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_MIPS_COBALT is not set
 CONFIG_MACH_DECSTATION=y
 # CONFIG_MACH_JAZZ is not set
Index: linux-queue/arch/mips/configs/e55_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/e55_defconfig
+++ linux-queue/arch/mips/configs/e55_defconfig
@@ -9,7 +9,6 @@ CONFIG_MIPS=y
 # Machine selection
 #
 # CONFIG_MACH_ALCHEMY is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
 # CONFIG_MACH_JAZZ is not set
Index: linux-queue/arch/mips/configs/excite_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/excite_defconfig
+++ /dev/null
@@ -1,1335 +0,0 @@
-#
-# Automatically generated make config: don't edit
-# Linux kernel version: 2.6.20
-# Tue Feb 20 21:47:31 2007
-#
-CONFIG_MIPS=y
-
-#
-# Machine selection
-#
-CONFIG_ZONE_DMA=y
-# CONFIG_MIPS_MTX1 is not set
-# CONFIG_MIPS_BOSPORUS is not set
-# CONFIG_MIPS_PB1000 is not set
-# CONFIG_MIPS_PB1100 is not set
-# CONFIG_MIPS_PB1500 is not set
-# CONFIG_MIPS_PB1550 is not set
-# CONFIG_MIPS_PB1200 is not set
-# CONFIG_MIPS_DB1000 is not set
-# CONFIG_MIPS_DB1100 is not set
-# CONFIG_MIPS_DB1500 is not set
-# CONFIG_MIPS_DB1550 is not set
-# CONFIG_MIPS_DB1200 is not set
-# CONFIG_MIPS_MIRAGE is not set
-CONFIG_BASLER_EXCITE=y
-# CONFIG_BASLER_EXCITE_PROTOTYPE is not set
-# CONFIG_MIPS_COBALT is not set
-# CONFIG_MACH_DECSTATION is not set
-# CONFIG_MACH_JAZZ is not set
-# CONFIG_MIPS_MALTA is not set
-# CONFIG_WR_PPMC is not set
-# CONFIG_MIPS_SIM is not set
-# CONFIG_MOMENCO_JAGUAR_ATX is not set
-# CONFIG_MIPS_XXS1500 is not set
-# CONFIG_PNX8550_JBS is not set
-# CONFIG_PNX8550_STB810 is not set
-# CONFIG_MACH_VR41XX is not set
-# CONFIG_PMC_YOSEMITE is not set
-# CONFIG_MARKEINS is not set
-# CONFIG_SGI_IP22 is not set
-# CONFIG_SGI_IP27 is not set
-# CONFIG_SGI_IP32 is not set
-# CONFIG_SIBYTE_BIGSUR is not set
-# CONFIG_SIBYTE_SWARM is not set
-# CONFIG_SIBYTE_SENTOSA is not set
-# CONFIG_SIBYTE_RHONE is not set
-# CONFIG_SIBYTE_CARMEL is not set
-# CONFIG_SIBYTE_LITTLESUR is not set
-# CONFIG_SIBYTE_CRHINE is not set
-# CONFIG_SIBYTE_CRHONE is not set
-# CONFIG_SNI_RM is not set
-# CONFIG_TOSHIBA_JMR3927 is not set
-# CONFIG_TOSHIBA_RBTX4927 is not set
-# CONFIG_TOSHIBA_RBTX4938 is not set
-CONFIG_RWSEM_GENERIC_SPINLOCK=y
-# CONFIG_ARCH_HAS_ILOG2_U32 is not set
-# CONFIG_ARCH_HAS_ILOG2_U64 is not set
-CONFIG_GENERIC_FIND_NEXT_BIT=y
-CONFIG_GENERIC_HWEIGHT=y
-CONFIG_GENERIC_CALIBRATE_DELAY=y
-CONFIG_GENERIC_TIME=y
-CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
-# CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ is not set
-CONFIG_DMA_COHERENT=y
-CONFIG_CPU_BIG_ENDIAN=y
-# CONFIG_CPU_LITTLE_ENDIAN is not set
-CONFIG_SYS_SUPPORTS_BIG_ENDIAN=y
-CONFIG_IRQ_CPU=y
-CONFIG_IRQ_CPU_RM7K=y
-CONFIG_IRQ_CPU_RM9K=y
-CONFIG_MIPS_RM9122=y
-CONFIG_SERIAL_RM9000=y
-CONFIG_GPI_RM9000=y
-CONFIG_WDT_RM9000=y
-CONFIG_MIPS_L1_CACHE_SHIFT=5
-
-#
-# CPU selection
-#
-# CONFIG_CPU_MIPS32_R1 is not set
-# CONFIG_CPU_MIPS32_R2 is not set
-# CONFIG_CPU_MIPS64_R1 is not set
-# CONFIG_CPU_MIPS64_R2 is not set
-# CONFIG_CPU_R3000 is not set
-# CONFIG_CPU_TX39XX is not set
-# CONFIG_CPU_VR41XX is not set
-# CONFIG_CPU_R4300 is not set
-# CONFIG_CPU_R4X00 is not set
-# CONFIG_CPU_TX49XX is not set
-# CONFIG_CPU_R5000 is not set
-# CONFIG_CPU_R5432 is not set
-# CONFIG_CPU_R6000 is not set
-# CONFIG_CPU_NEVADA is not set
-# CONFIG_CPU_R8000 is not set
-# CONFIG_CPU_R10000 is not set
-# CONFIG_CPU_RM7000 is not set
-CONFIG_CPU_RM9000=y
-# CONFIG_CPU_SB1 is not set
-CONFIG_SYS_HAS_CPU_RM9000=y
-CONFIG_WEAK_ORDERING=y
-CONFIG_SYS_SUPPORTS_32BIT_KERNEL=y
-CONFIG_SYS_SUPPORTS_64BIT_KERNEL=y
-CONFIG_CPU_SUPPORTS_32BIT_KERNEL=y
-CONFIG_CPU_SUPPORTS_64BIT_KERNEL=y
-
-#
-# Kernel type
-#
-CONFIG_32BIT=y
-# CONFIG_64BIT is not set
-CONFIG_PAGE_SIZE_4KB=y
-# CONFIG_PAGE_SIZE_8KB is not set
-# CONFIG_PAGE_SIZE_16KB is not set
-# CONFIG_PAGE_SIZE_64KB is not set
-CONFIG_CPU_HAS_PREFETCH=y
-CONFIG_MIPS_MT_DISABLED=y
-# CONFIG_MIPS_MT_SMP is not set
-# CONFIG_MIPS_MT_SMTC is not set
-# CONFIG_MIPS_VPE_LOADER is not set
-# CONFIG_64BIT_PHYS_ADDR is not set
-CONFIG_CPU_HAS_SYNC=y
-CONFIG_GENERIC_HARDIRQS=y
-CONFIG_GENERIC_IRQ_PROBE=y
-CONFIG_CPU_SUPPORTS_HIGHMEM=y
-CONFIG_ARCH_FLATMEM_ENABLE=y
-CONFIG_SELECT_MEMORY_MODEL=y
-CONFIG_FLATMEM_MANUAL=y
-# CONFIG_DISCONTIGMEM_MANUAL is not set
-# CONFIG_SPARSEMEM_MANUAL is not set
-CONFIG_FLATMEM=y
-CONFIG_FLAT_NODE_MEM_MAP=y
-# CONFIG_SPARSEMEM_STATIC is not set
-CONFIG_SPLIT_PTLOCK_CPUS=4
-# CONFIG_RESOURCES_64BIT is not set
-CONFIG_ZONE_DMA_FLAG=1
-# CONFIG_HZ_48 is not set
-# CONFIG_HZ_100 is not set
-# CONFIG_HZ_128 is not set
-# CONFIG_HZ_250 is not set
-# CONFIG_HZ_256 is not set
-CONFIG_HZ_1000=y
-# CONFIG_HZ_1024 is not set
-CONFIG_SYS_SUPPORTS_ARBIT_HZ=y
-CONFIG_HZ=1000
-# CONFIG_PREEMPT_NONE is not set
-# CONFIG_PREEMPT_VOLUNTARY is not set
-CONFIG_PREEMPT=y
-CONFIG_PREEMPT_BKL=y
-# CONFIG_KEXEC is not set
-CONFIG_LOCKDEP_SUPPORT=y
-CONFIG_STACKTRACE_SUPPORT=y
-CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
-
-#
-# Code maturity level options
-#
-CONFIG_EXPERIMENTAL=y
-CONFIG_BROKEN_ON_SMP=y
-CONFIG_LOCK_KERNEL=y
-CONFIG_INIT_ENV_ARG_LIMIT=32
-
-#
-# General setup
-#
-CONFIG_LOCALVERSION=""
-# CONFIG_LOCALVERSION_AUTO is not set
-CONFIG_SWAP=y
-CONFIG_SYSVIPC=y
-# CONFIG_IPC_NS is not set
-CONFIG_SYSVIPC_SYSCTL=y
-CONFIG_POSIX_MQUEUE=y
-# CONFIG_BSD_PROCESS_ACCT is not set
-# CONFIG_TASKSTATS is not set
-# CONFIG_UTS_NS is not set
-# CONFIG_AUDIT is not set
-# CONFIG_IKCONFIG is not set
-CONFIG_SYSFS_DEPRECATED=y
-# CONFIG_RELAY is not set
-CONFIG_CC_OPTIMIZE_FOR_SIZE=y
-CONFIG_SYSCTL=y
-CONFIG_EMBEDDED=y
-CONFIG_SYSCTL_SYSCALL=y
-CONFIG_KALLSYMS=y
-# CONFIG_KALLSYMS_EXTRA_PASS is not set
-CONFIG_HOTPLUG=y
-CONFIG_PRINTK=y
-CONFIG_BUG=y
-CONFIG_ELF_CORE=y
-CONFIG_BASE_FULL=y
-CONFIG_FUTEX=y
-CONFIG_EPOLL=y
-CONFIG_SHMEM=y
-CONFIG_SLAB=y
-CONFIG_VM_EVENT_COUNTERS=y
-CONFIG_RT_MUTEXES=y
-# CONFIG_TINY_SHMEM is not set
-CONFIG_BASE_SMALL=0
-# CONFIG_SLOB is not set
-
-#
-# Loadable module support
-#
-CONFIG_MODULES=y
-CONFIG_MODULE_UNLOAD=y
-# CONFIG_MODULE_FORCE_UNLOAD is not set
-# CONFIG_MODVERSIONS is not set
-# CONFIG_MODULE_SRCVERSION_ALL is not set
-CONFIG_KMOD=y
-
-#
-# Block layer
-#
-CONFIG_BLOCK=y
-# CONFIG_LBD is not set
-# CONFIG_BLK_DEV_IO_TRACE is not set
-# CONFIG_LSF is not set
-
-#
-# IO Schedulers
-#
-CONFIG_IOSCHED_NOOP=y
-CONFIG_IOSCHED_AS=y
-CONFIG_IOSCHED_DEADLINE=y
-CONFIG_IOSCHED_CFQ=y
-CONFIG_DEFAULT_AS=y
-# CONFIG_DEFAULT_DEADLINE is not set
-# CONFIG_DEFAULT_CFQ is not set
-# CONFIG_DEFAULT_NOOP is not set
-CONFIG_DEFAULT_IOSCHED="anticipatory"
-
-#
-# Bus options (PCI, PCMCIA, EISA, ISA, TC)
-#
-CONFIG_HW_HAS_PCI=y
-CONFIG_PCI=y
-CONFIG_MMU=y
-
-#
-# PCCARD (PCMCIA/CardBus) support
-#
-# CONFIG_PCCARD is not set
-
-#
-# PCI Hotplug Support
-#
-# CONFIG_HOTPLUG_PCI is not set
-
-#
-# Executable file formats
-#
-CONFIG_BINFMT_ELF=y
-# CONFIG_BINFMT_MISC is not set
-CONFIG_TRAD_SIGNALS=y
-
-#
-# Power management options
-#
-CONFIG_PM=y
-# CONFIG_PM_LEGACY is not set
-# CONFIG_PM_DEBUG is not set
-# CONFIG_PM_SYSFS_DEPRECATED is not set
-
-#
-# Networking
-#
-CONFIG_NET=y
-
-#
-# Networking options
-#
-# CONFIG_NETDEBUG is not set
-CONFIG_PACKET=y
-CONFIG_PACKET_MMAP=y
-CONFIG_UNIX=y
-CONFIG_XFRM=y
-# CONFIG_XFRM_USER is not set
-# CONFIG_XFRM_SUB_POLICY is not set
-CONFIG_XFRM_MIGRATE=y
-# CONFIG_NET_KEY is not set
-CONFIG_INET=y
-# CONFIG_IP_MULTICAST is not set
-# CONFIG_IP_ADVANCED_ROUTER is not set
-CONFIG_IP_FIB_HASH=y
-CONFIG_IP_PNP=y
-CONFIG_IP_PNP_DHCP=y
-# CONFIG_IP_PNP_BOOTP is not set
-# CONFIG_IP_PNP_RARP is not set
-# CONFIG_NET_IPIP is not set
-# CONFIG_NET_IPGRE is not set
-# CONFIG_ARPD is not set
-# CONFIG_SYN_COOKIES is not set
-# CONFIG_INET_AH is not set
-# CONFIG_INET_ESP is not set
-# CONFIG_INET_IPCOMP is not set
-# CONFIG_INET_XFRM_TUNNEL is not set
-# CONFIG_INET_TUNNEL is not set
-CONFIG_INET_XFRM_MODE_TRANSPORT=m
-CONFIG_INET_XFRM_MODE_TUNNEL=m
-CONFIG_INET_XFRM_MODE_BEET=m
-CONFIG_INET_DIAG=y
-CONFIG_INET_TCP_DIAG=y
-# CONFIG_TCP_CONG_ADVANCED is not set
-CONFIG_TCP_CONG_CUBIC=y
-CONFIG_DEFAULT_TCP_CONG="cubic"
-CONFIG_TCP_MD5SIG=y
-# CONFIG_IPV6 is not set
-# CONFIG_INET6_XFRM_TUNNEL is not set
-# CONFIG_INET6_TUNNEL is not set
-CONFIG_NETWORK_SECMARK=y
-# CONFIG_NETFILTER is not set
-
-#
-# DCCP Configuration (EXPERIMENTAL)
-#
-# CONFIG_IP_DCCP is not set
-
-#
-# SCTP Configuration (EXPERIMENTAL)
-#
-# CONFIG_IP_SCTP is not set
-
-#
-# TIPC Configuration (EXPERIMENTAL)
-#
-# CONFIG_TIPC is not set
-# CONFIG_ATM is not set
-# CONFIG_BRIDGE is not set
-# CONFIG_VLAN_8021Q is not set
-# CONFIG_DECNET is not set
-# CONFIG_LLC2 is not set
-# CONFIG_IPX is not set
-# CONFIG_ATALK is not set
-# CONFIG_X25 is not set
-# CONFIG_LAPB is not set
-# CONFIG_ECONET is not set
-# CONFIG_WAN_ROUTER is not set
-
-#
-# QoS and/or fair queueing
-#
-# CONFIG_NET_SCHED is not set
-
-#
-# Network testing
-#
-# CONFIG_NET_PKTGEN is not set
-# CONFIG_HAMRADIO is not set
-# CONFIG_IRDA is not set
-# CONFIG_BT is not set
-# CONFIG_IEEE80211 is not set
-
-#
-# Device Drivers
-#
-
-#
-# Generic Driver Options
-#
-CONFIG_STANDALONE=y
-CONFIG_PREVENT_FIRMWARE_BUILD=y
-CONFIG_FW_LOADER=m
-# CONFIG_SYS_HYPERVISOR is not set
-
-#
-# Connector - unified userspace <-> kernelspace linker
-#
-# CONFIG_CONNECTOR is not set
-
-#
-# Memory Technology Devices (MTD)
-#
-CONFIG_MTD=y
-# CONFIG_MTD_DEBUG is not set
-# CONFIG_MTD_CONCAT is not set
-CONFIG_MTD_PARTITIONS=y
-# CONFIG_MTD_REDBOOT_PARTS is not set
-# CONFIG_MTD_CMDLINE_PARTS is not set
-
-#
-# User Modules And Translation Layers
-#
-CONFIG_MTD_CHAR=y
-CONFIG_MTD_BLKDEVS=y
-CONFIG_MTD_BLOCK=y
-# CONFIG_FTL is not set
-# CONFIG_NFTL is not set
-# CONFIG_INFTL is not set
-# CONFIG_RFD_FTL is not set
-# CONFIG_SSFDC is not set
-
-#
-# RAM/ROM/Flash chip drivers
-#
-# CONFIG_MTD_CFI is not set
-# CONFIG_MTD_JEDECPROBE is not set
-CONFIG_MTD_MAP_BANK_WIDTH_1=y
-CONFIG_MTD_MAP_BANK_WIDTH_2=y
-CONFIG_MTD_MAP_BANK_WIDTH_4=y
-# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
-# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
-# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
-CONFIG_MTD_CFI_I1=y
-CONFIG_MTD_CFI_I2=y
-# CONFIG_MTD_CFI_I4 is not set
-# CONFIG_MTD_CFI_I8 is not set
-# CONFIG_MTD_RAM is not set
-# CONFIG_MTD_ROM is not set
-# CONFIG_MTD_ABSENT is not set
-# CONFIG_MTD_OBSOLETE_CHIPS is not set
-
-#
-# Mapping drivers for chip access
-#
-# CONFIG_MTD_COMPLEX_MAPPINGS is not set
-# CONFIG_MTD_PLATRAM is not set
-
-#
-# Self-contained MTD device drivers
-#
-# CONFIG_MTD_PMC551 is not set
-# CONFIG_MTD_SLRAM is not set
-# CONFIG_MTD_PHRAM is not set
-# CONFIG_MTD_MTDRAM is not set
-# CONFIG_MTD_BLOCK2MTD is not set
-
-#
-# Disk-On-Chip Device Drivers
-#
-# CONFIG_MTD_DOC2000 is not set
-# CONFIG_MTD_DOC2001 is not set
-# CONFIG_MTD_DOC2001PLUS is not set
-
-#
-# NAND Flash Device Drivers
-#
-CONFIG_MTD_NAND=y
-CONFIG_MTD_NAND_VERIFY_WRITE=y
-# CONFIG_MTD_NAND_ECC_SMC is not set
-CONFIG_MTD_NAND_IDS=y
-# CONFIG_MTD_NAND_DISKONCHIP is not set
-# CONFIG_MTD_NAND_BASLER_EXCITE is not set
-# CONFIG_MTD_NAND_CAFE is not set
-# CONFIG_MTD_NAND_NANDSIM is not set
-
-#
-# OneNAND Flash Device Drivers
-#
-# CONFIG_MTD_ONENAND is not set
-
-#
-# Parallel port support
-#
-# CONFIG_PARPORT is not set
-
-#
-# Plug and Play support
-#
-# CONFIG_PNPACPI is not set
-
-#
-# Block devices
-#
-# CONFIG_BLK_CPQ_DA is not set
-# CONFIG_BLK_CPQ_CISS_DA is not set
-# CONFIG_BLK_DEV_DAC960 is not set
-# CONFIG_BLK_DEV_UMEM is not set
-# CONFIG_BLK_DEV_COW_COMMON is not set
-CONFIG_BLK_DEV_LOOP=m
-# CONFIG_BLK_DEV_CRYPTOLOOP is not set
-# CONFIG_BLK_DEV_NBD is not set
-# CONFIG_BLK_DEV_SX8 is not set
-# CONFIG_BLK_DEV_UB is not set
-# CONFIG_BLK_DEV_RAM is not set
-# CONFIG_BLK_DEV_INITRD is not set
-# CONFIG_CDROM_PKTCDVD is not set
-# CONFIG_ATA_OVER_ETH is not set
-
-#
-# Misc devices
-#
-CONFIG_SGI_IOC4=m
-# CONFIG_TIFM_CORE is not set
-
-#
-# ATA/ATAPI/MFM/RLL support
-#
-# CONFIG_IDE is not set
-
-#
-# SCSI device support
-#
-# CONFIG_RAID_ATTRS is not set
-CONFIG_SCSI=y
-CONFIG_SCSI_TGT=m
-# CONFIG_SCSI_NETLINK is not set
-# CONFIG_SCSI_PROC_FS is not set
-
-#
-# SCSI support type (disk, tape, CD-ROM)
-#
-CONFIG_BLK_DEV_SD=y
-# CONFIG_CHR_DEV_ST is not set
-# CONFIG_CHR_DEV_OSST is not set
-# CONFIG_BLK_DEV_SR is not set
-# CONFIG_CHR_DEV_SG is not set
-# CONFIG_CHR_DEV_SCH is not set
-
-#
-# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
-#
-# CONFIG_SCSI_MULTI_LUN is not set
-# CONFIG_SCSI_CONSTANTS is not set
-# CONFIG_SCSI_LOGGING is not set
-CONFIG_SCSI_SCAN_ASYNC=y
-
-#
-# SCSI Transports
-#
-# CONFIG_SCSI_SPI_ATTRS is not set
-# CONFIG_SCSI_FC_ATTRS is not set
-# CONFIG_SCSI_ISCSI_ATTRS is not set
-CONFIG_SCSI_SAS_ATTRS=m
-CONFIG_SCSI_SAS_LIBSAS=m
-# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
-
-#
-# SCSI low-level drivers
-#
-# CONFIG_ISCSI_TCP is not set
-# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
-# CONFIG_SCSI_3W_9XXX is not set
-# CONFIG_SCSI_ACARD is not set
-# CONFIG_SCSI_AACRAID is not set
-# CONFIG_SCSI_AIC7XXX is not set
-# CONFIG_SCSI_AIC7XXX_OLD is not set
-# CONFIG_SCSI_AIC79XX is not set
-CONFIG_SCSI_AIC94XX=m
-# CONFIG_AIC94XX_DEBUG is not set
-# CONFIG_SCSI_DPT_I2O is not set
-# CONFIG_SCSI_ARCMSR is not set
-# CONFIG_MEGARAID_NEWGEN is not set
-# CONFIG_MEGARAID_LEGACY is not set
-# CONFIG_MEGARAID_SAS is not set
-# CONFIG_SCSI_HPTIOP is not set
-# CONFIG_SCSI_DMX3191D is not set
-# CONFIG_SCSI_FUTURE_DOMAIN is not set
-# CONFIG_SCSI_IPS is not set
-# CONFIG_SCSI_INITIO is not set
-# CONFIG_SCSI_INIA100 is not set
-# CONFIG_SCSI_STEX is not set
-# CONFIG_SCSI_SYM53C8XX_2 is not set
-# CONFIG_SCSI_QLOGIC_1280 is not set
-# CONFIG_SCSI_QLA_FC is not set
-# CONFIG_SCSI_QLA_ISCSI is not set
-# CONFIG_SCSI_LPFC is not set
-# CONFIG_SCSI_DC395x is not set
-# CONFIG_SCSI_DC390T is not set
-# CONFIG_SCSI_NSP32 is not set
-# CONFIG_SCSI_DEBUG is not set
-# CONFIG_SCSI_SRP is not set
-
-#
-# Serial ATA (prod) and Parallel ATA (experimental) drivers
-#
-# CONFIG_ATA is not set
-
-#
-# Multi-device support (RAID and LVM)
-#
-# CONFIG_MD is not set
-
-#
-# Fusion MPT device support
-#
-# CONFIG_FUSION is not set
-# CONFIG_FUSION_SPI is not set
-# CONFIG_FUSION_FC is not set
-# CONFIG_FUSION_SAS is not set
-
-#
-# IEEE 1394 (FireWire) support
-#
-# CONFIG_IEEE1394 is not set
-
-#
-# I2O device support
-#
-# CONFIG_I2O is not set
-
-#
-# Network device support
-#
-CONFIG_NETDEVICES=y
-# CONFIG_DUMMY is not set
-# CONFIG_BONDING is not set
-# CONFIG_EQUALIZER is not set
-# CONFIG_TUN is not set
-
-#
-# ARCnet devices
-#
-# CONFIG_ARCNET is not set
-
-#
-# PHY device support
-#
-
-#
-# Ethernet (10 or 100Mbit)
-#
-# CONFIG_NET_ETHERNET is not set
-
-#
-# Ethernet (1000 Mbit)
-#
-# CONFIG_ACENIC is not set
-# CONFIG_DL2K is not set
-# CONFIG_E1000 is not set
-# CONFIG_NS83820 is not set
-# CONFIG_HAMACHI is not set
-# CONFIG_YELLOWFIN is not set
-# CONFIG_R8169 is not set
-# CONFIG_SIS190 is not set
-# CONFIG_SKGE is not set
-# CONFIG_SKY2 is not set
-# CONFIG_SK98LIN is not set
-# CONFIG_TIGON3 is not set
-# CONFIG_BNX2 is not set
-CONFIG_QLA3XXX=m
-# CONFIG_ATL1 is not set
-
-#
-# Ethernet (10000 Mbit)
-#
-# CONFIG_CHELSIO_T1 is not set
-CONFIG_CHELSIO_T3=m
-# CONFIG_IXGB is not set
-# CONFIG_S2IO is not set
-# CONFIG_MYRI10GE is not set
-CONFIG_NETXEN_NIC=m
-
-#
-# Token Ring devices
-#
-# CONFIG_TR is not set
-
-#
-# Wireless LAN (non-hamradio)
-#
-# CONFIG_NET_RADIO is not set
-
-#
-# Wan interfaces
-#
-# CONFIG_WAN is not set
-# CONFIG_FDDI is not set
-# CONFIG_HIPPI is not set
-# CONFIG_PPP is not set
-# CONFIG_SLIP is not set
-# CONFIG_NET_FC is not set
-# CONFIG_SHAPER is not set
-# CONFIG_NETCONSOLE is not set
-# CONFIG_NETPOLL is not set
-# CONFIG_NET_POLL_CONTROLLER is not set
-
-#
-# ISDN subsystem
-#
-# CONFIG_ISDN is not set
-
-#
-# Telephony Support
-#
-# CONFIG_PHONE is not set
-
-#
-# Input device support
-#
-CONFIG_INPUT=y
-# CONFIG_INPUT_FF_MEMLESS is not set
-
-#
-# Userland interfaces
-#
-CONFIG_INPUT_MOUSEDEV=m
-CONFIG_INPUT_MOUSEDEV_PSAUX=y
-CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
-CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
-# CONFIG_INPUT_JOYDEV is not set
-# CONFIG_INPUT_TSDEV is not set
-CONFIG_INPUT_EVDEV=m
-# CONFIG_INPUT_EVBUG is not set
-
-#
-# Input Device Drivers
-#
-# CONFIG_INPUT_KEYBOARD is not set
-# CONFIG_INPUT_MOUSE is not set
-# CONFIG_INPUT_JOYSTICK is not set
-# CONFIG_INPUT_TOUCHSCREEN is not set
-# CONFIG_INPUT_MISC is not set
-
-#
-# Hardware I/O ports
-#
-# CONFIG_SERIO is not set
-# CONFIG_GAMEPORT is not set
-
-#
-# Character devices
-#
-CONFIG_VT=y
-CONFIG_VT_CONSOLE=y
-CONFIG_HW_CONSOLE=y
-CONFIG_VT_HW_CONSOLE_BINDING=y
-# CONFIG_SERIAL_NONSTANDARD is not set
-
-#
-# Serial drivers
-#
-CONFIG_SERIAL_8250=y
-CONFIG_SERIAL_8250_CONSOLE=y
-CONFIG_SERIAL_8250_PCI=y
-CONFIG_SERIAL_8250_NR_UARTS=2
-CONFIG_SERIAL_8250_RUNTIME_UARTS=2
-CONFIG_SERIAL_8250_EXTENDED=y
-# CONFIG_SERIAL_8250_MANY_PORTS is not set
-CONFIG_SERIAL_8250_SHARE_IRQ=y
-# CONFIG_SERIAL_8250_DETECT_IRQ is not set
-# CONFIG_SERIAL_8250_RSA is not set
-
-#
-# Non-8250 serial port support
-#
-CONFIG_SERIAL_CORE=y
-CONFIG_SERIAL_CORE_CONSOLE=y
-# CONFIG_SERIAL_JSM is not set
-CONFIG_UNIX98_PTYS=y
-# CONFIG_LEGACY_PTYS is not set
-
-#
-# IPMI
-#
-# CONFIG_IPMI_HANDLER is not set
-
-#
-# Watchdog Cards
-#
-CONFIG_WATCHDOG=y
-# CONFIG_WATCHDOG_NOWAYOUT is not set
-
-#
-# Watchdog Device Drivers
-#
-# CONFIG_SOFT_WATCHDOG is not set
-CONFIG_WDT_RM9K_GPI=m
-
-#
-# PCI-based Watchdog Cards
-#
-# CONFIG_PCIPCWATCHDOG is not set
-# CONFIG_WDTPCI is not set
-
-#
-# USB-based Watchdog Cards
-#
-# CONFIG_USBPCWATCHDOG is not set
-# CONFIG_HW_RANDOM is not set
-# CONFIG_RTC is not set
-# CONFIG_GEN_RTC is not set
-# CONFIG_DTLK is not set
-# CONFIG_R3964 is not set
-# CONFIG_APPLICOM is not set
-# CONFIG_DRM is not set
-# CONFIG_RAW_DRIVER is not set
-
-#
-# TPM devices
-#
-# CONFIG_TCG_TPM is not set
-
-#
-# I2C support
-#
-# CONFIG_I2C is not set
-
-#
-# SPI support
-#
-# CONFIG_SPI is not set
-# CONFIG_SPI_MASTER is not set
-
-#
-# Dallas's 1-wire bus
-#
-# CONFIG_W1 is not set
-
-#
-# Hardware Monitoring support
-#
-# CONFIG_HWMON is not set
-# CONFIG_HWMON_VID is not set
-
-#
-# Multimedia devices
-#
-# CONFIG_VIDEO_DEV is not set
-
-#
-# Digital Video Broadcasting Devices
-#
-# CONFIG_DVB is not set
-# CONFIG_USB_DABUSB is not set
-
-#
-# Graphics support
-#
-# CONFIG_FIRMWARE_EDID is not set
-CONFIG_FB=y
-# CONFIG_FB_CFB_FILLRECT is not set
-# CONFIG_FB_CFB_COPYAREA is not set
-# CONFIG_FB_CFB_IMAGEBLIT is not set
-# CONFIG_FB_SVGALIB is not set
-# CONFIG_FB_MACMODES is not set
-# CONFIG_FB_BACKLIGHT is not set
-# CONFIG_FB_MODE_HELPERS is not set
-# CONFIG_FB_TILEBLITTING is not set
-# CONFIG_FB_CIRRUS is not set
-# CONFIG_FB_PM2 is not set
-# CONFIG_FB_CYBER2000 is not set
-# CONFIG_FB_ASILIANT is not set
-# CONFIG_FB_IMSTT is not set
-# CONFIG_FB_S1D13XXX is not set
-# CONFIG_FB_NVIDIA is not set
-# CONFIG_FB_RIVA is not set
-# CONFIG_FB_MATROX is not set
-# CONFIG_FB_RADEON is not set
-# CONFIG_FB_ATY128 is not set
-# CONFIG_FB_ATY is not set
-# CONFIG_FB_S3 is not set
-# CONFIG_FB_SAVAGE is not set
-# CONFIG_FB_SIS is not set
-# CONFIG_FB_NEOMAGIC is not set
-# CONFIG_FB_KYRO is not set
-# CONFIG_FB_3DFX is not set
-# CONFIG_FB_VOODOO1 is not set
-# CONFIG_FB_SMIVGX is not set
-# CONFIG_FB_TRIDENT is not set
-# CONFIG_FB_VIRTUAL is not set
-
-#
-# Console display driver support
-#
-# CONFIG_VGA_CONSOLE is not set
-CONFIG_DUMMY_CONSOLE=y
-CONFIG_FRAMEBUFFER_CONSOLE=m
-# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
-# CONFIG_FONTS is not set
-CONFIG_FONT_8x8=y
-CONFIG_FONT_8x16=y
-
-#
-# Logo configuration
-#
-# CONFIG_LOGO is not set
-# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
-
-#
-# Sound
-#
-# CONFIG_SOUND is not set
-
-#
-# HID Devices
-#
-CONFIG_HID=y
-# CONFIG_HID_DEBUG is not set
-
-#
-# USB support
-#
-CONFIG_USB_ARCH_HAS_HCD=y
-CONFIG_USB_ARCH_HAS_OHCI=y
-CONFIG_USB_ARCH_HAS_EHCI=y
-CONFIG_USB=y
-# CONFIG_USB_DEBUG is not set
-
-#
-# Miscellaneous USB options
-#
-CONFIG_USB_DEVICEFS=y
-# CONFIG_USB_DYNAMIC_MINORS is not set
-# CONFIG_USB_SUSPEND is not set
-# CONFIG_USB_OTG is not set
-
-#
-# USB Host Controller Drivers
-#
-CONFIG_USB_EHCI_HCD=y
-# CONFIG_USB_EHCI_SPLIT_ISO is not set
-# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
-# CONFIG_USB_EHCI_TT_NEWSCHED is not set
-# CONFIG_USB_EHCI_BIG_ENDIAN_MMIO is not set
-# CONFIG_USB_ISP116X_HCD is not set
-CONFIG_USB_OHCI_HCD=y
-# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
-# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
-CONFIG_USB_OHCI_LITTLE_ENDIAN=y
-# CONFIG_USB_UHCI_HCD is not set
-# CONFIG_USB_SL811_HCD is not set
-
-#
-# USB Device Class drivers
-#
-# CONFIG_USB_ACM is not set
-# CONFIG_USB_PRINTER is not set
-
-#
-# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
-#
-
-#
-# may also be needed; see USB_STORAGE Help for more information
-#
-CONFIG_USB_STORAGE=y
-# CONFIG_USB_STORAGE_DEBUG is not set
-# CONFIG_USB_STORAGE_DATAFAB is not set
-# CONFIG_USB_STORAGE_FREECOM is not set
-# CONFIG_USB_STORAGE_DPCM is not set
-# CONFIG_USB_STORAGE_USBAT is not set
-# CONFIG_USB_STORAGE_SDDR09 is not set
-# CONFIG_USB_STORAGE_SDDR55 is not set
-# CONFIG_USB_STORAGE_JUMPSHOT is not set
-# CONFIG_USB_STORAGE_ALAUDA is not set
-# CONFIG_USB_STORAGE_KARMA is not set
-# CONFIG_USB_LIBUSUAL is not set
-
-#
-# USB Input Devices
-#
-CONFIG_USB_HID=m
-# CONFIG_USB_HIDINPUT_POWERBOOK is not set
-# CONFIG_HID_FF is not set
-# CONFIG_USB_HIDDEV is not set
-
-#
-# USB HID Boot Protocol drivers
-#
-# CONFIG_USB_KBD is not set
-# CONFIG_USB_MOUSE is not set
-# CONFIG_USB_AIPTEK is not set
-# CONFIG_USB_WACOM is not set
-# CONFIG_USB_ACECAD is not set
-# CONFIG_USB_KBTAB is not set
-# CONFIG_USB_POWERMATE is not set
-# CONFIG_USB_TOUCHSCREEN is not set
-# CONFIG_USB_YEALINK is not set
-# CONFIG_USB_XPAD is not set
-# CONFIG_USB_ATI_REMOTE is not set
-# CONFIG_USB_ATI_REMOTE2 is not set
-# CONFIG_USB_KEYSPAN_REMOTE is not set
-# CONFIG_USB_APPLETOUCH is not set
-# CONFIG_USB_GTCO is not set
-
-#
-# USB Imaging devices
-#
-# CONFIG_USB_MDC800 is not set
-# CONFIG_USB_MICROTEK is not set
-
-#
-# USB Network Adapters
-#
-# CONFIG_USB_CATC is not set
-# CONFIG_USB_KAWETH is not set
-# CONFIG_USB_PEGASUS is not set
-# CONFIG_USB_RTL8150 is not set
-# CONFIG_USB_USBNET_MII is not set
-# CONFIG_USB_USBNET is not set
-# CONFIG_USB_MON is not set
-
-#
-# USB port drivers
-#
-
-#
-# USB Serial Converter support
-#
-# CONFIG_USB_SERIAL is not set
-
-#
-# USB Miscellaneous drivers
-#
-# CONFIG_USB_EMI62 is not set
-# CONFIG_USB_EMI26 is not set
-# CONFIG_USB_ADUTUX is not set
-# CONFIG_USB_AUERSWALD is not set
-# CONFIG_USB_RIO500 is not set
-# CONFIG_USB_LEGOTOWER is not set
-# CONFIG_USB_LCD is not set
-# CONFIG_USB_BERRY_CHARGE is not set
-# CONFIG_USB_LED is not set
-# CONFIG_USB_CYPRESS_CY7C63 is not set
-# CONFIG_USB_CYTHERM is not set
-# CONFIG_USB_PHIDGET is not set
-# CONFIG_USB_IDMOUSE is not set
-# CONFIG_USB_FTDI_ELAN is not set
-# CONFIG_USB_APPLEDISPLAY is not set
-# CONFIG_USB_SISUSBVGA is not set
-# CONFIG_USB_LD is not set
-# CONFIG_USB_TRANCEVIBRATOR is not set
-# CONFIG_USB_TEST is not set
-
-#
-# USB DSL modem support
-#
-
-#
-# USB Gadget Support
-#
-# CONFIG_USB_GADGET is not set
-
-#
-# MMC/SD Card support
-#
-# CONFIG_MMC is not set
-
-#
-# LED devices
-#
-# CONFIG_NEW_LEDS is not set
-
-#
-# LED drivers
-#
-
-#
-# LED Triggers
-#
-
-#
-# InfiniBand support
-#
-# CONFIG_INFINIBAND is not set
-
-#
-# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
-#
-
-#
-# Real Time Clock
-#
-# CONFIG_RTC_CLASS is not set
-
-#
-# DMA Engine support
-#
-# CONFIG_DMA_ENGINE is not set
-
-#
-# DMA Clients
-#
-
-#
-# DMA Devices
-#
-
-#
-# Auxiliary Display support
-#
-
-#
-# Virtualization
-#
-
-#
-# File systems
-#
-CONFIG_EXT2_FS=y
-# CONFIG_EXT2_FS_XATTR is not set
-# CONFIG_EXT2_FS_XIP is not set
-# CONFIG_EXT3_FS is not set
-# CONFIG_EXT4DEV_FS is not set
-# CONFIG_REISERFS_FS is not set
-# CONFIG_JFS_FS is not set
-CONFIG_FS_POSIX_ACL=y
-# CONFIG_XFS_FS is not set
-# CONFIG_GFS2_FS is not set
-# CONFIG_OCFS2_FS is not set
-# CONFIG_MINIX_FS is not set
-# CONFIG_ROMFS_FS is not set
-CONFIG_INOTIFY=y
-CONFIG_INOTIFY_USER=y
-# CONFIG_QUOTA is not set
-# CONFIG_DNOTIFY is not set
-# CONFIG_AUTOFS_FS is not set
-# CONFIG_AUTOFS4_FS is not set
-# CONFIG_FUSE_FS is not set
-CONFIG_GENERIC_ACL=y
-
-#
-# CD-ROM/DVD Filesystems
-#
-# CONFIG_ISO9660_FS is not set
-# CONFIG_UDF_FS is not set
-
-#
-# DOS/FAT/NT Filesystems
-#
-CONFIG_FAT_FS=m
-CONFIG_MSDOS_FS=m
-CONFIG_VFAT_FS=m
-CONFIG_FAT_DEFAULT_CODEPAGE=437
-CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
-# CONFIG_NTFS_FS is not set
-
-#
-# Pseudo filesystems
-#
-CONFIG_PROC_FS=y
-CONFIG_PROC_KCORE=y
-CONFIG_PROC_SYSCTL=y
-CONFIG_SYSFS=y
-CONFIG_TMPFS=y
-CONFIG_TMPFS_POSIX_ACL=y
-# CONFIG_HUGETLB_PAGE is not set
-CONFIG_RAMFS=y
-CONFIG_CONFIGFS_FS=m
-
-#
-# Miscellaneous filesystems
-#
-# CONFIG_ADFS_FS is not set
-# CONFIG_AFFS_FS is not set
-# CONFIG_HFS_FS is not set
-# CONFIG_HFSPLUS_FS is not set
-# CONFIG_BEFS_FS is not set
-# CONFIG_BFS_FS is not set
-# CONFIG_EFS_FS is not set
-CONFIG_JFFS2_FS=y
-CONFIG_JFFS2_FS_DEBUG=0
-CONFIG_JFFS2_FS_WRITEBUFFER=y
-# CONFIG_JFFS2_SUMMARY is not set
-# CONFIG_JFFS2_FS_XATTR is not set
-# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
-CONFIG_JFFS2_ZLIB=y
-CONFIG_JFFS2_RTIME=y
-# CONFIG_JFFS2_RUBIN is not set
-# CONFIG_CRAMFS is not set
-# CONFIG_VXFS_FS is not set
-# CONFIG_HPFS_FS is not set
-# CONFIG_QNX4FS_FS is not set
-# CONFIG_SYSV_FS is not set
-# CONFIG_UFS_FS is not set
-
-#
-# Network File Systems
-#
-CONFIG_NFS_FS=y
-CONFIG_NFS_V3=y
-# CONFIG_NFS_V3_ACL is not set
-# CONFIG_NFS_V4 is not set
-# CONFIG_NFS_DIRECTIO is not set
-# CONFIG_NFSD is not set
-CONFIG_ROOT_NFS=y
-CONFIG_LOCKD=y
-CONFIG_LOCKD_V4=y
-CONFIG_NFS_COMMON=y
-CONFIG_SUNRPC=y
-# CONFIG_RPCSEC_GSS_KRB5 is not set
-# CONFIG_RPCSEC_GSS_SPKM3 is not set
-# CONFIG_SMB_FS is not set
-# CONFIG_CIFS is not set
-# CONFIG_NCP_FS is not set
-# CONFIG_CODA_FS is not set
-# CONFIG_AFS_FS is not set
-# CONFIG_9P_FS is not set
-
-#
-# Partition Types
-#
-CONFIG_PARTITION_ADVANCED=y
-# CONFIG_ACORN_PARTITION is not set
-# CONFIG_OSF_PARTITION is not set
-# CONFIG_AMIGA_PARTITION is not set
-# CONFIG_ATARI_PARTITION is not set
-# CONFIG_MAC_PARTITION is not set
-CONFIG_MSDOS_PARTITION=y
-# CONFIG_BSD_DISKLABEL is not set
-# CONFIG_MINIX_SUBPARTITION is not set
-# CONFIG_SOLARIS_X86_PARTITION is not set
-# CONFIG_UNIXWARE_DISKLABEL is not set
-# CONFIG_LDM_PARTITION is not set
-# CONFIG_SGI_PARTITION is not set
-# CONFIG_ULTRIX_PARTITION is not set
-# CONFIG_SUN_PARTITION is not set
-# CONFIG_KARMA_PARTITION is not set
-# CONFIG_EFI_PARTITION is not set
-
-#
-# Native Language Support
-#
-CONFIG_NLS=y
-CONFIG_NLS_DEFAULT="iso8859-1"
-CONFIG_NLS_CODEPAGE_437=m
-# CONFIG_NLS_CODEPAGE_737 is not set
-# CONFIG_NLS_CODEPAGE_775 is not set
-CONFIG_NLS_CODEPAGE_850=m
-# CONFIG_NLS_CODEPAGE_852 is not set
-# CONFIG_NLS_CODEPAGE_855 is not set
-# CONFIG_NLS_CODEPAGE_857 is not set
-# CONFIG_NLS_CODEPAGE_860 is not set
-# CONFIG_NLS_CODEPAGE_861 is not set
-# CONFIG_NLS_CODEPAGE_862 is not set
-# CONFIG_NLS_CODEPAGE_863 is not set
-# CONFIG_NLS_CODEPAGE_864 is not set
-# CONFIG_NLS_CODEPAGE_865 is not set
-# CONFIG_NLS_CODEPAGE_866 is not set
-# CONFIG_NLS_CODEPAGE_869 is not set
-# CONFIG_NLS_CODEPAGE_936 is not set
-# CONFIG_NLS_CODEPAGE_950 is not set
-# CONFIG_NLS_CODEPAGE_932 is not set
-# CONFIG_NLS_CODEPAGE_949 is not set
-# CONFIG_NLS_CODEPAGE_874 is not set
-# CONFIG_NLS_ISO8859_8 is not set
-# CONFIG_NLS_CODEPAGE_1250 is not set
-# CONFIG_NLS_CODEPAGE_1251 is not set
-# CONFIG_NLS_ASCII is not set
-CONFIG_NLS_ISO8859_1=m
-# CONFIG_NLS_ISO8859_2 is not set
-# CONFIG_NLS_ISO8859_3 is not set
-# CONFIG_NLS_ISO8859_4 is not set
-# CONFIG_NLS_ISO8859_5 is not set
-# CONFIG_NLS_ISO8859_6 is not set
-# CONFIG_NLS_ISO8859_7 is not set
-# CONFIG_NLS_ISO8859_9 is not set
-# CONFIG_NLS_ISO8859_13 is not set
-# CONFIG_NLS_ISO8859_14 is not set
-# CONFIG_NLS_ISO8859_15 is not set
-# CONFIG_NLS_KOI8_R is not set
-# CONFIG_NLS_KOI8_U is not set
-# CONFIG_NLS_UTF8 is not set
-
-#
-# Distributed Lock Manager
-#
-CONFIG_DLM=m
-CONFIG_DLM_TCP=y
-# CONFIG_DLM_SCTP is not set
-# CONFIG_DLM_DEBUG is not set
-
-#
-# Profiling support
-#
-# CONFIG_PROFILING is not set
-
-#
-# Kernel hacking
-#
-CONFIG_TRACE_IRQFLAGS_SUPPORT=y
-# CONFIG_PRINTK_TIME is not set
-CONFIG_ENABLE_MUST_CHECK=y
-# CONFIG_MAGIC_SYSRQ is not set
-# CONFIG_UNUSED_SYMBOLS is not set
-# CONFIG_DEBUG_FS is not set
-# CONFIG_HEADERS_CHECK is not set
-# CONFIG_DEBUG_KERNEL is not set
-CONFIG_LOG_BUF_SHIFT=14
-CONFIG_CROSSCOMPILE=y
-CONFIG_CMDLINE=""
-
-#
-# Security options
-#
-# CONFIG_KEYS is not set
-# CONFIG_SECURITY is not set
-
-#
-# Cryptographic options
-#
-CONFIG_CRYPTO=y
-CONFIG_CRYPTO_ALGAPI=y
-CONFIG_CRYPTO_BLKCIPHER=m
-CONFIG_CRYPTO_HASH=m
-CONFIG_CRYPTO_MANAGER=m
-# CONFIG_CRYPTO_HMAC is not set
-CONFIG_CRYPTO_XCBC=m
-# CONFIG_CRYPTO_NULL is not set
-# CONFIG_CRYPTO_MD4 is not set
-CONFIG_CRYPTO_MD5=y
-# CONFIG_CRYPTO_SHA1 is not set
-# CONFIG_CRYPTO_SHA256 is not set
-# CONFIG_CRYPTO_SHA512 is not set
-# CONFIG_CRYPTO_WP512 is not set
-# CONFIG_CRYPTO_TGR192 is not set
-CONFIG_CRYPTO_GF128MUL=m
-CONFIG_CRYPTO_ECB=m
-CONFIG_CRYPTO_CBC=m
-CONFIG_CRYPTO_PCBC=m
-CONFIG_CRYPTO_LRW=m
-# CONFIG_CRYPTO_DES is not set
-CONFIG_CRYPTO_FCRYPT=m
-# CONFIG_CRYPTO_BLOWFISH is not set
-# CONFIG_CRYPTO_TWOFISH is not set
-# CONFIG_CRYPTO_SERPENT is not set
-# CONFIG_CRYPTO_AES is not set
-# CONFIG_CRYPTO_CAST5 is not set
-# CONFIG_CRYPTO_CAST6 is not set
-# CONFIG_CRYPTO_TEA is not set
-# CONFIG_CRYPTO_ARC4 is not set
-# CONFIG_CRYPTO_KHAZAD is not set
-# CONFIG_CRYPTO_ANUBIS is not set
-# CONFIG_CRYPTO_DEFLATE is not set
-# CONFIG_CRYPTO_MICHAEL_MIC is not set
-# CONFIG_CRYPTO_CRC32C is not set
-CONFIG_CRYPTO_CAMELLIA=m
-# CONFIG_CRYPTO_TEST is not set
-
-#
-# Hardware crypto devices
-#
-
-#
-# Library routines
-#
-CONFIG_BITREVERSE=y
-# CONFIG_CRC_CCITT is not set
-# CONFIG_CRC16 is not set
-CONFIG_CRC32=y
-# CONFIG_LIBCRC32C is not set
-CONFIG_ZLIB_INFLATE=y
-CONFIG_ZLIB_DEFLATE=y
-CONFIG_PLIST=y
-CONFIG_HAS_IOMEM=y
-CONFIG_HAS_IOPORT=y
Index: linux-queue/arch/mips/configs/fuloong2e_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/fuloong2e_defconfig
+++ linux-queue/arch/mips/configs/fuloong2e_defconfig
@@ -10,7 +10,6 @@ CONFIG_MIPS=y
 #
 # CONFIG_MACH_ALCHEMY is not set
 # CONFIG_AR7 is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_BCM47XX is not set
 # CONFIG_BCM63XX is not set
 # CONFIG_MIPS_COBALT is not set
Index: linux-queue/arch/mips/configs/ip22_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/ip22_defconfig
+++ linux-queue/arch/mips/configs/ip22_defconfig
@@ -9,7 +9,6 @@ CONFIG_MIPS=y
 # Machine selection
 #
 # CONFIG_MACH_ALCHEMY is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_BCM47XX is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
Index: linux-queue/arch/mips/configs/ip27_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/ip27_defconfig
+++ linux-queue/arch/mips/configs/ip27_defconfig
@@ -9,7 +9,6 @@ CONFIG_MIPS=y
 # Machine selection
 #
 # CONFIG_MACH_ALCHEMY is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
 # CONFIG_MACH_JAZZ is not set
Index: linux-queue/arch/mips/configs/ip28_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/ip28_defconfig
+++ linux-queue/arch/mips/configs/ip28_defconfig
@@ -9,7 +9,6 @@ CONFIG_MIPS=y
 # Machine selection
 #
 # CONFIG_MACH_ALCHEMY is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_BCM47XX is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
Index: linux-queue/arch/mips/configs/ip32_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/ip32_defconfig
+++ linux-queue/arch/mips/configs/ip32_defconfig
@@ -9,7 +9,6 @@ CONFIG_MIPS=y
 # Machine selection
 #
 # CONFIG_MACH_ALCHEMY is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_BCM47XX is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
Index: linux-queue/arch/mips/configs/jazz_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/jazz_defconfig
+++ linux-queue/arch/mips/configs/jazz_defconfig
@@ -22,7 +22,6 @@ CONFIG_ZONE_DMA=y
 # CONFIG_MIPS_DB1550 is not set
 # CONFIG_MIPS_DB1200 is not set
 # CONFIG_MIPS_MIRAGE is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
 CONFIG_MACH_JAZZ=y
Index: linux-queue/arch/mips/configs/jmr3927_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/jmr3927_defconfig
+++ linux-queue/arch/mips/configs/jmr3927_defconfig
@@ -9,7 +9,6 @@ CONFIG_MIPS=y
 # Machine selection
 #
 # CONFIG_MACH_ALCHEMY is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_BCM47XX is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
Index: linux-queue/arch/mips/configs/lasat_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/lasat_defconfig
+++ linux-queue/arch/mips/configs/lasat_defconfig
@@ -9,7 +9,6 @@ CONFIG_MIPS=y
 # Machine selection
 #
 # CONFIG_MACH_ALCHEMY is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
 # CONFIG_MACH_JAZZ is not set
Index: linux-queue/arch/mips/configs/lemote2f_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/lemote2f_defconfig
+++ linux-queue/arch/mips/configs/lemote2f_defconfig
@@ -10,7 +10,6 @@ CONFIG_MIPS=y
 #
 # CONFIG_MACH_ALCHEMY is not set
 # CONFIG_AR7 is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_BCM47XX is not set
 # CONFIG_BCM63XX is not set
 # CONFIG_MIPS_COBALT is not set
Index: linux-queue/arch/mips/configs/malta_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/malta_defconfig
+++ linux-queue/arch/mips/configs/malta_defconfig
@@ -10,7 +10,6 @@ CONFIG_MIPS=y
 #
 CONFIG_ZONE_DMA=y
 # CONFIG_MACH_ALCHEMY is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_BCM47XX is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
Index: linux-queue/arch/mips/configs/markeins_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/markeins_defconfig
+++ linux-queue/arch/mips/configs/markeins_defconfig
@@ -22,7 +22,6 @@ CONFIG_ZONE_DMA=y
 # CONFIG_MIPS_DB1550 is not set
 # CONFIG_MIPS_DB1200 is not set
 # CONFIG_MIPS_MIRAGE is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
 # CONFIG_MACH_JAZZ is not set
Index: linux-queue/arch/mips/configs/mipssim_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/mipssim_defconfig
+++ linux-queue/arch/mips/configs/mipssim_defconfig
@@ -9,7 +9,6 @@ CONFIG_MIPS=y
 # Machine selection
 #
 # CONFIG_MACH_ALCHEMY is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_BCM47XX is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
Index: linux-queue/arch/mips/configs/mpc30x_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/mpc30x_defconfig
+++ linux-queue/arch/mips/configs/mpc30x_defconfig
@@ -9,7 +9,6 @@ CONFIG_MIPS=y
 # Machine selection
 #
 # CONFIG_MACH_ALCHEMY is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
 # CONFIG_MACH_JAZZ is not set
Index: linux-queue/arch/mips/configs/msp71xx_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/msp71xx_defconfig
+++ linux-queue/arch/mips/configs/msp71xx_defconfig
@@ -22,7 +22,6 @@ CONFIG_ZONE_DMA=y
 # CONFIG_MIPS_DB1550 is not set
 # CONFIG_MIPS_DB1200 is not set
 # CONFIG_MIPS_MIRAGE is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
 # CONFIG_MACH_JAZZ is not set
Index: linux-queue/arch/mips/configs/mtx1_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/mtx1_defconfig
+++ linux-queue/arch/mips/configs/mtx1_defconfig
@@ -9,7 +9,6 @@ CONFIG_MIPS=y
 # Machine selection
 #
 CONFIG_MACH_ALCHEMY=y
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
 # CONFIG_MACH_JAZZ is not set
Index: linux-queue/arch/mips/configs/pb1100_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/pb1100_defconfig
+++ linux-queue/arch/mips/configs/pb1100_defconfig
@@ -23,7 +23,6 @@ CONFIG_MIPS_PB1100=y
 # CONFIG_MIPS_DB1550 is not set
 # CONFIG_MIPS_DB1200 is not set
 # CONFIG_MIPS_MIRAGE is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
 # CONFIG_MACH_JAZZ is not set
Index: linux-queue/arch/mips/configs/pb1500_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/pb1500_defconfig
+++ linux-queue/arch/mips/configs/pb1500_defconfig
@@ -23,7 +23,6 @@ CONFIG_MIPS_PB1500=y
 # CONFIG_MIPS_DB1550 is not set
 # CONFIG_MIPS_DB1200 is not set
 # CONFIG_MIPS_MIRAGE is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
 # CONFIG_MACH_JAZZ is not set
Index: linux-queue/arch/mips/configs/pb1550_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/pb1550_defconfig
+++ linux-queue/arch/mips/configs/pb1550_defconfig
@@ -23,7 +23,6 @@ CONFIG_MIPS_PB1550=y
 # CONFIG_MIPS_DB1550 is not set
 # CONFIG_MIPS_DB1200 is not set
 # CONFIG_MIPS_MIRAGE is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
 # CONFIG_MACH_JAZZ is not set
Index: linux-queue/arch/mips/configs/pnx8335-stb225_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/pnx8335-stb225_defconfig
+++ linux-queue/arch/mips/configs/pnx8335-stb225_defconfig
@@ -9,7 +9,6 @@ CONFIG_MIPS=y
 # Machine selection
 #
 # CONFIG_MACH_ALCHEMY is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_BCM47XX is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
Index: linux-queue/arch/mips/configs/pnx8550-jbs_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/pnx8550-jbs_defconfig
+++ linux-queue/arch/mips/configs/pnx8550-jbs_defconfig
@@ -22,7 +22,6 @@ CONFIG_ZONE_DMA=y
 # CONFIG_MIPS_DB1550 is not set
 # CONFIG_MIPS_DB1200 is not set
 # CONFIG_MIPS_MIRAGE is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
 # CONFIG_MACH_JAZZ is not set
Index: linux-queue/arch/mips/configs/pnx8550-stb810_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/pnx8550-stb810_defconfig
+++ linux-queue/arch/mips/configs/pnx8550-stb810_defconfig
@@ -22,7 +22,6 @@ CONFIG_ZONE_DMA=y
 # CONFIG_MIPS_DB1550 is not set
 # CONFIG_MIPS_DB1200 is not set
 # CONFIG_MIPS_MIRAGE is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
 # CONFIG_MACH_JAZZ is not set
Index: linux-queue/arch/mips/configs/powertv_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/powertv_defconfig
+++ linux-queue/arch/mips/configs/powertv_defconfig
@@ -10,7 +10,6 @@ CONFIG_MIPS=y
 #
 # CONFIG_MACH_ALCHEMY is not set
 # CONFIG_AR7 is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_BCM47XX is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
Index: linux-queue/arch/mips/configs/rb532_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/rb532_defconfig
+++ linux-queue/arch/mips/configs/rb532_defconfig
@@ -9,7 +9,6 @@ CONFIG_MIPS=y
 # Machine selection
 #
 # CONFIG_MACH_ALCHEMY is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_BCM47XX is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
Index: linux-queue/arch/mips/configs/rbtx49xx_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/rbtx49xx_defconfig
+++ linux-queue/arch/mips/configs/rbtx49xx_defconfig
@@ -10,7 +10,6 @@ CONFIG_MIPS=y
 #
 # CONFIG_MACH_ALCHEMY is not set
 # CONFIG_AR7 is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_BCM47XX is not set
 # CONFIG_BCM63XX is not set
 # CONFIG_MIPS_COBALT is not set
Index: linux-queue/arch/mips/configs/rm200_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/rm200_defconfig
+++ linux-queue/arch/mips/configs/rm200_defconfig
@@ -22,7 +22,6 @@ CONFIG_ZONE_DMA=y
 # CONFIG_MIPS_DB1550 is not set
 # CONFIG_MIPS_DB1200 is not set
 # CONFIG_MIPS_MIRAGE is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
 # CONFIG_MACH_JAZZ is not set
Index: linux-queue/arch/mips/configs/sb1250-swarm_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/sb1250-swarm_defconfig
+++ linux-queue/arch/mips/configs/sb1250-swarm_defconfig
@@ -9,7 +9,6 @@ CONFIG_MIPS=y
 # Machine selection
 #
 # CONFIG_MACH_ALCHEMY is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_BCM47XX is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
Index: linux-queue/arch/mips/configs/tb0219_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/tb0219_defconfig
+++ linux-queue/arch/mips/configs/tb0219_defconfig
@@ -9,7 +9,6 @@ CONFIG_MIPS=y
 # Machine selection
 #
 # CONFIG_MACH_ALCHEMY is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_BCM47XX is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
Index: linux-queue/arch/mips/configs/tb0226_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/tb0226_defconfig
+++ linux-queue/arch/mips/configs/tb0226_defconfig
@@ -9,7 +9,6 @@ CONFIG_MIPS=y
 # Machine selection
 #
 # CONFIG_MACH_ALCHEMY is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_BCM47XX is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
Index: linux-queue/arch/mips/configs/tb0287_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/tb0287_defconfig
+++ linux-queue/arch/mips/configs/tb0287_defconfig
@@ -9,7 +9,6 @@ CONFIG_MIPS=y
 # Machine selection
 #
 # CONFIG_MACH_ALCHEMY is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_BCM47XX is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
Index: linux-queue/arch/mips/configs/workpad_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/workpad_defconfig
+++ linux-queue/arch/mips/configs/workpad_defconfig
@@ -9,7 +9,6 @@ CONFIG_MIPS=y
 # Machine selection
 #
 # CONFIG_MACH_ALCHEMY is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
 # CONFIG_MACH_JAZZ is not set
Index: linux-queue/arch/mips/configs/wrppmc_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/wrppmc_defconfig
+++ linux-queue/arch/mips/configs/wrppmc_defconfig
@@ -22,7 +22,6 @@ CONFIG_ZONE_DMA=y
 # CONFIG_MIPS_DB1550 is not set
 # CONFIG_MIPS_DB1200 is not set
 # CONFIG_MIPS_MIRAGE is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
 # CONFIG_MACH_JAZZ is not set
Index: linux-queue/arch/mips/configs/yosemite_defconfig
===================================================================
--- linux-queue.orig/arch/mips/configs/yosemite_defconfig
+++ linux-queue/arch/mips/configs/yosemite_defconfig
@@ -22,7 +22,6 @@ CONFIG_ZONE_DMA=y
 # CONFIG_MIPS_DB1550 is not set
 # CONFIG_MIPS_DB1200 is not set
 # CONFIG_MIPS_MIRAGE is not set
-# CONFIG_BASLER_EXCITE is not set
 # CONFIG_MIPS_COBALT is not set
 # CONFIG_MACH_DECSTATION is not set
 # CONFIG_MACH_JAZZ is not set
Index: linux-queue/arch/mips/Makefile
===================================================================
--- linux-queue.orig/arch/mips/Makefile
+++ linux-queue/arch/mips/Makefile
@@ -369,13 +369,6 @@ cflags-$(CONFIG_PMC_YOSEMITE)	+= -I$(src
 load-$(CONFIG_PMC_YOSEMITE)	+= 0xffffffff80100000
 
 #
-# Basler eXcite
-#
-core-$(CONFIG_BASLER_EXCITE)	+= arch/mips/basler/excite/
-cflags-$(CONFIG_BASLER_EXCITE)	+= -I$(srctree)/arch/mips/include/asm/mach-excite
-load-$(CONFIG_BASLER_EXCITE)	+= 0x80100000
-
-#
 # LASAT platforms
 #
 core-$(CONFIG_LASAT)		+= arch/mips/lasat/
Index: linux-queue/arch/mips/pci/Makefile
===================================================================
--- linux-queue.orig/arch/mips/pci/Makefile
+++ linux-queue/arch/mips/pci/Makefile
@@ -22,7 +22,6 @@ obj-$(CONFIG_BCM63XX)		+= pci-bcm63xx.o 
 #
 # These are still pretty much in the old state, watch, go blind.
 #
-obj-$(CONFIG_BASLER_EXCITE)	+= ops-titan.o pci-excite.o fixup-excite.o
 obj-$(CONFIG_LASAT)		+= pci-lasat.o
 obj-$(CONFIG_MIPS_COBALT)	+= fixup-cobalt.o
 obj-$(CONFIG_SOC_AU1500)	+= fixup-au1000.o ops-au1000.o
Index: linux-queue/arch/mips/pci/fixup-excite.c
===================================================================
--- linux-queue.orig/arch/mips/pci/fixup-excite.c
+++ /dev/null
@@ -1,36 +0,0 @@
-/*
- *  Copyright (C) 2004 by Basler Vision Technologies AG
- *  Author: Thomas Koeller <thomas.koeller@baslerweb.com>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/pci.h>
-#include <excite.h>
-
-int __init pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
-{
-	if (pin == 0)
-		return -1;
-
-	return USB_IRQ;		/* USB controller is the only PCI device */
-}
-
-/* Do platform specific device initialization at pci_enable_device() time */
-int pcibios_plat_dev_init(struct pci_dev *dev)
-{
-	return 0;
-}
Index: linux-queue/drivers/watchdog/Makefile
===================================================================
--- linux-queue.orig/drivers/watchdog/Makefile
+++ linux-queue/drivers/watchdog/Makefile
@@ -109,7 +109,6 @@ obj-$(CONFIG_RC32434_WDT) += rc32434_wdt
 obj-$(CONFIG_INDYDOG) += indydog.o
 obj-$(CONFIG_WDT_MTX1) += mtx-1_wdt.o
 obj-$(CONFIG_PNX833X_WDT) += pnx833x_wdt.o
-obj-$(CONFIG_WDT_RM9K_GPI) += rm9k_wdt.o
 obj-$(CONFIG_SIBYTE_WDOG) += sb_wdog.o
 obj-$(CONFIG_AR7_WDT) += ar7_wdt.o
 obj-$(CONFIG_TXX9_WDT) += txx9wdt.o
Index: linux-queue/drivers/watchdog/rm9k_wdt.c
===================================================================
--- linux-queue.orig/drivers/watchdog/rm9k_wdt.c
+++ /dev/null
@@ -1,419 +0,0 @@
-/*
- *  Watchdog implementation for GPI h/w found on PMC-Sierra RM9xxx
- *  chips.
- *
- *  Copyright (C) 2004 by Basler Vision Technologies AG
- *  Author: Thomas Koeller <thomas.koeller@baslerweb.com>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-#include <linux/platform_device.h>
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/interrupt.h>
-#include <linux/fs.h>
-#include <linux/reboot.h>
-#include <linux/notifier.h>
-#include <linux/miscdevice.h>
-#include <linux/watchdog.h>
-#include <linux/io.h>
-#include <linux/uaccess.h>
-#include <asm/atomic.h>
-#include <asm/processor.h>
-#include <asm/system.h>
-#include <asm/rm9k-ocd.h>
-
-#include <rm9k_wdt.h>
-
-
-#define CLOCK                  125000000
-#define MAX_TIMEOUT_SECONDS    32
-#define CPCCR                  0x0080
-#define CPGIG1SR               0x0044
-#define CPGIG1ER               0x0054
-
-
-/* Function prototypes */
-static irqreturn_t wdt_gpi_irqhdl(int, void *);
-static void wdt_gpi_start(void);
-static void wdt_gpi_stop(void);
-static void wdt_gpi_set_timeout(unsigned int);
-static int wdt_gpi_open(struct inode *, struct file *);
-static int wdt_gpi_release(struct inode *, struct file *);
-static ssize_t wdt_gpi_write(struct file *, const char __user *, size_t,
-								loff_t *);
-static long wdt_gpi_ioctl(struct file *, unsigned int, unsigned long);
-static int wdt_gpi_notify(struct notifier_block *, unsigned long, void *);
-static const struct resource *wdt_gpi_get_resource(struct platform_device *,
-						const char *, unsigned int);
-static int __init wdt_gpi_probe(struct platform_device *);
-static int __exit wdt_gpi_remove(struct platform_device *);
-
-
-static const char wdt_gpi_name[] = "wdt_gpi";
-static atomic_t opencnt;
-static int expect_close;
-static int locked;
-
-
-/* These are set from device resources */
-static void __iomem *wd_regs;
-static unsigned int wd_irq, wd_ctr;
-
-
-/* Module arguments */
-static int timeout = MAX_TIMEOUT_SECONDS;
-module_param(timeout, int, 0444);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds");
-
-static unsigned long resetaddr = 0xbffdc200;
-module_param(resetaddr, ulong, 0444);
-MODULE_PARM_DESC(resetaddr, "Address to write to to force a reset");
-
-static unsigned long flagaddr = 0xbffdc104;
-module_param(flagaddr, ulong, 0444);
-MODULE_PARM_DESC(flagaddr, "Address to write to boot flags to");
-
-static int powercycle;
-module_param(powercycle, bool, 0444);
-MODULE_PARM_DESC(powercycle, "Cycle power if watchdog expires");
-
-static int nowayout = WATCHDOG_NOWAYOUT;
-module_param(nowayout, bool, 0444);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be disabled once started");
-
-
-/* Kernel interfaces */
-static const struct file_operations fops = {
-	.owner		= THIS_MODULE,
-	.open		= wdt_gpi_open,
-	.release	= wdt_gpi_release,
-	.write		= wdt_gpi_write,
-	.unlocked_ioctl	= wdt_gpi_ioctl,
-};
-
-static struct miscdevice miscdev = {
-	.minor		= WATCHDOG_MINOR,
-	.name		= wdt_gpi_name,
-	.fops		= &fops,
-};
-
-static struct notifier_block wdt_gpi_shutdown = {
-	.notifier_call	= wdt_gpi_notify,
-};
-
-
-/* Interrupt handler */
-static irqreturn_t wdt_gpi_irqhdl(int irq, void *ctxt)
-{
-	if (!unlikely(__raw_readl(wd_regs + 0x0008) & 0x1))
-		return IRQ_NONE;
-	__raw_writel(0x1, wd_regs + 0x0008);
-
-
-	printk(KERN_CRIT "%s: watchdog expired - resetting system\n",
-		wdt_gpi_name);
-
-	*(volatile char *) flagaddr |= 0x01;
-	*(volatile char *) resetaddr = powercycle ? 0x01 : 0x2;
-	iob();
-	while (1)
-		cpu_relax();
-}
-
-
-/* Watchdog functions */
-static void wdt_gpi_start(void)
-{
-	u32 reg;
-
-	lock_titan_regs();
-	reg = titan_readl(CPGIG1ER);
-	titan_writel(reg | (0x100 << wd_ctr), CPGIG1ER);
-	iob();
-	unlock_titan_regs();
-}
-
-static void wdt_gpi_stop(void)
-{
-	u32 reg;
-
-	lock_titan_regs();
-	reg = titan_readl(CPCCR) & ~(0xf << (wd_ctr * 4));
-	titan_writel(reg, CPCCR);
-	reg = titan_readl(CPGIG1ER);
-	titan_writel(reg & ~(0x100 << wd_ctr), CPGIG1ER);
-	iob();
-	unlock_titan_regs();
-}
-
-static void wdt_gpi_set_timeout(unsigned int to)
-{
-	u32 reg;
-	const u32 wdval = (to * CLOCK) & ~0x0000000f;
-
-	lock_titan_regs();
-	reg = titan_readl(CPCCR) & ~(0xf << (wd_ctr * 4));
-	titan_writel(reg, CPCCR);
-	wmb();
-	__raw_writel(wdval, wd_regs + 0x0000);
-	wmb();
-	titan_writel(reg | (0x2 << (wd_ctr * 4)), CPCCR);
-	wmb();
-	titan_writel(reg | (0x5 << (wd_ctr * 4)), CPCCR);
-	iob();
-	unlock_titan_regs();
-}
-
-
-/* /dev/watchdog operations */
-static int wdt_gpi_open(struct inode *inode, struct file *file)
-{
-	int res;
-
-	if (unlikely(atomic_dec_if_positive(&opencnt) < 0))
-		return -EBUSY;
-
-	expect_close = 0;
-	if (locked) {
-		module_put(THIS_MODULE);
-		free_irq(wd_irq, &miscdev);
-		locked = 0;
-	}
-
-	res = request_irq(wd_irq, wdt_gpi_irqhdl, IRQF_SHARED | IRQF_DISABLED,
-			  wdt_gpi_name, &miscdev);
-	if (unlikely(res))
-		return res;
-
-	wdt_gpi_set_timeout(timeout);
-	wdt_gpi_start();
-
-	printk(KERN_INFO "%s: watchdog started, timeout = %u seconds\n",
-		wdt_gpi_name, timeout);
-	return nonseekable_open(inode, file);
-}
-
-static int wdt_gpi_release(struct inode *inode, struct file *file)
-{
-	if (nowayout) {
-		printk(KERN_INFO "%s: no way out - watchdog left running\n",
-			wdt_gpi_name);
-		__module_get(THIS_MODULE);
-		locked = 1;
-	} else {
-		if (expect_close) {
-			wdt_gpi_stop();
-			free_irq(wd_irq, &miscdev);
-			printk(KERN_INFO "%s: watchdog stopped\n",
-							wdt_gpi_name);
-		} else {
-			printk(KERN_CRIT "%s: unexpected close() -"
-				" watchdog left running\n",
-				wdt_gpi_name);
-			wdt_gpi_set_timeout(timeout);
-			__module_get(THIS_MODULE);
-			locked = 1;
-		}
-	}
-
-	atomic_inc(&opencnt);
-	return 0;
-}
-
-static ssize_t wdt_gpi_write(struct file *f, const char __user *d, size_t s,
-								loff_t *o)
-{
-	char val;
-
-	wdt_gpi_set_timeout(timeout);
-	expect_close = (s > 0) && !get_user(val, d) && (val == 'V');
-	return s ? 1 : 0;
-}
-
-static long wdt_gpi_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
-{
-	long res = -ENOTTY;
-	const long size = _IOC_SIZE(cmd);
-	int stat;
-	void __user *argp = (void __user *)arg;
-	static struct watchdog_info wdinfo = {
-		.identity               = "RM9xxx/GPI watchdog",
-		.firmware_version       = 0,
-		.options                = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING
-	};
-
-	if (unlikely(_IOC_TYPE(cmd) != WATCHDOG_IOCTL_BASE))
-		return -ENOTTY;
-
-	if ((_IOC_DIR(cmd) & _IOC_READ)
-	    && !access_ok(VERIFY_WRITE, arg, size))
-		return -EFAULT;
-
-	if ((_IOC_DIR(cmd) & _IOC_WRITE)
-	    && !access_ok(VERIFY_READ, arg, size))
-		return -EFAULT;
-
-	expect_close = 0;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		wdinfo.options = nowayout ?
-			WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING :
-			WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
-			WDIOF_MAGICCLOSE;
-		res = __copy_to_user(argp, &wdinfo, size) ?  -EFAULT : size;
-		break;
-
-	case WDIOC_GETSTATUS:
-		break;
-
-	case WDIOC_GETBOOTSTATUS:
-		stat = (*(volatile char *) flagaddr & 0x01)
-			? WDIOF_CARDRESET : 0;
-		res = __copy_to_user(argp, &stat, size) ?
-			-EFAULT : size;
-		break;
-
-	case WDIOC_SETOPTIONS:
-		break;
-
-	case WDIOC_KEEPALIVE:
-		wdt_gpi_set_timeout(timeout);
-		res = size;
-		break;
-
-	case WDIOC_SETTIMEOUT:
-		{
-			int val;
-			if (unlikely(__copy_from_user(&val, argp, size))) {
-				res = -EFAULT;
-				break;
-			}
-
-			if (val > MAX_TIMEOUT_SECONDS)
-				val = MAX_TIMEOUT_SECONDS;
-			timeout = val;
-			wdt_gpi_set_timeout(val);
-			res = size;
-			printk(KERN_INFO "%s: timeout set to %u seconds\n",
-				wdt_gpi_name, timeout);
-		}
-		break;
-
-	case WDIOC_GETTIMEOUT:
-		res = __copy_to_user(argp, &timeout, size) ?
-			-EFAULT : size;
-		break;
-	}
-
-	return res;
-}
-
-
-/* Shutdown notifier */
-static int wdt_gpi_notify(struct notifier_block *this, unsigned long code,
-			  void *unused)
-{
-	if (code == SYS_DOWN || code == SYS_HALT)
-		wdt_gpi_stop();
-
-	return NOTIFY_DONE;
-}
-
-
-/* Init & exit procedures */
-static const struct resource *wdt_gpi_get_resource(struct platform_device *pdv,
-					const char *name, unsigned int type)
-{
-	char buf[80];
-	if (snprintf(buf, sizeof(buf), "%s_0", name) >= sizeof(buf))
-		return NULL;
-	return platform_get_resource_byname(pdv, type, buf);
-}
-
-/* No hotplugging on the platform bus - use __devinit */
-static int __devinit wdt_gpi_probe(struct platform_device *pdv)
-{
-	int res;
-	const struct resource
-		* const rr = wdt_gpi_get_resource(pdv, WDT_RESOURCE_REGS,
-						  IORESOURCE_MEM),
-		* const ri = wdt_gpi_get_resource(pdv, WDT_RESOURCE_IRQ,
-						  IORESOURCE_IRQ),
-		* const rc = wdt_gpi_get_resource(pdv, WDT_RESOURCE_COUNTER,
-						  0);
-
-	if (unlikely(!rr || !ri || !rc))
-		return -ENXIO;
-
-	wd_regs = ioremap_nocache(rr->start, rr->end + 1 - rr->start);
-	if (unlikely(!wd_regs))
-		return -ENOMEM;
-	wd_irq = ri->start;
-	wd_ctr = rc->start;
-	res = misc_register(&miscdev);
-	if (res)
-		iounmap(wd_regs);
-	else
-		register_reboot_notifier(&wdt_gpi_shutdown);
-	return res;
-}
-
-static int __devexit wdt_gpi_remove(struct platform_device *dev)
-{
-	int res;
-
-	unregister_reboot_notifier(&wdt_gpi_shutdown);
-	res = misc_deregister(&miscdev);
-	iounmap(wd_regs);
-	wd_regs = NULL;
-	return res;
-}
-
-
-/* Device driver init & exit */
-static struct platform_driver wgt_gpi_driver = {
-	.driver = {
-		.name		= wdt_gpi_name,
-		.owner		= THIS_MODULE,
-	},
-	.probe		= wdt_gpi_probe,
-	.remove		= __devexit_p(wdt_gpi_remove),
-};
-
-static int __init wdt_gpi_init_module(void)
-{
-	atomic_set(&opencnt, 1);
-	if (timeout > MAX_TIMEOUT_SECONDS)
-		timeout = MAX_TIMEOUT_SECONDS;
-	return platform_driver_register(&wdt_gpi_driver);
-}
-
-static void __exit wdt_gpi_cleanup_module(void)
-{
-	platform_driver_unregister(&wdt_gpi_driver);
-}
-
-module_init(wdt_gpi_init_module);
-module_exit(wdt_gpi_cleanup_module);
-
-MODULE_AUTHOR("Thomas Koeller <thomas.koeller@baslerweb.com>");
-MODULE_DESCRIPTION("Basler eXcite watchdog driver for gpi devices");
-MODULE_VERSION("0.1");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-
Index: linux-queue/drivers/watchdog/Kconfig
===================================================================
--- linux-queue.orig/drivers/watchdog/Kconfig
+++ linux-queue/drivers/watchdog/Kconfig
@@ -815,16 +815,6 @@ config PNX833X_WDT
 	  timer has expired and no process has written to /dev/watchdog during
 	  that time.
 
-config WDT_RM9K_GPI
-	tristate "RM9000/GPI hardware watchdog"
-	depends on CPU_RM9000
-	help
-	  Watchdog implementation using the GPI hardware found on
-	  PMC-Sierra RM9xxx CPUs.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called rm9k_wdt.
-
 config SIBYTE_WDOG
 	tristate "Sibyte SoC hardware watchdog"
 	depends on CPU_SB1
Index: linux-queue/arch/mips/pci/pci-excite.c
===================================================================
--- linux-queue.orig/arch/mips/pci/pci-excite.c
+++ /dev/null
@@ -1,149 +0,0 @@
-/*
- *  Copyright (C) 2004 by Basler Vision Technologies AG
- *  Author: Thomas Koeller <thomas.koeller@baslerweb.com>
- *  Based on the PMC-Sierra Yosemite board support by Ralf Baechle.
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/pci.h>
-#include <linux/bitops.h>
-#include <asm/rm9k-ocd.h>
-#include <excite.h>
-
-
-extern struct pci_ops titan_pci_ops;
-
-
-static struct resource
-	mem_resource = 	{
-		.name	= "PCI memory",
-		.start	= EXCITE_PHYS_PCI_MEM,
-		.end	= EXCITE_PHYS_PCI_MEM + EXCITE_SIZE_PCI_MEM - 1,
-		.flags	= IORESOURCE_MEM
-	},
-	io_resource = {
-		.name	= "PCI I/O",
-		.start	= EXCITE_PHYS_PCI_IO,
-		.end	= EXCITE_PHYS_PCI_IO + EXCITE_SIZE_PCI_IO - 1,
-		.flags	= IORESOURCE_IO
-	};
-
-
-static struct pci_controller bx_controller = {
-	.pci_ops	= &titan_pci_ops,
-	.mem_resource	= &mem_resource,
-	.mem_offset	= 0x00000000UL,
-	.io_resource	= &io_resource,
-	.io_offset	= 0x00000000UL
-};
-
-
-static char
-	iopage_failed[] __initdata   = "Cannot allocate PCI I/O page",
-	modebits_no_pci[] __initdata = "PCI is not configured in mode bits";
-
-#define RM9000x2_OCD_HTSC	0x0604
-#define RM9000x2_OCD_HTBHL	0x060c
-#define RM9000x2_OCD_PCIHRST	0x078c
-
-#define RM9K_OCD_MODEBIT1	0x00d4 /* (MODEBIT1) Mode Bit 1 */
-#define RM9K_OCD_CPHDCR		0x00f4 /* CPU-PCI/HT Data Control. */
-
-#define PCISC_FB2B 		0x00000200
-#define PCISC_MWICG		0x00000010
-#define PCISC_EMC		0x00000004
-#define PCISC_ERMA		0x00000002
-
-
-
-static int __init basler_excite_pci_setup(void)
-{
-	const unsigned int fullbars = memsize / (256 << 20);
-	unsigned int i;
-
-	/* Check modebits to see if PCI is really enabled. */
-	if (!((ocd_readl(RM9K_OCD_MODEBIT1) >> (47-32)) & 0x1))
-		panic(modebits_no_pci);
-
-	if (NULL == request_mem_region(EXCITE_PHYS_PCI_IO, EXCITE_SIZE_PCI_IO,
-				       "Memory-mapped PCI I/O page"))
-		panic(iopage_failed);
-
-	/* Enable PCI 0 as master for config cycles */
-	ocd_writel(PCISC_EMC | PCISC_ERMA, RM9000x2_OCD_HTSC);
-
-
-	/* Set up latency timer */
-	ocd_writel(0x8008, RM9000x2_OCD_HTBHL);
-
-	/*  Setup host IO and Memory space */
-	ocd_writel((EXCITE_PHYS_PCI_IO >> 4) | 1, LKB7);
-	ocd_writel(((EXCITE_SIZE_PCI_IO >> 4) & 0x7fffff00) - 0x100, LKM7);
-	ocd_writel((EXCITE_PHYS_PCI_MEM >> 4) | 1, LKB8);
-	ocd_writel(((EXCITE_SIZE_PCI_MEM >> 4) & 0x7fffff00) - 0x100, LKM8);
-
-	/* Set up PCI BARs to map all installed memory */
-	for (i = 0; i < 6; i++) {
-		const unsigned int bar = 0x610 + i * 4;
-
-	     	if (i < fullbars) {
-			ocd_writel(0x10000000 * i, bar);
-			ocd_writel(0x01000000 * i, bar + 0x140);
-			ocd_writel(0x0ffff029, bar + 0x100);
-			continue;
-		}
-
-	     	if (i == fullbars) {
-			int o;
-			u32 mask;
-
-			const unsigned long rem = memsize - i * 0x10000000;
-			if (!rem) {
-				ocd_writel(0x00000000, bar + 0x100);
-				continue;
-			}
-
-			o = ffs(rem) - 1;
-			if (rem & ~(0x1 << o))
-				o++;
-			mask = ((0x1 << o) & 0x0ffff000) - 0x1000;
-			ocd_writel(0x10000000 * i, bar);
-			ocd_writel(0x01000000 * i, bar + 0x140);
-			ocd_writel(0x00000029 | mask, bar + 0x100);
-			continue;
-		}
-
-		ocd_writel(0x00000000, bar + 0x100);
-	}
-
-	/* Finally, enable the PCI interrupt */
-#if USB_IRQ > 7
-	set_c0_intcontrol(1 << USB_IRQ);
-#else
-	set_c0_status(1 << (USB_IRQ + 8));
-#endif
-
-	ioport_resource.start = EXCITE_PHYS_PCI_IO;
-	ioport_resource.end = EXCITE_PHYS_PCI_IO + EXCITE_SIZE_PCI_IO - 1;
-	set_io_port_base((unsigned long) ioremap_nocache(EXCITE_PHYS_PCI_IO, EXCITE_SIZE_PCI_IO));
-	register_pci_controller(&bx_controller);
-	return 0;
-}
-
-
-arch_initcall(basler_excite_pci_setup);
