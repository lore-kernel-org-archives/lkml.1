Return-Path: <linux-kernel-owner+w=401wt.eu-S1762248AbZLPPLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762248AbZLPPLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 10:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762228AbZLPPLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 10:11:22 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48439 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762239AbZLPPLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 10:11:16 -0500
Date: Wed, 16 Dec 2009 07:11:11 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH RFC tip/core/rcu 14/18] rcu: lockdep check for exiting
	to user space as RCU reader
Message-ID: <20091216151111.GA6744@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091215230213.GA9093@linux.vnet.ibm.com> <1260959082.17860.35.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260959082.17860.35.camel@laptop>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 11:24:42AM +0100, Peter Zijlstra wrote:
> On Tue, 2009-12-15 at 15:02 -0800, Paul E. McKenney wrote:
> > From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Proposed for 2.6.34, not for inclusion.
> > 
> > It is illegal to return to user-space execution while running within an
> > RCU read-side critical section.  It turns out that CONFIG_TREE_PREEMPT_RCU
> > has enough information lying around to detect this, so add the checks
> > to lockdep (CONFIG_PROVE_LOCKING).
> 
> But uhm, we already track the rcu read lock as a regular lockdep lock,
> so it should already check this, no?

I guess I can drop that patch, then.  ;-)

Thank you for looking this over!

							Thanx, Paul
