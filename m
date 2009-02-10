Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbZBJRit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbZBJRit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 12:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754423AbZBJRgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 12:36:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52675 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbZBJRgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 12:36:20 -0500
Message-Id: <20090210173618.848913407@goodmis.org>
References: <20090210173504.973802731@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 10 Feb 2009 12:35:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wenji Huang <wenji.huang@oracle.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 5/7] tracing: remove unneeded variable
Content-Disposition: inline; filename=0005-tracing-remove-unneeded-variable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wenji Huang <wenji.huang@oracle.com>

Impact: clean up.

Remove the unnecessary variable ret.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
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
1.5.6.5

-- 
