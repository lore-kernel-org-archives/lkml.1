Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbXJ2VQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbXJ2VQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 17:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbXJ2VQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 17:16:41 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:35383 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbXJ2VQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 17:16:40 -0400
Date: Mon, 29 Oct 2007 14:16:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, tony@bakeyournoodle.com, paulus@samba.org,
       dino@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com, antonb@us.ibm.com,
       rostedt@goodmis.org, niv@us.ibm.com
Subject: Re: [PATCH, RFC] hacks to allow -rt to run kernbench on POWER
Message-ID: <20071029211638.GH8824@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20071029185044.GA23413@linux.vnet.ibm.com> <1193688468.9928.30.camel@pasglop> <20071029202617.GF8824@linux.vnet.ibm.com> <1193690270.9928.35.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193690270.9928.35.camel@pasglop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 07:37:50AM +1100, Benjamin Herrenschmidt wrote:
> 
> On Mon, 2007-10-29 at 13:26 -0700, Paul E. McKenney wrote:
> > 
> > > I see a lot of case where you add preempt_disable/enable around
> > areas
> > > that have the PTE lock held...
> > > 
> > > So in -rt, spin_lock doesn't disable preempt ? I'm a bit worried...
> > > there are some strong requirements that anything within that lock is
> > not
> > > preempted, so zap_pte_ranges() is the obvious ones but all of them
> > would
> > > need to be addressed.
> > 
> > Right in one!  One of the big changes in -rt is that spinlock critical
> > sections (and RCU read-side critical sections, for that matter) are
> > preemptible under CONFIG_PREEMPT_RT.
> > 
> > And I agree that this patchset will have missed quite a few places
> > where
> > additional changes are required.  Hence the word "including" above,
> > rather
> > than something like "specifically".  ;-)
> 
> Ok, well, I'm pretty familiar with that MM code since I wrote a good
> deal of the current version so I'll try to spend some time with your
> patch have a look. It may have to wait for next week though, but feel
> free to ping me if you don't hear back, in case it falls through the
> hole in my brain :-)

Works for me!!!

							Thanx, Paul
