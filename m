Return-Path: <linux-kernel-owner+w=401wt.eu-S1761879AbYCWIZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761879AbYCWIZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759399AbYCWIJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:09:18 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2276 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759373AbYCWIJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:09:17 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 082/148] include/asm-x86/page_32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:57 -0700
Message-Id: <1206259443-13210-83-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/page_32.h |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86/page_32.h b/include/asm-x86/page_32.h
index 5f7257f..424e82f 100644
--- a/include/asm-x86/page_32.h
+++ b/include/asm-x86/page_32.h
@@ -47,7 +47,10 @@ typedef unsigned long	pgdval_t;
 typedef unsigned long	pgprotval_t;
 typedef unsigned long	phys_addr_t;
 
-typedef union { pteval_t pte, pte_low; } pte_t;
+typedef union {
+	pteval_t pte;
+	pteval_t pte_low;
+} pte_t;
 
 #endif	/* __ASSEMBLY__ */
 #endif	/* CONFIG_X86_PAE */
@@ -61,7 +64,7 @@ typedef struct page *pgtable_t;
 #endif
 
 #ifndef __ASSEMBLY__
-#define __phys_addr(x)		((x)-PAGE_OFFSET)
+#define __phys_addr(x)		((x) - PAGE_OFFSET)
 #define __phys_reloc_hide(x)	RELOC_HIDE((x), 0)
 
 #ifdef CONFIG_FLATMEM
@@ -78,7 +81,7 @@ extern unsigned int __VMALLOC_RESERVE;
 extern int sysctl_legacy_va_layout;
 
 #define VMALLOC_RESERVE		((unsigned long)__VMALLOC_RESERVE)
-#define MAXMEM			(-__PAGE_OFFSET-__VMALLOC_RESERVE)
+#define MAXMEM			(-__PAGE_OFFSET - __VMALLOC_RESERVE)
 
 #ifdef CONFIG_X86_USE_3DNOW
 #include <asm/mmx.h>
-- 
1.5.4.rc2

