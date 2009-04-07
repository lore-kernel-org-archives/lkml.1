Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbZDGNPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbZDGNPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756967AbZDGNON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:14:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:59417 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756912AbZDGNOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:14:11 -0400
Date: Tue, 7 Apr 2009 13:13:38 GMT
From: Nikanth Karthikesan <knikanth@suse.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, knikanth@suse.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, knikanth@suse.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <200903231158.32151.knikanth@suse.de>
References: <200903231158.32151.knikanth@suse.de>
Subject: [tip:tracing/urgent] Update /debug/tracing/README
Message-ID: <tip-bc2b6871c17b3aff79fb14e1a1c06c5f5a187f76@git.kernel.org>
Git-Commit-ID: bc2b6871c17b3aff79fb14e1a1c06c5f5a187f76
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Apr 2009 13:13:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bc2b6871c17b3aff79fb14e1a1c06c5f5a187f76
Gitweb:     http://git.kernel.org/tip/bc2b6871c17b3aff79fb14e1a1c06c5f5a187f76
Author:     Nikanth Karthikesan <knikanth@suse.de>
AuthorDate: Mon, 23 Mar 2009 11:58:31 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 14:02:36 +0200

Update /debug/tracing/README

Some of the tracers have been renamed, which was not updated in the in-kernel
run-time README file. Update it.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
LKML-Reference: <200903231158.32151.knikanth@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index fc8c7d6..9d28476 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2369,9 +2369,9 @@ static const char readme_msg[] =
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
