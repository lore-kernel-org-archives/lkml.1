Return-Path: <linux-kernel-owner+w=401wt.eu-S933226AbYCWIyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226AbYCWIyn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757580AbYCWILq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:46 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2342 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760105AbYCWILg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:36 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 034/148] include/asm-x86/fixmap_32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:09 -0700
Message-Id: <1206259443-13210-35-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/fixmap_32.h |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/include/asm-x86/fixmap_32.h b/include/asm-x86/fixmap_32.h
index a7404d5..eb16651 100644
--- a/include/asm-x86/fixmap_32.h
+++ b/include/asm-x86/fixmap_32.h
@@ -99,8 +99,7 @@ enum fixed_addresses {
 	 */
 #define NR_FIX_BTMAPS		64
 #define FIX_BTMAPS_NESTING	4
-	FIX_BTMAP_END =
-		__end_of_permanent_fixed_addresses + 512 -
+	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 512 -
 			(__end_of_permanent_fixed_addresses & 511),
 	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_NESTING - 1,
 	FIX_WP_TEST,
@@ -110,20 +109,20 @@ enum fixed_addresses {
 	__end_of_fixed_addresses
 };
 
-extern void __set_fixmap (enum fixed_addresses idx,
-					unsigned long phys, pgprot_t flags);
+extern void __set_fixmap(enum fixed_addresses idx,
+			 unsigned long phys, pgprot_t flags);
 extern void reserve_top_address(unsigned long reserve);
 
-#define set_fixmap(idx, phys) \
-		__set_fixmap(idx, phys, PAGE_KERNEL)
+#define set_fixmap(idx, phys)				\
+	__set_fixmap(idx, phys, PAGE_KERNEL)
 /*
  * Some hardware wants to get fixmapped without caching.
  */
-#define set_fixmap_nocache(idx, phys) \
-		__set_fixmap(idx, phys, PAGE_KERNEL_NOCACHE)
+#define set_fixmap_nocache(idx, phys)			\
+	__set_fixmap(idx, phys, PAGE_KERNEL_NOCACHE)
 
-#define clear_fixmap(idx) \
-		__set_fixmap(idx, 0, __pgprot(0))
+#define clear_fixmap(idx)			\
+	__set_fixmap(idx, 0, __pgprot(0))
 
 #define FIXADDR_TOP	((unsigned long)__FIXADDR_TOP)
 
@@ -156,7 +155,7 @@ static __always_inline unsigned long fix_to_virt(const unsigned int idx)
 	if (idx >= __end_of_fixed_addresses)
 		__this_fixmap_does_not_exist();
 
-        return __fix_to_virt(idx);
+	return __fix_to_virt(idx);
 }
 
 static inline unsigned long virt_to_fix(const unsigned long vaddr)
-- 
1.5.4.rc2

