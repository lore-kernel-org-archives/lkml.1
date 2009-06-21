Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbZFUKcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbZFUKcy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 06:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbZFUKcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 06:32:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57833 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbZFUKco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 06:32:44 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: w.sang@pengutronix.de
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Date: Sun, 21 Jun 2009 12:32:39 +0200
Message-Id: <1245580359-4465-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.6.3.1
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH] [TRIVIAL] Documentation/sched-rt-group: Fix style issues & bump version
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- add missing closing bracket
- fix two 80-chars issues (as the rest of the document adheres to it)
- bump a reference to kernel version, so the document does not feel aged

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
---
 Documentation/scheduler/sched-rt-group.txt |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/Documentation/scheduler/sched-rt-group.txt b/Documentation/scheduler/sched-rt-group.txt
index 1df7f9c..f1fd4af 100644
--- a/Documentation/scheduler/sched-rt-group.txt
+++ b/Documentation/scheduler/sched-rt-group.txt
@@ -73,7 +73,7 @@ The remaining CPU time will be used for user input and other tasks. Because
 realtime tasks have explicitly allocated the CPU time they need to perform
 their tasks, buffer underruns in the graphics or audio can be eliminated.
 
-NOTE: the above example is not fully implemented as of yet (2.6.25). We still
+NOTE: the above example is not fully implemented as of yet (2.6.31). We still
 lack an EDF scheduler to make non-uniform periods usable.
 
 
@@ -140,14 +140,15 @@ The other option is:
 
 .o CONFIG_CGROUP_SCHED (aka "Basis for grouping tasks" = "Control groups")
 
-This uses the /cgroup virtual file system and "/cgroup/<cgroup>/cpu.rt_runtime_us"
-to control the CPU time reserved for each control group instead.
+This uses the /cgroup virtual file system and
+"/cgroup/<cgroup>/cpu.rt_runtime_us" to control the CPU time reserved for each
+control group instead.
 
 For more information on working with control groups, you should read
 Documentation/cgroups/cgroups.txt as well.
 
-Group settings are checked against the following limits in order to keep the configuration
-schedulable:
+Group settings are checked against the following limits in order to keep the
+configuration schedulable:
 
    \Sum_{i} runtime_{i} / global_period <= global_runtime / global_period
 
@@ -189,7 +190,7 @@ Implementing SCHED_EDF might take a while to complete. Priority Inheritance is
 the biggest challenge as the current linux PI infrastructure is geared towards
 the limited static priority levels 0-99. With deadline scheduling you need to
 do deadline inheritance (since priority is inversely proportional to the
-deadline delta (deadline - now).
+deadline delta (deadline - now)).
 
 This means the whole PI machinery will have to be reworked - and that is one of
 the most complex pieces of code we have.
-- 
1.6.3.1

