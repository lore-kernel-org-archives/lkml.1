Return-Path: <linux-kernel-owner+w=401wt.eu-S1764424AbYCWIes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764424AbYCWIes (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758783AbYCWIKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:10:10 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2292 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759663AbYCWIKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:03 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 115/148] include/asm-x86/smp_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:30 -0700
Message-Id: <1206259443-13210-116-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/smp_64.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86/smp_64.h b/include/asm-x86/smp_64.h
index fd709cb..c53a011 100644
--- a/include/asm-x86/smp_64.h
+++ b/include/asm-x86/smp_64.h
@@ -24,9 +24,9 @@ extern int smp_call_function_mask(cpumask_t mask, void (*func)(void *),
 #define raw_smp_processor_id()	read_pda(cpunumber)
 
 #define stack_smp_processor_id()					\
-	({								\
+({									\
 	struct thread_info *ti;						\
-	__asm__("andq %%rsp,%0; ":"=r" (ti) : "0" (CURRENT_MASK));	\
+	asm("andq %%rsp,%0; ":"=r" (ti) : "0" (CURRENT_MASK));	\
 	ti->cpu;							\
 })
 
@@ -46,7 +46,7 @@ static inline int num_booting_cpus(void)
 
 #define safe_smp_processor_id()		smp_processor_id()
 
-static __inline int logical_smp_processor_id(void)
+static inline int logical_smp_processor_id(void)
 {
 	/* we don't want to mark this access volatile - bad code generation */
 	return GET_APIC_LOGICAL_ID(*(u32 *)(APIC_BASE + APIC_LDR));
-- 
1.5.4.rc2

