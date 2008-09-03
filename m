Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbYICTWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbYICTWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 15:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbYICTWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 15:22:09 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:42882 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879AbYICTWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 15:22:06 -0400
Date: Wed, 3 Sep 2008 21:22:04 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Adrian Bunk <bunk@kernel.org>
cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] m68k: Reverse platform MMU logic so Sun 3 is last
In-Reply-To: <20080903073629.GD4104@cs181140183.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0809032114590.23421@anakin>
References: <20080903071542.615137611@mail.of.borg> <20080903071741.424551678@mail.of.borg>
 <20080903073629.GD4104@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008, Adrian Bunk wrote:
> On Wed, Sep 03, 2008 at 09:15:44AM +0200, Geert Uytterhoeven wrote:
> > From: Geert Uytterhoeven <geert@linux-m68k.org>
> > 
> > Currently Sun 3 support is the first platform option, as the Sun 3 MMU is
> > incompatible with standard Motorola MMUs. However, this means that
> > `allmodconfig' enables support for Sun 3, and thus disables support for all
> > other platforms.
> >...
> 
> I hope it isn't too heretical to ask whether Sun 3 support actually has 
> users and works?

Sammy regularly (a few times per year) submits patches for Sun 3/3x, so
I assume it still works.

> Apollo support was broken for over 7 years without anyone noticing, and 
> it might not be the only m68k platform that is long unused.

Apollo had probably less than a handful of users ever.

> Do you have any overview of which m68k platforms still have users?

As already mentioned, Amiga, Atari (especially ARAnyM these days), and Mac
are the biggest m68k platforms in active use. Not all drivers receive the
same amount of regression testing, but especially the network and SCSI (the
ones we still have; people regularly complain about the removed NCR53C9x
drivers) drivers should be in good shape.

The VME boards have always been quite exotic, just like the HP9000/300 and /400
workstations.

Q40/Q60 probably lost their last few users, too.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
