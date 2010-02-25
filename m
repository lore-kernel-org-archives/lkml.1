Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532Ab0BYTqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 14:46:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51177 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933440Ab0BYTpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:45:30 -0500
X-Authority-Analysis: v=1.0 c=1 a=yGVWz7ep5I8A:10 a=yPCof4ZbAAAA:8 a=meVymXHHAAAA:8 a=UJRi8k-bpEhzNJ5X9xUA:9 a=q08jbrKFg2ZH2hRU3izDpwHI9gYA:4 a=7DSvI1NPTFQA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100225194529.419632558@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 25 Feb 2010 14:43:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH 4/7] tracing: Fix typo in prof_sysexit_enable()
References: <20100225194355.707261669@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Fix-typo-in-prof_sysexit_enable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wenji Huang <wenji.huang@oracle.com>

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
LKML-Reference: <1266997226-6833-1-git-send-email-wenji.huang@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_syscalls.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 49cea70..8cdda95 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -603,7 +603,7 @@ int prof_sysexit_enable(struct ftrace_event_call *call)
 		ret = register_trace_sys_exit(prof_syscall_exit);
 	if (ret) {
 		pr_info("event trace: Could not activate"
-				"syscall entry trace point");
+				"syscall exit trace point");
 	} else {
 		set_bit(num, enabled_prof_exit_syscalls);
 		sys_prof_refcount_exit++;
-- 
1.6.5


