Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbYF3BmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbYF3BmV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 21:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbYF3BmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 21:42:06 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64495 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753740AbYF3BmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 21:42:04 -0400
Date: Mon, 30 Jun 2008 02:39:47 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Andi Kleen <andi-suse@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
In-Reply-To: <200806300106.38414.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.55.0806300205180.22548@cliff.in.clinika.pl>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <20080629200210.GB31633@elte.hu>
 <Pine.LNX.4.55.0806292104560.22548@cliff.in.clinika.pl> <200806300106.38414.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008, Rafael J. Wysocki wrote:

> > > well as long as we eliminate the bad effects around via DMI exceptions 
> > > nobody will feel the need to argue whether it's a regression ;-) [this 
> > > problem could be argued to be a regression, even if it's caused by prior 
> > > luck/stupidity of Linux. We have to live with the effects of our 
> > > mistakes.]
> > 
> >  Of course -- this is the only reason I can be bothered with the issue in
> > the first place.  Otherwise, I would have said: 'Get the manufacturer to
> > fix it, use "noapic" or live with a local patch.'
> 
> In that case your patch would surely make it to the regression list.

 Please be careful -- you seem to contradict yourself.  I wrote to the
effect of: "If this wasn't a regression, I would have said [...]" and your
reply is: "In that case your [non-regressing] patch would surely make it
to the regression list."

> >  This is actually how I have kept one of my old MPS SMP systems up for
> > years now -- it has a broken MP table which prevents interrupts from
> > working when too many PCI option cards are present, so I have prepared a
> > patch for patching the table manually.  I proposed it once, which you may
> > recall, but it was rejected on the grounds of the syntax being too tough
> > to comprehend to a poor average user being.  I am sure more systems would
> > benefit as MP table breakages used to be quite common.
> > 
> >  Here the simple workaround was "noapic" too, so everyone else could be
> > happy and I have been happy to keep the patch and use the capabilities of
> > the piece of hardware properly despite its broken firmware.
> 
> Again.  If there's a configuration that didn't need any manual workarounds
> before, it's expected to continue to work without any manual workarounds and
> as a patch submitter, it's _your_ burden to make that happen.

 That is certainly true for standard hardware.  We have to take
responsibility for own bugs, sure.  I cannot readily understand why you
apparently try to imply hardware vendors do not.

> Otherwise you throw this burden onto users who
> (1) don't expect things to stop working,
> (2) may not be able to figure out themselves what the right workaround is,
> (3) may not be able to make hardware manufacturers do anything.
> 
> If there's a configuration that worked before your patch and doesn't work
> after it, you're hurting the users of that configuration.

 Honestly?  These poor users who have no clue or time to follow the
development lists and/or fix bugs themselves should report the problem to
the supplier of their Linux distribution, who would sort it out by, first,
providing a temporary workaround till the problem is sorted out correctly,
second, contacting the hardware vendor through a recognised channel to
request the problem to be investigated and fixed properly.  I am fairly
sure all the reputable (responsible?) distribution vendors have service
agreements already in place with all the major hardware vendors and all
the minor hardware vendors will be happy to cooperate anyway so as not to
be minor vendors anymore.  This is why I have asked for points of contact 
repeatedly in this thread.

 Of course it leaves hobbyist distributions at a slight disadvantage, but
their users are sort of expected to be "power users" (otherwise they
wouldn't have been hobbyists, would they?) and adding an option or a patch
even should not be a problem for them.  We may try to do our best to help
them, but not at the price of penalising good hardware.

  Maciej
