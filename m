Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbZILHxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbZILHxX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 03:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbZILHxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 03:53:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:33464 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbZILHxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 03:53:16 -0400
Date: Sat, 12 Sep 2009 07:52:54 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4AA8579B.4020706@cn.fujitsu.com>
References: <4AA8579B.4020706@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: format clean ups
Message-ID: <tip-bd9cfca9cb71200dd82b320bba12540dc078f4e0@git.kernel.org>
Git-Commit-ID: bd9cfca9cb71200dd82b320bba12540dc078f4e0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 12 Sep 2009 07:52:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bd9cfca9cb71200dd82b320bba12540dc078f4e0
Gitweb:     http://git.kernel.org/tip/bd9cfca9cb71200dd82b320bba12540dc078f4e0
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 10 Sep 2009 09:34:19 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 9 Sep 2009 23:54:07 -0400

tracing: format clean ups

Fix white-space formatting.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4AA8579B.4020706@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


---
 kernel/trace/trace.h |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 536ae1d..86a0523 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -169,20 +169,20 @@ enum kmemtrace_type_id {
 
 struct kmemtrace_alloc_entry {
 	struct trace_entry	ent;
-	enum kmemtrace_type_id type_id;
-	unsigned long call_site;
-	const void *ptr;
-	size_t bytes_req;
-	size_t bytes_alloc;
-	gfp_t gfp_flags;
-	int node;
+	enum kmemtrace_type_id	type_id;
+	unsigned long		call_site;
+	const void		*ptr;
+	size_t			bytes_req;
+	size_t			bytes_alloc;
+	gfp_t			gfp_flags;
+	int			node;
 };
 
 struct kmemtrace_free_entry {
 	struct trace_entry	ent;
-	enum kmemtrace_type_id type_id;
-	unsigned long call_site;
-	const void *ptr;
+	enum kmemtrace_type_id	type_id;
+	unsigned long		call_site;
+	const void		*ptr;
 };
 
 struct syscall_trace_enter {
@@ -203,7 +203,7 @@ struct syscall_trace_exit {
  * states when a trace occurs. These are:
  *  IRQS_OFF		- interrupts were disabled
  *  IRQS_NOSUPPORT	- arch does not support irqs_disabled_flags
- *  NEED_RESCED		- reschedule is requested
+ *  NEED_RESCHED	- reschedule is requested
  *  HARDIRQ		- inside an interrupt handler
  *  SOFTIRQ		- inside a softirq handler
  */
