Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbZJZLiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbZJZLiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 07:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834AbZJZLiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 07:38:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:57241 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755815AbZJZLiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 07:38:11 -0400
Date: Mon, 26 Oct 2009 11:37:27 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, josh@joshtriplett.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, josh@joshtriplett.org,
       laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <12565226354176-git-send-email->
References: <12565226354176-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Add synchronize_srcu_expedited() to the documentation
Message-ID: <tip-64179861cb801eac4f00c79f39a29ea5ac9470d7@git.kernel.org>
Git-Commit-ID: 64179861cb801eac4f00c79f39a29ea5ac9470d7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  64179861cb801eac4f00c79f39a29ea5ac9470d7
Gitweb:     http://git.kernel.org/tip/64179861cb801eac4f00c79f39a29ea5ac9470d7
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Sun, 25 Oct 2009 19:03:53 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 26 Oct 2009 09:40:31 +0100

rcu: Add synchronize_srcu_expedited() to the documentation

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Josh Triplett <josh@joshtriplett.org>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
Cc: avi@redhat.com
Cc: mtosatti@redhat.com
LKML-Reference: <12565226354176-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
