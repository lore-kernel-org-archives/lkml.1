Return-Path: <linux-kernel-owner+w=401wt.eu-S1757010AbXFQVLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010AbXFQVLf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 17:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbXFQVL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 17:11:28 -0400
Received: from barikada.upol.cz ([158.194.242.200]:41410 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbXFQVL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 17:11:27 -0400
Date: Sun, 17 Jun 2007 23:23:56 +0200
To: david@lang.hm, Adrian Bunk <bunk@stusta.de>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] (Re: regression tracking (Re: Linux 2.6.21))
Message-ID: <20070617212356.GG16016@flower.upol.cz>
References: <alpine.LFD.0.98.0706151618380.14121@woody.linux-foundation.org> <20070615234202.GP3588@stusta.de> <20070616013236.GA16016@flower.upol.cz> <4673D63D.5020804@s5r6.in-berlin.de> <20070617004436.GU3588@stusta.de> <467501D0.3090203@googlemail.com> <20070617025552.addd1c41.akpm@linux-foundation.org> <6bffcb0e0706170322j3c51868fn6189bfd7d3bcac1@mail.gmail.com> <20070617114709.GD16016@flower.upol.cz> <Pine.LNX.4.64.0706171038290.28371@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706171038290.28371@asgard.lang.hm>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 10:44:39AM -0700, david@lang.hm wrote:
> On Sun, 17 Jun 2007, Oleg Verych wrote:
[]
> >That's wrong if developers are tending to reply only one thing --
> >git-bisect.
> >
> >If things are going to be that bad, then better to start dealing with the
> >cause, not consequences. In this situation requesting test-cases is a
> >better way, as it's going to influence developer as cause of potential
> >problems. If tests will show *hardware* side of problem, then, well some
> >parts may be not obvious, thus bisecting is a way to continue.
> 
> most people who report bugs don't know enough about what's actually going 
> wrong to be able to write a test case (those that do can probably just 
> write a patch to fix it). Along similar lines a debugger wouldn't be of 
> much use either.

Sorry for my English. Requesting test cases from the developers of
course. Or at least results of some kind of testing, so people may run
and check them as well, if something is suspected. And this from my POV
leads again to organized way of filtering noise and collecting structured
information easily (yea, i think it's BTS with reportbug in Debian).{0}

> the fact that git-bisect doesn't require any knowledge other then 
> knowledge the reporter has demonstrated that they already have (the 
> ability to compile and install their own kernel) puts it within the reach 
> of testers.
> 
> unfortunantly, as good as it is it can take a lot of effort, especially if 
> the bug takes time to show up. it's not perfect, but it's a huge help.

I think, positive feedback from {0} to the LTP may improve that.
Especially, if things are in parts and easy to choose for testing.

> and developers aren't always responding with 'do a bisect', sometimes they 
> respond with 'yes, we know about that'

> or 'that sounds like X',

That two are _exactly_ what reportbug tool is doing. That's why i'm
talking about it. And i'm *no* wonder why developers are boring -- at
some points they might not handle the *noise*.

> so it's still worthwhile for people to report the problem first before
> going to the ffort of doing a bisect.
> 
> David Lang
__

Bits for Adrian.

*ML*

I *use* Gmane. I'm not subscribed (receiving e-mail to my mbox) to any ML,
except <kbuild@sf.net>.

Nearly every my e-mail here is with Gmane links. You seem ignored all of
them. As for me it's result of *your personal*, rather than technical
activity.

*offense*

I'm not talking about personal offense, you are seem thinking about, but
technical one. I.e. when possible benefit might be even more, than NOHZ
on x86 and a like[0], with much less effort. I still think, unless i will
develop or fail, that reducing traffic on one or two order of magnitude
is possible as well as improving kbuild/kconfig to reduce of the noise of
mis-configurations/tester's .config length. Discouraging that effort is
my source of offense.

(FYI Until Linus checked in my _RFT_ kbuild patches, i realized how
*many* people are willing to understand and try to test kbuild stuff.)

[0] I bet VGA, DRAM, HDD are far more power hungry room-heaters. Unless
    you can substantially lower frequency, you might have no benefit at
    all. Whana know how it's done in perfectly designed embedded
    MCU/CPU? Please, see for instance MSP430 from TI (i know, it uses
    SRAM, but i've asked to look on processor core design).
____
