Return-Path: <linux-kernel-owner+w=401wt.eu-S1751098AbZGBP0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751098AbZGBP0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZGBP0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:26:25 -0400
Received: from mail-ew0-f215.google.com ([209.85.219.215]:49024 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbZGBP0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:26:21 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jul 2009 11:25:58 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=B3WIiixSvVrYlJZgJIv8Ag0pWeuA0h+LCCRq4uMwtaf91gvgbbG6Q3rmQjz5Q0I+9I
         mI3CZDC/grLM8DE0K/NpGpb/qaB/KMiHHn6xcl+FJtDoQw07Qg1g8ko+g1CspCMc+CDT
         Wy5Dll6aZ7rBQg0KFQLHUaLh4V223ZW3WUB/s=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       ralf@linux-mips.org
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, Yan Hua <yanh@lemote.com>,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Zhang Fuxin <zhangfx@lemote.com>,
       loongson-dev <loongson-dev@googlegroups.com>,
       Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>,
       Arnaud Patard <apatard@mandriva.com>
Subject: [PATCH v4 12/16] [loongson] change naming methods
Date: Thu,  2 Jul 2009 23:26:08 +0800
Message-Id: <a8ce49d46eb489e284cce8b857fe377850f06c6f.1246546684.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cover.1246546684.git.wuzhangjin@gmail.com>
References: <cover.1246546684.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

to make source code of loongson sharable to the machines(such as gdium)
made by the other companies, we rename arch/mips/lemote to
arch/mips/loongson, asm/mach-lemote to asm/mach-loongson, and rename
lm2e to the name of the machine: fuloong-2e. accordingly, FULONG are
renamed to FULOONG2E to make it distinguishable to the future FULOONG2F.
and also, some other relative tuning is needed.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/Kconfig                                  |    8 +-
 arch/mips/Makefile                                 |    8 +-
 .../asm/mach-lemote/cpu-feature-overrides.h        |   59 -----
 arch/mips/include/asm/mach-lemote/dma-coherence.h  |   68 ------
 arch/mips/include/asm/mach-lemote/loongson.h       |   56 -----
 arch/mips/include/asm/mach-lemote/mc146818rtc.h    |   36 ---
 arch/mips/include/asm/mach-lemote/pci.h            |   31 ---
 arch/mips/include/asm/mach-lemote/war.h            |   25 ---
 .../asm/mach-loongson/cpu-feature-overrides.h      |   59 +++++
 .../mips/include/asm/mach-loongson/dma-coherence.h |   68 ++++++
 arch/mips/include/asm/mach-loongson/loongson.h     |   56 +++++
 arch/mips/include/asm/mach-loongson/mc146818rtc.h  |   36 +++
 arch/mips/include/asm/mach-loongson/pci.h          |   31 +++
 arch/mips/include/asm/mach-loongson/war.h          |   25 +++
 arch/mips/include/asm/mips-boards/bonito64.h       |    2 +-
 arch/mips/lemote/lm2e/Makefile                     |   13 --
 arch/mips/lemote/lm2e/bonito-irq.c                 |   51 -----
 arch/mips/lemote/lm2e/cmdline.c                    |   52 -----
 arch/mips/lemote/lm2e/early_printk.c               |   39 ----
 arch/mips/lemote/lm2e/env.c                        |   58 -----
 arch/mips/lemote/lm2e/init.c                       |   30 ---
 arch/mips/lemote/lm2e/irq.c                        |  111 ----------
 arch/mips/lemote/lm2e/machtype.c                   |   15 --
 arch/mips/lemote/lm2e/mem.c                        |   36 ---
 arch/mips/lemote/lm2e/pci.c                        |   83 -------
 arch/mips/lemote/lm2e/reset.c                      |   39 ----
 arch/mips/lemote/lm2e/setup.c                      |   60 ------
 arch/mips/lemote/lm2e/time.c                       |   27 ---
 arch/mips/loongson/fuloong-2e/Makefile             |   13 ++
 arch/mips/loongson/fuloong-2e/bonito-irq.c         |   51 +++++
 arch/mips/loongson/fuloong-2e/cmdline.c            |   52 +++++
 arch/mips/loongson/fuloong-2e/early_printk.c       |   39 ++++
 arch/mips/loongson/fuloong-2e/env.c                |   58 +++++
 arch/mips/loongson/fuloong-2e/init.c               |   30 +++
 arch/mips/loongson/fuloong-2e/irq.c                |  111 ++++++++++
 arch/mips/loongson/fuloong-2e/machtype.c           |   15 ++
 arch/mips/loongson/fuloong-2e/mem.c                |   36 +++
 arch/mips/loongson/fuloong-2e/pci.c                |   83 +++++++
 arch/mips/loongson/fuloong-2e/reset.c              |   39 ++++
 arch/mips/loongson/fuloong-2e/setup.c              |   60 ++++++
 arch/mips/loongson/fuloong-2e/time.c               |   27 +++
 arch/mips/pci/Makefile                             |    2 +-
 arch/mips/pci/fixup-fuloong2e.c                    |  224 ++++++++++++++++++++
 arch/mips/pci/fixup-lm2e.c                         |  224 --------------------
 arch/mips/pci/ops-bonito64.c                       |    4 +-
 45 files changed, 1125 insertions(+), 1125 deletions(-)
 delete mode 100644 arch/mips/include/asm/mach-lemote/cpu-feature-overrides.h
 delete mode 100644 arch/mips/include/asm/mach-lemote/dma-coherence.h
 delete mode 100644 arch/mips/include/asm/mach-lemote/loongson.h
 delete mode 100644 arch/mips/include/asm/mach-lemote/mc146818rtc.h
 delete mode 100644 arch/mips/include/asm/mach-lemote/pci.h
 delete mode 100644 arch/mips/include/asm/mach-lemote/war.h
 create mode 100644 arch/mips/include/asm/mach-loongson/cpu-feature-overrides.h
 create mode 100644 arch/mips/include/asm/mach-loongson/dma-coherence.h
 create mode 100644 arch/mips/include/asm/mach-loongson/loongson.h
 create mode 100644 arch/mips/include/asm/mach-loongson/mc146818rtc.h
 create mode 100644 arch/mips/include/asm/mach-loongson/pci.h
 create mode 100644 arch/mips/include/asm/mach-loongson/war.h
 delete mode 100644 arch/mips/lemote/lm2e/Makefile
 delete mode 100644 arch/mips/lemote/lm2e/bonito-irq.c
 delete mode 100644 arch/mips/lemote/lm2e/cmdline.c
 delete mode 100644 arch/mips/lemote/lm2e/early_printk.c
 delete mode 100644 arch/mips/lemote/lm2e/env.c
 delete mode 100644 arch/mips/lemote/lm2e/init.c
 delete mode 100644 arch/mips/lemote/lm2e/irq.c
 delete mode 100644 arch/mips/lemote/lm2e/machtype.c
 delete mode 100644 arch/mips/lemote/lm2e/mem.c
 delete mode 100644 arch/mips/lemote/lm2e/pci.c
 delete mode 100644 arch/mips/lemote/lm2e/reset.c
 delete mode 100644 arch/mips/lemote/lm2e/setup.c
 delete mode 100644 arch/mips/lemote/lm2e/time.c
 create mode 100644 arch/mips/loongson/fuloong-2e/Makefile
 create mode 100644 arch/mips/loongson/fuloong-2e/bonito-irq.c
 create mode 100644 arch/mips/loongson/fuloong-2e/cmdline.c
 create mode 100644 arch/mips/loongson/fuloong-2e/early_printk.c
 create mode 100644 arch/mips/loongson/fuloong-2e/env.c
 create mode 100644 arch/mips/loongson/fuloong-2e/init.c
 create mode 100644 arch/mips/loongson/fuloong-2e/irq.c
 create mode 100644 arch/mips/loongson/fuloong-2e/machtype.c
 create mode 100644 arch/mips/loongson/fuloong-2e/mem.c
 create mode 100644 arch/mips/loongson/fuloong-2e/pci.c
 create mode 100644 arch/mips/loongson/fuloong-2e/reset.c
 create mode 100644 arch/mips/loongson/fuloong-2e/setup.c
 create mode 100644 arch/mips/loongson/fuloong-2e/time.c
 create mode 100644 arch/mips/pci/fixup-fuloong2e.c
 delete mode 100644 arch/mips/pci/fixup-lm2e.c

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index a383dac..3414e23 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -6,7 +6,7 @@ config MIPS
 	select HAVE_ARCH_KGDB
 	# Horrible source of confusion.  Die, die, die ...
 	select EMBEDDED
-	select RTC_LIB if !LEMOTE_FULONG
+	select RTC_LIB if !LEMOTE_FULOONG2E
 
 mainmenu "Linux/MIPS Kernel Configuration"
 
@@ -174,8 +174,8 @@ config LASAT
 	select SYS_SUPPORTS_64BIT_KERNEL if BROKEN
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 
-config LEMOTE_FULONG
-	bool "Lemote Fulong mini-PC"
+config LEMOTE_FULOONG2E
+	bool "Lemote Fuloong2e mini-PC"
 	select ARCH_SPARSEMEM_ENABLE
 	select CEVT_R4K
 	select CSRC_R4K
@@ -196,7 +196,7 @@ config LEMOTE_FULONG
 	select GENERIC_ISA_DMA_SUPPORT_BROKEN
 	select CPU_HAS_WB
 	help
-	  Lemote Fulong mini-PC board based on the Chinese Loongson-2E CPU and
+	  Lemote Fuloong2e mini-PC board based on the Chinese Loongson-2E CPU and
 	  an FPGA northbridge
 
 config MIPS_MALTA
diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 861da51..7754cbb 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -314,11 +314,11 @@ cflags-$(CONFIG_WR_PPMC)		+= -I$(srctree)/arch/mips/include/asm/mach-wrppmc
 load-$(CONFIG_WR_PPMC)		+= 0xffffffff80100000
 
 #
-# lemote fulong mini-PC board
+# lemote fuloong2e mini-PC board
 #
-core-$(CONFIG_LEMOTE_FULONG) +=arch/mips/lemote/lm2e/
-load-$(CONFIG_LEMOTE_FULONG) +=0xffffffff80100000
-cflags-$(CONFIG_LEMOTE_FULONG) += -I$(srctree)/arch/mips/include/asm/mach-lemote
+core-$(CONFIG_LEMOTE_FULOONG2E) +=arch/mips/loongson/fuloong-2e/
+load-$(CONFIG_LEMOTE_FULOONG2E) +=0xffffffff80100000
+cflags-$(CONFIG_LEMOTE_FULOONG2E) += -I$(srctree)/arch/mips/include/asm/mach-loongson/
 
 #
 # MIPS Malta board
diff --git a/arch/mips/include/asm/mach-lemote/cpu-feature-overrides.h b/arch/mips/include/asm/mach-lemote/cpu-feature-overrides.h
deleted file mode 100644
index 550a10d..0000000
--- a/arch/mips/include/asm/mach-lemote/cpu-feature-overrides.h
+++ /dev/null
@@ -1,59 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2009 Wu Zhangjin <wuzj@lemote.com>
- * Copyright (C) 2009 Philippe Vachon <philippe@cowpig.ca>
- * Copyright (C) 2009 Zhang Le <r0bertz@gentoo.org>
- *
- * reference: /proc/cpuinfo,
- * 	arch/mips/kernel/cpu-probe.c(cpu_probe_legacy),
- * 	arch/mips/kernel/proc.c(show_cpuinfo),
- *      loongson2f user manual.
- */
-
-#ifndef __ASM_MACH_LEMOTE_CPU_FEATURE_OVERRIDES_H
-#define __ASM_MACH_LEMOTE_CPU_FEATURE_OVERRIDES_H
-
-#define cpu_dcache_line_size()	32
-#define cpu_icache_line_size()	32
-#define cpu_scache_line_size()	32
-
-
-#define cpu_has_32fpr		1
-#define cpu_has_3k_cache	0
-#define cpu_has_4k_cache	1
-#define cpu_has_4kex		1
-#define cpu_has_64bits		1
-#define cpu_has_cache_cdex_p	0
-#define cpu_has_cache_cdex_s	0
-#define cpu_has_counter		1
-#define cpu_has_dc_aliases	1
-#define cpu_has_divec		0
-#define cpu_has_dsp		0
-#define cpu_has_ejtag		0
-#define cpu_has_fpu		1
-#define cpu_has_ic_fills_f_dc	0
-#define cpu_has_inclusive_pcaches	1
-#define cpu_has_llsc 		1
-#define cpu_has_mcheck		0
-#define cpu_has_mdmx		0
-#define cpu_has_mips16		0
-#define cpu_has_mips32r1	0
-#define cpu_has_mips32r2	0
-#define cpu_has_mips3d		0
-#define cpu_has_mips64r1	0
-#define cpu_has_mips64r2	0
-#define cpu_has_mipsmt		0
-#define cpu_has_prefetch	0
-#define cpu_has_smartmips	0
-#define cpu_has_tlb		1
-#define cpu_has_tx39_cache	0
-#define cpu_has_userlocal	0
-#define cpu_has_vce		0
-#define cpu_has_vtag_icache	0
-#define cpu_has_watch		1
-#define cpu_icache_snoops_remote_store	1
-
-#endif /* __ASM_MACH_LEMOTE_CPU_FEATURE_OVERRIDES_H */
diff --git a/arch/mips/include/asm/mach-lemote/dma-coherence.h b/arch/mips/include/asm/mach-lemote/dma-coherence.h
deleted file mode 100644
index c8de5e7..0000000
--- a/arch/mips/include/asm/mach-lemote/dma-coherence.h
+++ /dev/null
@@ -1,68 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2006, 07  Ralf Baechle <ralf@linux-mips.org>
- * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
- * Author: Fuxin Zhang, zhangfx@lemote.com
- *
- */
-#ifndef __ASM_MACH_LEMOTE_DMA_COHERENCE_H
-#define __ASM_MACH_LEMOTE_DMA_COHERENCE_H
-
-struct device;
-
-static inline dma_addr_t plat_map_dma_mem(struct device *dev, void *addr,
-					  size_t size)
-{
-	return virt_to_phys(addr) | 0x80000000;
-}
-
-static inline dma_addr_t plat_map_dma_mem_page(struct device *dev,
-					       struct page *page)
-{
-	return page_to_phys(page) | 0x80000000;
-}
-
-static inline unsigned long plat_dma_addr_to_phys(struct device *dev,
-	dma_addr_t dma_addr)
-{
-	return dma_addr & 0x7fffffff;
-}
-
-static inline void plat_unmap_dma_mem(struct device *dev, dma_addr_t dma_addr,
-	size_t size, enum dma_data_direction direction)
-{
-}
-
-static inline int plat_dma_supported(struct device *dev, u64 mask)
-{
-	/*
-	 * we fall back to GFP_DMA when the mask isn't all 1s,
-	 * so we can't guarantee allocations that must be
-	 * within a tighter range than GFP_DMA..
-	 */
-	if (mask < DMA_BIT_MASK(24))
-		return 0;
-
-	return 1;
-}
-
-static inline void plat_extra_sync_for_device(struct device *dev)
-{
-	return;
-}
-
-static inline int plat_dma_mapping_error(struct device *dev,
-					 dma_addr_t dma_addr)
-{
-	return 0;
-}
-
-static inline int plat_device_is_coherent(struct device *dev)
-{
-	return 0;
-}
-
-#endif /* __ASM_MACH_LEMOTE_DMA_COHERENCE_H */
diff --git a/arch/mips/include/asm/mach-lemote/loongson.h b/arch/mips/include/asm/mach-lemote/loongson.h
deleted file mode 100644
index 95ee4c8..0000000
--- a/arch/mips/include/asm/mach-lemote/loongson.h
+++ /dev/null
@@ -1,56 +0,0 @@
-/*
- * Copyright (C) 2009 Lemote, Inc. & Institute of Computing Technology
- * Author: Wu Zhangjin <wuzj@lemote.com>
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- *
- */
-
-#ifndef __ASM_MACH_LOONGSON_LOONGSON_H
-#define __ASM_MACH_LOONGSON_LOONGSON_H
-
-#include <linux/io.h>
-#include <linux/init.h>
-
-/* there is an internal bonito64-compatiable northbridge in loongson2e/2f */
-#include <asm/mips-boards/bonito64.h>
-
-/* loongson internal northbridge initialization */
-extern void bonito_irq_init(void);
-
-/* loongson-based machines specific reboot setup */
-extern void mips_reboot_setup(void);
-
-/* environment arguments from bootloader */
-extern unsigned long bus_clock, cpu_clock_freq;
-extern unsigned long memsize, highmemsize;
-
-/* loongson-specific command line, env and memory initialization */
-extern void __init prom_init_memory(void);
-extern void __init prom_init_cmdline(void);
-extern void __init prom_init_env(void);
-
-/* PCI Configuration Registers */
-#define LOONGSON_PCI_ISR4C  BONITO_PCI_REG(0x4c)
-
-/* PCI_Hit*_Sel_* */
-
-#define LOONGSON_PCI_HIT0_SEL_L     BONITO(BONITO_REGBASE + 0x50)
-#define LOONGSON_PCI_HIT0_SEL_H     BONITO(BONITO_REGBASE + 0x54)
-#define LOONGSON_PCI_HIT1_SEL_L     BONITO(BONITO_REGBASE + 0x58)
-#define LOONGSON_PCI_HIT1_SEL_H     BONITO(BONITO_REGBASE + 0x5c)
-#define LOONGSON_PCI_HIT2_SEL_L     BONITO(BONITO_REGBASE + 0x60)
-#define LOONGSON_PCI_HIT2_SEL_H     BONITO(BONITO_REGBASE + 0x64)
-
-/* PXArb Config & Status */
-
-#define LOONGSON_PXARB_CFG      BONITO(BONITO_REGBASE + 0x68)
-#define LOONGSON_PXARB_STATUS       BONITO(BONITO_REGBASE + 0x6c)
-
-/* loongson2-specific perf counter IRQ */
-#define LOONGSON2_PERFCNT_IRQ   (MIPS_CPU_IRQ_BASE + 6)
-
-#endif /* __ASM_MACH_LOONGSON_LOONGSON_H */
diff --git a/arch/mips/include/asm/mach-lemote/mc146818rtc.h b/arch/mips/include/asm/mach-lemote/mc146818rtc.h
deleted file mode 100644
index ed5147e..0000000
--- a/arch/mips/include/asm/mach-lemote/mc146818rtc.h
+++ /dev/null
@@ -1,36 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 1998, 2001, 03, 07 by Ralf Baechle (ralf@linux-mips.org)
- *
- * RTC routines for PC style attached Dallas chip.
- */
-#ifndef __ASM_MACH_LEMOTE_MC146818RTC_H
-#define __ASM_MACH_LEMOTE_MC146818RTC_H
-
-#include <linux/io.h>
-
-#define RTC_PORT(x)	(0x70 + (x))
-#define RTC_IRQ		8
-
-static inline unsigned char CMOS_READ(unsigned long addr)
-{
-	outb_p(addr, RTC_PORT(0));
-	return inb_p(RTC_PORT(1));
-}
-
-static inline void CMOS_WRITE(unsigned char data, unsigned long addr)
-{
-	outb_p(addr, RTC_PORT(0));
-	outb_p(data, RTC_PORT(1));
-}
-
-#define RTC_ALWAYS_BCD	0
-
-#ifndef mc146818_decode_year
-#define mc146818_decode_year(year) ((year) < 70 ? (year) + 2000 : (year) + 1970)
-#endif
-
-#endif /* __ASM_MACH_LEMOTE_MC146818RTC_H */
diff --git a/arch/mips/include/asm/mach-lemote/pci.h b/arch/mips/include/asm/mach-lemote/pci.h
deleted file mode 100644
index 3e6b130..0000000
--- a/arch/mips/include/asm/mach-lemote/pci.h
+++ /dev/null
@@ -1,31 +0,0 @@
-/*
- * Copyright (c) 2008 Zhang Le <r0bertz@gentoo.org>
- *
- * This program is free software; you can redistribute it
- * and/or modify it under the terms of the GNU General
- * Public License as published by the Free Software
- * Foundation; either version 2 of the License, or (at your
- * option) any later version.
- *
- * This program is distributed in the hope that it will be
- * useful, but WITHOUT ANY WARRANTY; without even the implied
- * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
- * PURPOSE.  See the GNU General Public License for more
- * details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the Free
- * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA
- * 02139, USA.
- */
-
-#ifndef __ASM_MACH_LEMOTE_PCI_H_
-#define __ASM_MACH_LEMOTE_PCI_H_
-
-extern struct pci_ops bonito64_pci_ops;
-
-#define LOONGSON2E_PCI_MEM_START	BONITO_PCILO1_BASE
-#define LOONGSON2E_PCI_MEM_END		(BONITO_PCILO1_BASE + 0x04000000 * 2)
-#define LOONGSON2E_PCI_IO_START		0x00004000UL
-
-#endif /* !__ASM_MACH_LEMOTE_PCI_H_ */
diff --git a/arch/mips/include/asm/mach-lemote/war.h b/arch/mips/include/asm/mach-lemote/war.h
deleted file mode 100644
index 05f89e0..0000000
--- a/arch/mips/include/asm/mach-lemote/war.h
+++ /dev/null
@@ -1,25 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2002, 2004, 2007 by Ralf Baechle <ralf@linux-mips.org>
- */
-#ifndef __ASM_MIPS_MACH_LEMOTE_WAR_H
-#define __ASM_MIPS_MACH_LEMOTE_WAR_H
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
-#define RM9000_CDEX_SMP_WAR		0
-#define ICACHE_REFILLS_WORKAROUND_WAR	0
-#define R10000_LLSC_WAR			0
-#define MIPS34K_MISSED_ITLB_WAR		0
-
-#endif /* __ASM_MIPS_MACH_LEMOTE_WAR_H */
diff --git a/arch/mips/include/asm/mach-loongson/cpu-feature-overrides.h b/arch/mips/include/asm/mach-loongson/cpu-feature-overrides.h
new file mode 100644
index 0000000..ce5b6e2
--- /dev/null
+++ b/arch/mips/include/asm/mach-loongson/cpu-feature-overrides.h
@@ -0,0 +1,59 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2009 Wu Zhangjin <wuzj@lemote.com>
+ * Copyright (C) 2009 Philippe Vachon <philippe@cowpig.ca>
+ * Copyright (C) 2009 Zhang Le <r0bertz@gentoo.org>
+ *
+ * reference: /proc/cpuinfo,
+ * 	arch/mips/kernel/cpu-probe.c(cpu_probe_legacy),
+ * 	arch/mips/kernel/proc.c(show_cpuinfo),
+ *      loongson2f user manual.
+ */
+
+#ifndef __ASM_MACH_LOONGSON_CPU_FEATURE_OVERRIDES_H
+#define __ASM_MACH_LOONGSON_CPU_FEATURE_OVERRIDES_H
+
+#define cpu_dcache_line_size()	32
+#define cpu_icache_line_size()	32
+#define cpu_scache_line_size()	32
+
+
+#define cpu_has_32fpr		1
+#define cpu_has_3k_cache	0
+#define cpu_has_4k_cache	1
+#define cpu_has_4kex		1
+#define cpu_has_64bits		1
+#define cpu_has_cache_cdex_p	0
+#define cpu_has_cache_cdex_s	0
+#define cpu_has_counter		1
+#define cpu_has_dc_aliases	1
+#define cpu_has_divec		0
+#define cpu_has_dsp		0
+#define cpu_has_ejtag		0
+#define cpu_has_fpu		1
+#define cpu_has_ic_fills_f_dc	0
+#define cpu_has_inclusive_pcaches	1
+#define cpu_has_llsc 		1
+#define cpu_has_mcheck		0
+#define cpu_has_mdmx		0
+#define cpu_has_mips16		0
+#define cpu_has_mips32r1	0
+#define cpu_has_mips32r2	0
+#define cpu_has_mips3d		0
+#define cpu_has_mips64r1	0
+#define cpu_has_mips64r2	0
+#define cpu_has_mipsmt		0
+#define cpu_has_prefetch	0
+#define cpu_has_smartmips	0
+#define cpu_has_tlb		1
+#define cpu_has_tx39_cache	0
+#define cpu_has_userlocal	0
+#define cpu_has_vce		0
+#define cpu_has_vtag_icache	0
+#define cpu_has_watch		1
+#define cpu_icache_snoops_remote_store	1
+
+#endif /* __ASM_MACH_LOONGSON_CPU_FEATURE_OVERRIDES_H */
diff --git a/arch/mips/include/asm/mach-loongson/dma-coherence.h b/arch/mips/include/asm/mach-loongson/dma-coherence.h
new file mode 100644
index 0000000..71a6851
--- /dev/null
+++ b/arch/mips/include/asm/mach-loongson/dma-coherence.h
@@ -0,0 +1,68 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006, 07  Ralf Baechle <ralf@linux-mips.org>
+ * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
+ * Author: Fuxin Zhang, zhangfx@lemote.com
+ *
+ */
+#ifndef __ASM_MACH_LOONGSON_DMA_COHERENCE_H
+#define __ASM_MACH_LOONGSON_DMA_COHERENCE_H
+
+struct device;
+
+static inline dma_addr_t plat_map_dma_mem(struct device *dev, void *addr,
+					  size_t size)
+{
+	return virt_to_phys(addr) | 0x80000000;
+}
+
+static inline dma_addr_t plat_map_dma_mem_page(struct device *dev,
+					       struct page *page)
+{
+	return page_to_phys(page) | 0x80000000;
+}
+
+static inline unsigned long plat_dma_addr_to_phys(struct device *dev,
+	dma_addr_t dma_addr)
+{
+	return dma_addr & 0x7fffffff;
+}
+
+static inline void plat_unmap_dma_mem(struct device *dev, dma_addr_t dma_addr,
+	size_t size, enum dma_data_direction direction)
+{
+}
+
+static inline int plat_dma_supported(struct device *dev, u64 mask)
+{
+	/*
+	 * we fall back to GFP_DMA when the mask isn't all 1s,
+	 * so we can't guarantee allocations that must be
+	 * within a tighter range than GFP_DMA..
+	 */
+	if (mask < DMA_BIT_MASK(24))
+		return 0;
+
+	return 1;
+}
+
+static inline void plat_extra_sync_for_device(struct device *dev)
+{
+	return;
+}
+
+static inline int plat_dma_mapping_error(struct device *dev,
+					 dma_addr_t dma_addr)
+{
+	return 0;
+}
+
+static inline int plat_device_is_coherent(struct device *dev)
+{
+	return 0;
+}
+
+#endif /* __ASM_MACH_LOONGSON_DMA_COHERENCE_H */
diff --git a/arch/mips/include/asm/mach-loongson/loongson.h b/arch/mips/include/asm/mach-loongson/loongson.h
new file mode 100644
index 0000000..95ee4c8
--- /dev/null
+++ b/arch/mips/include/asm/mach-loongson/loongson.h
@@ -0,0 +1,56 @@
+/*
+ * Copyright (C) 2009 Lemote, Inc. & Institute of Computing Technology
+ * Author: Wu Zhangjin <wuzj@lemote.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ */
+
+#ifndef __ASM_MACH_LOONGSON_LOONGSON_H
+#define __ASM_MACH_LOONGSON_LOONGSON_H
+
+#include <linux/io.h>
+#include <linux/init.h>
+
+/* there is an internal bonito64-compatiable northbridge in loongson2e/2f */
+#include <asm/mips-boards/bonito64.h>
+
+/* loongson internal northbridge initialization */
+extern void bonito_irq_init(void);
+
+/* loongson-based machines specific reboot setup */
+extern void mips_reboot_setup(void);
+
+/* environment arguments from bootloader */
+extern unsigned long bus_clock, cpu_clock_freq;
+extern unsigned long memsize, highmemsize;
+
+/* loongson-specific command line, env and memory initialization */
+extern void __init prom_init_memory(void);
+extern void __init prom_init_cmdline(void);
+extern void __init prom_init_env(void);
+
+/* PCI Configuration Registers */
+#define LOONGSON_PCI_ISR4C  BONITO_PCI_REG(0x4c)
+
+/* PCI_Hit*_Sel_* */
+
+#define LOONGSON_PCI_HIT0_SEL_L     BONITO(BONITO_REGBASE + 0x50)
+#define LOONGSON_PCI_HIT0_SEL_H     BONITO(BONITO_REGBASE + 0x54)
+#define LOONGSON_PCI_HIT1_SEL_L     BONITO(BONITO_REGBASE + 0x58)
+#define LOONGSON_PCI_HIT1_SEL_H     BONITO(BONITO_REGBASE + 0x5c)
+#define LOONGSON_PCI_HIT2_SEL_L     BONITO(BONITO_REGBASE + 0x60)
+#define LOONGSON_PCI_HIT2_SEL_H     BONITO(BONITO_REGBASE + 0x64)
+
+/* PXArb Config & Status */
+
+#define LOONGSON_PXARB_CFG      BONITO(BONITO_REGBASE + 0x68)
+#define LOONGSON_PXARB_STATUS       BONITO(BONITO_REGBASE + 0x6c)
+
+/* loongson2-specific perf counter IRQ */
+#define LOONGSON2_PERFCNT_IRQ   (MIPS_CPU_IRQ_BASE + 6)
+
+#endif /* __ASM_MACH_LOONGSON_LOONGSON_H */
diff --git a/arch/mips/include/asm/mach-loongson/mc146818rtc.h b/arch/mips/include/asm/mach-loongson/mc146818rtc.h
new file mode 100644
index 0000000..ed7fe97
--- /dev/null
+++ b/arch/mips/include/asm/mach-loongson/mc146818rtc.h
@@ -0,0 +1,36 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 1998, 2001, 03, 07 by Ralf Baechle (ralf@linux-mips.org)
+ *
+ * RTC routines for PC style attached Dallas chip.
+ */
+#ifndef __ASM_MACH_LOONGSON_MC146818RTC_H
+#define __ASM_MACH_LOONGSON_MC146818RTC_H
+
+#include <linux/io.h>
+
+#define RTC_PORT(x)	(0x70 + (x))
+#define RTC_IRQ		8
+
+static inline unsigned char CMOS_READ(unsigned long addr)
+{
+	outb_p(addr, RTC_PORT(0));
+	return inb_p(RTC_PORT(1));
+}
+
+static inline void CMOS_WRITE(unsigned char data, unsigned long addr)
+{
+	outb_p(addr, RTC_PORT(0));
+	outb_p(data, RTC_PORT(1));
+}
+
+#define RTC_ALWAYS_BCD	0
+
+#ifndef mc146818_decode_year
+#define mc146818_decode_year(year) ((year) < 70 ? (year) + 2000 : (year) + 1970)
+#endif
+
+#endif /* __ASM_MACH_LOONGSON_MC146818RTC_H */
diff --git a/arch/mips/include/asm/mach-loongson/pci.h b/arch/mips/include/asm/mach-loongson/pci.h
new file mode 100644
index 0000000..e229b29
--- /dev/null
+++ b/arch/mips/include/asm/mach-loongson/pci.h
@@ -0,0 +1,31 @@
+/*
+ * Copyright (c) 2008 Zhang Le <r0bertz@gentoo.org>
+ *
+ * This program is free software; you can redistribute it
+ * and/or modify it under the terms of the GNU General
+ * Public License as published by the Free Software
+ * Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be
+ * useful, but WITHOUT ANY WARRANTY; without even the implied
+ * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
+ * PURPOSE.  See the GNU General Public License for more
+ * details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the Free
+ * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA
+ * 02139, USA.
+ */
+
+#ifndef __ASM_MACH_LOONGSON_PCI_H_
+#define __ASM_MACH_LOONGSON_PCI_H_
+
+extern struct pci_ops bonito64_pci_ops;
+
+#define LOONGSON2E_PCI_MEM_START	BONITO_PCILO1_BASE
+#define LOONGSON2E_PCI_MEM_END		(BONITO_PCILO1_BASE + 0x04000000 * 2)
+#define LOONGSON2E_PCI_IO_START		0x00004000UL
+
+#endif /* !__ASM_MACH_LOONGSON_PCI_H_ */
diff --git a/arch/mips/include/asm/mach-loongson/war.h b/arch/mips/include/asm/mach-loongson/war.h
new file mode 100644
index 0000000..4b971c3
--- /dev/null
+++ b/arch/mips/include/asm/mach-loongson/war.h
@@ -0,0 +1,25 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2002, 2004, 2007 by Ralf Baechle <ralf@linux-mips.org>
+ */
+#ifndef __ASM_MACH_LOONGSON_WAR_H
+#define __ASM_MACH_LOONGSON_WAR_H
+
+#define R4600_V1_INDEX_ICACHEOP_WAR	0
+#define R4600_V1_HIT_CACHEOP_WAR	0
+#define R4600_V2_HIT_CACHEOP_WAR	0
+#define R5432_CP0_INTERRUPT_WAR		0
+#define BCM1250_M3_WAR			0
+#define SIBYTE_1956_WAR			0
+#define MIPS4K_ICACHE_REFILL_WAR	0
+#define MIPS_CACHE_SYNC_WAR		0
+#define TX49XX_ICACHE_INDEX_INV_WAR	0
+#define RM9000_CDEX_SMP_WAR		0
+#define ICACHE_REFILLS_WORKAROUND_WAR	0
+#define R10000_LLSC_WAR			0
+#define MIPS34K_MISSED_ITLB_WAR		0
+
+#endif /* __ASM_MACH_LEMOTE_WAR_H */
diff --git a/arch/mips/include/asm/mips-boards/bonito64.h b/arch/mips/include/asm/mips-boards/bonito64.h
index a0f04bb..a576ce0 100644
--- a/arch/mips/include/asm/mips-boards/bonito64.h
+++ b/arch/mips/include/asm/mips-boards/bonito64.h
@@ -26,7 +26,7 @@
 /* offsets from base register */
 #define BONITO(x)	(x)
 
-#elif defined(CONFIG_LEMOTE_FULONG)
+#elif defined(CONFIG_LEMOTE_FULOONG2E)
 
 #define BONITO(x) (*(volatile u32 *)((char *)CKSEG1ADDR(BONITO_REG_BASE) + (x)))
 #define BONITO_IRQ_BASE   32
diff --git a/arch/mips/lemote/lm2e/Makefile b/arch/mips/lemote/lm2e/Makefile
deleted file mode 100644
index a5bc1ef..0000000
--- a/arch/mips/lemote/lm2e/Makefile
+++ /dev/null
@@ -1,13 +0,0 @@
-#
-# Makefile for Lemote Fulong mini-PC board.
-#
-
-obj-y += setup.o init.o reset.o irq.o pci.o bonito-irq.o mem.o \
-		env.o cmdline.o time.o machtype.o
-
-#
-# Early printk support
-#
-obj-$(CONFIG_EARLY_PRINTK) += early_printk.o
-
-EXTRA_CFLAGS += -Werror
diff --git a/arch/mips/lemote/lm2e/bonito-irq.c b/arch/mips/lemote/lm2e/bonito-irq.c
deleted file mode 100644
index 3e31e7a..0000000
--- a/arch/mips/lemote/lm2e/bonito-irq.c
+++ /dev/null
@@ -1,51 +0,0 @@
-/*
- * Copyright 2001 MontaVista Software Inc.
- * Author: Jun Sun, jsun@mvista.com or jsun@junsun.net
- * Copyright (C) 2000, 2001 Ralf Baechle (ralf@gnu.org)
- *
- * Copyright (C) 2007 Lemote Inc. & Insititute of Computing Technology
- * Author: Fuxin Zhang, zhangfx@lemote.com
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- */
-#include <linux/interrupt.h>
-
-#include <loongson.h>
-
-static inline void bonito_irq_enable(unsigned int irq)
-{
-	BONITO_INTENSET = (1 << (irq - BONITO_IRQ_BASE));
-	mmiowb();
-}
-
-static inline void bonito_irq_disable(unsigned int irq)
-{
-	BONITO_INTENCLR = (1 << (irq - BONITO_IRQ_BASE));
-	mmiowb();
-}
-
-static struct irq_chip bonito_irq_type = {
-	.name	= "bonito_irq",
-	.ack	= bonito_irq_disable,
-	.mask	= bonito_irq_disable,
-	.mask_ack = bonito_irq_disable,
-	.unmask	= bonito_irq_enable,
-};
-
-static struct irqaction dma_timeout_irqaction = {
-	.handler	= no_action,
-	.name		= "dma_timeout",
-};
-
-void bonito_irq_init(void)
-{
-	u32 i;
-
-	for (i = BONITO_IRQ_BASE; i < BONITO_IRQ_BASE + 32; i++)
-		set_irq_chip_and_handler(i, &bonito_irq_type, handle_level_irq);
-
-	setup_irq(BONITO_IRQ_BASE + 10, &dma_timeout_irqaction);
-}
diff --git a/arch/mips/lemote/lm2e/cmdline.c b/arch/mips/lemote/lm2e/cmdline.c
deleted file mode 100644
index 75f1b24..0000000
--- a/arch/mips/lemote/lm2e/cmdline.c
+++ /dev/null
@@ -1,52 +0,0 @@
-/*
- * Based on Ocelot Linux port, which is
- * Copyright 2001 MontaVista Software Inc.
- * Author: jsun@mvista.com or jsun@junsun.net
- *
- * Copyright 2003 ICT CAS
- * Author: Michael Guo <guoyi@ict.ac.cn>
- *
- * Copyright (C) 2007 Lemote Inc. & Insititute of Computing Technology
- * Author: Fuxin Zhang, zhangfx@lemote.com
- *
- * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
- * Author: Wu Zhangjin, wuzj@lemote.com
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-#include <asm/bootinfo.h>
-
-#include <loongson.h>
-
-int prom_argc;
-/* pmon passes arguments in 32bit pointers */
-int *_prom_argv;
-
-void __init prom_init_cmdline(void)
-{
-	int i;
-	long l;
-
-	/* firmware arguments are initialized in head.S */
-	prom_argc = fw_arg0;
-	_prom_argv = (int *)fw_arg1;
-
-	/* arg[0] is "g", the rest is boot parameters */
-	arcs_cmdline[0] = '\0';
-	for (i = 1; i < prom_argc; i++) {
-		l = (long)_prom_argv[i];
-		if (strlen(arcs_cmdline) + strlen(((char *)l) + 1)
-		    >= sizeof(arcs_cmdline))
-			break;
-		strcat(arcs_cmdline, ((char *)l));
-		strcat(arcs_cmdline, " ");
-	}
-
-	if ((strstr(arcs_cmdline, "console=")) == NULL)
-		strcat(arcs_cmdline, " console=ttyS0,115200");
-	if ((strstr(arcs_cmdline, "root=")) == NULL)
-		strcat(arcs_cmdline, " root=/dev/hda1");
-}
diff --git a/arch/mips/lemote/lm2e/early_printk.c b/arch/mips/lemote/lm2e/early_printk.c
deleted file mode 100644
index 3e0a6ea..0000000
--- a/arch/mips/lemote/lm2e/early_printk.c
+++ /dev/null
@@ -1,39 +0,0 @@
-/*  early printk support
- *
- *  Copyright (c) 2009 Philippe Vachon <philippe@cowpig.ca>
- *  Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
- *  Author: Wu Zhangjin, wuzj@lemote.com
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- */
-#include <linux/serial_reg.h>
-
-#include <loongson.h>
-
-#define UART_BASE (BONITO_PCIIO_BASE + 0x3f8)
-
-#define PORT(base, offset) (u8 *)(base + offset)
-
-static inline unsigned int serial_in(phys_addr_t base, int offset)
-{
-	return readb(PORT(base, offset));
-}
-
-static inline void serial_out(phys_addr_t base, int offset, int value)
-{
-	writeb(value, PORT(base, offset));
-}
-
-void prom_putchar(char c)
-{
-	phys_addr_t uart_base =
-		(phys_addr_t) ioremap_nocache(UART_BASE, 8);
-
-	while ((serial_in(uart_base, UART_LSR) & UART_LSR_THRE) == 0)
-		;
-
-	serial_out(uart_base, UART_TX, c);
-}
diff --git a/arch/mips/lemote/lm2e/env.c b/arch/mips/lemote/lm2e/env.c
deleted file mode 100644
index b9ef503..0000000
--- a/arch/mips/lemote/lm2e/env.c
+++ /dev/null
@@ -1,58 +0,0 @@
-/*
- * Based on Ocelot Linux port, which is
- * Copyright 2001 MontaVista Software Inc.
- * Author: jsun@mvista.com or jsun@junsun.net
- *
- * Copyright 2003 ICT CAS
- * Author: Michael Guo <guoyi@ict.ac.cn>
- *
- * Copyright (C) 2007 Lemote Inc. & Insititute of Computing Technology
- * Author: Fuxin Zhang, zhangfx@lemote.com
- *
- * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
- * Author: Wu Zhangjin, wuzj@lemote.com
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-#include <asm/bootinfo.h>
-
-#include <loongson.h>
-
-unsigned long bus_clock, cpu_clock_freq;
-unsigned long memsize, highmemsize;
-
-/* pmon passes arguments in 32bit pointers */
-int *_prom_envp;
-
-#define parse_even_earlier(res, option, p)				\
-do {									\
-	if (strncmp(option, (char *)p, strlen(option)) == 0)		\
-			strict_strtol((char *)p + strlen(option"="),	\
-					10, &res);			\
-} while (0)
-
-void __init prom_init_env(void)
-{
-	long l;
-
-	/* firmware arguments are initialized in head.S */
-	_prom_envp = (int *)fw_arg2;
-
-	l = (long)*_prom_envp;
-	while (l != 0) {
-		parse_even_earlier(bus_clock, "busclock", l);
-		parse_even_earlier(cpu_clock_freq, "cpuclock", l);
-		parse_even_earlier(memsize, "memsize", l);
-		parse_even_earlier(highmemsize, "highmemsize", l);
-		_prom_envp++;
-		l = (long)*_prom_envp;
-	}
-	if (memsize == 0)
-		memsize = 256;
-
-	pr_info("busclock=%ld, cpuclock=%ld, memsize=%ld, highmemsize=%ld\n",
-		bus_clock, cpu_clock_freq, memsize, highmemsize);
-}
diff --git a/arch/mips/lemote/lm2e/init.c b/arch/mips/lemote/lm2e/init.c
deleted file mode 100644
index 3abe927..0000000
--- a/arch/mips/lemote/lm2e/init.c
+++ /dev/null
@@ -1,30 +0,0 @@
-/*
- * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
- * Author: Wu Zhangjin, wuzj@lemote.com
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-
-#include <linux/bootmem.h>
-
-#include <asm/bootinfo.h>
-
-#include <loongson.h>
-
-void __init prom_init(void)
-{
-    /* init base address of io space */
-	set_io_port_base((unsigned long)
-		ioremap(BONITO_PCIIO_BASE, BONITO_PCIIO_SIZE));
-
-	prom_init_cmdline();
-	prom_init_env();
-	prom_init_memory();
-}
-
-void __init prom_free_prom_memory(void)
-{
-}
diff --git a/arch/mips/lemote/lm2e/irq.c b/arch/mips/lemote/lm2e/irq.c
deleted file mode 100644
index 9585f5a..0000000
--- a/arch/mips/lemote/lm2e/irq.c
+++ /dev/null
@@ -1,111 +0,0 @@
-/*
- * Copyright (C) 2007 Lemote Inc. & Insititute of Computing Technology
- * Author: Fuxin Zhang, zhangfx@lemote.com
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- */
-#include <linux/delay.h>
-#include <linux/interrupt.h>
-
-#include <asm/irq_cpu.h>
-#include <asm/i8259.h>
-
-#include <loongson.h>
-/*
- * the first level int-handler will jump here if it is a bonito irq
- */
-static void bonito_irqdispatch(void)
-{
-	u32 int_status;
-	int i;
-
-	/* workaround the IO dma problem: let cpu looping to allow DMA finish */
-	int_status = BONITO_INTISR;
-	if (int_status & (1 << 10)) {
-		while (int_status & (1 << 10)) {
-			udelay(1);
-			int_status = BONITO_INTISR;
-		}
-	}
-
-	/* Get pending sources, masked by current enables */
-	int_status = BONITO_INTISR & BONITO_INTEN;
-
-	if (int_status != 0) {
-		i = __ffs(int_status);
-		int_status &= ~(1 << i);
-		do_IRQ(BONITO_IRQ_BASE + i);
-	}
-}
-
-static void i8259_irqdispatch(void)
-{
-	int irq;
-
-	irq = i8259_irq();
-	if (irq >= 0)
-		do_IRQ(irq);
-	else
-		spurious_interrupt();
-}
-
-asmlinkage void plat_irq_dispatch(void)
-{
-	unsigned int pending = read_c0_cause() & read_c0_status() & ST0_IM;
-
-	if (pending & CAUSEF_IP7)
-		do_IRQ(MIPS_CPU_IRQ_BASE + 7);
-	else if (pending & CAUSEF_IP6) /* perf counter loverflow */
-		do_IRQ(LOONGSON2_PERFCNT_IRQ);
-	else if (pending & CAUSEF_IP5)
-		i8259_irqdispatch();
-	else if (pending & CAUSEF_IP2)
-		bonito_irqdispatch();
-	else
-		spurious_interrupt();
-}
-
-static struct irqaction cascade_irqaction = {
-	.handler = no_action,
-	.name = "cascade",
-};
-
-void __init arch_init_irq(void)
-{
-	/*
-	 * Clear all of the interrupts while we change the able around a bit.
-	 * int-handler is not on bootstrap
-	 */
-	clear_c0_status(ST0_IM | ST0_BEV);
-	local_irq_disable();
-
-	/* most bonito irq should be level triggered */
-	BONITO_INTEDGE = BONITO_ICU_SYSTEMERR | BONITO_ICU_MASTERERR |
-		BONITO_ICU_RETRYERR | BONITO_ICU_MBOXES;
-	BONITO_INTSTEER = 0;
-
-	/*
-	 * Mask out all interrupt by writing "1" to all bit position in
-	 * the interrupt reset reg.
-	 */
-	BONITO_INTENCLR = ~0;
-
-	/* init all controller
-	 *   0-15         ------> i8259 interrupt
-	 *   16-23        ------> mips cpu interrupt
-	 *   32-63        ------> bonito irq
-	 */
-
-	/* Sets the first-level interrupt dispatcher. */
-	mips_cpu_irq_init();
-	init_i8259_irqs();
-	bonito_irq_init();
-
-	/* bonito irq at IP2 */
-	setup_irq(MIPS_CPU_IRQ_BASE + 2, &cascade_irqaction);
-	/* 8259 irq at IP5 */
-	setup_irq(MIPS_CPU_IRQ_BASE + 5, &cascade_irqaction);
-}
diff --git a/arch/mips/lemote/lm2e/machtype.c b/arch/mips/lemote/lm2e/machtype.c
deleted file mode 100644
index 8d803ee..0000000
--- a/arch/mips/lemote/lm2e/machtype.c
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
- * Author: Wu Zhangjin, wuzj@lemote.com
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-
-const char *get_system_type(void)
-{
-	return "lemote-fulong";
-}
-
diff --git a/arch/mips/lemote/lm2e/mem.c b/arch/mips/lemote/lm2e/mem.c
deleted file mode 100644
index 6a7feb1..0000000
--- a/arch/mips/lemote/lm2e/mem.c
+++ /dev/null
@@ -1,36 +0,0 @@
-/*
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-#include <linux/fs.h>
-#include <linux/fcntl.h>
-#include <linux/mm.h>
-
-#include <asm/bootinfo.h>
-
-#include <loongson.h>
-
-void __init prom_init_memory(void)
-{
-    add_memory_region(0x0, (memsize << 20), BOOT_MEM_RAM);
-#ifdef CONFIG_64BIT
-    if (highmemsize > 0)
-		add_memory_region(0x20000000, highmemsize << 20, BOOT_MEM_RAM);
-#endif /* CONFIG_64BIT */
-}
-
-/* override of arch/mips/mm/cache.c: __uncached_access */
-int __uncached_access(struct file *file, unsigned long addr)
-{
-	if (file->f_flags & O_SYNC)
-		return 1;
-
-	/*
-	 * On the Lemote Loongson 2e system, the peripheral registers
-	 * reside between 0x1000:0000 and 0x2000:0000.
-	 */
-	return addr >= __pa(high_memory) ||
-		((addr >= 0x10000000) && (addr < 0x20000000));
-}
diff --git a/arch/mips/lemote/lm2e/pci.c b/arch/mips/lemote/lm2e/pci.c
deleted file mode 100644
index 9812c30..0000000
--- a/arch/mips/lemote/lm2e/pci.c
+++ /dev/null
@@ -1,83 +0,0 @@
-/*
- * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
- * Author: Fuxin Zhang, zhangfx@lemote.com
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- */
-#include <linux/pci.h>
-
-#include <pci.h>
-#include <loongson.h>
-
-static struct resource loongson2e_pci_mem_resource = {
-	.name   = "LOONGSON2E PCI MEM",
-	.start  = LOONGSON2E_PCI_MEM_START,
-	.end    = LOONGSON2E_PCI_MEM_END,
-	.flags  = IORESOURCE_MEM,
-};
-
-static struct resource loongson2e_pci_io_resource = {
-	.name   = "LOONGSON2E PCI IO MEM",
-	.start  = LOONGSON2E_PCI_IO_START,
-	.end    = IO_SPACE_LIMIT,
-	.flags  = IORESOURCE_IO,
-};
-
-static struct pci_controller  loongson2e_pci_controller = {
-	.pci_ops        = &bonito64_pci_ops,
-	.io_resource    = &loongson2e_pci_io_resource,
-	.mem_resource   = &loongson2e_pci_mem_resource,
-	.mem_offset     = 0x00000000UL,
-	.io_offset      = 0x00000000UL,
-};
-
-static void __init setup_pcimap(void)
-{
-	/*
-	 * local to PCI mapping for CPU accessing PCI space
-	 * CPU address space [256M,448M] is window for accessing pci space
-	 * we set pcimap_lo[0,1,2] to map it to pci space[0M,64M], [320M,448M]
-	 *
-	 * pcimap: PCI_MAP2  PCI_Mem_Lo2 PCI_Mem_Lo1 PCI_Mem_Lo0
-	 * 	     [<2G]   [384M,448M] [320M,384M] [0M,64M]
-	 */
-	BONITO_PCIMAP = BONITO_PCIMAP_PCIMAP_2 |
-		BONITO_PCIMAP_WIN(2, BONITO_PCILO2_BASE) |
-		BONITO_PCIMAP_WIN(1, BONITO_PCILO1_BASE) |
-		BONITO_PCIMAP_WIN(0, 0);
-
-	/*
-	 * PCI-DMA to local mapping: [2G,2G+256M] -> [0M,256M]
-	 */
-	BONITO_PCIBASE0 = 0x80000000ul;   /* base: 2G -> mmap: 0M */
-	/* size: 256M, burst transmission, pre-fetch enable, 64bit */
-	LOONGSON_PCI_HIT0_SEL_L = 0xc000000cul;
-	LOONGSON_PCI_HIT0_SEL_H = 0xfffffffful;
-	LOONGSON_PCI_HIT1_SEL_L = 0x00000006ul; /* set this BAR as invalid */
-	LOONGSON_PCI_HIT1_SEL_H = 0x00000000ul;
-	LOONGSON_PCI_HIT2_SEL_L = 0x00000006ul; /* set this BAR as invalid */
-	LOONGSON_PCI_HIT2_SEL_H = 0x00000000ul;
-
-	/* avoid deadlock of PCI reading/writing lock operation */
-	LOONGSON_PCI_ISR4C = 0xd2000001ul;
-
-	/* can not change gnt to break pci transfer when device's gnt not
-	deassert for some broken device */
-	LOONGSON_PXARB_CFG = 0x00fe0105ul;
-}
-
-static int __init pcibios_init(void)
-{
-	setup_pcimap();
-
-	loongson2e_pci_controller.io_map_base = mips_io_port_base;
-
-	register_pci_controller(&loongson2e_pci_controller);
-
-	return 0;
-}
-
-arch_initcall(pcibios_init);
diff --git a/arch/mips/lemote/lm2e/reset.c b/arch/mips/lemote/lm2e/reset.c
deleted file mode 100644
index d89c9e4..0000000
--- a/arch/mips/lemote/lm2e/reset.c
+++ /dev/null
@@ -1,39 +0,0 @@
-/*
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- *
- * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
- * Author: Fuxin Zhang, zhangfx@lemote.com
- * Copyright (C) 2009 Lemote, Inc. & Institute of Computing Technology
- * Author: Zhangjin Wu, wuzj@lemote.com
- */
-#include <linux/pm.h>
-
-#include <asm/reboot.h>
-
-#include <loongson.h>
-
-static void loongson2e_restart(char *command)
-{
-	/* do preparation for reboot */
-	BONITO_BONGENCFG &= ~(1 << 2);
-	BONITO_BONGENCFG |= (1 << 2);
-
-	/* reboot via jumping to boot base address */
-	((void (*)(void))ioremap_nocache(BONITO_BOOT_BASE, 4)) ();
-}
-
-static void loongson2e_halt(void)
-{
-	while (1)
-		;
-}
-
-void mips_reboot_setup(void)
-{
-	_machine_restart = loongson2e_restart;
-	_machine_halt = loongson2e_halt;
-	pm_power_off = loongson2e_halt;
-}
diff --git a/arch/mips/lemote/lm2e/setup.c b/arch/mips/lemote/lm2e/setup.c
deleted file mode 100644
index 655695c..0000000
--- a/arch/mips/lemote/lm2e/setup.c
+++ /dev/null
@@ -1,60 +0,0 @@
-/*
- * Copyright (C) 2007 Lemote Inc. & Insititute of Computing Technology
- * Author: Fuxin Zhang, zhangfx@lemote.com
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- */
-#include <linux/module.h>
-
-#include <asm/wbflush.h>
-
-#include <loongson.h>
-
-#ifdef CONFIG_VT
-#include <linux/console.h>
-#include <linux/screen_info.h>
-#endif
-
-void (*__wbflush)(void);
-EXPORT_SYMBOL(__wbflush);
-
-static void wbflush_loongson2e(void)
-{
-	asm(".set\tpush\n\t"
-	    ".set\tnoreorder\n\t"
-	    ".set mips3\n\t"
-	    "sync\n\t"
-	    "nop\n\t"
-	    ".set\tpop\n\t"
-	    ".set mips0\n\t");
-}
-
-void __init plat_mem_setup(void)
-{
-	mips_reboot_setup();
-
-	__wbflush = wbflush_loongson2e;
-
-#ifdef CONFIG_VT
-#if defined(CONFIG_VGA_CONSOLE)
-	conswitchp = &vga_con;
-
-	screen_info = (struct screen_info) {
-		0, 25,		/* orig-x, orig-y */
-		    0,		/* unused */
-		    0,		/* orig-video-page */
-		    0,		/* orig-video-mode */
-		    80,		/* orig-video-cols */
-		    0, 0, 0,	/* ega_ax, ega_bx, ega_cx */
-		    25,		/* orig-video-lines */
-		    VIDEO_TYPE_VGAC,	/* orig-video-isVGA */
-		    16		/* orig-video-points */
-	};
-#elif defined(CONFIG_DUMMY_CONSOLE)
-	conswitchp = &dummy_con;
-#endif
-#endif
-}
diff --git a/arch/mips/lemote/lm2e/time.c b/arch/mips/lemote/lm2e/time.c
deleted file mode 100644
index b13d171..0000000
--- a/arch/mips/lemote/lm2e/time.c
+++ /dev/null
@@ -1,27 +0,0 @@
-/*
- * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
- * Author: Fuxin Zhang, zhangfx@lemote.com
- *
- * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
- * Author: Wu Zhangjin, wuzj@lemote.com
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- */
-#include <asm/mc146818-time.h>
-#include <asm/time.h>
-
-#include <loongson.h>
-
-void __init plat_time_init(void)
-{
-	/* setup mips r4k timer */
-	mips_hpt_frequency = cpu_clock_freq / 2;
-}
-
-unsigned long read_persistent_clock(void)
-{
-	return mc146818_get_cmos_time();
-}
diff --git a/arch/mips/loongson/fuloong-2e/Makefile b/arch/mips/loongson/fuloong-2e/Makefile
new file mode 100644
index 0000000..feb1d6b
--- /dev/null
+++ b/arch/mips/loongson/fuloong-2e/Makefile
@@ -0,0 +1,13 @@
+#
+# Makefile for Lemote Fuloong2e mini-PC board.
+#
+
+obj-y += setup.o init.o reset.o irq.o pci.o bonito-irq.o mem.o \
+		env.o cmdline.o time.o machtype.o
+
+#
+# Early printk support
+#
+obj-$(CONFIG_EARLY_PRINTK) += early_printk.o
+
+EXTRA_CFLAGS += -Werror
diff --git a/arch/mips/loongson/fuloong-2e/bonito-irq.c b/arch/mips/loongson/fuloong-2e/bonito-irq.c
new file mode 100644
index 0000000..3e31e7a
--- /dev/null
+++ b/arch/mips/loongson/fuloong-2e/bonito-irq.c
@@ -0,0 +1,51 @@
+/*
+ * Copyright 2001 MontaVista Software Inc.
+ * Author: Jun Sun, jsun@mvista.com or jsun@junsun.net
+ * Copyright (C) 2000, 2001 Ralf Baechle (ralf@gnu.org)
+ *
+ * Copyright (C) 2007 Lemote Inc. & Insititute of Computing Technology
+ * Author: Fuxin Zhang, zhangfx@lemote.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+#include <linux/interrupt.h>
+
+#include <loongson.h>
+
+static inline void bonito_irq_enable(unsigned int irq)
+{
+	BONITO_INTENSET = (1 << (irq - BONITO_IRQ_BASE));
+	mmiowb();
+}
+
+static inline void bonito_irq_disable(unsigned int irq)
+{
+	BONITO_INTENCLR = (1 << (irq - BONITO_IRQ_BASE));
+	mmiowb();
+}
+
+static struct irq_chip bonito_irq_type = {
+	.name	= "bonito_irq",
+	.ack	= bonito_irq_disable,
+	.mask	= bonito_irq_disable,
+	.mask_ack = bonito_irq_disable,
+	.unmask	= bonito_irq_enable,
+};
+
+static struct irqaction dma_timeout_irqaction = {
+	.handler	= no_action,
+	.name		= "dma_timeout",
+};
+
+void bonito_irq_init(void)
+{
+	u32 i;
+
+	for (i = BONITO_IRQ_BASE; i < BONITO_IRQ_BASE + 32; i++)
+		set_irq_chip_and_handler(i, &bonito_irq_type, handle_level_irq);
+
+	setup_irq(BONITO_IRQ_BASE + 10, &dma_timeout_irqaction);
+}
diff --git a/arch/mips/loongson/fuloong-2e/cmdline.c b/arch/mips/loongson/fuloong-2e/cmdline.c
new file mode 100644
index 0000000..75f1b24
--- /dev/null
+++ b/arch/mips/loongson/fuloong-2e/cmdline.c
@@ -0,0 +1,52 @@
+/*
+ * Based on Ocelot Linux port, which is
+ * Copyright 2001 MontaVista Software Inc.
+ * Author: jsun@mvista.com or jsun@junsun.net
+ *
+ * Copyright 2003 ICT CAS
+ * Author: Michael Guo <guoyi@ict.ac.cn>
+ *
+ * Copyright (C) 2007 Lemote Inc. & Insititute of Computing Technology
+ * Author: Fuxin Zhang, zhangfx@lemote.com
+ *
+ * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
+ * Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+#include <asm/bootinfo.h>
+
+#include <loongson.h>
+
+int prom_argc;
+/* pmon passes arguments in 32bit pointers */
+int *_prom_argv;
+
+void __init prom_init_cmdline(void)
+{
+	int i;
+	long l;
+
+	/* firmware arguments are initialized in head.S */
+	prom_argc = fw_arg0;
+	_prom_argv = (int *)fw_arg1;
+
+	/* arg[0] is "g", the rest is boot parameters */
+	arcs_cmdline[0] = '\0';
+	for (i = 1; i < prom_argc; i++) {
+		l = (long)_prom_argv[i];
+		if (strlen(arcs_cmdline) + strlen(((char *)l) + 1)
+		    >= sizeof(arcs_cmdline))
+			break;
+		strcat(arcs_cmdline, ((char *)l));
+		strcat(arcs_cmdline, " ");
+	}
+
+	if ((strstr(arcs_cmdline, "console=")) == NULL)
+		strcat(arcs_cmdline, " console=ttyS0,115200");
+	if ((strstr(arcs_cmdline, "root=")) == NULL)
+		strcat(arcs_cmdline, " root=/dev/hda1");
+}
diff --git a/arch/mips/loongson/fuloong-2e/early_printk.c b/arch/mips/loongson/fuloong-2e/early_printk.c
new file mode 100644
index 0000000..3e0a6ea
--- /dev/null
+++ b/arch/mips/loongson/fuloong-2e/early_printk.c
@@ -0,0 +1,39 @@
+/*  early printk support
+ *
+ *  Copyright (c) 2009 Philippe Vachon <philippe@cowpig.ca>
+ *  Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
+ *  Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+#include <linux/serial_reg.h>
+
+#include <loongson.h>
+
+#define UART_BASE (BONITO_PCIIO_BASE + 0x3f8)
+
+#define PORT(base, offset) (u8 *)(base + offset)
+
+static inline unsigned int serial_in(phys_addr_t base, int offset)
+{
+	return readb(PORT(base, offset));
+}
+
+static inline void serial_out(phys_addr_t base, int offset, int value)
+{
+	writeb(value, PORT(base, offset));
+}
+
+void prom_putchar(char c)
+{
+	phys_addr_t uart_base =
+		(phys_addr_t) ioremap_nocache(UART_BASE, 8);
+
+	while ((serial_in(uart_base, UART_LSR) & UART_LSR_THRE) == 0)
+		;
+
+	serial_out(uart_base, UART_TX, c);
+}
diff --git a/arch/mips/loongson/fuloong-2e/env.c b/arch/mips/loongson/fuloong-2e/env.c
new file mode 100644
index 0000000..b9ef503
--- /dev/null
+++ b/arch/mips/loongson/fuloong-2e/env.c
@@ -0,0 +1,58 @@
+/*
+ * Based on Ocelot Linux port, which is
+ * Copyright 2001 MontaVista Software Inc.
+ * Author: jsun@mvista.com or jsun@junsun.net
+ *
+ * Copyright 2003 ICT CAS
+ * Author: Michael Guo <guoyi@ict.ac.cn>
+ *
+ * Copyright (C) 2007 Lemote Inc. & Insititute of Computing Technology
+ * Author: Fuxin Zhang, zhangfx@lemote.com
+ *
+ * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
+ * Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+#include <asm/bootinfo.h>
+
+#include <loongson.h>
+
+unsigned long bus_clock, cpu_clock_freq;
+unsigned long memsize, highmemsize;
+
+/* pmon passes arguments in 32bit pointers */
+int *_prom_envp;
+
+#define parse_even_earlier(res, option, p)				\
+do {									\
+	if (strncmp(option, (char *)p, strlen(option)) == 0)		\
+			strict_strtol((char *)p + strlen(option"="),	\
+					10, &res);			\
+} while (0)
+
+void __init prom_init_env(void)
+{
+	long l;
+
+	/* firmware arguments are initialized in head.S */
+	_prom_envp = (int *)fw_arg2;
+
+	l = (long)*_prom_envp;
+	while (l != 0) {
+		parse_even_earlier(bus_clock, "busclock", l);
+		parse_even_earlier(cpu_clock_freq, "cpuclock", l);
+		parse_even_earlier(memsize, "memsize", l);
+		parse_even_earlier(highmemsize, "highmemsize", l);
+		_prom_envp++;
+		l = (long)*_prom_envp;
+	}
+	if (memsize == 0)
+		memsize = 256;
+
+	pr_info("busclock=%ld, cpuclock=%ld, memsize=%ld, highmemsize=%ld\n",
+		bus_clock, cpu_clock_freq, memsize, highmemsize);
+}
diff --git a/arch/mips/loongson/fuloong-2e/init.c b/arch/mips/loongson/fuloong-2e/init.c
new file mode 100644
index 0000000..3abe927
--- /dev/null
+++ b/arch/mips/loongson/fuloong-2e/init.c
@@ -0,0 +1,30 @@
+/*
+ * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
+ * Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/bootmem.h>
+
+#include <asm/bootinfo.h>
+
+#include <loongson.h>
+
+void __init prom_init(void)
+{
+    /* init base address of io space */
+	set_io_port_base((unsigned long)
+		ioremap(BONITO_PCIIO_BASE, BONITO_PCIIO_SIZE));
+
+	prom_init_cmdline();
+	prom_init_env();
+	prom_init_memory();
+}
+
+void __init prom_free_prom_memory(void)
+{
+}
diff --git a/arch/mips/loongson/fuloong-2e/irq.c b/arch/mips/loongson/fuloong-2e/irq.c
new file mode 100644
index 0000000..9585f5a
--- /dev/null
+++ b/arch/mips/loongson/fuloong-2e/irq.c
@@ -0,0 +1,111 @@
+/*
+ * Copyright (C) 2007 Lemote Inc. & Insititute of Computing Technology
+ * Author: Fuxin Zhang, zhangfx@lemote.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+
+#include <asm/irq_cpu.h>
+#include <asm/i8259.h>
+
+#include <loongson.h>
+/*
+ * the first level int-handler will jump here if it is a bonito irq
+ */
+static void bonito_irqdispatch(void)
+{
+	u32 int_status;
+	int i;
+
+	/* workaround the IO dma problem: let cpu looping to allow DMA finish */
+	int_status = BONITO_INTISR;
+	if (int_status & (1 << 10)) {
+		while (int_status & (1 << 10)) {
+			udelay(1);
+			int_status = BONITO_INTISR;
+		}
+	}
+
+	/* Get pending sources, masked by current enables */
+	int_status = BONITO_INTISR & BONITO_INTEN;
+
+	if (int_status != 0) {
+		i = __ffs(int_status);
+		int_status &= ~(1 << i);
+		do_IRQ(BONITO_IRQ_BASE + i);
+	}
+}
+
+static void i8259_irqdispatch(void)
+{
+	int irq;
+
+	irq = i8259_irq();
+	if (irq >= 0)
+		do_IRQ(irq);
+	else
+		spurious_interrupt();
+}
+
+asmlinkage void plat_irq_dispatch(void)
+{
+	unsigned int pending = read_c0_cause() & read_c0_status() & ST0_IM;
+
+	if (pending & CAUSEF_IP7)
+		do_IRQ(MIPS_CPU_IRQ_BASE + 7);
+	else if (pending & CAUSEF_IP6) /* perf counter loverflow */
+		do_IRQ(LOONGSON2_PERFCNT_IRQ);
+	else if (pending & CAUSEF_IP5)
+		i8259_irqdispatch();
+	else if (pending & CAUSEF_IP2)
+		bonito_irqdispatch();
+	else
+		spurious_interrupt();
+}
+
+static struct irqaction cascade_irqaction = {
+	.handler = no_action,
+	.name = "cascade",
+};
+
+void __init arch_init_irq(void)
+{
+	/*
+	 * Clear all of the interrupts while we change the able around a bit.
+	 * int-handler is not on bootstrap
+	 */
+	clear_c0_status(ST0_IM | ST0_BEV);
+	local_irq_disable();
+
+	/* most bonito irq should be level triggered */
+	BONITO_INTEDGE = BONITO_ICU_SYSTEMERR | BONITO_ICU_MASTERERR |
+		BONITO_ICU_RETRYERR | BONITO_ICU_MBOXES;
+	BONITO_INTSTEER = 0;
+
+	/*
+	 * Mask out all interrupt by writing "1" to all bit position in
+	 * the interrupt reset reg.
+	 */
+	BONITO_INTENCLR = ~0;
+
+	/* init all controller
+	 *   0-15         ------> i8259 interrupt
+	 *   16-23        ------> mips cpu interrupt
+	 *   32-63        ------> bonito irq
+	 */
+
+	/* Sets the first-level interrupt dispatcher. */
+	mips_cpu_irq_init();
+	init_i8259_irqs();
+	bonito_irq_init();
+
+	/* bonito irq at IP2 */
+	setup_irq(MIPS_CPU_IRQ_BASE + 2, &cascade_irqaction);
+	/* 8259 irq at IP5 */
+	setup_irq(MIPS_CPU_IRQ_BASE + 5, &cascade_irqaction);
+}
diff --git a/arch/mips/loongson/fuloong-2e/machtype.c b/arch/mips/loongson/fuloong-2e/machtype.c
new file mode 100644
index 0000000..e03aa0d
--- /dev/null
+++ b/arch/mips/loongson/fuloong-2e/machtype.c
@@ -0,0 +1,15 @@
+/*
+ * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
+ * Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+const char *get_system_type(void)
+{
+	return "lemote-fuloong-2e-box";
+}
+
diff --git a/arch/mips/loongson/fuloong-2e/mem.c b/arch/mips/loongson/fuloong-2e/mem.c
new file mode 100644
index 0000000..6a7feb1
--- /dev/null
+++ b/arch/mips/loongson/fuloong-2e/mem.c
@@ -0,0 +1,36 @@
+/*
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+#include <linux/fs.h>
+#include <linux/fcntl.h>
+#include <linux/mm.h>
+
+#include <asm/bootinfo.h>
+
+#include <loongson.h>
+
+void __init prom_init_memory(void)
+{
+    add_memory_region(0x0, (memsize << 20), BOOT_MEM_RAM);
+#ifdef CONFIG_64BIT
+    if (highmemsize > 0)
+		add_memory_region(0x20000000, highmemsize << 20, BOOT_MEM_RAM);
+#endif /* CONFIG_64BIT */
+}
+
+/* override of arch/mips/mm/cache.c: __uncached_access */
+int __uncached_access(struct file *file, unsigned long addr)
+{
+	if (file->f_flags & O_SYNC)
+		return 1;
+
+	/*
+	 * On the Lemote Loongson 2e system, the peripheral registers
+	 * reside between 0x1000:0000 and 0x2000:0000.
+	 */
+	return addr >= __pa(high_memory) ||
+		((addr >= 0x10000000) && (addr < 0x20000000));
+}
diff --git a/arch/mips/loongson/fuloong-2e/pci.c b/arch/mips/loongson/fuloong-2e/pci.c
new file mode 100644
index 0000000..9812c30
--- /dev/null
+++ b/arch/mips/loongson/fuloong-2e/pci.c
@@ -0,0 +1,83 @@
+/*
+ * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
+ * Author: Fuxin Zhang, zhangfx@lemote.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+#include <linux/pci.h>
+
+#include <pci.h>
+#include <loongson.h>
+
+static struct resource loongson2e_pci_mem_resource = {
+	.name   = "LOONGSON2E PCI MEM",
+	.start  = LOONGSON2E_PCI_MEM_START,
+	.end    = LOONGSON2E_PCI_MEM_END,
+	.flags  = IORESOURCE_MEM,
+};
+
+static struct resource loongson2e_pci_io_resource = {
+	.name   = "LOONGSON2E PCI IO MEM",
+	.start  = LOONGSON2E_PCI_IO_START,
+	.end    = IO_SPACE_LIMIT,
+	.flags  = IORESOURCE_IO,
+};
+
+static struct pci_controller  loongson2e_pci_controller = {
+	.pci_ops        = &bonito64_pci_ops,
+	.io_resource    = &loongson2e_pci_io_resource,
+	.mem_resource   = &loongson2e_pci_mem_resource,
+	.mem_offset     = 0x00000000UL,
+	.io_offset      = 0x00000000UL,
+};
+
+static void __init setup_pcimap(void)
+{
+	/*
+	 * local to PCI mapping for CPU accessing PCI space
+	 * CPU address space [256M,448M] is window for accessing pci space
+	 * we set pcimap_lo[0,1,2] to map it to pci space[0M,64M], [320M,448M]
+	 *
+	 * pcimap: PCI_MAP2  PCI_Mem_Lo2 PCI_Mem_Lo1 PCI_Mem_Lo0
+	 * 	     [<2G]   [384M,448M] [320M,384M] [0M,64M]
+	 */
+	BONITO_PCIMAP = BONITO_PCIMAP_PCIMAP_2 |
+		BONITO_PCIMAP_WIN(2, BONITO_PCILO2_BASE) |
+		BONITO_PCIMAP_WIN(1, BONITO_PCILO1_BASE) |
+		BONITO_PCIMAP_WIN(0, 0);
+
+	/*
+	 * PCI-DMA to local mapping: [2G,2G+256M] -> [0M,256M]
+	 */
+	BONITO_PCIBASE0 = 0x80000000ul;   /* base: 2G -> mmap: 0M */
+	/* size: 256M, burst transmission, pre-fetch enable, 64bit */
+	LOONGSON_PCI_HIT0_SEL_L = 0xc000000cul;
+	LOONGSON_PCI_HIT0_SEL_H = 0xfffffffful;
+	LOONGSON_PCI_HIT1_SEL_L = 0x00000006ul; /* set this BAR as invalid */
+	LOONGSON_PCI_HIT1_SEL_H = 0x00000000ul;
+	LOONGSON_PCI_HIT2_SEL_L = 0x00000006ul; /* set this BAR as invalid */
+	LOONGSON_PCI_HIT2_SEL_H = 0x00000000ul;
+
+	/* avoid deadlock of PCI reading/writing lock operation */
+	LOONGSON_PCI_ISR4C = 0xd2000001ul;
+
+	/* can not change gnt to break pci transfer when device's gnt not
+	deassert for some broken device */
+	LOONGSON_PXARB_CFG = 0x00fe0105ul;
+}
+
+static int __init pcibios_init(void)
+{
+	setup_pcimap();
+
+	loongson2e_pci_controller.io_map_base = mips_io_port_base;
+
+	register_pci_controller(&loongson2e_pci_controller);
+
+	return 0;
+}
+
+arch_initcall(pcibios_init);
diff --git a/arch/mips/loongson/fuloong-2e/reset.c b/arch/mips/loongson/fuloong-2e/reset.c
new file mode 100644
index 0000000..d89c9e4
--- /dev/null
+++ b/arch/mips/loongson/fuloong-2e/reset.c
@@ -0,0 +1,39 @@
+/*
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
+ * Author: Fuxin Zhang, zhangfx@lemote.com
+ * Copyright (C) 2009 Lemote, Inc. & Institute of Computing Technology
+ * Author: Zhangjin Wu, wuzj@lemote.com
+ */
+#include <linux/pm.h>
+
+#include <asm/reboot.h>
+
+#include <loongson.h>
+
+static void loongson2e_restart(char *command)
+{
+	/* do preparation for reboot */
+	BONITO_BONGENCFG &= ~(1 << 2);
+	BONITO_BONGENCFG |= (1 << 2);
+
+	/* reboot via jumping to boot base address */
+	((void (*)(void))ioremap_nocache(BONITO_BOOT_BASE, 4)) ();
+}
+
+static void loongson2e_halt(void)
+{
+	while (1)
+		;
+}
+
+void mips_reboot_setup(void)
+{
+	_machine_restart = loongson2e_restart;
+	_machine_halt = loongson2e_halt;
+	pm_power_off = loongson2e_halt;
+}
diff --git a/arch/mips/loongson/fuloong-2e/setup.c b/arch/mips/loongson/fuloong-2e/setup.c
new file mode 100644
index 0000000..655695c
--- /dev/null
+++ b/arch/mips/loongson/fuloong-2e/setup.c
@@ -0,0 +1,60 @@
+/*
+ * Copyright (C) 2007 Lemote Inc. & Insititute of Computing Technology
+ * Author: Fuxin Zhang, zhangfx@lemote.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+#include <linux/module.h>
+
+#include <asm/wbflush.h>
+
+#include <loongson.h>
+
+#ifdef CONFIG_VT
+#include <linux/console.h>
+#include <linux/screen_info.h>
+#endif
+
+void (*__wbflush)(void);
+EXPORT_SYMBOL(__wbflush);
+
+static void wbflush_loongson2e(void)
+{
+	asm(".set\tpush\n\t"
+	    ".set\tnoreorder\n\t"
+	    ".set mips3\n\t"
+	    "sync\n\t"
+	    "nop\n\t"
+	    ".set\tpop\n\t"
+	    ".set mips0\n\t");
+}
+
+void __init plat_mem_setup(void)
+{
+	mips_reboot_setup();
+
+	__wbflush = wbflush_loongson2e;
+
+#ifdef CONFIG_VT
+#if defined(CONFIG_VGA_CONSOLE)
+	conswitchp = &vga_con;
+
+	screen_info = (struct screen_info) {
+		0, 25,		/* orig-x, orig-y */
+		    0,		/* unused */
+		    0,		/* orig-video-page */
+		    0,		/* orig-video-mode */
+		    80,		/* orig-video-cols */
+		    0, 0, 0,	/* ega_ax, ega_bx, ega_cx */
+		    25,		/* orig-video-lines */
+		    VIDEO_TYPE_VGAC,	/* orig-video-isVGA */
+		    16		/* orig-video-points */
+	};
+#elif defined(CONFIG_DUMMY_CONSOLE)
+	conswitchp = &dummy_con;
+#endif
+#endif
+}
diff --git a/arch/mips/loongson/fuloong-2e/time.c b/arch/mips/loongson/fuloong-2e/time.c
new file mode 100644
index 0000000..b13d171
--- /dev/null
+++ b/arch/mips/loongson/fuloong-2e/time.c
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
+ * Author: Fuxin Zhang, zhangfx@lemote.com
+ *
+ * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
+ * Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+#include <asm/mc146818-time.h>
+#include <asm/time.h>
+
+#include <loongson.h>
+
+void __init plat_time_init(void)
+{
+	/* setup mips r4k timer */
+	mips_hpt_frequency = cpu_clock_freq / 2;
+}
+
+unsigned long read_persistent_clock(void)
+{
+	return mc146818_get_cmos_time();
+}
diff --git a/arch/mips/pci/Makefile b/arch/mips/pci/Makefile
index e8a97f5..1c66fc0 100644
--- a/arch/mips/pci/Makefile
+++ b/arch/mips/pci/Makefile
@@ -26,7 +26,7 @@ obj-$(CONFIG_MIPS_COBALT)	+= fixup-cobalt.o
 obj-$(CONFIG_SOC_AU1500)	+= fixup-au1000.o ops-au1000.o
 obj-$(CONFIG_SOC_AU1550)	+= fixup-au1000.o ops-au1000.o
 obj-$(CONFIG_SOC_PNX8550)	+= fixup-pnx8550.o ops-pnx8550.o
