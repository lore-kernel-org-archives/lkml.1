Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbZJZCEG (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sun, 25 Oct 2009 22:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbZJZCEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 22:04:05 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56577 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754532AbZJZCEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 22:04:01 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, avi@redhat.com,
        mtosatti@redhat.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/6] rcu: add synchronize_srcu_expedited() to the documentation
Date: Sun, 25 Oct 2009 19:03:53 -0700
Message-Id: <12565226354176-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091026020253.GA11350@linux.vnet.ibm.com>
References: <20091026020253.GA11350@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/whatisRCU.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index e41a7fe..d542ca2 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -830,7 +830,7 @@ sched:	Critical sections	Grace period		Barrier
 SRCU:	Critical sections	Grace period		Barrier
 
 	srcu_read_lock		synchronize_srcu	N/A
-	srcu_read_unlock
+	srcu_read_unlock	synchronize_srcu_expedited
 
 SRCU:	Initialization/cleanup
 	init_srcu_struct
-- 
1.5.2.5

