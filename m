Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050AbZBQJcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbZBQJcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 04:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbZBQJcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 04:32:32 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:29564 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbZBQJca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 04:32:30 -0500
From: Wenji Huang <wenji.huang@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, Wenji Huang <wenji.huang@oracle.com>
Subject: [RE-SEND PATCH 1/3] tracing: use the more proper parameter.
Date: Tue, 17 Feb 2009 01:07:28 -0500
Message-Id: <1234850848-3525-1-git-send-email-wenji.huang@oracle.com>
X-Mailer: git-send-email 1.5.6
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.499A8428.0138:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass tsk to tracing_record_cmdline instead of current.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
---
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 95f99a7..dc61e82 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -336,7 +336,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 	data->rt_priority = tsk->rt_priority;
 
 	/* record this tasks comm */
-	tracing_record_cmdline(current);
+	tracing_record_cmdline(tsk);
 }
 
 static void
-- 
1.5.6

