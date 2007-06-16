Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbXFPNZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbXFPNZu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 09:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbXFPNZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 09:25:43 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36781 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755556AbXFPNZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 09:25:43 -0400
Date: Sat, 16 Jun 2007 15:25:57 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: regression tracking (Re: Linux 2.6.21)
Message-ID: <20070616132557.GT3588@stusta.de>
References: <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org> <200704291849.23197.rjw@sisk.pl> <20070429173725.GB30248@one.firstfloor.org> <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <E1HyipW-0005wJ-0Q@flower> <alpine.LFD.0.98.0706151618380.14121@woody.linux-foundation.org> <20070615234202.GP3588@stusta.de> <20070616013236.GA16016@flower.upol.cz> <20070616025516.GR3588@stusta.de> <20070616050344.GB16016@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070616050344.GB16016@flower.upol.cz>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2007 at 07:03:44AM +0200, Oleg Verych wrote:
>...
> On Sat, Jun 16, 2007 at 04:55:16AM +0200, Adrian Bunk wrote:
> > On Sat, Jun 16, 2007 at 03:32:36AM +0200, Oleg Verych wrote:
> > > On Sat, Jun 16, 2007 at 01:42:02AM +0200, Adrian Bunk wrote:
>...
> > > For example you feel, that you've wasted time. But after all, if you've
> > > came up with some kind of tool, everybody else could take it. No
> > > problems, useful ideas must and will evolve. But _ideally_ this must not be
> > > from ground zero every time. _Ideally_ from technical, not personal
> > > point of view ;).
> > 
> > As I expected, someone else has picked up regression tracking.
> > And other from what you claim, this did not require any kind of tool.
> 
> So you expected good, doing bad. ``Bad'' means bringing pointless flame
> about what everybody should do, without constructive approach like: "OK,
> i can't do it due to my POV{0}, useless manual work. Everybody willing to
> bring another way of dealing with it is welcome."
> 
> Your first reply:
> 
> "And it's not that Linus started developing the Linux kernel with writing
> git, the first 10 years of Linux development were without any SCM." {3}
> 
> to my note about, that you are not hurry anywhere, that after all that
> years of Open Source and Free Software development you are not trying
> to deal with such important thing like regression/bug tracking in
> ***organized way***, is rather pointless.

I am dealing with bug tracking in the kernel Bugzilla.
I did regression tracking for the kernel.
Michal is currently tracking regressions.
Andrew is doing an enormous amount of work in these areas.

You might not see it because you are not active in this area, but it is 
working in an organized way.

What is not working is getting all tracked bugs properly debugged.

> > > That's why people in Debian have started *team* maintenance with alioth. 
> > 
> > The problem for the Linux kernel is that for a better bug handling you'd 
> > need people willing to learn other people's code and to do the hard work 
> > of debugging bug reports.
> 
> ... {0}++
> 
> Do you know, for example, why i'm not making my "hacker's career"
> doing that?
> 
> 1. because i ended up with lynx, slrn, mutt, emacs-nox. Including
>    "zarro bogs found" kind of thing and other "userspace suck" problems.
> 2. i have no way to know if something *really* broken, unless it right
>    on my hardware
> 
> This all unlike Debian BTS using reportbug, where you have basic
> information, mbox format messages for easy "mutt -f", and other funny
> things, real maintainers aware of (i'm trying to know, learn about).
> 
> Thus organized, non brain-damaged way of reporting and tracking is the
> key issue.

Bugzilla is a usable tool for bug and regression reporting and tracking 
tracking.

I am using the Debian BTS since 8 years and I've used many Bugzillas.

Both are usable, and the real problem in kernel development is not 
really related to the question which tool to use for bug tracking.

>...
> > Talking about "team maintenance" sounds nice, but the problem in the 
> > kernel starts with code that has zero maintainers.
> 
> Floppy went pretty fine, before it was started to be maintained, and
> you know that. But you also told that unmaintained and not-working are
> different things.

unmaintained != unused
user != developer
worked != went pretty fine

Stuff can easily get broken and noone looks after bugs if there's no 
maintainer both knowing the code and willing to debug bugs.

The floppy driver is actually an example of code that has been broken 
quite often by patches simply because noone who completely understands 
this driver reviewed patches.

It somehow works and it might work for some years, but there is a 
problem.

>...
> I see (this repetition). Maybe i've managed to express my POV, that it
> can be seeing more cleanly.

IMHO your point of view is simply not related to the real current 
quality problems in kernel development.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

