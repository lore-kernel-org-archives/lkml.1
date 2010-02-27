Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030763Ab0B0Wwn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 17:52:43 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34022 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964920Ab0B0Wwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 17:52:42 -0500
Date: Sat, 27 Feb 2010 14:52:40 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH tip/core/rcu 0/2] more lockdep-RCU and RCU_FAST_NO_HZ fixes
Message-ID: <20100227225240.GA16515@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series (1) makes RCU_FAST_NO_HZ actually do the full number of
iterations specified instead of just one and (2) fixes an RCU lockdep
splat.

							Thanx, Paul

------------------------------------------------------------------------

 include/linux/cgroup.h  |    2 +-
 kernel/rcutree_plugin.h |    9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)
