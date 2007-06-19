Return-Path: <linux-kernel-owner+w=401wt.eu-S1759418AbXFSPfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759418AbXFSPfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 11:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757238AbXFSPel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 11:34:41 -0400
Received: from barikada.upol.cz ([158.194.242.200]:35826 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049AbXFSPek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 11:34:40 -0400
Date: Tue, 19 Jun 2007 17:47:12 +0200
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@mbligh.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: This is [Re:] How to improve the quality of the kernel[?].
Message-ID: <20070619154712.GC19904@flower.upol.cz>
References: <F1D642E5A91BC94D9504EC83AE19E6B0128A0D@ecqcmtlmail3.quebec.int.ec.gc.ca> <32209efe0706181531x5322533dr31dc90e6dd8c7973@mail.gmail.com> <46770A22.4020007@mbligh.org> <32209efe0706181556l2ed378f4sf520c3852f398fa4@mail.gmail.com> <46771C5D.10809@mbligh.org> <alpine.LFD.0.98.0706181706470.3593@woody.linux-foundation.org> <E1I0UzP-0004AY-Hy@flower> <20070619124855.GB12950@stusta.de> <20070619140512.GA19904@flower.upol.cz> <4677E7C3.90706@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4677E7C3.90706@s5r6.in-berlin.de>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 04:27:15PM +0200, Stefan Richter wrote:
> On 6/19/2007 4:05 PM, Oleg Verych wrote:
> > On Tue, Jun 19, 2007 at 02:48:55PM +0200, Adrian Bunk wrote:
> >> The Debian BTS requires you to either write emails with control messages 
> >> or generating control messages with external tools.
> ...
> >> In Bugzilla the same works through a web interface.
> ...
> > Basic concept of Debian BTS is what i've discovered after many useless
> > hours i spent in Bugzilla. And this is mainly because of one basic
> > important thing, that nobody acknowledged (for newbies, like me):
> > 
> > * E-Mail with useful MUAs, after it got reliable delivery MTAs with qmail
> >   (or exim) is the main communication toolset.
> > 
> > Can't you see that from Linux's patch sending policy?
> 
> That's for developers, not for users.
> 
> There are different people involved in
>   - patch handling,
>   - bug handling (bugs are reported by end-users),
> therefore don't forget that PTS and BTS have different requirements.

Sure. But if tracking was done, possible bugs where killed, user's bug
report seems to depend on that patch (bisecting), why not to have a
linkage here? Usefulness for a developer (in sub-system association),
next time to see what went wrong, check test-cases, users might be
interested to have them run too before crying (again) about broken
system. Bug report can become part of (reopened) patch discussion (as
i've wrote). Until that, as bug-candidate without identified patch it
can be associated to some particular sub-system or abstract one
bug-category {1}.

Reversed time. As "do-bisection" shows, problems are not happening
just simply because of something abstract. If problem worth of solving
it, eventually there will be patch trying solve that, in both cases:

* when breaking patch (bisection) actually correct, but hardware
  (or similar independent) problem arise.
* something different, like feature request or something.

So, this guys are candidate for patch, and can have ID numerically from
the same domain as patch ID, but with different prefix, like "i'm just
candidate for patch". Bugs {1}, are obviously in this category.

Current identification of problems and patch association
have completely zero level of tracking or automation, while Bugzilla is
believed by somebody to have positive efficiency in bug tracking.

That two (patch/bug tracking) aren't that perpendicular to each other at
all.

Eventually it might be that perfect unification, that bug-tracking can be
obsolete, because of good tracking of patches/features-added and what
they did/do.

In any case, i would like to ask mentors to write at least something
similar to technical task, if that, what i'm saying is accessible for
you. Because your experience is treasure, that must be preserved and
possibly automated/organized.
____
