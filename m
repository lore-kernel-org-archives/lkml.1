Return-Path: <linux-kernel-owner+w=401wt.eu-S1753611AbZBJIz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbZBJIz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 03:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbZBJIyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 03:54:43 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:28002 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbZBJIym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 03:54:42 -0500
From: Wenji Huang <wenji.huang@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, fweisbec@gmail.com,
       Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH 1/3] trace: remove unneeded variable.
Date: Tue, 10 Feb 2009 01:02:46 -0500
Message-Id: <1234245766-14506-1-git-send-email-wenji.huang@oracle.com>
X-Mailer: git-send-email 1.5.6
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.499140CB.006B:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the unnecessary variable ret.

Impact: clean up.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
---
 kernel/trace/trace_branch.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index f8ae2c5..c2e68d4 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -91,8 +91,6 @@ void trace_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 
 int enable_branch_tracing(struct trace_array *tr)
 {
-	int ret = 0;
-
 	mutex_lock(&branch_tracing_mutex);
 	branch_tracer = tr;
 	/*
@@ -103,7 +101,7 @@ int enable_branch_tracing(struct trace_array *tr)
 	branch_tracing_enabled++;
 	mutex_unlock(&branch_tracing_mutex);
 
-	return ret;
+	return 0;
 }
 
 void disable_branch_tracing(void)
-- 
1.5.6

