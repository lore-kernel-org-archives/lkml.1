Return-Path: <linux-kernel-owner+w=401wt.eu-S1765652AbZD3TD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765652AbZD3TD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 15:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764798AbZD3TDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 15:03:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54735 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758002AbZD3TC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 15:02:56 -0400
Message-Id: <20090430185716.621755663@arndb.de>
References: <20090430185628.866082445@arndb.de>
User-Agent: quilt/0.46-1
Date: Thu, 30 Apr 2009 20:56:30 +0200
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: [PATCH v2 2/9] asm-generic: rename page.h to getorder.h
Content-Disposition: inline; filename=0002-asm-generic-rename-page.h-to-getorder.h.patch
X-Provags-ID: V01U2FsdGVkX18uOo4fe0FRwlilUxLr7fIn1FI9BejfjkDWMJg
 DahwXzly3XANsPOqW7qhTx2f9lDqm77mjRjxnhjrHZ14DQw+4o
 yhHIKB6165GqSAC3Glpvw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current asm-generic/page.h only contains the get_order
function. This renames the file to getorder.h to make
room for a new page.h file that will be usable by all
nommu architectures.

Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/alpha/include/asm/page.h              |    2 +-
 arch/arm/include/asm/page.h                |    2 +-
 arch/blackfin/include/asm/page.h           |    2 +-
 arch/cris/include/asm/page.h               |    2 +-
 arch/frv/include/asm/page.h                |    2 +-
 arch/h8300/include/asm/page.h              |    2 +-
 arch/m32r/include/asm/page.h               |    2 +-
 arch/m68k/include/asm/page_mm.h            |    2 +-
 arch/m68k/include/asm/page_no.h            |    2 +-
 arch/microblaze/include/asm/page.h         |    2 +-
 arch/mips/include/asm/page.h               |    2 +-
 arch/parisc/include/asm/page.h             |    2 +-
 arch/powerpc/include/asm/page_32.h         |    2 +-
 arch/powerpc/include/asm/page_64.h         |    2 +-
 arch/s390/include/asm/page.h               |    2 +-
 arch/sh/include/asm/page.h                 |    2 +-
 arch/sparc/include/asm/page_32.h           |    2 +-
 arch/sparc/include/asm/page_64.h           |    2 +-
 arch/um/include/asm/page.h                 |    2 +-
 arch/x86/include/asm/page.h                |    2 +-
 arch/xtensa/include/asm/page.h             |    2 +-
 include/asm-generic/{page.h => getorder.h} |    8 ++++----
 22 files changed, 25 insertions(+), 25 deletions(-)
 rename include/asm-generic/{page.h => getorder.h} (59%)

diff --git a/arch/alpha/include/asm/page.h b/arch/alpha/include/asm/page.h
index 0995f9d..07af062 100644
--- a/arch/alpha/include/asm/page.h
+++ b/arch/alpha/include/asm/page.h
@@ -93,6 +93,6 @@ typedef struct page *pgtable_t;
 					 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
+#include <asm-generic/getorder.h>
 
 #endif /* _ALPHA_PAGE_H */
diff --git a/arch/arm/include/asm/page.h b/arch/arm/include/asm/page.h
index e6eb8a6..dee70a3 100644
--- a/arch/arm/include/asm/page.h
+++ b/arch/arm/include/asm/page.h
@@ -209,6 +209,6 @@ typedef struct page *pgtable_t;
 #define ARCH_SLAB_MINALIGN 8
 #endif
 
-#include <asm-generic/page.h>
+#include <asm-generic/getorder.h>
 
 #endif
diff --git a/arch/blackfin/include/asm/page.h b/arch/blackfin/include/asm/page.h
index 344f6a8..3ea2016 100644
--- a/arch/blackfin/include/asm/page.h
+++ b/arch/blackfin/include/asm/page.h
@@ -81,7 +81,7 @@ extern unsigned long memory_end;
 #define	virt_addr_valid(kaddr)	(((void *)(kaddr) >= (void *)PAGE_OFFSET) && \
 				((void *)(kaddr) < (void *)memory_end))
 
-#include <asm-generic/page.h>
+#include <asm-generic/getorder.h>
 
 #endif				/* __ASSEMBLY__ */
 
diff --git a/arch/cris/include/asm/page.h b/arch/cris/include/asm/page.h
index f3fdbd0..be45ee3 100644
--- a/arch/cris/include/asm/page.h
+++ b/arch/cris/include/asm/page.h
@@ -68,7 +68,7 @@ typedef struct page *pgtable_t;
 				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
+#include <asm-generic/getorder.h>
 
 #endif /* _CRIS_PAGE_H */
 
