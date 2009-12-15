Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934293AbZLOXPv (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 15 Dec 2009 18:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761866AbZLOXPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:15:40 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44976 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934171AbZLOXCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:02:46 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 12/18] rcu: make MAINTAINERS file match new RCU reality
Date: Tue, 15 Dec 2009 15:02:35 -0800
Message-Id: <12609181613187-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091215230213.GA9093@linux.vnet.ibm.com>
References: <20091215230213.GA9093@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Proposed for 2.6.34, not for inclusion.

Both rcutorture and RCU are supported.  Also, update the files
to match the new layout.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 MAINTAINERS |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e1da925..21c9d3b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4335,7 +4335,7 @@ F:	drivers/net/wireless/ray*
 RCUTORTURE MODULE
 M:	Josh Triplett <josh@freedesktop.org>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
-S:	Maintained
+S:	Supported
 F:	Documentation/RCU/torture.txt
 F:	kernel/rcutorture.c
 
@@ -4360,11 +4360,12 @@ M:	Dipankar Sarma <dipankar@in.ibm.com>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
 W:	http://www.rdrop.com/users/paulmck/rclock/
 S:	Supported
-F:	Documentation/RCU/rcu.txt
-F:	Documentation/RCU/rcuref.txt
-F:	include/linux/rcupdate.h
-F:	include/linux/srcu.h
-F:	kernel/rcupdate.c
+F:	Documentation/RCU/
+F:	include/linux/rcu*
+F:	include/linux/srcu*
+F:	kernel/rcu*
+F:	kernel/srcu*
+X:	kernel/rcutorture.c
 
 REAL TIME CLOCK DRIVER
 M:	Paul Gortmaker <p_gortmaker@yahoo.com>
-- 
1.5.2.5

