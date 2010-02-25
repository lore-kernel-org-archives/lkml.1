Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933539Ab0BYTqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 14:46:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51177 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933448Ab0BYTpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:45:31 -0500
X-Authority-Analysis: v=1.0 c=1 a=izPsiRU1U3oA:10 a=yPCof4ZbAAAA:8 a=meVymXHHAAAA:8 a=2A4we_5U9G-I7y0qdXkA:9 a=dlMbwphKyHpJQJh_N8Ktv3K94WwA:4 a=7DSvI1NPTFQA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100225194529.962504036@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 25 Feb 2010 14:44:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH 6/7] tracing: Remove unnecessary variable in print_graph_return
References: <20100225194355.707261669@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-Remove-unnecessary-variable-in-print_graph_r.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wenji Huang <wenji.huang@oracle.com>

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
-- 
1.6.5


