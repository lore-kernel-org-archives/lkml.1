Return-Path: <linux-kernel-owner+w=401wt.eu-S1764543AbZEAOtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764543AbZEAOtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760970AbZEAOmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:42:36 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49169 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760384AbZEAOme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:42:34 -0400
Subject: [RFC][PATCH 20/35] xtensa: create ptemap.h
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 01 May 2009 07:42:32 -0700
References: <20090501144201.D31EF417@kernel>
In-Reply-To: <20090501144201.D31EF417@kernel>
Message-Id: <20090501144232.9007BCB9@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/xtensa/include/asm/pgtable.h |    6 ------
 linux-2.6.git-dave/arch/xtensa/include/asm/ptemap.h  |   10 ++++++++++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff -puN arch/xtensa/include/asm/pgtable.h~xtensa-ptemaph arch/xtensa/include/asm/pgtable.h
--- linux-2.6.git/arch/xtensa/include/asm/pgtable.h~xtensa-ptemaph	2009-04-30 15:11:04.000000000 -0700
+++ linux-2.6.git-dave/arch/xtensa/include/asm/pgtable.h	2009-04-30 15:11:04.000000000 -0700
@@ -323,12 +323,6 @@ ptep_set_wrprotect(struct mm_struct *mm,
 #define pte_index(address)	(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
 #define pte_offset_kernel(dir,addr) 					\
 	((pte_t*) pmd_page_vaddr(*(dir)) + pte_index(addr))
-#define pte_offset_map(dir,addr)	pte_offset_kernel((dir),(addr))
-#define pte_offset_map_nested(dir,addr)	pte_offset_kernel((dir),(addr))
-
-#define pte_unmap(pte)		do { } while (0)
-#define pte_unmap_nested(pte)	do { } while (0)
-
 
 /*
  * Encode and decode a swap entry.
diff -puN /dev/null arch/xtensa/include/asm/ptemap.h
--- /dev/null	2008-09-02 09:40:19.000000000 -0700
+++ linux-2.6.git-dave/arch/xtensa/include/asm/ptemap.h	2009-04-30 15:11:04.000000000 -0700
@@ -0,0 +1,10 @@
+#ifndef _XTENSA_ASM_PTEMAP_H
+#define _XTENSA_ASM_PTEMAP_H
+
+#define pte_offset_map(dir,addr)	pte_offset_kernel((dir),(addr))
+#define pte_offset_map_nested(dir,addr)	pte_offset_kernel((dir),(addr))
+
+#define pte_unmap(pte)		do { } while (0)
+#define pte_unmap_nested(pte)	do { } while (0)
+
+#endif /* _XTENSA_ASM_PTEMAP_H */
_
