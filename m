Return-Path: <linux-kernel-owner+w=401wt.eu-S1761529AbYCWIeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761529AbYCWIeX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759733AbYCWIKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:10:08 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2293 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759664AbYCWIKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:03 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 104/148] include/asm-x86/resume-trace.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:19 -0700
Message-Id: <1206259443-13210-105-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/resume-trace.h |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/asm-x86/resume-trace.h b/include/asm-x86/resume-trace.h
index 46f725b..2557514 100644
--- a/include/asm-x86/resume-trace.h
+++ b/include/asm-x86/resume-trace.h
@@ -3,16 +3,17 @@
 
 #include <asm/asm.h>
 
-#define TRACE_RESUME(user) do {					\
+#define TRACE_RESUME(user)					\
+do {								\
 	if (pm_trace_enabled) {					\
 		void *tracedata;				\
 		asm volatile(_ASM_MOV_UL " $1f,%0\n"		\
-			".section .tracedata,\"a\"\n"		\
-			"1:\t.word %c1\n\t"			\
-			_ASM_PTR " %c2\n"			\
-			".previous"				\
-			:"=r" (tracedata)			\
-			: "i" (__LINE__), "i" (__FILE__));	\
+			     ".section .tracedata,\"a\"\n"	\
+			     "1:\t.word %c1\n\t"		\
+			     _ASM_PTR " %c2\n"			\
+			     ".previous"			\
+			     :"=r" (tracedata)			\
+			     : "i" (__LINE__), "i" (__FILE__));	\
 		generate_resume_trace(tracedata, user);		\
 	}							\
 } while (0)
-- 
1.5.4.rc2

