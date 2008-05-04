Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbYEEMZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbYEEMZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 08:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbYEEMYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 08:24:41 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:59580 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752749AbYEEMYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 08:24:38 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 29/56] microblaze_v2: page.h, segment.h, unaligned.h
Date: Sun,  4 May 2008 13:41:18 +0200
Message-Id: <09ce2baf0c8308d3fbca98e7eb36a6aab59112a7.1209897266.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <41c1f410eaafd875246362d10ef9866d8cc2a934.1209897266.git.monstr@monstr.eu>
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
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/page.h      |  119 ++++++++++++++++++++++++++++++++++++
 include/asm-microblaze/segment.h   |   42 +++++++++++++
 include/asm-microblaze/unaligned.h |   16 +++++
 3 files changed, 177 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/page.h
 create mode 100644 include/asm-microblaze/segment.h
 create mode 100644 include/asm-microblaze/unaligned.h

diff --git a/include/asm-microblaze/page.h b/include/asm-microblaze/page.h
new file mode 100644
index 0000000..5c7c262
--- /dev/null
+++ b/include/asm-microblaze/page.h
@@ -0,0 +1,119 @@
+/*
+ * include/asm-microblaze/page.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_PAGE_H
+#define _ASM_MICROBLAZE_PAGE_H
+
+#include <linux/autoconf.h>
+#include <linux/pfn.h>
+
+/* PAGE_SHIFT determines the page size */
+
+#define PAGE_SHIFT	(12)
+#define PAGE_SIZE	(1UL << PAGE_SHIFT)
+#define PAGE_MASK	(~(PAGE_SIZE-1))
+
+#ifdef __KERNEL__
+
+#include <asm/setup.h>
+
+#ifndef __ASSEMBLY__
+
+#define get_user_page(vaddr)			__get_free_page(GFP_KERNEL)
+#define free_user_page(page, addr)		free_page(addr)
+
+#define clear_page(pgaddr)			memset((pgaddr), 0, PAGE_SIZE)
+#define copy_page(to, from)			memcpy((to), (from), PAGE_SIZE)
+
+#define clear_user_page(pgaddr, vaddr, page)	memset((pgaddr), 0, PAGE_SIZE)
+#define copy_user_page(vto, vfrom, vaddr, topg) \
+			memcpy((vto), (vfrom), PAGE_SIZE)
+
+/*
+ * These are used to make use of C type-checking..
+ */
+typedef struct { unsigned long	pte; }		pte_t;
+typedef struct { unsigned long	ste[64]; }	pmd_t;
+typedef struct { pmd_t		pue[1]; }	pud_t;
+typedef struct { pud_t		pge[1]; }	pgd_t;
+typedef struct { unsigned long	pgprot; }	pgprot_t;
+typedef struct page *pgtable_t;
+
+#define pte_val(x)	((x).pte)
+#define pmd_val(x)	((x).ste[0])
+#define pud_val(x)	((x).pue[0])
+#define pgd_val(x)	((x).pge[0])
+#define pgprot_val(x)	((x).pgprot)
+
+#define __pte(x)	((pte_t) { (x) })
+#define __pmd(x)	((pmd_t) { (x) })
+#define __pgd(x)	((pgd_t) { (x) })
+#define __pgprot(x)	((pgprot_t) { (x) })
+
+/* align addr on a size boundary - adjust address up/down if needed */
+#define _ALIGN_UP(addr, size)	(((addr)+((size)-1))&(~((size)-1)))
+#define _ALIGN_DOWN(addr, size)	((addr)&(~((size)-1)))
+
+/* align addr on a size boundary - adjust address up if needed */
+#define _ALIGN(addr, size)	_ALIGN_UP(addr, size)
+
+/* to align the pointer to the (next) page boundary */
+#define PAGE_ALIGN(addr)	(((addr) + PAGE_SIZE - 1) & PAGE_MASK)
+
+extern unsigned int __page_offset;
+#define PAGE_OFFSET __page_offset
+
+/**
+ * Conversions for virtual address, physical address, pfn, and struct
+ * page are defined in the following files.
+ *
+ * virt -+
+ *	 | asm-microblaze/page.h
+ * phys -+
+ *	 | linux/pfn.h
+ *  pfn -+
+ *	 | asm-generic/memory_model.h
+ * page -+
+ *
+ */
+
+extern unsigned long max_low_pfn;
+extern unsigned long min_low_pfn;
+extern unsigned long max_pfn;
+
+#define __pa(vaddr)		((unsigned long) (vaddr))
+#define __va(paddr)		((void *) (paddr))
+
+#define phys_to_pfn(phys)	(PFN_DOWN(phys))
+#define pfn_to_phys(pfn)	(PFN_PHYS(pfn))
+
+#define virt_to_pfn(vaddr)	(phys_to_pfn((__pa(vaddr))))
+#define pfn_to_virt(pfn)	__va(pfn_to_phys((pfn)))
+
+#define virt_to_page(vaddr)	(pfn_to_page(virt_to_pfn(vaddr)))
+#define page_to_virt(page)	(pfn_to_virt(page_to_pfn(page)))
+
+#define page_to_phys(page)	(pfn_to_phys(page_to_pfn(page)))
+#define page_to_bus(page)	(page_to_phys(page))
+#define phys_to_page(paddr)	(pfn_to_page(phys_to_pfn(paddr)))
+
+#define pfn_valid(pfn)		((pfn) >= min_low_pfn && (pfn) < max_mapnr)
+#define	virt_addr_valid(vaddr)	(pfn_valid(virt_to_pfn(vaddr)))
+
+#define ARCH_PFN_OFFSET		(PAGE_OFFSET >> PAGE_SHIFT)
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* __KERNEL__ */
+
+#include <asm-generic/memory_model.h>
+#include <asm-generic/page.h>
+
+#endif /* _ASM_MICROBLAZE_PAGE_H */
diff --git a/include/asm-microblaze/segment.h b/include/asm-microblaze/segment.h
new file mode 100644
index 0000000..af0ddf0
--- /dev/null
+++ b/include/asm-microblaze/segment.h
@@ -0,0 +1,42 @@
+/*
+ * include/asm-microblaze/segment.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ */
+
+#ifndef _ASM_MICROBLAZE_SEGMENT_H
+#define _ASM_MICROBLAZE_SEGMENT_H
+
+#ifndef __ASSEMBLY__
+
+typedef struct {
+	unsigned long seg;
+} mm_segment_t;
+
+/*
+ * The fs value determines whether argument validity checking should be
+ * performed or not. If get_fs() == USER_DS, checking is performed, with
+ * get_fs() == KERNEL_DS, checking is bypassed.
+ *
+ * For historical reasons, these macros are grossly misnamed.
+ *
+ * For non-MMU arch like Microblaze, KERNEL_DS and USER_DS is equal.
+ */
+#define KERNEL_DS	((mm_segment_t){0})
+#define USER_DS		KERNEL_DS
+
+#define get_ds()	(KERNEL_DS)
+#define get_fs()	(current_thread_info()->addr_limit)
+#define set_fs(x) \
+		do { current_thread_info()->addr_limit = (x); } while (0)
+
+#define segment_eq(a, b)		((a).seg == (b).seg)
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_MICROBLAZE_SEGMENT_H */
diff --git a/include/asm-microblaze/unaligned.h b/include/asm-microblaze/unaligned.h
new file mode 100644
index 0000000..aff800d
--- /dev/null
+++ b/include/asm-microblaze/unaligned.h
@@ -0,0 +1,16 @@
+/*
+ * include/asm-microblaze/unaligned.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_UNALIGNED_H
+#define _ASM_MICROBLAZE_UNALIGNED_H
+
+#include <asm-generic/unaligned.h>
+
+#endif /* _ASM_MICROBLAZE_UNALIGNED_H */
-- 
1.5.4.GIT

