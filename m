Return-Path: <linux-kernel-owner+w=401wt.eu-S1759918AbXEJItU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759918AbXEJItU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 04:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986AbXEJItG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 04:49:06 -0400
Received: from europa.telenet-ops.be ([195.130.137.75]:42480 "EHLO
	europa.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304AbXEJItE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 04:49:04 -0400
Date: Thu, 10 May 2007 10:48:59 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: John Anthony Kazos Jr <jakj@j-a-k-j.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: include files: convert "include" subdirectory to UTF-8
In-Reply-To: <20070510081845.GJ23574@stusta.de>
Message-ID: <Pine.LNX.4.64.0705101047550.14358@anakin>
References: <200705092102.l49L2axT029607@hera.kernel.org>
 <Pine.LNX.4.64.0705100921230.13222@anakin> <20070510081845.GJ23574@stusta.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463808512-1371349946-1178786939=:14358"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463808512-1371349946-1178786939=:14358
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 10 May 2007, Adrian Bunk wrote:
> On Thu, May 10, 2007 at 09:22:44AM +0200, Geert Uytterhoeven wrote:
> > On Wed, 9 May 2007, Linux Kernel Mailing List wrote:
> > > diff --git a/include/asm-m68k/atarihw.h b/include/asm-m68k/atarihw.h
> > > index f28acd0..6211363 100644
> > > --- a/include/asm-m68k/atarihw.h
> > > +++ b/include/asm-m68k/atarihw.h
> > > @@ -2,7 +2,7 @@
> > >  ** linux/atarihw.h -- This header defines some macros and pointers for
> > >  **                    the various Atari custom hardware registers.
> > >  **
> > > -** Copyright 1994 by Bj?rn Brauel
> > > +** Copyright 1994 by Bjrn Brauel
> > >  **
> > >  ** 5/1/94 Roman Hodek:
> > >  **   Added definitions for TT specific chips.
> > > diff --git a/include/asm-m68k/atariints.h b/include/asm-m68k/atariints.h
> > > index 0ed454f..ce6c445 100644
> > > --- a/include/asm-m68k/atariints.h
> > > +++ b/include/asm-m68k/atariints.h
> > > @@ -1,7 +1,7 @@
> > >  /*
> > >  ** atariints.h -- Atari Linux interrupt handling structs and prototypes
> > >  **
> > > -** Copyright 1994 by Bj?rn Brauel
> > > +** Copyright 1994 by Bjrn Brauel
> > >  **
> > >  ** 5/2/94 Roman Hodek:
> > >  **   TT interrupt definitions added.
> > 
> > These two seem to have failed.
> 
> They changed from wrong and invalid UTF-8 to wrong and valid UTF-8.
> 
> I saw this when applying the patch, but I wasn't sure which character 
> would be correct in this name.

I checked a very old source tree and a few encodings. In IBM850 it's an
o-umlaut, which is what I expected in the first place.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
---1463808512-1371349946-1178786939=:14358--
