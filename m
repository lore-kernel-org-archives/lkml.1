Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbZLNJsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbZLNJsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 04:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbZLNJsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 04:48:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:48259 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755252AbZLNJru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 04:47:50 -0500
Date: Mon, 14 Dec 2009 09:47:32 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de
In-Reply-To: <4B1DC50A.7040402@cn.fujitsu.com>
References: <4B1DC50A.7040402@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing: Remove useless trace option
Message-ID: <tip-2cbafd68b826f8e0471875cf33cdfb8a1478aef1@git.kernel.org>
Git-Commit-ID: 2cbafd68b826f8e0471875cf33cdfb8a1478aef1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2cbafd68b826f8e0471875cf33cdfb8a1478aef1
Gitweb:     http://git.kernel.org/tip/2cbafd68b826f8e0471875cf33cdfb8a1478aef1
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 8 Dec 2009 11:16:26 +0800
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Sun, 13 Dec 2009 18:37:27 +0100

tracing: Remove useless trace option

Since commit 4d9493c90f8e6e1b164aede3814010a290161abb
("ftrace: remove add-hoc code"), option "sched-tree"
has become useless.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4B1DC50A.7040402@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c |    1 -
 kernel/trace/trace.h |   23 +++++++++++------------
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 886268e..898409d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -313,7 +313,6 @@ static const char *trace_options[] = {
 	"bin",
 	"block",
 	"stacktrace",
-	"sched-tree",
 	"trace_printk",
 	"ftrace_preempt",
 	"branch",
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 7fa33ca..1b18cb2 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -597,18 +597,17 @@ enum trace_iterator_flags {
 	TRACE_ITER_BIN			= 0x40,
 	TRACE_ITER_BLOCK		= 0x80,
 	TRACE_ITER_STACKTRACE		= 0x100,
-	TRACE_ITER_SCHED_TREE		= 0x200,
-	TRACE_ITER_PRINTK		= 0x400,
-	TRACE_ITER_PREEMPTONLY		= 0x800,
-	TRACE_ITER_BRANCH		= 0x1000,
-	TRACE_ITER_ANNOTATE		= 0x2000,
-	TRACE_ITER_USERSTACKTRACE       = 0x4000,
-	TRACE_ITER_SYM_USEROBJ          = 0x8000,
-	TRACE_ITER_PRINTK_MSGONLY	= 0x10000,
-	TRACE_ITER_CONTEXT_INFO		= 0x20000, /* Print pid/cpu/time */
-	TRACE_ITER_LATENCY_FMT		= 0x40000,
-	TRACE_ITER_SLEEP_TIME		= 0x80000,
-	TRACE_ITER_GRAPH_TIME		= 0x100000,
+	TRACE_ITER_PRINTK		= 0x200,
+	TRACE_ITER_PREEMPTONLY		= 0x400,
+	TRACE_ITER_BRANCH		= 0x800,
+	TRACE_ITER_ANNOTATE		= 0x1000,
+	TRACE_ITER_USERSTACKTRACE       = 0x2000,
+	TRACE_ITER_SYM_USEROBJ          = 0x4000,
+	TRACE_ITER_PRINTK_MSGONLY	= 0x8000,
+	TRACE_ITER_CONTEXT_INFO		= 0x10000, /* Print pid/cpu/time */
+	TRACE_ITER_LATENCY_FMT		= 0x20000,
+	TRACE_ITER_SLEEP_TIME		= 0x40000,
+	TRACE_ITER_GRAPH_TIME		= 0x80000,
 };
 
 /*
