Return-Path: <linux-kernel-owner+w=401wt.eu-S1765798AbYCWJDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765798AbYCWJDJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760277AbYCWIMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:14 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2369 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760222AbYCWIL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:57 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 093/148] include/asm-x86/pgtable-2level.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:08 -0700
Message-Id: <1206259443-13210-94-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/pgtable-2level.h |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/include/asm-x86/pgtable-2level.h b/include/asm-x86/pgtable-2level.h
index 701404f..46bc52c 100644
--- a/include/asm-x86/pgtable-2level.h
+++ b/include/asm-x86/pgtable-2level.h
@@ -26,7 +26,8 @@ static inline void native_set_pte_atomic(pte_t *ptep, pte_t pte)
 	native_set_pte(ptep, pte);
 }
 
-static inline void native_set_pte_present(struct mm_struct *mm, unsigned long addr,
+static inline void native_set_pte_present(struct mm_struct *mm,
+					  unsigned long addr,
 					  pte_t *ptep, pte_t pte)
 {
 	native_set_pte(ptep, pte);
@@ -37,7 +38,8 @@ static inline void native_pmd_clear(pmd_t *pmdp)
 	native_set_pmd(pmdp, __pmd(0));
 }
 
-static inline void native_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *xp)
+static inline void native_pte_clear(struct mm_struct *mm,
+				    unsigned long addr, pte_t *xp)
 {
 	*xp = native_make_pte(0);
 }
@@ -61,16 +63,18 @@ static inline pte_t native_ptep_get_and_clear(pte_t *xp)
  */
 #define PTE_FILE_MAX_BITS	29
 
-#define pte_to_pgoff(pte) \
-	((((pte).pte_low >> 1) & 0x1f ) + (((pte).pte_low >> 8) << 5 ))
+#define pte_to_pgoff(pte)						\
+	((((pte).pte_low >> 1) & 0x1f) + (((pte).pte_low >> 8) << 5))
 
-#define pgoff_to_pte(off) \
-	((pte_t) { .pte_low = (((off) & 0x1f) << 1) + (((off) >> 5) << 8) + _PAGE_FILE })
+#define pgoff_to_pte(off)						\
+	((pte_t) { .pte_low = (((off) & 0x1f) << 1) +			\
+			(((off) >> 5) << 8) + _PAGE_FILE })
 
 /* Encode and de-code a swap entry */
 #define __swp_type(x)			(((x).val >> 1) & 0x1f)
 #define __swp_offset(x)			((x).val >> 8)
-#define __swp_entry(type, offset)	((swp_entry_t) { ((type) << 1) | ((offset) << 8) })
+#define __swp_entry(type, offset)				\
+	((swp_entry_t) { ((type) << 1) | ((offset) << 8) })
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { (pte).pte_low })
 #define __swp_entry_to_pte(x)		((pte_t) { .pte = (x).val })
 
-- 
1.5.4.rc2

