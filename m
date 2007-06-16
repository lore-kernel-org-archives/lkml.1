Return-Path: <linux-kernel-owner+w=401wt.eu-S1758151AbXFQAPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151AbXFQAPS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 20:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756370AbXFQAPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 20:15:07 -0400
Received: from paragon.brong.net ([66.232.154.163]:60334 "EHLO
	paragon.brong.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239AbXFQAPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 20:15:05 -0400
Date: Sun, 17 Jun 2007 09:32:51 +1000
From: Bron Gondwana <brong@fastmail.fm>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Bron Gondwana <brong@fastmail.fm>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070616233251.GA17270@brong.net>
References: <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br> <20070614235004.GA14952@elte.hu> <20070615041149.GA6741@brong.net> <orzm313hge.fsf@oliva.athome.lsd.ic.unicamp.br> <20070615072322.GA7594@brong.net> <orabv110k5.fsf@oliva.athome.lsd.ic.unicamp.br> <20070616021630.GA30660@brong.net> <orhcp8s402.fsf@oliva.athome.lsd.ic.unicamp.br> <20070616103130.GD32405@brong.net> <orhcp7rfd6.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <orhcp7rfd6.fsf@oliva.athome.lsd.ic.unicamp.br>
Organization: brong.net
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[note: I'm writting this while offline and likely to remain so for the
next 8 hours or so, so I'll probably miss a bunch of other replies]

On Sat, Jun 16, 2007 at 02:14:29PM -0300, Alexandre Oliva wrote:
> On Jun 16, 2007, Bron Gondwana <brong@fastmail.fm> wrote:
> 
> > On Sat, Jun 16, 2007 at 05:22:21AM -0300, Alexandre Oliva wrote:
> >> On Jun 15, 2007, Bron Gondwana <brong@fastmail.fm> wrote:
> >> 
> >> > because it could easily be argued that they linked the BIOS with the
> >> > Linux kernel
> >> 
> >> How so?
> 
> > Er, they installed it in the same piece of equipment, and the kernel
> > couldn't function without it in that work.
> 
> I see what you're getting at.  You're thinking of a license that
> doesn't respect the idea of "mere aggregation", right?

No, I'm arguing that it's not "mere aggregation" - the kernel is useless
on that machine unless the BIOS is present or replaced with something
else with equivalent functionality.  I suspect any decent lawyer could
make the theory that this made the kernel as compiled on to that machine
with specific chipset support selected for that hardware into a "derived
work" of the BIOS - especially if the vendor had contributed GPLed code
for drivers which interact with their hardware into said kernel.

In fact, particularly if the hardware vendor has also contributed GPL
code that interacts on one side of the software/(firmware, hardware)
boundard which worked around bugs in said firmware/hardware which they
also had the ability to change.  The two really are a combined work of
which only one part is GPLed.

Ringing any binary kernel module video card driver bells yet?  It's
really the same thing from the opposite direction - the only criteria
is where you fit in the pecking order - hardware manufacturers work
around Windows bugs, Linux kernel drivers work around hardware bugs -
it's all about who has more to lose if they aren't compatible.
 
> For starters, this wouldn't evidently not qualify as an Open Source
> license, and I'm pretty sure it wouldn't qualify as a Free Software
> license either.

Strawman licence?

> > By using GPLix as part of their boot process along with their
> > non-GPL BIOS, they're subverting the freedoms that the user should
> > have in being able to control the entire boot process.
> 
> You're pushing the "freedom to change" too far.  Sure, I'd like to be
> able to do that, and I prefer hardware that lets me do it, but it's
> not like this BIOS in the scenario you described is being used as a
> means to stop me from modifying the GPLed software.

Well, yeah - except this is the direction GPL3 takes us, and it's a
theory that GPL3 makes more likely to fly in court than GPL2 does -
meaning that hardware vendor lawyers lie awake at night worrying about
stuff (I'd hate to be a good lawyer - I'd never get any sleep!)

> I have never said that including a GPLed piece of software should
> grant users the right to modify anything whatsoever in the system, or
> grant them control over the entire system.  Others have, but it's not
> true, it just shows how much mis-information is floating around.

No, but your interactions with Linus (lazy bums 'r' us) have shown that
the logical result of what you do want includes this.  It's a lot harder
to objectively judge one of these than the other:

a) have they provided the source code to this binary to anyone who asks.

b) have any of the limitations of this piece of hardware been created
   with the intent of making it more difficult for J. Random Enduser to
   build modified binaries from said source and have them function
   correctly.

(b) has much more scope for shenanigans by bad apples on the copyright
owner side - and don't pretend that only the hardware vendors are bad
guys - it takes all sorts and the idea of a licence is to protect both
parties.

> All the GPL stands for is to defend the freedom of the users over the
> particular program it applies to.  You can't impose further
> restrictions on the user's ability to modify what *that* software
> does.

Except where they run into limitations of the platform itself, or just
plain bugs.  Oops.  The lawyers will have a field day discovering intent
every time J. Random's kernel doesn't do what he wants after he fiddles
the code a bit.

> If you wanted to change something else, but this something else is not
> covered by the license, and is not being used to contradict the terms
> of the license, well, too bad, you lose.
> 
> > b) deny themselves the ability to every offer a patch to said BIOS if
> >    bugs are found 
> 
> > Point (b) is also exactly on topic for the discussion of enforcing
> > legal safety obligations in hardware on a peripheral rather than the
> > software drivers.
> 
> > It's requiring that these limitations be placed in a technically
> > inferior location to hack around a legal "bug".
> 
> I don't think this last sentence is true.  If you implement hardware
> locks that prevent modification of the software even by yourself, then
> you're in compliance with the terms of the GPLv3dd4.  But IANAL.

I obviously wasn't clear enough.  The only way to come into complience
with GPL3dd4 is to reduce your ability to fix things or grant everyone
else the ability to mess with things.  This severely restricts you from
doing _anything_ in certain problem spaces due to local laws on the
topic, even if you're an otherwise good actor who is making worthwhile
source code contributions to the rest of the community.

This would be a lot less of an issue if Linux was a modular kernel
(don't shoot me Linus) and you could be allowed to change the bits that
didn't touch the regulated hardware's access paths.  Messy to control if
you're running in ring0 though - you need hardware managed restrictions
at some level, and a barrier around the entire kernel is certainly the
easiest way to do that.

Bron.
