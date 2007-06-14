Return-Path: <linux-kernel-owner+w=401wt.eu-S1759653AbXFNBkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759653AbXFNBkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 21:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757989AbXFNBkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 21:40:21 -0400
Received: from keil-draco.com ([216.193.185.50]:50988 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757606AbXFNBkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 21:40:19 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Wed, 13 Jun 2007 21:40:13 -0400
User-Agent: KMail/1.9.6
Cc: Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
References: <466A3EC6.6030706@netone.net.tr> <200706132101.28330.dhazelton@enter.net> <20070614012401.GN3588@stusta.de>
In-Reply-To: <20070614012401.GN3588@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706132140.13490.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 June 2007 21:24:01 Adrian Bunk wrote:
> On Wed, Jun 13, 2007 at 09:01:28PM -0400, Daniel Hazelton wrote:
> > On Wednesday 13 June 2007 20:44:19 Adrian Bunk wrote:
> > > On Wed, Jun 13, 2007 at 07:46:15PM -0400, Daniel Hazelton wrote:
> > > > On Wednesday 13 June 2007 19:15:42 Alexandre Oliva wrote:
> > > > > On Jun 13, 2007, Linus Torvalds <torvalds@linux-foundation.org> 
wrote:
> > > > > > On Wed, 13 Jun 2007, Alan Cox wrote:
> > > > > >> > find offensive, so I don't choose to use it. It's offensive
> > > > > >> > because Tivo never did anything wrong, and the FSF even
> > > > > >> > acknowledged that. The fact
> > > > > >>
> > > > > >> Not all of us agree with this for the benefit of future legal
> > > > > >> interpretation.
> > > > > >
> > > > > > Well, even the FSF lawyers did,
> > > > >
> > > > > Or rather they didn't think an attempt to enforce that in the US
> > > > > would prevail (or so I'm told).  That's not saying what TiVo did
> > > > > was right, and that's not saying that what TiVo did was permitted
> > > > > by the license. Only courts of law can do that.
> > > >
> > > > Wrong! Anyone with half a brain can make the distinction. What TiVO
> > > > did is entirely legal - they fully complied with the GPLv2. Note that
> > > > what they *DON'T* allow people to do is run whatever version of
> > > > whatever software they want on their hardware. They have that right -
> > > > its the "Free Software Foundation" and the GPL - regardless of
> > > > version - is a *SOFTWARE* license. ...
> > >
> > > The GPLv2 says:
> > >
> > > "For an executable work, complete source code means all the source code
> > > for all modules it contains, plus any associated interface definition
> > > files, plus the scripts used to control compilation and installation of
> > > the executable."
> > >
> > > The question is whether this includes private keys.
> > > Different people have different opinions regarding this issue.
> > >
> > > If "the complete source code" includes private keys, the GPLv2 requires
> > > them to give any costumer the private keys.
> > >
> > > Fact is that Harald Welte did in several cases successfully convince
> > > vendors that private keys are part of the source code if they are
> > > required for running the compiled binary on some hardware.
> >
> > If the hardware was designed for the end-user to change the software
> > running on it - including running software that it was never meant to run
> > (ie: a complete webserver on cell phone) - then yes, the signing keys are
> > a part of the source, as the software running on the device is designed
> > to be updated by the user using the provided system.
> >
> > If, on the other hand, the only "software updates" the user is expected
> > to perform are the installation of newer versions of the existing code
> > for "Security" or "Bug Fix" reasons then the signing keys aren't part of
> > the source.
>
> Are you an idiot, or do you just choose to ignore all proof that doesn't
> fit your preconceived beliefs?

Nope. Merely stating a distinction. Either a device is distributed, like the 
common PC, that is designed for the user to change and update the software 
on, or, like the PS2 it isn't designed for that. If I find a way to update my 
PS2 to run Linux and find that it doesn't want to start the "Linux Firmware" 
because I'm lacking a signing key...

In the case of a device that internally runs Linux (or any other GPL'd 
software) and wasn't designed for the end-user to change the software running 
on it then the signing keys aren't part of the source. OTOH, if I sell a PC 
running Linux that requires the kernel be signed then the signing keys *are* 
part of the source, since a PC is designed for the end-user to change the 
software running on it.

BTW, nice use of irony with that line. Makes me regret letting my fingers get 
ahead of my brain.

> The GPL doesn't give someone distributing the software the choice of how
> much to limit the freedom of the user.

Never claimed it did. I just wasn't as specific as I should have been when 
giving my examples.

> Either private keys required to run the kernel on the hardware are
> always considered part of "the complete source code" or they are never
> part of it.

No. It all depends on the use-case. If the hardware is designed for the user 
to install their own, custom versions of the code on then the signing keys 
are part of the source as defined by the GPLv2.

If, OTOH, the hardware was never meant for the end-user to install custom 
versions of the software on, then while the signing keys are still 
*technically* part of the source, in practice they are not. Why? Because in 
most of those cases the end-user isn't granted the right to install and run 
custom binaries on the hardware. If the manufacturer provided the signing 
keys they'd be facilitating the commission of a crime. (call it "Breach of 
Contract")

> > I haven't looked into what Harald Welte did, but I'd be surprised if
> > someone tried following suit in America and had as much success.
> >...
>
> Harald is in Germany, and he therefore takes legal action against people
> distributing products violating his copyright on the Linux kernel
> in Germany at German courts based on German laws.

I know this. As I said, I doubt that anyone who tried this in America would 
have the success he has had.

DRH

> cu
> Adrian



-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
