Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbZA1PI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbZA1PI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 10:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbZA1PIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 10:08:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42819 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbZA1PIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 10:08:47 -0500
Date: Wed, 28 Jan 2009 13:08:37 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip] trace_sched_wakeup: Remove unused variable
Message-ID: <20090128150837.GC627@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup
    
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 93cecda..a48c9b4 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -184,13 +184,10 @@ out:
 
 static void __wakeup_reset(struct trace_array *tr)
 {
-	struct trace_array_cpu *data;
 	int cpu;
 
-	for_each_possible_cpu(cpu) {
-		data = tr->data[cpu];
+	for_each_possible_cpu(cpu)
 		tracing_reset(tr, cpu);
-	}
 
 	wakeup_cpu = -1;
 	wakeup_prio = -1;
