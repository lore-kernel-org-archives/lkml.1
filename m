Return-Path: <linux-kernel-owner+w=401wt.eu-S935093AbZJOJF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935093AbZJOJF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935067AbZJOJFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:05:25 -0400
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:40501 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935061AbZJOJFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:05:25 -0400
Date: Thu, 15 Oct 2009 02:00:43 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Jon Bernard <jbernard@debian.org>, Jan Blunck <jblunck@suse.de>,
       Pierre Habouzit <madcoder@debian.org>,
       Steven Munroe <munroesj@linux.vnet.ibm.com>,
       Bert Wesarg <bert.wesarg@googlemail.com>,
       Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>,
       ltt-dev@lists.casi.polymtl.ca, rp@svcs.cs.pdx.edu,
       linux-kernel@vger.kernel.org
Subject: Re: Userspace RCU 0.2.3
Message-ID: <20091015090042.GA7677@feather>
References: <20091014223657.GC6458@Krystal>
 <20091015000225.GG6763@linux.vnet.ibm.com>
 <20091015023925.GA27959@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015023925.GA27959@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
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

Even Debian has given up on real 386 systems at this point, primarily
because system libraries like glibc have; 486 and better represents the
bare minimum required at this point.  I don't know of any distributions
supporting real 386 systems at this point, and doing so would represent
a major undertaking.

- Josh Triplett
