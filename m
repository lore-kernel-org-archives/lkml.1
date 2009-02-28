Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbZB1JMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbZB1JMP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 04:12:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbZB1JJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 04:09:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36599 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098AbZB1JJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 04:09:40 -0500
Message-Id: <20090228090937.820225427@goodmis.org>
References: <20090228090646.265765024@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 28 Feb 2009 04:06:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       acme@ghostprotocols.net, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 05/10] tracing: add subsystem sched for sched events
Content-Disposition: inline; filename=0005-tracing-add-subsystem-sched-for-sched-events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Add the TRACE_SYSTEM sched for the sched events.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/trace/sched_event_types.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/trace/sched_event_types.h b/include/trace/sched_event_types.h
index a3d3d66..2ada206 100644
--- a/include/trace/sched_event_types.h
+++ b/include/trace/sched_event_types.h
@@ -5,6 +5,9 @@
 # error Unless you know what you are doing.
 #endif
 
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM sched
+
 TRACE_FORMAT(sched_kthread_stop,
 	TPPROTO(struct task_struct *t),
 	TPARGS(t),
@@ -70,3 +73,5 @@ TRACE_FORMAT(sched_signal_send,
 	TPPROTO(int sig, struct task_struct *p),
 	TPARGS(sig, p),
 	TPFMT("sig: %d   task %s:%d", sig, p->comm, p->pid));
+
+#undef TRACE_SYSTEM
-- 
1.5.6.5

-- 
