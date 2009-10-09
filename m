Return-Path: <linux-kernel-owner+w=401wt.eu-S1761559AbZJIWue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761559AbZJIWue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 18:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761539AbZJIWue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 18:50:34 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57886 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761522AbZJIWud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 18:50:33 -0400
Date: Fri, 9 Oct 2009 15:49:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, avi@redhat.com,
       mtosatti@redhat.com, torvalds@linux-foundation.org
Subject: [PATCH RFC tip/core/rcu 0/3] Tiny RCU and expedited SRCU
Message-ID: <20091009224954.GA26516@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series rebases TINY_RCU and creates an expedited SRCU along with
corresponding RCU torture tests.  These are post-2.6.32 material.

							Thanx, Paul


 include/linux/hardirq.h  |   24 ++++
 include/linux/rcupdate.h |    6 +
 include/linux/rcutiny.h  |  103 +++++++++++++++++
 include/linux/srcu.h     |    1 
 init/Kconfig             |    9 +
 kernel/Makefile          |    1 
 kernel/rcupdate.c        |    4 
 kernel/rcutiny.c         |  282 ++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/rcutorture.c      |   26 +++-
 kernel/srcu.c            |   75 ++++++++----
 10 files changed, 502 insertions(+), 29 deletions(-)
