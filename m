Return-Path: <linux-kernel-owner+w=401wt.eu-S1757638AbXFQRYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638AbXFQRYg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 13:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbXFQRY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 13:24:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33865 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005AbXFQRY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 13:24:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: How to improve the quality of the kernel?
Date: Sun, 17 Jun 2007 19:31:01 +0200
User-Agent: KMail/1.9.5
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <6bffcb0e0706170617k32e79d96q5af1bcd7d9492cb8@mail.gmail.com> <20070617142950.GW3588@stusta.de>
In-Reply-To: <20070617142950.GW3588@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706171931.02572.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 17 June 2007 16:29, Adrian Bunk wrote:
> On Sun, Jun 17, 2007 at 03:17:58PM +0200, Michal Piotrowski wrote:
> > On 17/06/07, Adrian Bunk <bunk@stusta.de> wrote:
> >...
> >> Fine with me, but:
> >>
> >> There are not so simple cases like big infrastructure patches with
> >> 20 other patches in the tree depending on it causing a regression, or
> >> even worse, a big infrastructure patch exposing a latent old bug in some
> >> completely different area of the kernel.
> >
> > It is different case.
> >
> > "If the patch introduces a new regression"
> >
> > introduces != exposes an old bug
> 
> My remark was meant as a note "this sentence can't handle all 
> regressions" (and for a user it doesn't matter whether a new 
> regression is introduced or an old regression exposed).
> 
> It could be we simply agree on this one.  ;-)
> 
> > Removal of 20 patches will be painful, but sometimes you need to
> > "choose minor evil to prevent a greater one" [1].
> > 
> >> And we should be aware that reverting is only a workaround for the real
> >> problem which lies in our bug handling.
> >...
> 
> And this is something I want to emphasize again.
> 
> How can we make any progress with the real problem and not only the 
> symptoms?

I think that we can handle bug reports like we handle modifications of code.

Namely, for each subsystem there can be a person (or a team) responsible
for handling bugs, by which I don't mean fixing them, but directing bug reports
at the right developers or subsystem maintainers, following the history of each
bug report etc.  [Of course, these people can choose to use the bugzilla or any
other bug tracking system they want, as long as it works for them.]

The email addresses of these people should be known (and even documented),
so that everyone can notify them if need be and so that it's clear who should
handle given bug reports.

Just an idea. :-)

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
