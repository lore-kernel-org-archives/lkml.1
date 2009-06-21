Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZFULQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZFULQa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 07:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbZFULQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 07:16:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:60591 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbZFULQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 07:16:22 -0400
Date: Sun, 21 Jun 2009 11:15:35 GMT
From: tip-bot for Wolfram Sang <w.sang@pengutronix.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, w.sang@pengutronix.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, w.sang@pengutronix.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1245580359-4465-1-git-send-email-w.sang@pengutronix.de>
References: <1245580359-4465-1-git-send-email-w.sang@pengutronix.de>
Subject: [tip:sched/urgent] sched: Documentation/sched-rt-group: Fix style issues & bump version
Message-ID: <tip-d4ec36bac3de39b7e10ec8f42fbdd20d9a9ed753@git.kernel.org>
Git-Commit-ID: d4ec36bac3de39b7e10ec8f42fbdd20d9a9ed753
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 21 Jun 2009 11:15:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d4ec36bac3de39b7e10ec8f42fbdd20d9a9ed753
Gitweb:     http://git.kernel.org/tip/d4ec36bac3de39b7e10ec8f42fbdd20d9a9ed753
Author:     Wolfram Sang <w.sang@pengutronix.de>
AuthorDate: Sun, 21 Jun 2009 12:32:39 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 21 Jun 2009 13:12:46 +0200

sched: Documentation/sched-rt-group: Fix style issues & bump version

- add missing closing bracket
- fix two 80-chars issues (as the rest of the document adheres to it)
- bump a reference to kernel version, so the document does not feel aged

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1245580359-4465-1-git-send-email-w.sang@pengutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/scheduler/sched-rt-group.txt |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/Documentation/scheduler/sched-rt-group.txt b/Documentation/scheduler/sched-rt-group.txt
index 1df7f9c..86eabe6 100644
--- a/Documentation/scheduler/sched-rt-group.txt
+++ b/Documentation/scheduler/sched-rt-group.txt
@@ -73,7 +73,7 @@ The remaining CPU time will be used for user input and other tasks. Because
 realtime tasks have explicitly allocated the CPU time they need to perform
 their tasks, buffer underruns in the graphics or audio can be eliminated.
 
-NOTE: the above example is not fully implemented as of yet (2.6.25). We still
+NOTE: the above example is not fully implemented yet. We still
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
