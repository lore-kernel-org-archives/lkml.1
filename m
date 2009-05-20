Return-Path: <linux-kernel-owner+w=401wt.eu-S1758672AbZETScf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbZETScf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756613AbZETSZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:25:52 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42468 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756725AbZETSZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:25:35 -0400
Subject: [RFC v2][PATCH 20/35] xtensa: create ptemap.h
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 20 May 2009 11:25:16 -0700
References: <20090520182445.D7B49A7C@kernel>
In-Reply-To: <20090520182445.D7B49A7C@kernel>
Message-Id: <20090520182516.896F76D5@kernel>
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
