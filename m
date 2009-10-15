Return-Path: <linux-kernel-owner+w=401wt.eu-S935081AbZJOJ1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935081AbZJOJ1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933788AbZJOJ1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:27:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:45727 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070AbZJOJ1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:27:21 -0400
Date: Thu, 15 Oct 2009 09:25:52 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12555405592804-git-send-email->
References: <12555405592804-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Update trace.txt documentation for blocked-tasks lists
Message-ID: <tip-0edf1a683e499191b27a067956ae9f5fa6e046c6@git.kernel.org>
Git-Commit-ID: 0edf1a683e499191b27a067956ae9f5fa6e046c6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 09:25:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0edf1a683e499191b27a067956ae9f5fa6e046c6
Gitweb:     http://git.kernel.org/tip/0edf1a683e499191b27a067956ae9f5fa6e046c6
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Wed, 14 Oct 2009 10:15:59 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Oct 2009 11:20:23 +0200

rcu: Update trace.txt documentation for blocked-tasks lists

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
Cc: npiggin@suse.de
Cc: jens.axboe@oracle.com
LKML-Reference: <12555405592804-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/RCU/trace.txt |   23 ++++++++++++++++-------
 1 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index c1a9550..8608fd8 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -158,14 +158,14 @@ o	"gpnum" is the number of grace periods that have started.  It is
 The output of "cat rcu/rcuhier" looks as follows, with very long lines:
 
 c=6902 g=6903 s=2 jfq=3 j=72c7 nfqs=13142/nfqsng=0(13142) fqlh=6 oqlen=0
-1/1 0:127 ^0    
-3/3 0:35 ^0    0/0 36:71 ^1    0/0 72:107 ^2    0/0 108:127 ^3    
-3/3f 0:5 ^0    2/3 6:11 ^1    0/0 12:17 ^2    0/0 18:23 ^3    0/0 24:29 ^4    0/0 30:35 ^5    0/0 36:41 ^0    0/0 42:47 ^1    0/0 48:53 ^2    0/0 54:59 ^3    0/0 60:65 ^4    0/0 66:71 ^5    0/0 72:77 ^0    0/0 78:83 ^1    0/0 84:89 ^2    0/0 90:95 ^3    0/0 96:101 ^4    0/0 102:107 ^5    0/0 108:113 ^0    0/0 114:119 ^1    0/0 120:125 ^2    0/0 126:127 ^3    
+1/1 .>. 0:127 ^0    
+3/3 .>. 0:35 ^0    0/0 .>. 36:71 ^1    0/0 .>. 72:107 ^2    0/0 .>. 108:127 ^3    
+3/3f .>. 0:5 ^0    2/3 .>. 6:11 ^1    0/0 .>. 12:17 ^2    0/0 .>. 18:23 ^3    0/0 .>. 24:29 ^4    0/0 .>. 30:35 ^5    0/0 .>. 36:41 ^0    0/0 .>. 42:47 ^1    0/0 .>. 48:53 ^2    0/0 .>. 54:59 ^3    0/0 .>. 60:65 ^4    0/0 .>. 66:71 ^5    0/0 .>. 72:77 ^0    0/0 .>. 78:83 ^1    0/0 .>. 84:89 ^2    0/0 .>. 90:95 ^3    0/0 .>. 96:101 ^4    0/0 .>. 102:107 ^5    0/0 .>. 108:113 ^0    0/0 .>. 114:119 ^1    0/0 .>. 120:125 ^2    0/0 .>. 126:127 ^3    
 rcu_bh:
 c=-226 g=-226 s=1 jfq=-5701 j=72c7 nfqs=88/nfqsng=0(88) fqlh=0 oqlen=0
-0/1 0:127 ^0    
-0/3 0:35 ^0    0/0 36:71 ^1    0/0 72:107 ^2    0/0 108:127 ^3    
-0/3f 0:5 ^0    0/3 6:11 ^1    0/0 12:17 ^2    0/0 18:23 ^3    0/0 24:29 ^4    0/0 30:35 ^5    0/0 36:41 ^0    0/0 42:47 ^1    0/0 48:53 ^2    0/0 54:59 ^3    0/0 60:65 ^4    0/0 66:71 ^5    0/0 72:77 ^0    0/0 78:83 ^1    0/0 84:89 ^2    0/0 90:95 ^3    0/0 96:101 ^4    0/0 102:107 ^5    0/0 108:113 ^0    0/0 114:119 ^1    0/0 120:125 ^2    0/0 126:127 ^3
+0/1 .>. 0:127 ^0    
+0/3 .>. 0:35 ^0    0/0 .>. 36:71 ^1    0/0 .>. 72:107 ^2    0/0 .>. 108:127 ^3    
+0/3f .>. 0:5 ^0    0/3 .>. 6:11 ^1    0/0 .>. 12:17 ^2    0/0 .>. 18:23 ^3    0/0 .>. 24:29 ^4    0/0 .>. 30:35 ^5    0/0 .>. 36:41 ^0    0/0 .>. 42:47 ^1    0/0 .>. 48:53 ^2    0/0 .>. 54:59 ^3    0/0 .>. 60:65 ^4    0/0 .>. 66:71 ^5    0/0 .>. 72:77 ^0    0/0 .>. 78:83 ^1    0/0 .>. 84:89 ^2    0/0 .>. 90:95 ^3    0/0 .>. 96:101 ^4    0/0 .>. 102:107 ^5    0/0 .>. 108:113 ^0    0/0 .>. 114:119 ^1    0/0 .>. 120:125 ^2    0/0 .>. 126:127 ^3
 
 This is once again split into "rcu_sched" and "rcu_bh" portions,
 and CONFIG_TREE_PREEMPT_RCU kernels will again have an additional
@@ -213,7 +213,7 @@ o	Each element of the form "1/1 0:127 ^0" represents one struct
 	might be either one, two, or three levels of rcu_node structures,
 	depending on the relationship between CONFIG_RCU_FANOUT and
 	CONFIG_NR_CPUS.
-	
+
 	o	The numbers separated by the "/" are the qsmask followed
 		by the qsmaskinit.  The qsmask will have one bit
 		set for each entity in the next lower level that
@@ -228,6 +228,15 @@ o	Each element of the form "1/1 0:127 ^0" represents one struct
 		are still waiting for CPUs 2 and 4 to check in for the
 		current grace period.
 
+	o	The characters separated by the ">" indicate the state
+		of the blocked-tasks lists.  A "T" preceding the ">"
+		indicates that at least one task blocked in an RCU
+		read-side critical section blocks the current grace
+		period, while a "." preceding the ">" indicates otherwise.
+		The character following the ">" indicates similarly for
+		the next grace period.  A "T" should appear in this
+		field only for rcu-preempt.
+
 	o	The numbers separated by the ":" are the range of CPUs
 		served by this struct rcu_node.  This can be helpful
 		in working out how the hierarchy is wired together.
