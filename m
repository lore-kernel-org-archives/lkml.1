Return-Path: <linux-kernel-owner+w=401wt.eu-S934569AbYCWJGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934569AbYCWJGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760311AbYCWIMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:24 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2366 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760232AbYCWIMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:12:00 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 130/148] include/asm-x86/tlbflush.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:45 -0700
Message-Id: <1206259443-13210-131-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/tlbflush.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86/tlbflush.h b/include/asm-x86/tlbflush.h
index 3998709..0c0674d 100644
--- a/include/asm-x86/tlbflush.h
+++ b/include/asm-x86/tlbflush.h
@@ -32,7 +32,7 @@ static inline void __native_flush_tlb_global(void)
 
 static inline void __native_flush_tlb_single(unsigned long addr)
 {
-	__asm__ __volatile__("invlpg (%0)" ::"r" (addr) : "memory");
+	asm volatile("invlpg (%0)" ::"r" (addr) : "memory");
 }
 
 static inline void __flush_tlb_all(void)
@@ -134,8 +134,7 @@ void native_flush_tlb_others(const cpumask_t *cpumask, struct mm_struct *mm,
 #define TLBSTATE_LAZY	2
 
 #ifdef CONFIG_X86_32
-struct tlb_state
-{
+struct tlb_state {
 	struct mm_struct *active_mm;
 	int state;
 	char __cacheline_padding[L1_CACHE_BYTES-8];
-- 
1.5.4.rc2

