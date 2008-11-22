Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbYKVAJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbYKVAJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 19:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbYKVAJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 19:09:14 -0500
Received: from [212.55.154.24] ([212.55.154.24]:40248 "HELO sapo.pt"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751989AbYKVAJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 19:09:14 -0500
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Sat, 22 Nov 2008 00:09:00 +0000
From: Luis Henriques <henrix@sapo.pt>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org
Subject: [PATCH] debugfs README file contents update
Message-ID: <20081122000900.GC9264@hades>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the debugfs README file contents.  Just some minor changes:
the list of available tracers and the name of the default current_tracer.

Signed-off-by: Luis Henriques <henrix@sapo.pt>
---
 kernel/trace/trace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d86e325..f19c4be 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2280,9 +2280,9 @@ static const char readme_msg[] =
 	"# mkdir /debug\n"
 	"# mount -t debugfs nodev /debug\n\n"
 	"# cat /debug/tracing/available_tracers\n"
-	"wakeup preemptirqsoff preemptoff irqsoff ftrace sched_switch none\n\n"
+	"wakeup preemptirqsoff preemptoff irqsoff function sysprof sched_switch nop\n\n"
 	"# cat /debug/tracing/current_tracer\n"
-	"none\n"
+	"nop\n"
 	"# echo sched_switch > /debug/tracing/current_tracer\n"
 	"# cat /debug/tracing/current_tracer\n"
 	"sched_switch\n"
-- 
1.6.0.4

