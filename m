Return-Path: <linux-kernel-owner+w=401wt.eu-S1759465AbYHCUBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465AbYHCUBO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 16:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbYHCUBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 16:01:00 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:41818 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbYHCUA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 16:00:59 -0400
Date: Sun, 3 Aug 2008 22:00:55 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Sam Ravnborg <sam@ravnborg.org>, David Miller <davem@davemloft.net>,
       linux-next@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: linux-next: m68k build failure
In-Reply-To: <20080802140650.ed81402d.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0808032200190.23329@anakin>
References: <20080730175233.02dbf021.sfr@canb.auug.org.au>
 <20080730.010234.193703201.davem@davemloft.net> <20080730084935.GA18545@uranus.ravnborg.org>
 <20080801153710.815bbb74.sfr@canb.auug.org.au> <Pine.LNX.4.64.0808011551120.30950@anakin>
 <20080801204157.GA12390@uranus.ravnborg.org> <20080802140650.ed81402d.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Aug 2008, Stephen Rothwell wrote:
> On Fri, 1 Aug 2008 22:41:57 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:
> > On Fri, Aug 01, 2008 at 03:52:22PM +0200, Geert Uytterhoeven wrote:
> > > BTW, is there a (good) way to have this without duplicating those header files?
> > 
> > The only solution I can come up with right now is:
> > 
> > Makefile:
> > ccflags-y += -Iarch/sparc/include
> > 
> > foo.c:
> > #include <asm/fbio.h>
> > 
> > Disadvantage is that we loose the explicit documentation that this
> > is header files from another architecture.
> > So we should at least add a comment saying this.
> > 
> > And the above would not work if the file has same filename,
> > but then that is not a likely situation either.
> 
> There is at least one of the m68k header files that includes the sparc
> file of the same name and then does other stuff.  So this scheme would
> not cover that  (unless we used #include_next?) 

OK, so I'll take Stephen's patch (thanks!) and send it to Linus.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
