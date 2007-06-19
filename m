Return-Path: <linux-kernel-owner+w=401wt.eu-S1758485AbXFSMss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485AbXFSMss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 08:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbXFSMsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 08:48:40 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:32866 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754123AbXFSMsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 08:48:39 -0400
Date: Tue, 19 Jun 2007 14:48:55 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Debbugs developers <debian-debbugs@lists.debian.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@mbligh.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: This is [Re:] How to improve the quality of the kernel[?].
Message-ID: <20070619124855.GB12950@stusta.de>
References: <200706172349.08813.bzolnier@gmail.com> <4675C083.6080409@s5r6.in-berlin.de> <20070617220927.99ebc1ee.akpm@linux-foundation.org> <F1D642E5A91BC94D9504EC83AE19E6B0128A0D@ecqcmtlmail3.quebec.int.ec.gc.ca> <32209efe0706181531x5322533dr31dc90e6dd8c7973@mail.gmail.com> <46770A22.4020007@mbligh.org> <32209efe0706181556l2ed378f4sf520c3852f398fa4@mail.gmail.com> <46771C5D.10809@mbligh.org> <alpine.LFD.0.98.0706181706470.3593@woody.linux-foundation.org> <E1I0UzP-0004AY-Hy@flower>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <E1I0UzP-0004AY-Hy@flower>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 06:06:47AM +0200, Oleg Verych wrote:
> [Dear Debbug developers, i wish your ideas will be useful.]
> 
> * From: Linus Torvalds
> * Newsgroups: gmane.linux.kernel
> * Date: Mon, 18 Jun 2007 17:09:37 -0700 (PDT)
> >
> > On Mon, 18 Jun 2007, Martin Bligh wrote:
> >> 
> >> Sorry to be a wet blanket, but I've seen those sort of things
> >> before, and they just don't seem to work, especially in the
> >> environment we're in with such a massive diversity of hardware.
> >
> > I do agree. It _sounds_ like a great idea to try to control the flow of 
> > patches better,
> 
> There were some ideas, i will try to summarize:
> 
> * New Patches (or sets) need tracking, review, testing
> 
>   Zero (tracking) done by sending (To, or bcc) [RFC] patch to something
>   like submit@pts.e-mail.example.com (like BTS now). Notifications will
>   be sent to intrested maintainers (if meta-information is ok) or testers
>   (see below)
> 
>   First is mostly done by maintainers or interested individuals.
>   Result is "Acked-by" and "Cc" entries in the next patch sent. Due to
>   lack of tracking this things are done manually, are generally in
>   trusted manner. But bad like <200706172053.41806.bzolnier@gmail.com>
>   sometimes happens.

The goal is to get all patches for a maintained subsystem submitted to 
Linus by the maintainer.

>   When patch in sent to this PTS, your lovely
>   checkpatch/check-whatever-crap-has-being-sent tools can be set up as
>   gatekeepers, thus making impossible stupid errors with MIME coding,
>   line wrapping, whatever style you've came up with now in checking
>   sent crap.

The -mm kernel already implements what your proposed PTS would do.

Plus it gives testers more or less all patches currently pending 
inclusion into Linus' tree in one kernel they can test.

The problem are more social problems like patches Andrew has never heard 
of before getting into Linus' tree during the merge window.

>...
> |-*- Feature Needed -*-
>   Addition, needed is hardware user tested have/had/used. Currently
>   ``reportbug'' tool includes packed specific and system specific
>   additions automaticly gathered and inserted to e-mail sent to BTS.
>   (e.g. <http://permalink.gmane.org/gmane.linux.debian.devel.kernel/29740>)

The problem is that most problems don't occur on one well-defined 
kind of hardware - patches often break in exactly the areas the patch
author expected no problems in.

And in many cases a patch for a device driver was written due to a bug 
report - in such cases a tester with the hardware in question is already 
available.

>...
> > but in the end, it needs to also be easy and painfree to the people
> > involved, and also make sure that any added workflow doesn't require
> > even *more* load and expertise on the already often overworked 
> > maintainers..
> 
> Experienced BTS users and developers. Please, correct me if i'm wrong.
> At least e-mail part of Debian's BTS and whole idea of it is *exactly*
> what is needed. Bugzilla fans, you can still use you useless pet,
> because Debian developers have done things, to track and e-mail states
> of bugs: <http://permalink.gmane.org/gmane.linux.debian.devel.kernel/29736>
>...

"useless pet"?
Be serious.
How many open source projects use Bugzilla and how many use the Debian BTS?
And then start thinking about why the "useless pet" has so many more 
user...

The Debian BTS requires you to either write emails with control messages 
or generating control messages with external tools.

In Bugzilla the same works through a web interface.

I know both the Debian BTS and Bugzilla and although they are quite 
different they both are reasonable tools for their purpose.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

