Return-Path: <linux-kernel-owner+w=401wt.eu-S1758692AbZJGNv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692AbZJGNv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbZJGNv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:51:28 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:45213 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440AbZJGNv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:51:28 -0400
Date: Wed, 7 Oct 2009 06:50:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 2/3] rcu: make hot-unplugged CPU
	relinquish its own RCU callbacks
Message-ID: <20091007135049.GF6838@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091007044748.GA12763@linux.vnet.ibm.com> <1254921372.1696.132.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254921372.1696.132.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 09:16:12AM -0400, Steven Rostedt wrote:
> Paul,
> 
> Still suffering jetlag? ;-)

As a matter of fact, yes.  ;-)

> On Tue, 2009-10-06 at 21:48 -0700, Paul E. McKenney wrote:
> > From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > The current interaction between RCU and CPU hotplug requires that
> > RCU block in CPU notifiers waiting for callbacks to drain.  This can
> > be greatly simplified by haing each CPU relinquish its own callbacks,
>                            having
> 
> > and for both _rcu_barrier() and CPU_DEAD notifiers to adopt all callbacks
> > that were previously relinquished.  This change also eliminates the
> > possibility of certain types of hangs due to the previous practice of
> > waiting for callbacks to be invoked from within CPU notifiers.  If you
> > don't every wait, you cannot hang.
>         ever
> 
> ;-)

Courtesy of "git cherry-pick" and my being out of it.  ;-)

							Thanx, Paul

> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> -- Steve
> 
> 
