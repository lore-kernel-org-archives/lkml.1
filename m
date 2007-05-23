Return-Path: <linux-kernel-owner+w=401wt.eu-S1764666AbXEWHZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764666AbXEWHZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 03:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760778AbXEWHYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 03:24:51 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:55054 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbXEWHYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 03:24:50 -0400
Date: Wed, 23 May 2007 09:24:46 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Landley <rob@landley.net>
Cc: Roland Dreier <rdreier@cisco.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Re: Cleaning up the Documentation directory.
In-Reply-To: <200705230025.45007.rob@landley.net>
Message-ID: <Pine.LNX.4.64.0705230922580.19474@anakin>
References: <200705222225.39949.rob@landley.net> <adaps4sb6x4.fsf@cisco.com>
 <200705230025.45007.rob@landley.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007, Rob Landley wrote:
> On Tuesday 22 May 2007 10:38 pm, Roland Dreier wrote:
> >  > I could send a patch to do this, but moving files via patch is icky.  
> Would it 
> >  > be better to start a git tree and ask people to pull from it, or to send 
> in 
> >  > script snippets like the above?
> > 
> > Actually a git patch would express that very nicely -- just pass -M to
> > git-format-patch and it should do the right thing.
> 
> Ok.
> 
> Signed-off-by: Rob Landley <rob@landley.net>
> 
> Move architecture documentation into "arch" and move multiport serio IO cards 
> into serial.
> 
> --
> 
> Equivalent to:
>    cd Documentation
>    mkdir -p arch/amiga
>    mv zorro.txt arch/amiga

Amiga part Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Probably you want to move Documentation/m68k/README.buddha there, too,
as it applies to Amiga (both m68k and PPC).

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
