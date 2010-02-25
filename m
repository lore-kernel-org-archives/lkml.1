Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934214Ab0BYWG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 17:06:29 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37296 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933895Ab0BYWG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 17:06:27 -0500
Date: Thu, 25 Feb 2010 14:06:24 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH tip/core/rcu 0/2] rcu: fixes for RCU lockdep
Message-ID: <20100225220624.GA7013@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This set fixes a couple of problems with the RCU-based lockdep patches:

1.	Make the lockdep_rcu_dereference() message less alarmist

2.	Make rcu_read_lock_sched_held() take boot-time lack of
	preemption into account.

							Thanx, Paul

------------------------------------------------------------------------

 include/linux/rcupdate.h |    4 +++-
 include/linux/rcutiny.h  |    4 ----
 include/linux/rcutree.h  |    1 -
 kernel/lockdep.c         |    7 +++----
 kernel/rcupdate.c        |   18 ++++++++++++++++++
 kernel/rcutree.c         |   20 --------------------
 6 files changed, 24 insertions(+), 30 deletions(-)
