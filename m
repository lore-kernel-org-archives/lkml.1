Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbZESQ0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbZESQ0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 12:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbZESQ0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 12:26:03 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:41706 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbZESQ0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 12:26:02 -0400
Date: Tue, 19 May 2009 21:55:58 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 2/2] Fix the style issue seen in ksym tracer ftrace plugin
Message-ID: <20090519162558.GC26009@in.ibm.com>
References: <20090519161720.374172804@prasadkr_t60p.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=fix_style_issue_ftrace_NEW_02
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the style issue seen in ksym tracer ftrace plugin

Move the extern 'process_new_ksym_entry' declaration from
trace_selftest.c to trace.h file due to a reported style issue.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 kernel/trace/trace.h          |    1 +
 kernel/trace/trace_selftest.c |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip.hbkpt/kernel/trace/trace.h
===================================================================
--- linux-2.6-tip.hbkpt.orig/kernel/trace/trace.h
+++ linux-2.6-tip.hbkpt/kernel/trace/trace.h
@@ -213,6 +213,7 @@ struct syscall_trace_exit {
 };
 
 #define KSYM_SELFTEST_ENTRY "ksym_selftest_dummy"
+extern int process_new_ksym_entry(char *ksymname, int op, unsigned long addr);
 
 struct trace_ksym {
 	struct trace_entry	ent;
Index: linux-2.6-tip.hbkpt/kernel/trace/trace_selftest.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/kernel/trace/trace_selftest.c
+++ linux-2.6-tip.hbkpt/kernel/trace/trace_selftest.c
@@ -810,7 +810,6 @@ trace_selftest_startup_hw_branches(struc
 #endif /* CONFIG_HW_BRANCH_TRACER */
 
 #ifdef CONFIG_KSYM_TRACER
-extern int process_new_ksym_entry(char *ksymname, int op, unsigned long addr);
 static int ksym_selftest_dummy;
 
 int

