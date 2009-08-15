Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239AbZHOQyA (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 15 Aug 2009 12:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932154AbZHOQx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 12:53:57 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:55103 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932073AbZHOQxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 12:53:53 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
   josht@linux.vnet.ibm.com, akpm@linux-foundation.org,
   mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
   tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
   hugh.dickins@tiscali.co.uk, benh@kernel.crashing.org,
   "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
   Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH -tip/core/rcu 6/6] Fix typo in rcu_irq_exit() comment header.
Date: Sat, 15 Aug 2009 09:53:51 -0700
Message-Id: <1250355231169-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20090815165153.GA8886@linux.vnet.ibm.com>
References: <20090815165153.GA8886@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcupreempt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index 2748b89..510898a 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -548,7 +548,7 @@ void rcu_irq_enter(void)
  * rcu_irq_exit - Called from exiting Hard irq context.
  *
  * If the CPU was idle with dynamic ticks active, update the
- * rcu_dyntick_sched.dynticks to put let the RCU handling be
+ * rcu_dyntick_sched.dynticks to let the RCU handling be
  * aware that the CPU is going back to idle with no ticks.
  */
 void rcu_irq_exit(void)
-- 
1.5.2.5

