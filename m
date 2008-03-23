Return-Path: <linux-kernel-owner+w=401wt.eu-S1762736AbYCWJFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762736AbYCWJFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759126AbYCWIMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:23 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2370 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760231AbYCWIMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:12:00 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 092/148] include/asm-x86/pgalloc.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:07 -0700
Message-Id: <1206259443-13210-93-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/pgalloc.h |   32 ++++++++++++++++++++++++--------
 1 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/include/asm-x86/pgalloc.h b/include/asm-x86/pgalloc.h
index 91e4641..c316e1b 100644
--- a/include/asm-x86/pgalloc.h
+++ b/include/asm-x86/pgalloc.h
@@ -8,14 +8,30 @@
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else
-static inline void paravirt_alloc_pte(struct mm_struct *mm, unsigned long pfn)	{}
-static inline void paravirt_alloc_pmd(struct mm_struct *mm, unsigned long pfn)	{}
-static inline void paravirt_alloc_pmd_clone(unsigned long pfn, unsigned long clonepfn,
-					    unsigned long start, unsigned long count) {}
-static inline void paravirt_alloc_pud(struct mm_struct *mm, unsigned long pfn)	{}
-static inline void paravirt_release_pte(unsigned long pfn) {}
-static inline void paravirt_release_pmd(unsigned long pfn) {}
-static inline void paravirt_release_pud(unsigned long pfn) {}
+static inline void paravirt_alloc_pte(struct mm_struct *mm, unsigned long pfn)
+{
+}
+static inline void paravirt_alloc_pmd(struct mm_struct *mm, unsigned long pfn)
+{
+}
+static inline void paravirt_alloc_pmd_clone(unsigned long pfn,
+					    unsigned long clonepfn,
+					    unsigned long start,
+					    unsigned long count)
+{
+}
+static inline void paravirt_alloc_pud(struct mm_struct *mm, unsigned long pfn)
+{
+}
+static inline void paravirt_release_pte(unsigned long pfn)
+{
+}
+static inline void paravirt_release_pmd(unsigned long pfn)
+{
+}
+static inline void paravirt_release_pud(unsigned long pfn)
+{
+}
 #endif
 
 /*
-- 
1.5.4.rc2

