Return-Path: <linux-kernel-owner+w=401wt.eu-S1751592AbZJQAHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbZJQAHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 20:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZJQAG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 20:06:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbZJQAG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 20:06:58 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip tracing/kprobes 1/9] tracing/kprobes: Update
	kprobe-tracer selftest against new syntax
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Date: Fri, 16 Oct 2009 20:07:20 -0400
Message-ID: <20091017000720.16556.26343.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update kprobe-tracer selftest since command syntax has been changed.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
-
---

 kernel/trace/trace_kprobe.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 739f70e..cdacdab 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1438,12 +1438,12 @@ static __init int kprobe_trace_self_tests_init(void)
 	pr_info("Testing kprobe tracing: ");
 
 	ret = command_trace_probe("p:testprobe kprobe_trace_selftest_target "
-				  "a1 a2 a3 a4 a5 a6");
+				  "$arg1 $arg2 $arg3 $arg4 $stack $stack0");
 	if (WARN_ON_ONCE(ret))
 		pr_warning("error enabling function entry\n");
 
 	ret = command_trace_probe("r:testprobe2 kprobe_trace_selftest_target "
-				  "ra rv");
+				  "$retval");
 	if (WARN_ON_ONCE(ret))
 		pr_warning("error enabling function return\n");
 


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
