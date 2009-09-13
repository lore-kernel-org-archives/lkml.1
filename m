Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbZIMQPO (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sun, 13 Sep 2009 12:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754886AbZIMQPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 12:15:07 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44717 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852AbZIMQPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 12:15:06 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
   akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
   josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
   tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
   Valdis.Kletnieks@vt.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/4] Kconfig help needs to say that TREE_PREEMPT_RCU scales down
Date: Sun, 13 Sep 2009 09:15:08 -0700
Message-Id: <12528585112362-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20090913161438.GA32550@linux.vnet.ibm.com>
References: <20090913161438.GA32550@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To quote Valdis:

	This leaves somebody who has a laptop wondering which choice
	is best for a system with only one or two cores that has
	CONFIG_PREEMPT defined. One choice says it scales down nicely,
	the other explicitly has a 'depends on PREEMPT' attached to it...

So add "scales down nicely" to TREE_PREEMPT_RCU to match that of
TREE_RCU.

Suggested-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 8e8b76d..4c2c936 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -331,7 +331,8 @@ config TREE_PREEMPT_RCU
 	  This option selects the RCU implementation that is
 	  designed for very large SMP systems with hundreds or
 	  thousands of CPUs, but for which real-time response
-	  is also required.
+	  is also required.  It also scales down nicely to
+	  smaller systems.
 
 endchoice
 
-- 
1.5.2.5

