Return-Path: <linux-kernel-owner+w=401wt.eu-S1762792AbXGRLUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762792AbXGRLUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 07:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755540AbXGRLTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 07:19:54 -0400
Received: from agave.telenet-ops.be ([195.130.137.77]:55118 "EHLO
	agave.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbXGRLTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 07:19:54 -0400
Date: Wed, 18 Jul 2007 13:19:52 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sasa Ostrouska <casaxa@gmail.com>
cc: Daniel Drake <dsd@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: VESAFB CUSTOM RESOLUTION
In-Reply-To: <dcf706c60707180250i55a4554di83fc8fed4f24f25@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707181318570.24281@anakin>
References: <dcf706c60707170713t605ce652r83b5b53f3c315691@mail.gmail.com>
 <469D71FB.5070408@gentoo.org> <dcf706c60707172336u38cb87c4ia77cc4dbe9b38a56@mail.gmail.com>
 <Pine.LNX.4.64.0707181116090.24281@anakin> <dcf706c60707180250i55a4554di83fc8fed4f24f25@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007, Sasa Ostrouska wrote:
> On 7/18/07, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Wed, 18 Jul 2007, Sasa Ostrouska wrote:
> > > On 7/18/07, Daniel Drake <dsd@gentoo.org> wrote:
> > > > Sasa Ostrouska wrote:
> > > > > I want to ask one question about a custom resolution in the console.
> > > > > I have a Sony Vaio Laptop VGN-SZ2VP/X, the screen resolution is
> > > > > 1280x800, now I'm using the vga=773 which is an 1024x768 but this is
> > > > > ugly as I get a border of about 2-3cm on one the sides of the screen.
> > > > > So is there a way that I set the 1280x800 resolution at boot time ?
> > > >
> > > > I don't think vesafb can do what you want. However, uvesafb probably
> > can.
> > > >
> > > > http://dev.gentoo.org/~spock/projects/uvesafb/
> > > >
> > > > Daniel
> > >
> > > Daniel you seem to be right, as till now, no one of those solutions
> > > for me worked, I always end up or with a non recognised option or a
> > > small square 640x480 pixels where I see the console. I need to try
> > > still the vbetest thing what Mr. Daplas proposed.
> > >
> > > In any case this laptop has an screen of 16:10 aspect ratio and I
> > > belive would be good
> > > to have those modes in the vesafb driver.
> > 
> > There are no modes in the vesafb driver. The vesafb driver uses the
> > video mode that was set by the BIOS before starting Linux.
> > 
> Geert, in that case what should i do to use the full screen, probably
> usind another driver ?

Yes, you can use a driver for one of yours graphics adapters.

> This laptop has 2 graphic cards in it. One is a Intel 915 another is
> the nVidia GeForce 7400. I manly use the nvidia one when i'm on AC
> adapter.
> So how can I do to set the console to 1280x800 ?

Use nvidiafb and video=1280x800?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
