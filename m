Return-Path: <linux-kernel-owner+w=401wt.eu-S1760018AbZCRVxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018AbZCRVxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758145AbZCRVnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:43:39 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54475 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757903AbZCRVnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:43:37 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 35/57] microblaze_v7: io.h IO operations
Date: Wed, 18 Mar 2009 21:31:02 +0100
Message-Id: <fde2defbb60d9476df3aac0dc7d87241ed247d3e.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <592d2a1c72581b6abf73841e640e7b7306c3ec3b.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
 <f7c1685bd3f387be8633db5fb3dd4cb5e7c2d792.1237407249.git.monstr@monstr.eu>
 <2f48efc353c11dfdfc7b052bdfe052b71c09ab23.1237407249.git.monstr@monstr.eu>
 <f7f2d17e21a3df9931c75976c37a003d11190cc9.1237407249.git.monstr@monstr.eu>
 <58cf06c85e07477170677b72ce3437af10476bec.1237407249.git.monstr@monstr.eu>
 <eaa0169a360a328883ab0eabd2a189c21bad4c30.1237407249.git.monstr@monstr.eu>
 <20227d6f2615060d6560785090513e251cbe2654.1237407249.git.monstr@monstr.eu>
 <69ef4f976d86c870a97fbe4974c242c74acc477d.1237407249.git.monstr@monstr.eu>
 <eb4ccc67cf39abc816c8d7653fdc7561d14c1da2.1237407249.git.monstr@monstr.eu>
 <1477ec41e7ba0ec847a064e1f8e422dc2a5dcc9f.1237407249.git.monstr@monstr.eu>
 <75127eae09c978220d452d92f95763dde24f1d52.1237407249.git.monstr@monstr.eu>
 <b726b7b271cf303c36af54c4e155140541a6769b.1237407249.git.monstr@monstr.eu>
 <644f08d7f8cd338e606ed703e221914f75588fb5.1237407249.git.monstr@monstr.eu>
 <6d19f608a4ba3e7718aa55794c2845f19b5ed5e2.1237407249.git.monstr@monstr.eu>
 <039bc2fea33d23a3e7d2d85ac6fb275b8d21b5ed.1237407249.git.monstr@monstr.eu>
 <513d4067a84be1ecb47577e1edf131d2b3572808.1237407249.git.monstr@monstr.eu>
 <c6a6fbe7b56db27d9b74ee593cf068963f86ee58.1237407249.git.monstr@monstr.eu>
 <e9d4d452140c50451741dd6024ab89efd24ac8e6.1237407249.git.monstr@monstr.eu>
 <f8494212852d4cec890ae5e152353c91153c7c0d.1237407249.git.monstr@monstr.eu>
 <5c66d0329884feb553ae745584f6db589a892eb1.1237407249.git.monstr@monstr.eu>
 <72b06b8fa7b051005ebfa5c23c53a40d6a27f94a.1237407249.git.monstr@monstr.eu>
 <aa044d06327435cee76599fb6220630007f38ba7.1237407249.git.monstr@monstr.eu>
 <99fdae6e9b1da3ae5e2d3ebc841d1afdc694dfae.1237407249.git.monstr@monstr.eu>
 <29d86e7cd1124e596c9dde627f397ca98dccf572.1237407249.git.monstr@monstr.eu>
 <827e2a6a349e009f6c98f31178ce84042b0e2e10.1237407249.git.monstr@monstr.eu>
 <6eb167a9a027d644f10b843b8b1bde66e4c2ee25.1237407249.git.monstr@monstr.eu>
 <592d2a1c72581b6abf73841e640e7b7306c3ec3b.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/io.h |  209 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 209 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/include/asm/io.h

