Return-Path: <linux-kernel-owner+w=401wt.eu-S1758904AbZLGHnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904AbZLGHnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758767AbZLGHnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:43:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60040 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758706AbZLGHnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:43:09 -0500
Message-ID: <4B1CB1FA.2090308@cn.fujitsu.com>
Date: Mon, 07 Dec 2009 15:42:50 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/13] tracing: Remove useless trace option
References: <4B1CB14A.4080402@cn.fujitsu.com>
In-Reply-To: <4B1CB14A.4080402@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 4d9493c90f8e6e1b164aede3814010a290161abb
("ftrace: remove add-hoc code"), option "sched-tree"
has become useless.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace.c |    1 -
 kernel/trace/trace.h |   23 +++++++++++------------
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 75871e5..2801b0b 100644
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
index ea5dda4..60f9471 100644
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
-- 
1.6.3

