Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbYEEMbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbYEEMbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 08:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444AbYEEMbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 08:31:38 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54430 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752181AbYEEMbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 08:31:37 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 34/56] microblaze_v2: io.h IO operations
Date: Sun,  4 May 2008 13:41:23 +0200
Message-Id: <491f823fac6c03cc36834ec569a45d30a03a72cf.1209897266.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <c4000ff625bd217f9bb683e3bf8c7193a82bd744.1209897266.git.monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
 <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>
 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
 <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu>
 <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu>
 <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
 <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu>
 <2f801c33caee22e112af51ae927c264ce99ead01.1209897266.git.monstr@monstr.eu>
 <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>
 <0873f3a1f3b72591735c6461b51964693cac52e5.1209897266.git.monstr@monstr.eu>
 <0ba1f259d3c17eba54e334622493577493f5065f.1209897266.git.monstr@monstr.eu>
 <694451053534fea7b78fb9d618b53a2b5ebeb602.1209897266.git.monstr@monstr.eu>
 <f0c837df4106a31c1a81917596603918f722ea7b.1209897266.git.monstr@monstr.eu>
 <d883a8d8da812d77fefd47730d28d0bdb7b504e0.1209897266.git.monstr@monstr.eu>
 <625ef466cf121d655539eedc919dd39166087e0c.1209897266.git.monstr@monstr.eu>
 <b5067a1846075ddd1035966ea1edc908579e2e88.1209897266.git.monstr@monstr.eu>
 <378157891bac535dbc55e658d5f03fdd332e85cf.1209897266.git.monstr@monstr.eu>
 <eadcc6f4754df78b69d6d54c404624d0390c8558.1209897266.git.monstr@monstr.eu>
 <4df4022e06b9056202cc2fdf0b99deb01563a0fa.1209897266.git.monstr@monstr.eu>
 <6b0c9864dc80776ae48d6488a6892e5d698751b7.1209897266.git.monstr@monstr.eu>
 <ea5cbbca49c38c506960fddba29cbd8cb24e1a8d.1209897266.git.monstr@monstr.eu>
 <4f4d6ed3fce9b21cdd6dcacb2d72fff7e9830628.1209897266.git.monstr@monstr.eu>
 <35e662a81eb86c7ffb2aaa6141ca38a07789f382.1209897266.git.monstr@monstr.eu>
 <b41fcf3dd830f4ba82692a9bec2406ed0c290e7e.1209897266.git.monstr@monstr.eu>
 <14acb31da2794d2d5916da3db3d75fe2285ac055.1209897266.git.monstr@monstr.eu>
 <598221ce2159046614d7b158ea62d5af51907af3.1209897266.git.monstr@monstr.eu>
 <41c1f410eaafd875246362d10ef9866d8cc2a934.1209897266.git.monstr@monstr.eu>
 <09ce2baf0c8308d3fbca98e7eb36a6aab59112a7.1209897266.git.monstr@monstr.eu>
 <c9418c683be99ae12abb89575c362d586c026bad.1209897266.git.monstr@monstr.eu>
 <cfde3796e95bdd17c32e4fd7762d0aee55967707.1209897266.git.monstr@monstr.eu>
 <8aba2d82c85cd1d5b56de328c1fd080ee51f0211.1209897266.git.monstr@monstr.eu>
 <c4000ff625bd217f9bb683e3bf8c7193a82bd744.1209897266.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/io.h |  210 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 210 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/io.h

diff --git a/include/asm-microblaze/io.h b/include/asm-microblaze/io.h
new file mode 100644
index 0000000..d2c492f
--- /dev/null
+++ b/include/asm-microblaze/io.h
@@ -0,0 +1,210 @@
+/*
+ * include/asm-microblaze/io.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_IO_H
+#define _ASM_MICROBLAZE_IO_H
+
+#include <asm/byteorder.h>
+#include <asm/page.h>
+
+static inline unsigned char __raw_readb(const volatile void *addr)
+{
+	return *(volatile unsigned char __force *)addr;
+}
+static inline unsigned short __raw_readw(const volatile void *addr)
+{
+	return *(volatile unsigned short __force *)addr;
+}
+static inline unsigned int __raw_readl(const volatile void *addr)
+{
+	return *(volatile unsigned int __force *)addr;
+}
+static inline unsigned long __raw_readq(const volatile void *addr)
+{
+	return *(volatile unsigned long __force *)addr;
+}
+static inline void __raw_writeb(unsigned char v, volatile void *addr)
+{
+	*(volatile unsigned char __force *)addr = v;
+}
+static inline void __raw_writew(unsigned short v, volatile void *addr)
+{
+	*(volatile unsigned short __force *)addr = v;
+}
+static inline void __raw_writel(unsigned int v, volatile void *addr)
+{
+	*(volatile unsigned int __force *)addr = v;
+}
+static inline void __raw_writeq(unsigned long v, volatile void *addr)
+{
+	*(volatile unsigned long __force *)addr = v;
+}
+
+/*
+ * read (readb, readw, readl, readq) and write (writeb, writew,
+ * writel, writeq) accessors are for PCI and thus littel endian.
+ * Linux 2.4 for Microblaze had this wrong.
+ */
+static inline unsigned char readb(const volatile void *addr)
+{
+	return *(volatile unsigned char __force *)addr;
+}
+static inline unsigned short readw(const volatile void *addr)
+{
+	return le16_to_cpu(*(volatile unsigned short __force *)addr);
+}
+static inline unsigned int readl(const volatile void *addr)
+{
+	return le32_to_cpu(*(volatile unsigned int __force *)addr);
+}
+static inline void writeb(unsigned char v, volatile void *addr)
+{
+	*(volatile unsigned char __force *)addr = v;
+}
+static inline void writew(unsigned short v, volatile void *addr)
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
+ *	virt_to_phys	-	map virtual addresses to physical
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
+ *	phys_to_virt	-	map physical address to virtual
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
+static inline void *__ioremap(unsigned long address, unsigned long size,
+			unsigned long flags)
+{
+	return (void *)address;
+}
+
+
+#define IO_SPACE_LIMIT ~(0UL)
+
+#define ioremap(physaddr, size)	((void *)(unsigned long)(physaddr))
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
+#define out_be32(a, v) __raw_writel((v), (a))
+#define out_be16(a, v) __raw_writew((v), (a))
+
+#define in_be32(a) __raw_readl(a)
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
1.5.4.GIT