diff --git a/arch/microblaze/include/asm/io.h b/arch/microblaze/include/asm/io.h
new file mode 100644
index 0000000..4ff514e
--- /dev/null
+++ b/arch/microblaze/include/asm/io.h
@@ -0,0 +1,209 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_IO_H
+#define _ASM_MICROBLAZE_IO_H
+
+#include <asm/byteorder.h>
+#include <asm/page.h>
+#include <linux/types.h>
+#include <asm/page.h>
+
+#define IO_SPACE_LIMIT ~(0UL)
+
+static inline unsigned char __raw_readb(const volatile void __iomem *addr)
+{
+	return *(volatile unsigned char __force *)addr;
+}
+static inline unsigned short __raw_readw(const volatile void __iomem *addr)
+{
+	return *(volatile unsigned short __force *)addr;
+}
+static inline unsigned int __raw_readl(const volatile void __iomem *addr)
+{
+	return *(volatile unsigned int __force *)addr;
+}
+static inline unsigned long __raw_readq(const volatile void __iomem *addr)
+{
+	return *(volatile unsigned long __force *)addr;
+}
+static inline void __raw_writeb(unsigned char v, volatile void __iomem *addr)
+{
+	*(volatile unsigned char __force *)addr = v;
+}
+static inline void __raw_writew(unsigned short v, volatile void __iomem *addr)
+{
+	*(volatile unsigned short __force *)addr = v;
+}
+static inline void __raw_writel(unsigned int v, volatile void __iomem *addr)
+{
+	*(volatile unsigned int __force *)addr = v;
+}
+static inline void __raw_writeq(unsigned long v, volatile void __iomem *addr)
+{
+	*(volatile unsigned long __force *)addr = v;
+}
+
+/*
+ * read (readb, readw, readl, readq) and write (writeb, writew,
+ * writel, writeq) accessors are for PCI and thus littel endian.
+ * Linux 2.4 for Microblaze had this wrong.
+ */
+static inline unsigned char readb(const volatile void __iomem *addr)
+{
+	return *(volatile unsigned char __force *)addr;
+}
+static inline unsigned short readw(const volatile void __iomem *addr)
+{
+	return le16_to_cpu(*(volatile unsigned short __force *)addr);
+}
+static inline unsigned int readl(const volatile void __iomem *addr)
+{
+	return le32_to_cpu(*(volatile unsigned int __force *)addr);
+}
+static inline void writeb(unsigned char v, volatile void __iomem *addr)
+{
+	*(volatile unsigned char __force *)addr = v;
+}
+static inline void writew(unsigned short v, volatile void __iomem *addr)
+{
+	*(volatile unsigned short __force *)addr = cpu_to_le16(v);
+}
+static inline void writel(unsigned int v, volatile void __iomem *addr)
+{
+	*(volatile unsigned int __force *)addr = cpu_to_le32(v);
+}
+
+/* ioread and iowrite variants. thease are for now same as __raw_
+ * variants of accessors. we might check for endianess in the feature
+ */
+#define ioread8(addr)		__raw_readb((u8 *)(addr))
+#define ioread16(addr)		__raw_readw((u16 *)(addr))
+#define ioread32(addr)		__raw_readl((u32 *)(addr))
+#define iowrite8(v, addr)	__raw_writeb((u8)(v), (u8 *)(addr))
+#define iowrite16(v, addr)	__raw_writew((u16)(v), (u16 *)(addr))
+#define iowrite32(v, addr)	__raw_writel((u32)(v), (u32 *)(addr))
+
+/* These are the definitions for the x86 IO instructions
+ * inb/inw/inl/outb/outw/outl, the "string" versions
+ * insb/insw/insl/outsb/outsw/outsl, and the "pausing" versions
+ * inb_p/inw_p/...
+ * The macros don't do byte-swapping.
+ */
+#define inb(port)		readb((u8 *)((port)))
+#define outb(val, port)		writeb((val), (u8 *)((unsigned long)(port)))
+#define inw(port)		readw((u16 *)((port)))
+#define outw(val, port)		writew((val), (u16 *)((unsigned long)(port)))
+#define inl(port)		readl((u32 *)((port)))
+#define outl(val, port)		writel((val), (u32 *)((unsigned long)(port)))
+
+#define inb_p(port)		inb((port))
+#define outb_p(val, port)	outb((val), (port))
+#define inw_p(port)		inw((port))
+#define outw_p(val, port)	outw((val), (port))
+#define inl_p(port)		inl((port))
+#define outl_p(val, port)	outl((val), (port))
+
+#define memset_io(a, b, c)	memset((void *)(a), (b), (c))
+#define memcpy_fromio(a, b, c)	memcpy((a), (void *)(b), (c))
+#define memcpy_toio(a, b, c)	memcpy((void *)(a), (b), (c))
+
+/**
+ *	virt_to_phys - map virtual addresses to physical
+ *	@address: address to remap
+ *
+ *	The returned physical address is the physical (CPU) mapping for
+ *	the memory address given. It is only valid to use this function on
+ *	addresses directly mapped or allocated via kmalloc.
+ *
+ *	This function does not give bus mappings for DMA transfers. In
+ *	almost all conceivable cases a device driver should not be using
+ *	this function
+ */
+static inline unsigned long __iomem virt_to_phys(volatile void *address)
+{
+	return __pa((unsigned long)address);
+}
+
+#define virt_to_bus virt_to_phys
+
+/**
+ *	phys_to_virt - map physical address to virtual
+ *	@address: address to remap
+ *
+ *	The returned virtual address is a current CPU mapping for
+ *	the memory address given. It is only valid to use this function on
+ *	addresses that have a kernel mapping
+ *
+ *	This function does not handle bus mappings for DMA transfers. In
+ *	almost all conceivable cases a device driver should not be using
+ *	this function
+ */
+static inline void *phys_to_virt(unsigned long address)
+{
+	return (void *)__va(address);
+}
+
+#define bus_to_virt(a) phys_to_virt(a)
+
+static inline void __iomem *__ioremap(phys_addr_t address, unsigned long size,
+			unsigned long flags)
+{
+	return (void *)address;
+}
+
+#define ioremap(physaddr, size)	((void __iomem *)(unsigned long)(physaddr))
+#define iounmap(addr)		((void)0)
+#define ioremap_nocache(physaddr, size)	ioremap(physaddr, size)
+
+/*
+ * Convert a physical pointer to a virtual kernel pointer for /dev/mem
+ * access
+ */
+#define xlate_dev_mem_ptr(p)	__va(p)
+
+/*
+ * Convert a virtual cached pointer to an uncached pointer
+ */
+#define xlate_dev_kmem_ptr(p)	p
+
+/*
+ * Big Endian
+ */
+#define out_be32(a, v) __raw_writel((v), (void __iomem __force *)(a))
+#define out_be16(a, v) __raw_writew((v), (a))
+
+#define in_be32(a) __raw_readl((const void __iomem __force *)(a))
+#define in_be16(a) __raw_readw(a)
+
+/*
+ * Little endian
+ */
+
+#define out_le32(a, v) __raw_writel(__cpu_to_le32(v), (a));
+#define out_le16(a, v) __raw_writew(__cpu_to_le16(v), (a))
+
+#define in_le32(a) __le32_to_cpu(__raw_readl(a))
+#define in_le16(a) __le16_to_cpu(__raw_readw(a))
+
+/* Byte ops */
+#define out_8(a, v) __raw_writeb((v), (a))
+#define in_8(a) __raw_readb(a)
+
+/* FIXME */
+static inline void __iomem *ioport_map(unsigned long port, unsigned int len)
+{
+	return (void __iomem *) (port);
+}
+
+static inline void ioport_unmap(void __iomem *addr)
+{
+	/* Nothing to do */
+}
+
+#endif /* _ASM_MICROBLAZE_IO_H */
-- 
1.5.5.1

