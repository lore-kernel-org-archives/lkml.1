Return-Path: <linux-kernel-owner+w=401wt.eu-S1760888AbXFQTbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760888AbXFQTbH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760069AbXFQTa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:30:56 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:37704 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759891AbXFQTa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:30:56 -0400
Date: Sun, 17 Jun 2007 21:31:10 +0200
From: Adrian Bunk <bunk@stusta.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: How to improve the quality of the kernel?
Message-ID: <20070617193110.GZ3588@stusta.de>
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <6bffcb0e0706170617k32e79d96q5af1bcd7d9492cb8@mail.gmail.com> <20070617142950.GW3588@stusta.de> <200706171931.02572.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200706171931.02572.rjw@sisk.pl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 07:31:01PM +0200, Rafael J. Wysocki wrote:
> On Sunday, 17 June 2007 16:29, Adrian Bunk wrote:
> > On Sun, Jun 17, 2007 at 03:17:58PM +0200, Michal Piotrowski wrote:
> > > On 17/06/07, Adrian Bunk <bunk@stusta.de> wrote:
> > >...
> > >> Fine with me, but:
> > >>
> > >> There are not so simple cases like big infrastructure patches with
> > >> 20 other patches in the tree depending on it causing a regression, or
> > >> even worse, a big infrastructure patch exposing a latent old bug in some
> > >> completely different area of the kernel.
> > >
> > > It is different case.
> > >
> > > "If the patch introduces a new regression"
> > >
> > > introduces != exposes an old bug
> > 
> > My remark was meant as a note "this sentence can't handle all 
> > regressions" (and for a user it doesn't matter whether a new 
> > regression is introduced or an old regression exposed).
> > 
> > It could be we simply agree on this one.  ;-)
> > 
> > > Removal of 20 patches will be painful, but sometimes you need to
> > > "choose minor evil to prevent a greater one" [1].
> > > 
> > >> And we should be aware that reverting is only a workaround for the real
> > >> problem which lies in our bug handling.
> > >...
> > 
> > And this is something I want to emphasize again.
> > 
> > How can we make any progress with the real problem and not only the 
> > symptoms?
> 
> I think that we can handle bug reports like we handle modifications of code.
> 
> Namely, for each subsystem there can be a person (or a team) responsible
> for handling bugs, by which I don't mean fixing them, but directing bug reports
> at the right developers or subsystem maintainers, following the history of each
> bug report etc.  [Of course, these people can choose to use the bugzilla or any
> other bug tracking system they want, as long as it works for them.]
> 
> The email addresses of these people should be known (and even documented),
> so that everyone can notify them if need be and so that it's clear who should
> handle given bug reports.

Currently, these people are "Andrew Morton" and the addresses are
linux-kernel@vger.kernel.org and http://bugzilla.kernel.org/ - and this 
part is working.

Although there is room for improvement in this area, the problem in the 
pipeline is really to find developers who know the code in question and 
who are willing to debug bug reports.

There are unmaintained parts of the kernel.

And there are parts of the kernel where the maintainers are developing 
code, reviewing code and handling patches but are not willing or simply 
not capable of looking at bug reports. That's not against these people 
and they might do great work, but then there's simply an additional 
person missing who would be willing to learn the subsystem in question 
and handle bug reports.

All bug handling becomes moot and every request for more information 
from the submitter a waste of time if there's noone available for 
looking deeper into a bug.

> Just an idea. :-)
> 
> Greetings,
> Rafael

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

