Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbZJNR24 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 14 Oct 2009 13:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbZJNR2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 13:28:55 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:45781 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754264AbZJNR2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 13:28:52 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, npiggin@suse.de,
        jens.axboe@oracle.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 6/6] rcu: Update trace.txt documentation for blocked-tasks lists
Date: Wed, 14 Oct 2009 10:15:59 -0700
Message-Id: <12555405592804-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091014171517.GA13635@linux.vnet.ibm.com>
References: <20091014171517.GA13635@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/trace.txt |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index c1a9550..b1c5c67 100644
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
-- 
1.5.2.5