diff --git a/arch/frv/include/asm/page.h b/arch/frv/include/asm/page.h
index bd9c220..25c6a50 100644
--- a/arch/frv/include/asm/page.h
+++ b/arch/frv/include/asm/page.h
@@ -73,6 +73,6 @@ extern unsigned long max_pfn;
 #endif /* __ASSEMBLY__ */
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
+#include <asm-generic/getorder.h>
 
 #endif /* _ASM_PAGE_H */
diff --git a/arch/h8300/include/asm/page.h b/arch/h8300/include/asm/page.h
index 0b6acf0..837381a 100644
--- a/arch/h8300/include/asm/page.h
+++ b/arch/h8300/include/asm/page.h
@@ -73,6 +73,6 @@ extern unsigned long memory_end;
 #endif /* __ASSEMBLY__ */
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
+#include <asm-generic/getorder.h>
 
 #endif /* _H8300_PAGE_H */
diff --git a/arch/m32r/include/asm/page.h b/arch/m32r/include/asm/page.h
index c933308..11777f7 100644
--- a/arch/m32r/include/asm/page.h
+++ b/arch/m32r/include/asm/page.h
@@ -82,6 +82,6 @@ typedef struct page *pgtable_t;
 #define devmem_is_allowed(x) 1
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
+#include <asm-generic/getorder.h>
 
 #endif /* _ASM_M32R_PAGE_H */
diff --git a/arch/m68k/include/asm/page_mm.h b/arch/m68k/include/asm/page_mm.h
index a34b8ba..d009f3e 100644
--- a/arch/m68k/include/asm/page_mm.h
+++ b/arch/m68k/include/asm/page_mm.h
@@ -223,6 +223,6 @@ static inline __attribute_const__ int __virt_to_node_shift(void)
 #define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
 				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
-#include <asm-generic/page.h>
+#include <asm-generic/getorder.h>
 
 #endif /* _M68K_PAGE_H */
diff --git a/arch/m68k/include/asm/page_no.h b/arch/m68k/include/asm/page_no.h
index 3a1ede4..9aa3f90 100644
--- a/arch/m68k/include/asm/page_no.h
+++ b/arch/m68k/include/asm/page_no.h
@@ -72,6 +72,6 @@ extern unsigned long memory_end;
 
 #endif /* __ASSEMBLY__ */
 
-#include <asm-generic/page.h>
+#include <asm-generic/getorder.h>
 
 #endif /* _M68KNOMMU_PAGE_H */
diff --git a/arch/microblaze/include/asm/page.h b/arch/microblaze/include/asm/page.h
index 7238dcf..962c210 100644
--- a/arch/microblaze/include/asm/page.h
+++ b/arch/microblaze/include/asm/page.h
@@ -135,6 +135,6 @@ extern unsigned int memory_size;
 #endif /* __KERNEL__ */
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
+#include <asm-generic/getorder.h>
 
 #endif /* _ASM_MICROBLAZE_PAGE_H */
diff --git a/arch/mips/include/asm/page.h b/arch/mips/include/asm/page.h
index fe7a88e..8a271b6 100644
--- a/arch/mips/include/asm/page.h
+++ b/arch/mips/include/asm/page.h
@@ -186,6 +186,6 @@ typedef struct { unsigned long pgprot; } pgprot_t;
 #define CAC_ADDR(addr)		((addr) - UNCAC_BASE + PAGE_OFFSET)
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
+#include <asm-generic/getorder.h>
 
 #endif /* _ASM_PAGE_H */
diff --git a/arch/parisc/include/asm/page.h b/arch/parisc/include/asm/page.h
index 7bc5125..a84cc1f 100644
--- a/arch/parisc/include/asm/page.h
+++ b/arch/parisc/include/asm/page.h
@@ -159,6 +159,6 @@ extern int npmem_ranges;
 				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
+#include <asm-generic/getorder.h>
 
 #endif /* _PARISC_PAGE_H */
diff --git a/arch/powerpc/include/asm/page_32.h b/arch/powerpc/include/asm/page_32.h
index a0e3f6e..bd0849d 100644
--- a/arch/powerpc/include/asm/page_32.h
+++ b/arch/powerpc/include/asm/page_32.h
@@ -41,7 +41,7 @@ extern void clear_pages(void *page, int order);
 static inline void clear_page(void *page) { clear_pages(page, 0); }
 extern void copy_page(void *to, void *from);
 
-#include <asm-generic/page.h>
+#include <asm-generic/getorder.h>
 
 #define PGD_T_LOG2	(__builtin_ffs(sizeof(pgd_t)) - 1)
 #define PTE_T_LOG2	(__builtin_ffs(sizeof(pte_t)) - 1)
