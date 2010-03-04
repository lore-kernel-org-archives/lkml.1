Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab0CDUgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 15:36:54 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57220 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756315Ab0CDUgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 15:36:52 -0500
Date: Thu, 4 Mar 2010 12:36:49 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 2/4] rcu: suppress RCU lockdep warnings
	during early boot
Message-ID: <20100304203649.GJ6768@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100303154638.GA8576@linux.vnet.ibm.com> <1267631219-8713-2-git-send-email-paulmck@linux.vnet.ibm.com> <20100304111245.GD21977@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100304111245.GD21977@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 12:12:45PM +0100, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > @@ -154,6 +167,10 @@ static inline int rcu_read_lock_sched_held(void)
> >  # define rcu_read_acquire_sched()	do { } while (0)
> >  # define rcu_read_release_sched()	do { } while (0)
> >  
> > +static inline void debug_lockdep_rcu_update(void)
> > +{
> > +}
> > +
> 
> Note, this method was only included for the !CONFIG_DEBUG_LOCK_ALLOC case, so 
> i left it out for the time being.
> 
> Which may result in a somewhat incomplete debug state, but it would at least 
> build with lockdep enabled ;-)

Indeed, I clearly didn't test with the boot-time lock testing enabled.  :-/

Please accept my apologies for my mess-up, and thank you for fixing it!

							Thanx, Paul
