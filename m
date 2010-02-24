Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab0BXHk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:40:59 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:58523 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab0BXHk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:40:57 -0500
From: Wenji Huang <wenji.huang@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, rostedt@goodmis.org,
       Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH -tip 3/5] tracing: remove unnecessary variable in print_graph_return
Date: Wed, 24 Feb 2010 15:40:24 +0800
Message-Id: <1266997226-6833-3-git-send-email-wenji.huang@oracle.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1266997226-6833-2-git-send-email-wenji.huang@oracle.com>
References: <1266997226-6833-1-git-send-email-wenji.huang@oracle.com>
 <1266997226-6833-2-git-send-email-wenji.huang@oracle.com>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B84D806.0051:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the local variable of the same name cpu in branch.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
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
1.5.6

