Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbZJNR2z (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 14 Oct 2009 13:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbZJNR2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 13:28:53 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54290 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200AbZJNR2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 13:28:50 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, npiggin@suse.de,
        jens.axboe@oracle.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/6] rcu: add exports for synchronize_rcu_expedited()
Date: Wed, 14 Oct 2009 10:15:57 -0700
Message-Id: <12555405591867-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091014171517.GA13635@linux.vnet.ibm.com>
References: <20091014171517.GA13635@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Export synchronize_rcu_expedited() to kernel modules via
EXPORT_SYMBOL_GPL().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index acef871..ebd20ee 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -401,6 +401,7 @@ void synchronize_rcu_expedited(void)
 {
 	synchronize_rcu();
 }
+EXPORT_SYMBOL_GPL(synchronize_rcu_expedited);
 
 /*
  * Check to see if there is any immediate preemptable-RCU-related work
@@ -582,6 +583,7 @@ void synchronize_rcu_expedited(void)
 {
 	synchronize_sched_expedited();
 }
+EXPORT_SYMBOL_GPL(synchronize_rcu_expedited);
 
 /*
  * Because preemptable RCU does not exist, it never has any work to do.
-- 
1.5.2.5

