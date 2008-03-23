Return-Path: <linux-kernel-owner+w=401wt.eu-S1759568AbYCWIJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568AbYCWIJx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758155AbYCWIHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:07:45 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1964 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbYCWIHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:07:36 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 021/148] include/asm-x86/current_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:01:56 -0700
Message-Id: <1206259443-13210-22-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/current_64.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/asm-x86/current_64.h b/include/asm-x86/current_64.h
index bc8adec..2d368ed 100644
--- a/include/asm-x86/current_64.h
+++ b/include/asm-x86/current_64.h
@@ -1,23 +1,23 @@
 #ifndef _X86_64_CURRENT_H
 #define _X86_64_CURRENT_H
 
-#if !defined(__ASSEMBLY__) 
+#if !defined(__ASSEMBLY__)
 struct task_struct;
 
 #include <asm/pda.h>
 
-static inline struct task_struct *get_current(void) 
-{ 
-	struct task_struct *t = read_pda(pcurrent); 
+static inline struct task_struct *get_current(void)
+{
+	struct task_struct *t = read_pda(pcurrent);
 	return t;
-} 
+}
 
 #define current get_current()
 
 #else
 
 #ifndef ASM_OFFSET_H
-#include <asm/asm-offsets.h> 
+#include <asm/asm-offsets.h>
 #endif
 
 #define GET_CURRENT(reg) movq %gs:(pda_pcurrent),reg
-- 
1.5.4.rc2

