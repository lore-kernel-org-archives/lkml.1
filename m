Return-Path: <linux-kernel-owner+w=401wt.eu-S1758555AbYGKBBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbYGKBBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 21:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756047AbYGKA7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 20:59:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49771 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbYGKA7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 20:59:52 -0400
Message-Id: <20080711005950.698565035@goodmis.org>
References: <20080711005808.316194101@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 20:58:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/8] ftrace: check proper config for preempt type
Content-Disposition: inline; filename=ftrace-update-preempt-output.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no CONFIG_PREEMPT_DESKTOP. Use the proper entry CONFIG_PREEMPT.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-07-03 17:30:24.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.c	2008-07-08 10:35:09.000000000 -0400
@@ -1341,7 +1341,7 @@ print_trace_header(struct seq_file *m, s
 		   "server",
 #elif defined(CONFIG_PREEMPT_VOLUNTARY)
 		   "desktop",
-#elif defined(CONFIG_PREEMPT_DESKTOP)
+#elif defined(CONFIG_PREEMPT)
 		   "preempt",
 #else
 		   "unknown",

-- 
