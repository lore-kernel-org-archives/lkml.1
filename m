Return-Path: <linux-kernel-owner+w=401wt.eu-S1761986AbXGRJQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761986AbXGRJQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 05:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbXGRJQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 05:16:43 -0400
Received: from europa.telenet-ops.be ([195.130.137.75]:44992 "EHLO
	europa.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbXGRJQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 05:16:42 -0400
Date: Wed, 18 Jul 2007 11:16:40 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sasa Ostrouska <casaxa@gmail.com>
Cc: Daniel Drake <dsd@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: VESAFB CUSTOM RESOLUTION
In-Reply-To: <dcf706c60707172336u38cb87c4ia77cc4dbe9b38a56@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707181116090.24281@anakin>
References: <dcf706c60707170713t605ce652r83b5b53f3c315691@mail.gmail.com>
 <469D71FB.5070408@gentoo.org> <dcf706c60707172336u38cb87c4ia77cc4dbe9b38a56@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007, Sasa Ostrouska wrote:
> On 7/18/07, Daniel Drake <dsd@gentoo.org> wrote:
> > Sasa Ostrouska wrote:
> > > I want to ask one question about a custom resolution in the console.
> > > I have a Sony Vaio Laptop VGN-SZ2VP/X, the screen resolution is
> > > 1280x800, now I'm using the vga=773 which is an 1024x768 but this is
> > > ugly as I get a border of about 2-3cm on one the sides of the screen.
> > > So is there a way that I set the 1280x800 resolution at boot time ?
> > 
> > I don't think vesafb can do what you want. However, uvesafb probably can.
> > 
> > http://dev.gentoo.org/~spock/projects/uvesafb/
> > 
> > Daniel
> 
> Daniel you seem to be right, as till now, no one of those solutions
> for me worked, I always end up or with a non recognised option or a
> small square 640x480 pixels where I see the console. I need to try
> still the vbetest thing what Mr. Daplas proposed.
> 
> In any case this laptop has an screen of 16:10 aspect ratio and I
> belive would be good
> to have those modes in the vesafb driver.

There are no modes in the vesafb driver. The vesafb driver uses the
video mode that was set by the BIOS before starting Linux.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
