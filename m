Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbZJQKFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbZJQKFj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 06:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbZJQKFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 06:05:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:33047 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706AbZJQKFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 06:05:30 -0400
Date: Sat, 17 Oct 2009 10:04:58 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20091017000720.16556.26343.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091017000720.16556.26343.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] tracing/kprobes: Update kprobe-tracer selftest against new syntax
Message-ID: <tip-f397af06e4c9bf5a0bc92facb8cb29905e338ab0@git.kernel.org>
Git-Commit-ID: f397af06e4c9bf5a0bc92facb8cb29905e338ab0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 10:04:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f397af06e4c9bf5a0bc92facb8cb29905e338ab0
Gitweb:     http://git.kernel.org/tip/f397af06e4c9bf5a0bc92facb8cb29905e338ab0
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Fri, 16 Oct 2009 20:07:20 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 17 Oct 2009 09:53:57 +0200

tracing/kprobes: Update kprobe-tracer selftest against new syntax

Update kprobe-tracer selftest since command syntax has been
changed.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20091017000720.16556.26343.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
