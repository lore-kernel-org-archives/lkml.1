Return-Path: <linux-kernel-owner+w=401wt.eu-S1752980AbZH1M3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbZH1M3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 08:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbZH1M3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 08:29:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:55524 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833AbZH1M3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 08:29:46 -0400
Date: Fri, 28 Aug 2009 12:28:56 GMT
From: tip-bot for Jason Baron <jbaron@redhat.com>
Cc: brueckner@linux.vnet.ibm.com, mathieu.desnoyers@polymtl.ca,
       mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, heiko.carstens@de.ibm.com, tglx@linutronix.de,
       jbaron@redhat.com, laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, jiayingz@google.com, lizf@cn.fujitsu.com,
       lethal@linux-sh.org, jistone@redhat.com, mingo@elte.hu,
       mbligh@google.com
Reply-To: mingo@redhat.com, mathieu.desnoyers@polymtl.ca,
       brueckner@linux.vnet.ibm.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, heiko.carstens@de.ibm.com, tglx@linutronix.de,
       jbaron@redhat.com, laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, jiayingz@google.com, lizf@cn.fujitsu.com,
       lethal@linux-sh.org, jistone@redhat.com, mingo@elte.hu,
       mbligh@google.com
In-Reply-To: <f2240cdc8f0b1ca7617390c8f5ec90ba2bd348cf.1251146513.git.jbaron@redhat.com>
References: <f2240cdc8f0b1ca7617390c8f5ec90ba2bd348cf.1251146513.git.jbaron@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Remove FTRACE_SYSCALL_MAX definitions
Message-ID: <tip-117226d15850387b55fd01675917ee4fcb9699e8@git.kernel.org>
Git-Commit-ID: 117226d15850387b55fd01675917ee4fcb9699e8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 28 Aug 2009 12:28:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  117226d15850387b55fd01675917ee4fcb9699e8
Gitweb:     http://git.kernel.org/tip/117226d15850387b55fd01675917ee4fcb9699e8
Author:     Jason Baron <jbaron@redhat.com>
AuthorDate: Mon, 24 Aug 2009 17:40:26 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Wed, 26 Aug 2009 21:30:39 +0200

tracing: Remove FTRACE_SYSCALL_MAX definitions

Remove the FTRACE_SYSCALL_MAX definitions now that we have converted the
syscall event tracing code to use NR_syscalls.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Josh Stone <jistone@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anwin <hpa@zytor.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
LKML-Reference: <f2240cdc8f0b1ca7617390c8f5ec90ba2bd348cf.1251146513.git.jbaron@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>


---
 arch/x86/include/asm/ftrace.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 7113654..db24c22 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -28,13 +28,6 @@
 
 #endif
 
-/* FIXME: I don't want to stay hardcoded */
-#ifdef CONFIG_X86_64
-# define FTRACE_SYSCALL_MAX     299
-#else
-# define FTRACE_SYSCALL_MAX     337
-#endif
-
 #ifdef CONFIG_FUNCTION_TRACER
 #define MCOUNT_ADDR		((long)(mcount))
 #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
