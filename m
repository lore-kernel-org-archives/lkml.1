Return-Path: <linux-kernel-owner+w=401wt.eu-S1763689AbXEZUaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763689AbXEZUaP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 16:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbXEZUaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 16:30:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51416 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbXEZUaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 16:30:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Date: Sat, 26 May 2007 22:35:16 +0200
User-Agent: KMail/1.9.5
Cc: suspend2-devel@lists.suspend2.net, Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>
References: <200704182245.24156.mail@earthworm.de> <20070425072350.GA6866@ucw.cz> <200705261938.03911.Martin@lichtvoll.de>
In-Reply-To: <200705261938.03911.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705262235.17230.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 26 May 2007 19:37, Martin Steigerwald wrote:
> Am Mittwoch 25 April 2007 schrieb Pavel Machek:
> > Hi!
> >
> > > This is why there's a lot to be said for
> > >
> > > 	echo mem > /sys/power/state
> > >
> > > and being able to follow the path through _one_ object (the kernel)
> > > over trying to figure out the interaction between many different
> > > parts with different versions.
> >
> > The 'promise' is 'if you can get echo disk > /sys/power/state working,
> > uswsusp will work. too'. IOW it should be ok to debug the in-kernel
> > parts, only.
> 
> Hello Nigel, Pavel, Rafael and everyone else who is involved,
> 
> I would like to ask what come out of the suspend2 merge discussion. Nigel 
> just told that suspend2 likely won't be merged anytime soon and thats its 
> business as usual:
> 
> ---------------------------------------------------------------------
> It's pretty much business as usual. Linus doesn't want another
> implementation merged, and he wants the three of us (Pavel, Rafael and
> myself) to agree on a way forward. He also believes that we're
> approaching things from the wrong direction at the moment. Funnily
> enough, this is the one area on which we do all agree.
> ---------------------------------------------------------------------
> http://lists.suspend2.net/lurker/message/20070510.021641.fe306add.en.html
> 
> 
> Has there been any further discussion and preferably agreement on the way 
> to go forward?

The outcome was, more-or-less, that we'll work on merging suspend2 or at least
some parts of it.

However, in the meantime there have been some discussions implying that we have
some important problems with suspend/hibernation that suspend2 doesn't solve
and that IMHO are more urgent than the merging of suspend2 right not.

So, as far as I'm concerned, the plan is to fix the more urgent problems first
and to work on merging suspend2 as far as there's time to do this.

The problem is there are only a few people working on it and there's a lot to
do, so I can only ask you to be patient. ;-)

Greetings,
Rafael
