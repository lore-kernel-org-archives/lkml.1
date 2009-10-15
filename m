Return-Path: <linux-kernel-owner+w=401wt.eu-S1751563AbZJOEem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbZJOEem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 00:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbZJOEem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 00:34:42 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:47275 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbZJOEel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 00:34:41 -0400
Date: Wed, 14 Oct 2009 21:34:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Josh Triplett <josh@joshtriplett.org>, Jon Bernard <jbernard@debian.org>,
       Jan Blunck <jblunck@suse.de>, Pierre Habouzit <madcoder@debian.org>,
       Steven Munroe <munroesj@linux.vnet.ibm.com>,
       Bert Wesarg <bert.wesarg@googlemail.com>,
       Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>,
       ltt-dev@lists.casi.polymtl.ca, rp@svcs.cs.pdx.edu,
       linux-kernel@vger.kernel.org
Subject: Re: Userspace RCU 0.2.3
Message-ID: <20091015043402.GA6837@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091014223657.GC6458@Krystal> <20091015000225.GG6763@linux.vnet.ibm.com> <20091015023925.GA27959@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015023925.GA27959@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 10:39:25PM -0400, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Wed, Oct 14, 2009 at 06:36:57PM -0400, Mathieu Desnoyers wrote:
> > > Hi,
> > > 
> > > I just released lib urcu 0.2.3, which is now using autotools. I also
> > > integrated automatic architecture detection for old 386 which lack
> > > cmpxchg (using a fall-back if necessary). I also use a lock; addl
> > > instead of mfence on x86-32 to support a larger variety of older Intel
> > > CPUs.
> > 
> > !!!
> > 
> > Is there anyone on these lists other than me who has actually used an
> > SMP 80386-based system?
> 
> SMP 386, ugh, no. But UP 386 yes (at least me). :)
> 
> It will become important as the library gets integrated in
> distributions.
> 
> > Either way, much appreciated for old time's sake.  The things we used
> > to do to avoid the need for cmpxchg!  ;-)
> 
> In this case I disable signals and take a mutex around the cmpxchg. It's
> really a best effort. Should be fine on UP 386, but not so much on SMP
> 386, as mixing it with assign/xchg pointer could lead to races. I'm not
> sure it's worth trying to support 386 SMP though.

Definitely not worth much, if anything, to support 386 SMP.

							Thanx, Paul
