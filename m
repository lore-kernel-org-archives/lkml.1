Return-Path: <linux-kernel-owner+w=401wt.eu-S1752110AbZLNFm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbZLNFm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 00:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbZLNFmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 00:42:25 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:34669 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbZLNFmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 00:42:24 -0500
From: Wenji Huang <wenji.huang@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH] tracing: remove unnecessary variable in print_graph_return
Date: Mon, 14 Dec 2009 13:39:32 +0800
Message-Id: <1260769172-16657-1-git-send-email-wenji.huang@oracle.com>
X-Mailer: git-send-email 1.5.6
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B25D03B.0094:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the local variable of the same name cpu in branch.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
---
 kernel/trace/trace_functions_graph.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index a43d009..51d071c 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -858,7 +858,6 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 	int i;
 
 	if (data) {
-		int cpu = iter->cpu;
 		int *depth = &(per_cpu_ptr(data->cpu_data, cpu)->depth);
 
 		/*
-- 
1.5.6