diff --git a/arch/powerpc/include/asm/page_64.h b/arch/powerpc/include/asm/page_64.h
index 043bfdf..5817a3b 100644
--- a/arch/powerpc/include/asm/page_64.h
+++ b/arch/powerpc/include/asm/page_64.h
@@ -180,6 +180,6 @@ do {						\
 	(test_thread_flag(TIF_32BIT) ? \
 	 VM_STACK_DEFAULT_FLAGS32 : VM_STACK_DEFAULT_FLAGS64)
 
-#include <asm-generic/page.h>
+#include <asm-generic/getorder.h>
 
 #endif /* _ASM_POWERPC_PAGE_64_H */
diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
index 32e8f6a..3e3594d 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -150,7 +150,7 @@ void arch_alloc_page(struct page *page, int order);
 				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
+#include <asm-generic/getorder.h>
 
 #define __HAVE_ARCH_GATE_AREA 1
 
diff --git a/arch/sh/include/asm/page.h b/arch/sh/include/asm/page.h
index 9c6d21e..49592c7 100644
--- a/arch/sh/include/asm/page.h
+++ b/arch/sh/include/asm/page.h
@@ -163,7 +163,7 @@ typedef struct page *pgtable_t;
 				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
+#include <asm-generic/getorder.h>
 
 /* vDSO support */
 #ifdef CONFIG_VSYSCALL
diff --git a/arch/sparc/include/asm/page_32.h b/arch/sparc/include/asm/page_32.h
index d1806ed..f72080b 100644
--- a/arch/sparc/include/asm/page_32.h
+++ b/arch/sparc/include/asm/page_32.h
@@ -152,6 +152,6 @@ extern unsigned long pfn_base;
 				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
+#include <asm-generic/getorder.h>
 
 #endif /* _SPARC_PAGE_H */
diff --git a/arch/sparc/include/asm/page_64.h b/arch/sparc/include/asm/page_64.h
index 4274ed1..f0d09b4 100644
--- a/arch/sparc/include/asm/page_64.h
+++ b/arch/sparc/include/asm/page_64.h
@@ -132,6 +132,6 @@ typedef struct page *pgtable_t;
 #define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
 				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
-#include <asm-generic/page.h>
+#include <asm-generic/getorder.h>
 
 #endif /* _SPARC64_PAGE_H */
diff --git a/arch/um/include/asm/page.h b/arch/um/include/asm/page.h
index 55f28a0..4cc9b6c 100644
--- a/arch/um/include/asm/page.h
+++ b/arch/um/include/asm/page.h
@@ -116,7 +116,7 @@ extern unsigned long uml_physmem;
 #define virt_addr_valid(v) pfn_valid(phys_to_pfn(__pa(v)))
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
+#include <asm-generic/getorder.h>
 
 #endif	/* __ASSEMBLY__ */
 #endif	/* __UM_PAGE_H */
diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 89ed9d7..625c3f0 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -56,7 +56,7 @@ extern bool __virt_addr_valid(unsigned long kaddr);
 #endif	/* __ASSEMBLY__ */
 
 #include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
+#include <asm-generic/getorder.h>
 
 #define __HAVE_ARCH_GATE_AREA 1
 
diff --git a/arch/xtensa/include/asm/page.h b/arch/xtensa/include/asm/page.h
index 17e0c53..161bb89 100644
--- a/arch/xtensa/include/asm/page.h
+++ b/arch/xtensa/include/asm/page.h
@@ -129,7 +129,7 @@ static inline __attribute_const__ int get_order(unsigned long size)
 
 #else
 
-# include <asm-generic/page.h>
+# include <asm-generic/getorder.h>
 
 #endif
 
diff --git a/include/asm-generic/page.h b/include/asm-generic/getorder.h
similarity index 59%
rename from include/asm-generic/page.h
rename to include/asm-generic/getorder.h
index 14db733..67e7245 100644
--- a/include/asm-generic/page.h
+++ b/include/asm-generic/getorder.h
@@ -1,12 +1,12 @@
-#ifndef _ASM_GENERIC_PAGE_H
-#define _ASM_GENERIC_PAGE_H
+#ifndef __ASM_GENERIC_GETORDER_H
+#define __ASM_GENERIC_GETORDER_H
 
 #ifndef __ASSEMBLY__
 
 #include <linux/compiler.h>
 
 /* Pure 2^n version of get_order */
-static __inline__ __attribute_const__ int get_order(unsigned long size)
+static inline __attribute_const__ int get_order(unsigned long size)
 {
 	int order;
 
@@ -21,4 +21,4 @@ static __inline__ __attribute_const__ int get_order(unsigned long size)
 
 #endif	/* __ASSEMBLY__ */
 
-#endif	/* _ASM_GENERIC_PAGE_H */
+#endif	/* __ASM_GENERIC_GETORDER_H */
-- 
1.5.6.3

-- 

