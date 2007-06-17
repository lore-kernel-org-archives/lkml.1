Return-Path: <linux-kernel-owner+w=401wt.eu-S1759994AbXFQLez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994AbXFQLez (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 07:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758772AbXFQLeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 07:34:46 -0400
Received: from barikada.upol.cz ([158.194.242.200]:39321 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758436AbXFQLeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 07:34:46 -0400
Date: Sun, 17 Jun 2007 13:47:09 +0200
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] (Re: regression tracking (Re: Linux 2.6.21))
Message-ID: <20070617114709.GD16016@flower.upol.cz>
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <E1HyipW-0005wJ-0Q@flower> <alpine.LFD.0.98.0706151618380.14121@woody.linux-foundation.org> <20070615234202.GP3588@stusta.de> <20070616013236.GA16016@flower.upol.cz> <4673D63D.5020804@s5r6.in-berlin.de> <20070617004436.GU3588@stusta.de> <467501D0.3090203@googlemail.com> <20070617025552.addd1c41.akpm@linux-foundation.org> <6bffcb0e0706170322j3c51868fn6189bfd7d3bcac1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0706170322j3c51868fn6189bfd7d3bcac1@mail.gmail.com>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 12:22:26PM +0200, Michal Piotrowski wrote:
> On 17/06/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> >On Sun, 17 Jun 2007 11:41:36 +0200 Michal Piotrowski 
> ><michal.k.k.piotrowski@gmail.com> wrote:
> >
> >> +If the patch introduces a new regression and this regression was not 
> >fixed
> >> +in seven days, then the patch will be reverted.
> >
> >Those regressions where we know which patch caused them are the easy ones.
> >Often we don't know which patch (or even which subsystem merge) is at
> >fault.
> >
> >I think.  How many of the present 2.6.22-rc regressions which you're
> >presently tracking have such a well-identified cause?
> >
> 
> Here lays the problem.
> 
> git-bisect is a killer app, people should start using it.

It's OK _only_ in case of unknown, hard to find *hardware* bugs.

If you think it's "a good thing" for bad, untested by developer
code, then something is completely wrong.

And if there's no debugger in the mainline kernel, which is developer's
tool, then why do you think testers must stick with git-bisect, as their
debugger-like tool (bandwidth in most and time consuming in some cases)?

That's wrong if developers are tending to reply only one thing --
git-bisect.

If things are going to be that bad, then better to start dealing with the
cause, not consequences. In this situation requesting test-cases is a
better way, as it's going to influence developer as cause of potential
problems. If tests will show *hardware* side of problem, then, well some
parts may be not obvious, thus bisecting is a way to continue.

Sorry if i'm from the abnormally different side yet one more time.
____
