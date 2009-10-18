Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbZJRWwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbZJRWwk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 18:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbZJRWwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 18:52:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60168 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbZJRWwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 18:52:39 -0400
Date: Mon, 19 Oct 2009 00:52:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>,
       Jan Blunck <jblunck@suse.de>,
       Steven Munroe <munroesj@linux.vnet.ibm.com>, rp@svcs.cs.pdx.edu,
       Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca, Pierre Habouzit <madcoder@debian.org>,
       Jon Bernard <jbernard@debian.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Bert Wesarg <bert.wesarg@googlemail.com>
Subject: Re: [rp] Userspace RCU 0.2.3
Message-ID: <20091018225234.GA9164@elf.ucw.cz>
References: <20091014223657.GC6458@Krystal>
 <20091015000225.GG6763@linux.vnet.ibm.com>
 <20091015023925.GA27959@Krystal>
 <20091015090042.GA7677@feather>
 <4AD75EA6.8080809@polymtl.ca>
 <20091017171615.GD1526@ucw.cz>
 <20091018220243.GA32405@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091018220243.GA32405@Krystal>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-10-18 18:02:43, Mathieu Desnoyers wrote:
> * Pavel Machek (pavel@ucw.cz) wrote:
> > On Thu 2009-10-15 13:40:54, Pierre-Marc Fournier wrote:
> > > Josh Triplett wrote:
> > > > 
> > > > Even Debian has given up on real 386 systems at this point, primarily
> > > > because system libraries like glibc have; 486 and better represents the
> > > > bare minimum required at this point.  I don't know of any distributions
> > > > supporting real 386 systems at this point, and doing so would represent
> > > > a major undertaking.
> > > > 
> > > 
> > > What about embedded systems? Anyone know if some 386 chips, perhaps even
> > > in smp configurations, are still in use in those?
> > 
> > smp 386: definitely not.
> 
> Hrm, so for UP 386, I wonder what's the best approach.
> 
> One would be to encapsulate all write accesses to the RCU pointers. If
> we detect that the architecture lacks cmpxchg, _all_ update operations
> (rcu_assign_pointer, rcu_xchg_pointer and rcu_cmpxchg_pointer) would
> have to use the signal-disabled+mutex fall-back.
> 
> Does it make sense ?

Yep, but it sounds expensive. Another option is to ignore the issue
and see how many people still have 386s :-). Few  embedded  systems
may be affected, but...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
