Return-Path: <linux-kernel-owner+w=401wt.eu-S1759459AbYCWIJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459AbYCWIJ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758006AbYCWIHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:07:43 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1959 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbYCWIHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:07:36 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 013/148] include/asm-x86/cacheflush.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:01:48 -0700
Message-Id: <1206259443-13210-14-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/cacheflush.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/asm-x86/cacheflush.h b/include/asm-x86/cacheflush.h
index 90437d3..7ab5b52 100644
--- a/include/asm-x86/cacheflush.h
+++ b/include/asm-x86/cacheflush.h
@@ -14,18 +14,18 @@
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
 #define flush_icache_range(start, end)		do { } while (0)
-#define flush_icache_page(vma,pg)		do { } while (0)
-#define flush_icache_user_range(vma,pg,adr,len)	do { } while (0)
+#define flush_icache_page(vma, pg)		do { } while (0)
+#define flush_icache_user_range(vma, pg, adr, len)	do { } while (0)
 #define flush_cache_vmap(start, end)		do { } while (0)
 #define flush_cache_vunmap(start, end)		do { } while (0)
 
-#define copy_to_user_page(vma, page, vaddr, dst, src, len) \
-	memcpy(dst, src, len)
-#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
-	memcpy(dst, src, len)
+#define copy_to_user_page(vma, page, vaddr, dst, src, len)	\
+	memcpy((dst), (src), (len))
+#define copy_from_user_page(vma, page, vaddr, dst, src, len)	\
+	memcpy((dst), (src), (len))
 
 int __deprecated_for_modules change_page_attr(struct page *page, int numpages,
-								pgprot_t prot);
+					      pgprot_t prot);
 
 int set_pages_uc(struct page *page, int numpages);
 int set_pages_wb(struct page *page, int numpages);
-- 
1.5.4.rc2

