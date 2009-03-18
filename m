Return-Path: <linux-kernel-owner+w=401wt.eu-S1760516AbZCRVw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760516AbZCRVw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758068AbZCRVng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:43:36 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54475 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757965AbZCRVnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:43:33 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 30/57] microblaze_v7: page.h, segment.h, unaligned.h
Date: Wed, 18 Mar 2009 21:30:57 +0100
Message-Id: <99fdae6e9b1da3ae5e2d3ebc841d1afdc694dfae.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <aa044d06327435cee76599fb6220630007f38ba7.1237407249.git.monstr@monstr.eu>
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
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/page.h      |  139 +++++++++++++++++++++++++++++++
 arch/microblaze/include/asm/segment.h   |   43 ++++++++++
 arch/microblaze/include/asm/unaligned.h |   22 +++++
 3 files changed, 204 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/include/asm/page.h
 create mode 100644 arch/microblaze/include/asm/segment.h
 create mode 100644 arch/microblaze/include/asm/unaligned.h

diff --git a/arch/microblaze/include/asm/page.h b/arch/microblaze/include/asm/page.h
new file mode 100644
index 0000000..15db1ea
--- /dev/null
+++ b/arch/microblaze/include/asm/page.h
@@ -0,0 +1,139 @@
+/*
+ * Copyright (C) 2008 Michal Simek
+ * Copyright (C) 2008 PetaLogix
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ * Changes for MMU support:
+ *    Copyright (C) 2007 Xilinx, Inc.  All rights reserved.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_PAGE_H
+#define _ASM_MICROBLAZE_PAGE_H
+
+#include <linux/pfn.h>
+#include <asm/setup.h>
+
+/* PAGE_SHIFT determines the page size */
+#define PAGE_SHIFT	(12)
+#define PAGE_SIZE	(1UL << PAGE_SHIFT)
+#define PAGE_MASK	(~(PAGE_SIZE-1))
+
+#ifdef __KERNEL__
+
+#ifndef __ASSEMBLY__
+
+#define PAGE_UP(addr)	(((addr)+((PAGE_SIZE)-1))&(~((PAGE_SIZE)-1)))
+#define PAGE_DOWN(addr)	((addr)&(~((PAGE_SIZE)-1)))
+
+/* align addr on a size boundary - adjust address up/down if needed */
+#define _ALIGN_UP(addr, size)	(((addr)+((size)-1))&(~((size)-1)))
+#define _ALIGN_DOWN(addr, size)	((addr)&(~((size)-1)))
+
+/* align addr on a size boundary - adjust address up if needed */
+#define _ALIGN(addr, size)	_ALIGN_UP(addr, size)
+
+/*
+ * PAGE_OFFSET -- the first address of the first page of memory. When not
+ * using MMU this corresponds to the first free page in physical memory (aligned
+ * on a page boundary).
+ */
+extern unsigned int __page_offset;
+#define PAGE_OFFSET __page_offset
+
+#define copy_page(to, from)			memcpy((to), (from), PAGE_SIZE)
+#define get_user_page(vaddr)			__get_free_page(GFP_KERNEL)
+#define free_user_page(page, addr)		free_page(addr)
+
+#define clear_page(pgaddr)			memset((pgaddr), 0, PAGE_SIZE)
+
+
+#define clear_user_page(pgaddr, vaddr, page)	memset((pgaddr), 0, PAGE_SIZE)
+#define copy_user_page(vto, vfrom, vaddr, topg) \
+			memcpy((vto), (vfrom), PAGE_SIZE)
+
+/*
+ * These are used to make use of C type-checking..
+ */
+typedef struct page *pgtable_t;
+typedef struct { unsigned long	pte; }		pte_t;
+typedef struct { unsigned long	pgprot; }	pgprot_t;
+typedef struct { unsigned long	ste[64]; }	pmd_t;
+typedef struct { pmd_t		pue[1]; }	pud_t;
+typedef struct { pud_t		pge[1]; }	pgd_t;
+
+
+#define pte_val(x)	((x).pte)
+#define pgprot_val(x)	((x).pgprot)
+#define pmd_val(x)	((x).ste[0])
+#define pud_val(x)	((x).pue[0])
+#define pgd_val(x)	((x).pge[0])
+
+#define __pte(x)	((pte_t) { (x) })
+#define __pmd(x)	((pmd_t) { (x) })
+#define __pgd(x)	((pgd_t) { (x) })
+#define __pgprot(x)	((pgprot_t) { (x) })
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
+extern unsigned int memory_start;
+extern unsigned int memory_end;
+extern unsigned int memory_size;
+
+#define pfn_valid(pfn)		((pfn) >= min_low_pfn && (pfn) < max_mapnr)
+
+#define ARCH_PFN_OFFSET		(PAGE_OFFSET >> PAGE_SHIFT)
+
+#endif /* __ASSEMBLY__ */
+
+#define virt_addr_valid(vaddr)	(pfn_valid(virt_to_pfn(vaddr)))
+
+/* Convert between virtual and physical address for MMU.  */
+/* Handle MicroBlaze processor with virtual memory.  */
+#define __virt_to_phys(addr)	addr
+#define __phys_to_virt(addr)	addr
+#define tophys(rd,rs)	addik rd,rs,0
+#define tovirt(rd,rs)	addik rd,rs,0
+
+#define TOPHYS(addr)  __virt_to_phys(addr)
+
+#endif /* __KERNEL__ */
+
+#include <asm-generic/memory_model.h>
+#include <asm-generic/page.h>
+
+#endif /* _ASM_MICROBLAZE_PAGE_H */
diff --git a/arch/microblaze/include/asm/segment.h b/arch/microblaze/include/asm/segment.h
new file mode 100644
index 0000000..7f5dcc5
--- /dev/null
+++ b/arch/microblaze/include/asm/segment.h
@@ -0,0 +1,43 @@
+/*
+ * Copyright (C) 2008 Michal Simek
+ * Copyright (C) 2008 PetaLogix
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
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
+ * On Microblaze the fs value is actually the top of the corresponding
+ * address space.
+ *
+ * The fs value determines whether argument validity checking should be
+ * performed or not. If get_fs() == USER_DS, checking is performed, with
+ * get_fs() == KERNEL_DS, checking is bypassed.
+ *
+ * For historical reasons, these macros are grossly misnamed.
+ *
+ * For non-MMU arch like Microblaze, KERNEL_DS and USER_DS is equal.
+ */
+#  define KERNEL_DS	((mm_segment_t){0})
+#  define USER_DS	KERNEL_DS
+
+# define get_ds()	(KERNEL_DS)
+# define get_fs()	(current_thread_info()->addr_limit)
+# define set_fs(x) \
+		do { current_thread_info()->addr_limit = (x); } while (0)
+
+# define segment_eq(a, b)		((a).seg == (b).seg)
+
+# endif /* __ASSEMBLY__ */
+#endif /* _ASM_MICROBLAZE_SEGMENT_H */
diff --git a/arch/microblaze/include/asm/unaligned.h b/arch/microblaze/include/asm/unaligned.h
new file mode 100644
index 0000000..9d66b64
--- /dev/null
+++ b/arch/microblaze/include/asm/unaligned.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (C) 2008 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_UNALIGNED_H
+#define _ASM_MICROBLAZE_UNALIGNED_H
+
+# ifdef __KERNEL__
+
+# include <linux/unaligned/access_ok.h>
+# include <linux/unaligned/generic.h>
+
+# define get_unaligned	__get_unaligned_be
+# define put_unaligned	__put_unaligned_be
+
+# endif	/* __KERNEL__ */
+#endif /* _ASM_MICROBLAZE_UNALIGNED_H */
-- 
1.5.5.1

