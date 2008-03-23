Return-Path: <linux-kernel-owner+w=401wt.eu-S1764205AbYCWIc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764205AbYCWIc5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759612AbYCWIJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:09:58 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2291 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759600AbYCWIJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:09:56 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 114/148] include/asm-x86/smp_32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:29 -0700
Message-Id: <1206259443-13210-115-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/smp_32.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
index f861d04..cb3ada2 100644
--- a/include/asm-x86/smp_32.h
+++ b/include/asm-x86/smp_32.h
@@ -18,8 +18,8 @@
 
 extern cpumask_t cpu_callin_map;
 
-extern void (*mtrr_hook) (void);
-extern void zap_low_mappings (void);
+extern void (*mtrr_hook)(void);
+extern void zap_low_mappings(void);
 
 #ifdef CONFIG_SMP
 /*
@@ -44,7 +44,7 @@ static inline int num_booting_cpus(void)
 
 #ifdef CONFIG_X86_LOCAL_APIC
 
-static __inline int logical_smp_processor_id(void)
+static inline int logical_smp_processor_id(void)
 {
 	/* we don't want to mark this access volatile - bad code generation */
 	return GET_APIC_LOGICAL_ID(*(u32 *)(APIC_BASE + APIC_LDR));
-- 
1.5.4.rc2

