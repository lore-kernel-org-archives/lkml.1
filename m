Return-Path: <linux-kernel-owner+w=401wt.eu-S1759143AbZDGCYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143AbZDGCYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 22:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbZDGCXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 22:23:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62436 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbZDGCXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 22:23:08 -0400
Message-Id: <20090407022305.342936742@goodmis.org>
References: <20090407022242.515462242@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 06 Apr 2009 22:22:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH 2/3] Update /debug/tracing/README
Content-Disposition: inline; filename=0002-Update-debug-tracing-README.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikanth Karthikesan <knikanth@suse.de>

Some of the tracers have been renamed, which was not updated in the in-kernel
run-time README file. Update it.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
LKML-Reference: <200903231158.32151.knikanth@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b0cec4c..0615751 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2360,9 +2360,9 @@ static const char readme_msg[] =
 	"# mkdir /debug\n"
 	"# mount -t debugfs nodev /debug\n\n"
 	"# cat /debug/tracing/available_tracers\n"
-	"wakeup preemptirqsoff preemptoff irqsoff ftrace sched_switch none\n\n"
+	"wakeup preemptirqsoff preemptoff irqsoff function sched_switch nop\n\n"
 	"# cat /debug/tracing/current_tracer\n"
-	"none\n"
+	"nop\n"
 	"# echo sched_switch > /debug/tracing/current_tracer\n"
 	"# cat /debug/tracing/current_tracer\n"
 	"sched_switch\n"
-- 
1.6.2.1

-- 
