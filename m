Return-Path: <linux-kernel-owner+w=401wt.eu-S1761278AbZLPK0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761278AbZLPK0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 05:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761244AbZLPK0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 05:26:18 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41635 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761241AbZLPK0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 05:26:14 -0500
Subject: Re: [PATCH RFC tip/core/rcu 14/18] rcu: lockdep check for exiting
 to user space as RCU reader
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
In-Reply-To: <12609181612244-git-send-email->
References: <20091215230213.GA9093@linux.vnet.ibm.com>
	 <12609181612244-git-send-email->
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 11:24:42 +0100
Message-ID: <1260959082.17860.35.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-15 at 15:02 -0800, Paul E. McKenney wrote:
> From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Proposed for 2.6.34, not for inclusion.
> 
> It is illegal to return to user-space execution while running within an
> RCU read-side critical section.  It turns out that CONFIG_TREE_PREEMPT_RCU
> has enough information lying around to detect this, so add the checks
> to lockdep (CONFIG_PROVE_LOCKING).

But uhm, we already track the rcu read lock as a regular lockdep lock,
so it should already check this, no?


