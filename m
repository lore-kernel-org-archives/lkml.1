Return-Path: <linux-kernel-owner+w=401wt.eu-S933617AbXEFL0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617AbXEFL0V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 07:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933646AbXEFL0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 07:26:21 -0400
Received: from assei1bl6.telenet-ops.be ([195.130.133.68]:43718 "EHLO
	assei1bl6.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933617AbXEFL0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 07:26:20 -0400
Date: Sun, 6 May 2007 13:26:17 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 06/33] m68k: CROSS_COMPILE = m68k-linux-gnu-
In-Reply-To: <20070501225605.GA5533@sci.fi>
Message-ID: <Pine.LNX.4.64.0705061323270.4741@anakin>
References: <20070501203234.252205858@mail.of.borg> <20070501203330.778353898@mail.of.borg>
 <20070501225605.GA5533@sci.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463808512-1387002833-1178450777=:4741"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463808512-1387002833-1178450777=:4741
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 2 May 2007, Ville Syrjälä wrote:
> On Tue, May 01, 2007 at 10:32:40PM +0200, Geert Uytterhoeven wrote:
> > Recent cross-compilers are called m68k-linux-gnu-gcc instead of m68k-linux-gcc
> > 
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > ---
> >  arch/m68k/Makefile |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- linux-m68k-2.6.21.orig/arch/m68k/Makefile
> > +++ linux-m68k-2.6.21/arch/m68k/Makefile
> > @@ -21,7 +21,7 @@ AS += -m68020
> >  LDFLAGS := -m m68kelf
> >  ifneq ($(COMPILE_ARCH),$(ARCH))
> >  	# prefix for cross-compiling binaries
> > -	CROSS_COMPILE = m68k-linux-
> > +	CROSS_COMPILE = m68k-linux-gnu-
> >  endif
> >  
> >  ifdef CONFIG_SUN3
> 
> What about using ?= so the user can override it. I sent a patch doing
> just that but never got any response.

I just gave it a try, and compilation failed because it used plain gcc
instead of m68k-linux-gnu-gcc.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
---1463808512-1387002833-1178450777=:4741--
