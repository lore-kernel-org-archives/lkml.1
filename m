Return-Path: <linux-kernel-owner+w=401wt.eu-S965341AbXHMPng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965341AbXHMPng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968475AbXHMN5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 09:57:39 -0400
Received: from ananke.telenet-ops.be ([195.130.137.78]:59286 "EHLO
	ananke.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969440AbXHMN5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 09:57:35 -0400
Date: Mon, 13 Aug 2007 15:57:28 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
cc: Finn Thain <fthain@telegraphics.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz, linuxppc-dev@ozlabs.org,
       debian-68k@lists.debian.org
Subject: Re: [patch 10/10] m68k/mac: Make mac_hid_mouse_emulate_buttons()
 declaration visible
In-Reply-To: <Pine.LNX.4.58.0708131531440.585@om.biophys.uni-duesseldorf.de>
Message-ID: <Pine.LNX.4.64.0708131552400.8645@anakin>
References: <20070812094050.522858761@mail.of.borg> <20070812094119.910815432@mail.of.borg>
 <Pine.LNX.4.58.0708131432560.32732@om.biophys.uni-duesseldorf.de>
 <Pine.LNX.4.64.0708132253530.21364@loopy.telegraphics.com.au>
 <Pine.LNX.4.58.0708131531440.585@om.biophys.uni-duesseldorf.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007, Michael Schmitz wrote:
> > > Anyone using mouseemu on m68k Mac?
> >
> > Yes, and on powermac too. It provides the paste key for gpm and I'm quite
> > fond of it. But if there's a better alternative, I'll happily try it
> > instead.
> 
> Too much overhead on m68k? On powermac it never gave me trouble, but I was
> surprised to hear people use it on m68k.
> 
> If it works OK, we can really drop the kernel support.

If it can be removed completely, for PowerMac, Mac/m68k, and IntelliMac (or
whatever it's called), fine for me!  Please coordinate with the other
Mac people.

But for now, Linus, please apply, as the missing prototype causes a
broken Mac/m68k build.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
