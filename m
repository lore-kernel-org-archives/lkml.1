Return-Path: <linux-kernel-owner+w=401wt.eu-S1759847AbYGBBWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759847AbYGBBWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 21:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755918AbYGBBWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 21:22:05 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61729 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754045AbYGBBWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 21:22:01 -0400
Date: Wed, 2 Jul 2008 02:19:38 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andi Kleen <andi@firstfloor.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Andi Kleen <andi-suse@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
In-Reply-To: <4868A659.2080308@firstfloor.org>
Message-ID: <Pine.LNX.4.55.0806301708490.30785@cliff.in.clinika.pl>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <20080629200210.GB31633@elte.hu>
 <Pine.LNX.4.55.0806292104560.22548@cliff.in.clinika.pl> <200806300106.38414.rjw@sisk.pl>
 <Pine.LNX.4.55.0806300205180.22548@cliff.in.clinika.pl> <4868A659.2080308@firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008, Andi Kleen wrote:

> >  That is certainly true for standard hardware.  We have to take
> > responsibility for own bugs, sure.  I cannot readily understand why you
> > apparently try to imply hardware vendors do not.
> 
> Sorry Maciej, you're totally off base on that. On consumer hardware

 Am I?  Just a little bit maybe.  Or actually I am more like playing a
devil's advocate here. ;)

> vendors very rarely fix anything after release of the machine
> and in general users expect Linux to work around any BIOS or
> hardware bugs that happen (especially if it's a regression and worked
> before)

 Well, that's no news to me, but my point is are you happy with such a 
state of affairs?  I am not.

 It is well known (at least to me) that quality of x86 firmware is
questionable and has been such for many years now.  I recall bad
experiences from as long ago as 15 years.  That was before I discovered
Linux and even without knowing the quality of free software I considered
many implementations of PC BIOSes a bad joke.

 Of course it may sometimes be difficult to notice all the problematic
bugs early enough.  Testing is expensive and takes a lot of time.  
Proving functional correctness of a non-trivial piece of software against
a complex specification is infeasible.  Back then firmware used to be
included in a piece of EPROM memory, so for practical purposes it was cast
in stone -- nobody would order new chips with an updated replacement for
their PC, which was a practice quite common among workstation/server
manufacturers though.

 These days the firmware is included in an easily reprogrammable piece of
Flash memory, which means technically an update can be done by any user.  
Yet apparently PC equipment manufacturers taught users (similarly to what
some companies did about operating system software) that bad quality is an
immanent property of firmware.  This way they can cut the cost of testing
down, effectively shifting it to someone else.  They take no
responsibility for their mistakes and make the others pay for them.  
That's quite a convenient situation, isn't it? -- I wish I could apply it
to myself as well.

 I do not blame the users.  For most of the users the internals of
computer equipment are beyond comprehension and this is perfectly fine as
nobody is meant to be skilled in everything.  Likewise I do not want to
know in details how a bridge is to be constructed -- I only want to use it
to cross the river.  I just need to trust someone the bridge is safe to
use.  Similarly the user of a computer trusts someone to decide whether a
given piece of equipment is good or not.  In this case I think it is our
role to make users aware firmware bugs are not our responsibility, and our
willingness to cope with them is more a courtesy than a duty.

 In a perfect world they would go back to the manufacturer, or better yet,
to the point of sale and demand the piece of equipment to be replaced with
a good one, fixed, discounted or refunded.  Just with all the other goods
-- if I buy a shirt and discover it has three sleeves despite being
advertised for regular human beings, I will not demand from a coat
manufacturer to get it fitted with three sleeves to match.  Instead I will
go to the shop I got the shirt from and demand to get the situation
rectified.  Of course I could go to a coat manufacturer instead and ask
them nicely to add an extra sleeve and they might do it, but that's by no
means their duty.

 As we are not in a perfect world, users are not likely to do so as they
can be easily god ridden of, by ignoring them or giving arguments they
feel not competent enough to dispute.  And if all manufacturers behaved
consistently, users would have no alternative for their next purchase.  

 The cost remains though.  For example people involved with this case
could have spent the time on something creative, like adding new
functionality.  I do not consider it fair when someone shifts their costs 
onto me and while I may accept it for a given case for some reasons, I am 
not going to treat the situation as normal and will seek a proper 
solution.

 Here I think there is some potential interest to a few well-defined
parties to get better support from hardware manufacturers when it comes to
the firmware.  These parties may be vendors of Linux distributions who
certainly bear costs of dealing with firmware bugs.  These parties may be
x86 CPU vendors as well as the overall quality of equipment matters for
their reputation.  And it is not that they can relax unconcerned in the
belief the x86 is there forever -- times are changing and there
alternatives on the horizon (the Jisus laptop may be just one swallow, but
even if it fails, there will be followers), which are unlikely to be
beaten by price, but may be beaten by quality.  While users will not care 
how baroque the solution is, they certainly will not disregard how it 
works.

 Sorry for such a long dissertation, but I think the current situation is
too far from perfect not to do anything about it.  I do not seem to be a
position to change it, but at least I may try to increase the awareness of
the problem.  And refer users who complain to the respective
manufacturers.  What I am sure of is if we just keep papering firmware
bugs over and never come back with them to the (ir)responsible
manufacturer, then the situation will never change.

  Maciej
