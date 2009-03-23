Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbZCWGbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbZCWGbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 02:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbZCWGbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 02:31:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37392 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163AbZCWGbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 02:31:01 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] Update /debug/tracing/README
Date: Mon, 23 Mar 2009 11:58:31 +0530
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc8-default; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903231158.32151.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the tracers have been renamed, which was not updated in the in-kernel
run-time README file. Update it.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 17bb88d..45ddd67 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2886,9 +2886,9 @@ static const char readme_msg[] =
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

