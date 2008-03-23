Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbYCWILm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbYCWILm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758570AbYCWIHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:07:49 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2000 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756137AbYCWIHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:07:40 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 002/148] include/asm-x86/alternative.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:01:37 -0700
Message-Id: <1206259443-13210-3-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/alternative.h |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/asm-x86/alternative.h b/include/asm-x86/alternative.h
index d26416b..1f6a9ca 100644
--- a/include/asm-x86/alternative.h
+++ b/include/asm-x86/alternative.h
@@ -66,8 +66,8 @@ extern void alternatives_smp_module_del(struct module *mod);
 extern void alternatives_smp_switch(int smp);
 #else
 static inline void alternatives_smp_module_add(struct module *mod, char *name,
-					void *locks, void *locks_end,
-					void *text, void *text_end) {}
+					       void *locks, void *locks_end,
+					       void *text, void *text_end) {}
 static inline void alternatives_smp_module_del(struct module *mod) {}
 static inline void alternatives_smp_switch(int smp) {}
 #endif	/* CONFIG_SMP */
@@ -148,9 +148,8 @@ struct paravirt_patch_site;
 void apply_paravirt(struct paravirt_patch_site *start,
 		    struct paravirt_patch_site *end);
 #else
-static inline void
-apply_paravirt(struct paravirt_patch_site *start,
-	       struct paravirt_patch_site *end)
+static inline void apply_paravirt(struct paravirt_patch_site *start,
+				  struct paravirt_patch_site *end)
 {}
 #define __parainstructions	NULL
 #define __parainstructions_end	NULL
-- 
1.5.4.rc2

