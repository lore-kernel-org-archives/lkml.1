Return-Path: <linux-kernel-owner+w=401wt.eu-S1757704AbXFPKcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704AbXFPKcx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 06:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757808AbXFPKbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 06:31:40 -0400
Received: from paragon.brong.net ([66.232.154.163]:57708 "EHLO
	paragon.brong.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759675AbXFPKbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 06:31:38 -0400
Date: Sat, 16 Jun 2007 20:31:30 +1000
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
Message-ID: <20070616103130.GD32405@brong.net>
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br> <20070614195517.GA4933@elte.hu> <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br> <20070614235004.GA14952@elte.hu> <20070615041149.GA6741@brong.net> <orzm313hge.fsf@oliva.athome.lsd.ic.unicamp.br> <20070615072322.GA7594@brong.net> <orabv110k5.fsf@oliva.athome.lsd.ic.unicamp.br> <20070616021630.GA30660@brong.net> <orhcp8s402.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <orhcp8s402.fsf@oliva.athome.lsd.ic.unicamp.br>
Organization: brong.net
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2007 at 05:22:21AM -0300, Alexandre Oliva wrote:
> On Jun 15, 2007, Bron Gondwana <brong@fastmail.fm> wrote:
> 
> > because it could easily be argued that they linked the BIOS with the
> > Linux kernel
> 
> How so?

(I'm going to refer to Linux as GPLix from here on since this argument
 is more general than a specific GPLed operating system)

Er, they installed it in the same piece of equipment, and the kernel
couldn't function without it in that work.  What's more 'linked' than
that.  It's a vital part of the boot process on that piece of hardware
in exactly the same way that the public-key check is a vital part of
the boot process.

If your printer^wPC isn't doing what you want and you know how to
change it to do what you want but it needs a BIOS patch.  Guess what,
you can't do it - your vendor can.  By using GPLix as part of their
boot process along with their non-GPL BIOS, they're subverting the
freedoms that the user should have in being able to control the entire
boot process.

Right?  Or are you unclear about the fact that there's a big grey area
cutting through this part of usage, and Linus sat down pretty clearly on
one side of it while you're arguing that the goalposts should be "where
I feel that my rights to make changes are being infringed".

While the vendor reserves the ability to change components of the
system (post sale, i.e. a BIOS flash update) and doesn't hand those
same rights on to you, they have partially Tivoised (hoover, kleenex,
you've got nothing on these guys for having your name associated with
a concept) the hardware.  By logical extention of your arguments over
the past few days, this denies them the ability to use any GPLed
software in 'the spirit of the licence' anyware on the machine because
they are denying you rights regarding the instance of the product
they shipped to you that they are retaining for themselves.  The very
freedoms you so vocally claim.

Now, the position I'm seeing here is that the above behaviour (every
single hardware manufacturer that has ever shipped a machine with
pre-installed Linux) violates the spirit of the GPL by the "retaining
exclusive freedoms to modify shipped product" rule, and hence their
BIOS is in the doghouse unless they either:

a) offer full source code access and rights per the holy spirit ghost
   of the GPL; or

b) deny themselves the ability to every offer a patch to said BIOS if
   bugs are found 


Point (b) is also exactly on topic for the discussion of enforcing
legal safety obligations in hardware on a peripheral rather than the
software drivers.  It's requiring that these limitations be placed in
a technically inferior location to hack around a legal "bug".  (A bug
is in the eye of the beholder, please wear glasses while cycling, it's
your own responsibility to protect your eyes)


Er, I think I'm done.  Yes.


Executive summary:

a) by not providing the BIOS source code but retaining the right to 
   change the BIOS the vendor is linking the GPLix kernel and the 
   BIOS (you can't run the kernel without it)

b) legislating intent is fraught.

c) by your arguments, (a) is violating the spirit and (b) is necessary
   to get around that.

Bron.
