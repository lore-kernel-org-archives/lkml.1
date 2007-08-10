Return-Path: <linux-kernel-owner+w=401wt.eu-S941607AbXHJUb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941607AbXHJUb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 16:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933697AbXHJUa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 16:30:57 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:42527 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932508AbXHJUa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 16:30:56 -0400
Date: Fri, 10 Aug 2007 13:30:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, Josh Triplett <josh@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm1: rcutorture xtime usage
Message-ID: <20070810203055.GE8511@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org> <20070810013146.GD18938@stusta.de> <20070810020040.GK8424@linux.vnet.ibm.com> <20070809190623.f60dcf70.akpm@linux-foundation.org> <20070810151208.GC8511@linux.vnet.ibm.com> <20070810101212.d59ce24a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810101212.d59ce24a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 10:12:12AM -0700, Andrew Morton wrote:
> On Fri, 10 Aug 2007 08:12:08 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > > One used to use sched_clock() for this, then get frowned at.  Now we
> > > have cpu_clock()...
> > 
> > Hmmm...  And cpu_clock() is not in 2.6.22, so must appear in some later
> > release.  Which means that the rate of API change in this area is a
> > bit high, so I should avoid it like the plague.
> 
> eh, it's been there for weeks.  It is dust-encrusted.
> 
> >  Therefore, I should
> > look for some other convenient source of entropy.
> > 
> > One convenient source would the per-CPU statistics that rcutorture
> > maintains.  Of course, a given CPU's RNG is nearly in lock-step with
> > its own statistics, but not with the adjacent CPU's statistics...
> > 
> > I will send a patch.
> 
> Please use cpu_clock().  It ain't going away.

D'accord...

							Thanx, Paul
