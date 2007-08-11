Return-Path: <linux-kernel-owner+w=401wt.eu-S1761251AbXHKTju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761251AbXHKTju (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 15:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbXHKTjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 15:39:41 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36562 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbXHKTjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 15:39:40 -0400
Date: Sat, 11 Aug 2007 12:39:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       Josh Triplett <josh@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm1: rcutorture xtime usage
Message-ID: <20070811193937.GB13410@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org> <20070810013146.GD18938@stusta.de> <20070810020040.GK8424@linux.vnet.ibm.com> <20070809190623.f60dcf70.akpm@linux-foundation.org> <20070810151208.GC8511@linux.vnet.ibm.com> <20070810101212.d59ce24a.akpm@linux-foundation.org> <20070810203055.GE8511@linux.vnet.ibm.com> <20070811002949.GA7918@linux.vnet.ibm.com> <20070811180909.GC24717@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070811180909.GC24717@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2007 at 08:09:09PM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Add an EXPORT_SYMBOL_GPL() for cpu_clock() and make rcutorture.c use it.
> > Compiles, but not yet tested.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> > --- linux-2.6.23-rc2/kernel/sched.c	2007-08-03 19:49:55.000000000 -0700
> > +++ linux-2.6.23-rc2-rcutorturesched/kernel/sched.c	2007-08-10 17:22:57.000000000 -0700
> > @@ -394,6 +394,8 @@ unsigned long long cpu_clock(int cpu)
> >  	return now;
> >  }
> >  
> > +EXPORT_SYMBOL_GPL(cpu_clock);
> 
> sure enough,
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>

Thank you!

Just for the record, given that the xtime API that it replaces
was EXPORT_SYMBOL(), I would have not objection to this also being
EXPORT_SYMBOL().  That said, I know of no specific reason for it being
other than EXPORT_SYMBOL_GPL().

						Thanx, Paul
