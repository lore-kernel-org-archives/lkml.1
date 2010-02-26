Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935735Ab0BZJ32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 04:29:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:39799 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935691Ab0BZJ3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 04:29:24 -0500
Date: Fri, 26 Feb 2010 09:28:51 GMT
From: tip-bot for Wenji Huang <wenji.huang@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, wenji.huang@oracle.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, wenji.huang@oracle.com
In-Reply-To: <1266997226-6833-3-git-send-email-wenji.huang@oracle.com>
References: <1266997226-6833-3-git-send-email-wenji.huang@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Remove unnecessary variable in print_graph_return
Message-ID: <tip-c85f3a91f84d5a85f179c2504bb7a39370c82b41@git.kernel.org>
Git-Commit-ID: c85f3a91f84d5a85f179c2504bb7a39370c82b41
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 09:28:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c85f3a91f84d5a85f179c2504bb7a39370c82b41
Gitweb:     http://git.kernel.org/tip/c85f3a91f84d5a85f179c2504bb7a39370c82b41
Author:     Wenji Huang <wenji.huang@oracle.com>
AuthorDate: Wed, 24 Feb 2010 15:40:24 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 25 Feb 2010 10:41:24 -0500

tracing: Remove unnecessary variable in print_graph_return

The "cpu" variable is declared at the start of the function and
also within a branch, with the exact same initialization.

Remove the local variable of the same name in the branch.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
LKML-Reference: <1266997226-6833-3-git-send-email-wenji.huang@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions_graph.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 616b135..112561d 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -855,7 +855,6 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 	int i;
 
 	if (data) {
-		int cpu = iter->cpu;
 		int *depth = &(per_cpu_ptr(data->cpu_data, cpu)->depth);
 
 		/*
