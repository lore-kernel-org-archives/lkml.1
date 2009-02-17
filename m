Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297AbZBQSWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbZBQSWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 13:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbZBQSV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 13:21:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63831 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbZBQSV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:21:27 -0500
Message-Id: <20090217182125.548603464@goodmis.org>
References: <20090217182048.233060814@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Feb 2009 13:20:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Wenji Huang <wenji.huang@oracle.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/6] tracing: use the more proper parameter
Content-Disposition: inline; filename=0003-tracing-use-the-more-proper-parameter.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wenji Huang <wenji.huang@oracle.com>

Pass tsk to tracing_record_cmdline instead of current.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
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
1.5.6.5

-- 
