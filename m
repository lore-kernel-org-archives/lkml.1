Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbXJBP2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbXJBP2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbXJBP2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:28:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39469 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbXJBP2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:28:00 -0400
Date: Tue, 2 Oct 2007 17:27:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, akpm@osdl.org
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
Message-ID: <20071002152727.GA18550@elte.hu>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <alpine.LRH.0.999.0710021250510.23586@www.tglx.de> <20071002140711.GA29395@elte.hu> <200710021623.09966.ak@suse.de> <20071002143115.GA4867@elte.hu> <20071002145806.GA3567@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071002145806.GA3567@uranus.ravnborg.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Tue, Oct 02, 2007 at 04:31:15PM +0200, Ingo Molnar wrote:
> > 
> > * Andi Kleen <ak@suse.de> wrote:
> > 
> > > > Andi, could you please send us the list of patches from the 
> > > > current.tar.gz queue above that you consider 2.6.24 candidates?
> > > 
> > > Everything in principle except the patches marked with TBD.
> > 
> > ok, the ones marked TBD are:
> > 
> >  cflags-probe
> >  cpa-clflush
> >  sched-clock-share
> >  svm-disabled
> >  unwinder
> > 
> > > > (and please add to the list if there's anything else pending)
> > > 
> > > I'm still merging/fixing etc. so the list is not final yet.
> > 
> > please merge it ontop of the arch/x86 tree so that we can start 
> > reviewing and testing it based on the unified tree ASAP. (but sending us 
> > a queue to the old layout is fine too - whichever variant you can do 
> > fastest) Thanks,
> 
> Hi Andi/Ingo.
> 
> I plan to integrate cflags-probe in kbuild.git if there is no 
> objection. And I will address any x86 issues when I do so. On top of 
> that I will most likely do the same change for i386.

great. I think that's the most straightforward merge path for such 
Makefile updates. Andi, Thomas, any objections?

	Ingo
