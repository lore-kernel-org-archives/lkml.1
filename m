Return-Path: <linux-kernel-owner+w=401wt.eu-S1763870AbYCWI7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763870AbYCWI7Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759638AbYCWIMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:00 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2358 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760105AbYCWILs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:48 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 058/148] include/asm-x86/kprobes.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:33 -0700
Message-Id: <1206259443-13210-59-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/kprobes.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/asm-x86/kprobes.h b/include/asm-x86/kprobes.h
index 61ad7b5..54980b0 100644
--- a/include/asm-x86/kprobes.h
+++ b/include/asm-x86/kprobes.h
@@ -35,12 +35,12 @@ typedef u8 kprobe_opcode_t;
 #define RELATIVEJUMP_INSTRUCTION 0xe9
 #define MAX_INSN_SIZE 16
 #define MAX_STACK_SIZE 64
-#define MIN_STACK_SIZE(ADDR) (((MAX_STACK_SIZE) < \
-	(((unsigned long)current_thread_info()) + THREAD_SIZE \
-	 - (unsigned long)(ADDR))) \
-	? (MAX_STACK_SIZE) \
-	: (((unsigned long)current_thread_info()) + THREAD_SIZE \
-	   - (unsigned long)(ADDR)))
+#define MIN_STACK_SIZE(ADDR)					       \
+	(((MAX_STACK_SIZE) < (((unsigned long)current_thread_info()) + \
+			      THREAD_SIZE - (unsigned long)(ADDR)))    \
+	 ? (MAX_STACK_SIZE)					       \
+	 : (((unsigned long)current_thread_info()) +		       \
+	    THREAD_SIZE - (unsigned long)(ADDR)))
 
 #define flush_insn_slot(p)	do { } while (0)
 
-- 
1.5.4.rc2

