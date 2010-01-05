Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab0AEAES (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 4 Jan 2010 19:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481Ab0AEAEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:04:15 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44392 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754Ab0AEAEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:04:10 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/3] rcu: make MAINTAINERS file match new RCU reality
Date: Mon,  4 Jan 2010 16:04:00 -0800
Message-Id: <12626498422334-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20100105000337.GA23307@linux.vnet.ibm.com>
References: <20100105000337.GA23307@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

