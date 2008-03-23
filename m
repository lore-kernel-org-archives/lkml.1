Return-Path: <linux-kernel-owner+w=401wt.eu-S1763200AbYCWIYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763200AbYCWIYZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759218AbYCWIJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:09:13 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2273 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759352AbYCWIJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:09:11 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 067/148] include/asm-x86/mmu_context_32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:42 -0700
Message-Id: <1206259443-13210-68-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/mmu_context_32.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/asm-x86/mmu_context_32.h b/include/asm-x86/mmu_context_32.h
index 8198d1c..9756ae0 100644
--- a/include/asm-x86/mmu_context_32.h
+++ b/include/asm-x86/mmu_context_32.h
@@ -62,7 +62,7 @@ static inline void switch_mm(struct mm_struct *prev,
 		BUG_ON(per_cpu(cpu_tlbstate, cpu).active_mm != next);
 
 		if (!cpu_test_and_set(cpu, next->cpu_vm_mask)) {
-			/* We were in lazy tlb mode and leave_mm disabled 
+			/* We were in lazy tlb mode and leave_mm disabled
 			 * tlb flush IPI delivery. We must reload %cr3.
 			 */
 			load_cr3(next->pgd);
@@ -75,10 +75,10 @@ static inline void switch_mm(struct mm_struct *prev,
 #define deactivate_mm(tsk, mm)			\
 	asm("movl %0,%%gs": :"r" (0));
 
-#define activate_mm(prev, next)				\
-	do {						\
-		paravirt_activate_mm(prev, next);	\
-		switch_mm((prev),(next),NULL);		\
-	} while(0);
+#define activate_mm(prev, next)			\
+do {						\
+	paravirt_activate_mm((prev), (next));	\
+	switch_mm((prev), (next), NULL);	\
+} while (0);
 
 #endif
-- 
1.5.4.rc2

