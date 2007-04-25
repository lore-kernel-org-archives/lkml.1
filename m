Return-Path: <linux-kernel-owner+w=401wt.eu-S2993126AbXDYVgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993126AbXDYVgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 17:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993124AbXDYVgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 17:36:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44809 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993126AbXDYVgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 17:36:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Date: Wed, 25 Apr 2007 23:40:18 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Ingo Molnar <mingo@elte.hu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
References: <20070419070437.GA25211@elte.hu> <alpine.LFD.0.98.0704251323000.9964@woody.linux-foundation.org> <20070425213049.GF17387@elf.ucw.cz>
In-Reply-To: <20070425213049.GF17387@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704252340.20378.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 25 April 2007 23:30, Pavel Machek wrote:
> Hi!
> 
> > > Please ask anyone who's worked with me if he's had any problem with that.
> > > If anyone say I'm unable to work with anybody else, I'd say you're right.  Till
> > > then, I feel offended.
> > 
> > I'll apologise (and virtually kiss your hairy feet) if you could actually 
> > show me a single implementation that people can agree on.
> > 
> > But until then, I claim that the suspend-to-disk people cannot work with 
> > each other.
> 
> It is not Rafael's fault. Actually it is quite hard to work with
> Nigel, because he implements every feature someone asks for, and wants
> to merge them all :-(. I don't expect to ever agree with Nigel on
> anything important, sorry.
> 
> > And no, "three different implementations" doesn't cut it. Even _two_ is 
> > too much. We need to get *rid* of something, not add more.
> 
> swsusp can be dropped. It is nice -- self contained, extremely easy to
> setup, Andrew likes it. uswsusp has all the features, and pretty
> elegant design. With klibc (or some way to ship userland code with
> kernel, and put it into initramfs or something) we can reasonably drop
> swsusp.

Well, I think we still need it and will need it in the future, at least for
debugging.  Moreover, I think there are many users of it.

Let's not drop things that are helping us. :-)

Greetings,
Rafael
