Return-Path: <linux-kernel-owner+w=401wt.eu-S1765653AbXEWUil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765653AbXEWUil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 16:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbXEWUid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 16:38:33 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:46133 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624AbXEWUic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 16:38:32 -0400
Date: Wed, 23 May 2007 22:38:21 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Roman Zippel <zippel@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, akpm@osdl.org,
       rmk@arm.linux.kernel.org, spyro@f2s.com, starvik@axis.com,
       ysato@users.sourceforge.jp, "Luck, Tony" <tony.luck@intel.com>,
       takata@linux-m32r.org, chris@zankel.net, uclinux-v850@lsi.nec.co.jp,
       kyle@parisc-linux.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] m68k: Enable arbitary speed tty support
In-Reply-To: <20070523205645.07b03581@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0705232233360.10610@anakin>
References: <20070523174446.37abfa7a@the-village.bc.nu>
 <Pine.LNX.4.64.0705232117260.10610@anakin> <20070523205645.07b03581@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007, Alan Cox wrote:
> > > +#define TCSETS2		_IOW('T',0x2B, struct termios2)
> > > +#define TCSETSW2	_IOW('T',0x2C, struct termios2)
> > > +#define TCSETSF2	_IOW('T',0x2D, struct termios2)
> > 
> > Where is `struct termios2' defined? Right now it doesn't compile because
> > of that.
> > 
> 
> Sorry, shortage of qualified gnomes: One of them forgot to post this diff first
> 
> Add the termios2 structure ready for enabling on most platforms. One or two like
> Sparc are plain weird so have been left alone. Most can use the same structure as
> ktermios for termios2 (ie the newer ioctl uses the structure matching the current
> kernel structure)

Why not `#define termios2 ktermios' (or vice versa) on platforms where
they are the same?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