-obj-$(CONFIG_LEMOTE_FULONG)	+= fixup-lm2e.o ops-bonito64.o
+obj-$(CONFIG_LEMOTE_FULOONG2E)	+= fixup-fuloong2e.o ops-bonito64.o
 obj-$(CONFIG_MIPS_MALTA)	+= fixup-malta.o
 obj-$(CONFIG_PMC_MSP7120_GW)	+= fixup-pmcmsp.o ops-pmcmsp.o
 obj-$(CONFIG_PMC_MSP7120_EVAL)	+= fixup-pmcmsp.o ops-pmcmsp.o
diff --git a/arch/mips/pci/fixup-fuloong2e.c b/arch/mips/pci/fixup-fuloong2e.c
new file mode 100644
index 0000000..0c4c7a8
--- /dev/null
+++ b/arch/mips/pci/fixup-fuloong2e.c
@@ -0,0 +1,224 @@
+/*
+ * Copyright (C) 2004 ICT CAS
+ * Author: Li xiaoyu, ICT CAS
+ *   lixy@ict.ac.cn
+ *
+ * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
+ * Author: Fuxin Zhang, zhangfx@lemote.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <asm/mips-boards/bonito64.h>
+
+/* South bridge slot number is set by the pci probe process */
+static u8 sb_slot = 5;
+
+int __init pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
+{
+	int irq = 0;
+
+	if (slot == sb_slot) {
+		switch (PCI_FUNC(dev->devfn)) {
+		case 2:
+			irq = 10;
+			break;
+		case 3:
+			irq = 11;
+			break;
+		case 5:
+			irq = 9;
+			break;
+		}
+	} else {
+		irq = BONITO_IRQ_BASE + 25 + pin;
+	}
+	return irq;
+
+}
+
+/* Do platform specific device initialization at pci_enable_device() time */
+int pcibios_plat_dev_init(struct pci_dev *dev)
+{
+	return 0;
+}
+
+static void __init loongson2e_nec_fixup(struct pci_dev *pdev)
+{
+	unsigned int val;
+
+	/* Configues port 1, 2, 3, 4 to be validate*/
+	pci_read_config_dword(pdev, 0xe0, &val);
+	pci_write_config_dword(pdev, 0xe0, (val & ~7) | 0x4);
+
+	/* System clock is 48-MHz Oscillator. */
+	pci_write_config_dword(pdev, 0xe4, 1 << 5);
+}
+
+static void __init loongson2e_686b_func0_fixup(struct pci_dev *pdev)
+{
+	unsigned char c;
+
+	sb_slot = PCI_SLOT(pdev->devfn);
+
+	printk(KERN_INFO "via686b fix: ISA bridge\n");
+
+	/*  Enable I/O Recovery time */
+	pci_write_config_byte(pdev, 0x40, 0x08);
+
+	/*  Enable ISA refresh */
+	pci_write_config_byte(pdev, 0x41, 0x01);
+
+	/*  disable ISA line buffer */
+	pci_write_config_byte(pdev, 0x45, 0x00);
+
+	/*  Gate INTR, and flush line buffer */
+	pci_write_config_byte(pdev, 0x46, 0xe0);
+
+	/*  Disable PCI Delay Transaction, Enable EISA ports 4D0/4D1. */
+	/* pci_write_config_byte(pdev, 0x47, 0x20); */
+
+	/*
+	 *  enable PCI Delay Transaction, Enable EISA ports 4D0/4D1.
+	 *  enable time-out timer
+	 */
+	pci_write_config_byte(pdev, 0x47, 0xe6);
+
+	/*
+	 * enable level trigger on pci irqs: 9,10,11,13
+	 * important! without this PCI interrupts won't work
+	 */
+	outb(0x2e, 0x4d1);
+
+	/*  512 K PCI Decode */
+	pci_write_config_byte(pdev, 0x48, 0x01);
+
+	/*  Wait for PGNT before grant to ISA Master/DMA */
+	pci_write_config_byte(pdev, 0x4a, 0x84);
+
+	/*
+	 * Plug'n'Play
+	 *
+	 *  Parallel DRQ 3, Floppy DRQ 2 (default)
+	 */
+	pci_write_config_byte(pdev, 0x50, 0x0e);
+
+	/*
+	 * IRQ Routing for Floppy and Parallel port
+	 *
+	 *  IRQ 6 for floppy, IRQ 7 for parallel port
+	 */
+	pci_write_config_byte(pdev, 0x51, 0x76);
+
+	/* IRQ Routing for serial ports (take IRQ 3 and 4) */
+	pci_write_config_byte(pdev, 0x52, 0x34);
+
+	/*  All IRQ's level triggered. */
+	pci_write_config_byte(pdev, 0x54, 0x00);
+
+	/* route PIRQA-D irq */
+	pci_write_config_byte(pdev, 0x55, 0x90);	/* bit 7-4, PIRQA */
+	pci_write_config_byte(pdev, 0x56, 0xba);	/* bit 7-4, PIRQC; */
+							/* 3-0, PIRQB */
+	pci_write_config_byte(pdev, 0x57, 0xd0);	/* bit 7-4, PIRQD */
+
+	/* enable function 5/6, audio/modem */
+	pci_read_config_byte(pdev, 0x85, &c);
+	c &= ~(0x3 << 2);
+	pci_write_config_byte(pdev, 0x85, c);
+
+	printk(KERN_INFO"via686b fix: ISA bridge done\n");
+}
+
+static void __init loongson2e_686b_func1_fixup(struct pci_dev *pdev)
+{
+	printk(KERN_INFO"via686b fix: IDE\n");
+
+	/* Modify IDE controller setup */
+	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 48);
+	pci_write_config_byte(pdev, PCI_COMMAND,
+			      PCI_COMMAND_IO | PCI_COMMAND_MEMORY |
+			      PCI_COMMAND_MASTER);
+	pci_write_config_byte(pdev, 0x40, 0x0b);
+	/* legacy mode */
+	pci_write_config_byte(pdev, 0x42, 0x09);
+
+#if 1/* play safe, otherwise we may see notebook's usb keyboard lockup */
+	/* disable read prefetch/write post buffers */
+	pci_write_config_byte(pdev, 0x41, 0x02);
+
+	/* use 3/4 as fifo thresh hold  */
+	pci_write_config_byte(pdev, 0x43, 0x0a);
+	pci_write_config_byte(pdev, 0x44, 0x00);
+
+	pci_write_config_byte(pdev, 0x45, 0x00);
+#else
+	pci_write_config_byte(pdev, 0x41, 0xc2);
+	pci_write_config_byte(pdev, 0x43, 0x35);
+	pci_write_config_byte(pdev, 0x44, 0x1c);
+
+	pci_write_config_byte(pdev, 0x45, 0x10);
+#endif
+
+	printk(KERN_INFO"via686b fix: IDE done\n");
+}
+
+static void __init loongson2e_686b_func2_fixup(struct pci_dev *pdev)
+{
+	/* irq routing */
+	pci_write_config_byte(pdev, PCI_INTERRUPT_LINE, 10);
+}
+
+static void __init loongson2e_686b_func3_fixup(struct pci_dev *pdev)
+{
+	/* irq routing */
+	pci_write_config_byte(pdev, PCI_INTERRUPT_LINE, 11);
+}
+
+static void __init loongson2e_686b_func5_fixup(struct pci_dev *pdev)
+{
+	unsigned int val;
+	unsigned char c;
+
+	/* enable IO */
+	pci_write_config_byte(pdev, PCI_COMMAND,
+			      PCI_COMMAND_IO | PCI_COMMAND_MEMORY |
+			      PCI_COMMAND_MASTER);
+	pci_read_config_dword(pdev, 0x4, &val);
+	pci_write_config_dword(pdev, 0x4, val | 1);
+
+	/* route ac97 IRQ */
+	pci_write_config_byte(pdev, 0x3c, 9);
+
+	pci_read_config_byte(pdev, 0x8, &c);
+
+	/* link control: enable link & SGD PCM output */
+	pci_write_config_byte(pdev, 0x41, 0xcc);
+
+	/* disable game port, FM, midi, sb, enable write to reg2c-2f */
+	pci_write_config_byte(pdev, 0x42, 0x20);
+
+	/* we are using Avance logic codec */
+	pci_write_config_word(pdev, 0x2c, 0x1005);
+	pci_write_config_word(pdev, 0x2e, 0x4710);
+	pci_read_config_dword(pdev, 0x2c, &val);
+
+	pci_write_config_byte(pdev, 0x42, 0x0);
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C686,
+			 loongson2e_686b_func0_fixup);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C586_1,
+			 loongson2e_686b_func1_fixup);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C586_2,
+			 loongson2e_686b_func2_fixup);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C586_3,
+			 loongson2e_686b_func3_fixup);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C686_5,
+			 loongson2e_686b_func5_fixup);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NEC, PCI_DEVICE_ID_NEC_USB,
+			 loongson2e_nec_fixup);
diff --git a/arch/mips/pci/fixup-lm2e.c b/arch/mips/pci/fixup-lm2e.c
deleted file mode 100644
index 0c4c7a8..0000000
--- a/arch/mips/pci/fixup-lm2e.c
+++ /dev/null
@@ -1,224 +0,0 @@
-/*
- * Copyright (C) 2004 ICT CAS
- * Author: Li xiaoyu, ICT CAS
- *   lixy@ict.ac.cn
- *
- * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
- * Author: Fuxin Zhang, zhangfx@lemote.com
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- */
-#include <linux/init.h>
-#include <linux/pci.h>
-#include <asm/mips-boards/bonito64.h>
-
-/* South bridge slot number is set by the pci probe process */
-static u8 sb_slot = 5;
-
-int __init pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
-{
-	int irq = 0;
-
-	if (slot == sb_slot) {
-		switch (PCI_FUNC(dev->devfn)) {
-		case 2:
-			irq = 10;
-			break;
-		case 3:
-			irq = 11;
-			break;
-		case 5:
-			irq = 9;
-			break;
-		}
-	} else {
-		irq = BONITO_IRQ_BASE + 25 + pin;
-	}
-	return irq;
-
-}
-
-/* Do platform specific device initialization at pci_enable_device() time */
-int pcibios_plat_dev_init(struct pci_dev *dev)
-{
-	return 0;
-}
-
-static void __init loongson2e_nec_fixup(struct pci_dev *pdev)
-{
-	unsigned int val;
-
-	/* Configues port 1, 2, 3, 4 to be validate*/
-	pci_read_config_dword(pdev, 0xe0, &val);
-	pci_write_config_dword(pdev, 0xe0, (val & ~7) | 0x4);
-
-	/* System clock is 48-MHz Oscillator. */
-	pci_write_config_dword(pdev, 0xe4, 1 << 5);
-}
-
-static void __init loongson2e_686b_func0_fixup(struct pci_dev *pdev)
-{
-	unsigned char c;
-
-	sb_slot = PCI_SLOT(pdev->devfn);
-
-	printk(KERN_INFO "via686b fix: ISA bridge\n");
-
-	/*  Enable I/O Recovery time */
-	pci_write_config_byte(pdev, 0x40, 0x08);
-
-	/*  Enable ISA refresh */
-	pci_write_config_byte(pdev, 0x41, 0x01);
-
-	/*  disable ISA line buffer */
-	pci_write_config_byte(pdev, 0x45, 0x00);
-
-	/*  Gate INTR, and flush line buffer */
-	pci_write_config_byte(pdev, 0x46, 0xe0);
-
-	/*  Disable PCI Delay Transaction, Enable EISA ports 4D0/4D1. */
-	/* pci_write_config_byte(pdev, 0x47, 0x20); */
-
-	/*
-	 *  enable PCI Delay Transaction, Enable EISA ports 4D0/4D1.
-	 *  enable time-out timer
-	 */
-	pci_write_config_byte(pdev, 0x47, 0xe6);
-
-	/*
-	 * enable level trigger on pci irqs: 9,10,11,13
-	 * important! without this PCI interrupts won't work
-	 */
-	outb(0x2e, 0x4d1);
-
-	/*  512 K PCI Decode */
-	pci_write_config_byte(pdev, 0x48, 0x01);
-
-	/*  Wait for PGNT before grant to ISA Master/DMA */
-	pci_write_config_byte(pdev, 0x4a, 0x84);
-
-	/*
-	 * Plug'n'Play
-	 *
-	 *  Parallel DRQ 3, Floppy DRQ 2 (default)
-	 */
-	pci_write_config_byte(pdev, 0x50, 0x0e);
-
-	/*
-	 * IRQ Routing for Floppy and Parallel port
-	 *
-	 *  IRQ 6 for floppy, IRQ 7 for parallel port
-	 */
-	pci_write_config_byte(pdev, 0x51, 0x76);
-
-	/* IRQ Routing for serial ports (take IRQ 3 and 4) */
-	pci_write_config_byte(pdev, 0x52, 0x34);
-
-	/*  All IRQ's level triggered. */
-	pci_write_config_byte(pdev, 0x54, 0x00);
-
-	/* route PIRQA-D irq */
-	pci_write_config_byte(pdev, 0x55, 0x90);	/* bit 7-4, PIRQA */
-	pci_write_config_byte(pdev, 0x56, 0xba);	/* bit 7-4, PIRQC; */
-							/* 3-0, PIRQB */
-	pci_write_config_byte(pdev, 0x57, 0xd0);	/* bit 7-4, PIRQD */
-
-	/* enable function 5/6, audio/modem */
-	pci_read_config_byte(pdev, 0x85, &c);
-	c &= ~(0x3 << 2);
-	pci_write_config_byte(pdev, 0x85, c);
-
-	printk(KERN_INFO"via686b fix: ISA bridge done\n");
-}
-
-static void __init loongson2e_686b_func1_fixup(struct pci_dev *pdev)
-{
-	printk(KERN_INFO"via686b fix: IDE\n");
-
-	/* Modify IDE controller setup */
-	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 48);
-	pci_write_config_byte(pdev, PCI_COMMAND,
-			      PCI_COMMAND_IO | PCI_COMMAND_MEMORY |
-			      PCI_COMMAND_MASTER);
-	pci_write_config_byte(pdev, 0x40, 0x0b);
-	/* legacy mode */
-	pci_write_config_byte(pdev, 0x42, 0x09);
-
-#if 1/* play safe, otherwise we may see notebook's usb keyboard lockup */
-	/* disable read prefetch/write post buffers */
-	pci_write_config_byte(pdev, 0x41, 0x02);
-
-	/* use 3/4 as fifo thresh hold  */
-	pci_write_config_byte(pdev, 0x43, 0x0a);
-	pci_write_config_byte(pdev, 0x44, 0x00);
-
-	pci_write_config_byte(pdev, 0x45, 0x00);
-#else
-	pci_write_config_byte(pdev, 0x41, 0xc2);
-	pci_write_config_byte(pdev, 0x43, 0x35);
-	pci_write_config_byte(pdev, 0x44, 0x1c);
-
-	pci_write_config_byte(pdev, 0x45, 0x10);
-#endif
-
-	printk(KERN_INFO"via686b fix: IDE done\n");
-}
-
-static void __init loongson2e_686b_func2_fixup(struct pci_dev *pdev)
-{
-	/* irq routing */
-	pci_write_config_byte(pdev, PCI_INTERRUPT_LINE, 10);
-}
-
-static void __init loongson2e_686b_func3_fixup(struct pci_dev *pdev)
-{
-	/* irq routing */
-	pci_write_config_byte(pdev, PCI_INTERRUPT_LINE, 11);
-}
-
-static void __init loongson2e_686b_func5_fixup(struct pci_dev *pdev)
-{
-	unsigned int val;
-	unsigned char c;
-
-	/* enable IO */
-	pci_write_config_byte(pdev, PCI_COMMAND,
-			      PCI_COMMAND_IO | PCI_COMMAND_MEMORY |
-			      PCI_COMMAND_MASTER);
-	pci_read_config_dword(pdev, 0x4, &val);
-	pci_write_config_dword(pdev, 0x4, val | 1);
-
-	/* route ac97 IRQ */
-	pci_write_config_byte(pdev, 0x3c, 9);
-
-	pci_read_config_byte(pdev, 0x8, &c);
-
-	/* link control: enable link & SGD PCM output */
-	pci_write_config_byte(pdev, 0x41, 0xcc);
-
-	/* disable game port, FM, midi, sb, enable write to reg2c-2f */
-	pci_write_config_byte(pdev, 0x42, 0x20);
-
-	/* we are using Avance logic codec */
-	pci_write_config_word(pdev, 0x2c, 0x1005);
-	pci_write_config_word(pdev, 0x2e, 0x4710);
-	pci_read_config_dword(pdev, 0x2c, &val);
-
-	pci_write_config_byte(pdev, 0x42, 0x0);
-}
-
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C686,
-			 loongson2e_686b_func0_fixup);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C586_1,
-			 loongson2e_686b_func1_fixup);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C586_2,
-			 loongson2e_686b_func2_fixup);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C586_3,
-			 loongson2e_686b_func3_fixup);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C686_5,
-			 loongson2e_686b_func5_fixup);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NEC, PCI_DEVICE_ID_NEC_USB,
-			 loongson2e_nec_fixup);
diff --git a/arch/mips/pci/ops-bonito64.c b/arch/mips/pci/ops-bonito64.c
index f742c51..54e55e7 100644
--- a/arch/mips/pci/ops-bonito64.c
+++ b/arch/mips/pci/ops-bonito64.c
@@ -29,7 +29,7 @@
 #define PCI_ACCESS_READ  0
 #define PCI_ACCESS_WRITE 1
 
-#ifdef CONFIG_LEMOTE_FULONG
+#ifdef CONFIG_LEMOTE_FULOONG2E
 #define CFG_SPACE_REG(offset) (void *)CKSEG1ADDR(BONITO_PCICFG_BASE | (offset))
 #define ID_SEL_BEGIN 11
 #else
@@ -77,7 +77,7 @@ static int bonito64_pcibios_config_access(unsigned char access_type,
 	addrp = CFG_SPACE_REG(addr & 0xffff);
 	if (access_type == PCI_ACCESS_WRITE) {
 		writel(cpu_to_le32(*data), addrp);
-#ifndef CONFIG_LEMOTE_FULONG
+#ifndef CONFIG_LEMOTE_FULOONG2E
 		/* Wait till done */
 		while (BONITO_PCIMSTAT & 0xF);
 #endif
-- 
1.6.2.1

