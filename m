Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbXEGItq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbXEGItq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 04:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbXEGItq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 04:49:46 -0400
Received: from astra.telenet-ops.be ([195.130.132.58]:57189 "EHLO
	astra.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbXEGItp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 04:49:45 -0400
Date: Mon, 7 May 2007 10:49:42 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68k: <asm/scatterlist.h> needs <asm/types.h>
In-Reply-To: <Pine.LNX.4.64.0705062238360.2956@scrub.home>
Message-ID: <Pine.LNX.4.64.0705070900190.4741@anakin>
References: <Pine.LNX.4.64.0705062233160.4741@anakin>
 <Pine.LNX.4.64.0705062238360.2956@scrub.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 May 2007, Roman Zippel wrote:
> On Sun, 6 May 2007, Geert Uytterhoeven wrote:
> > The recent <linux/pci.h> cleanup uncovered that include/asm-m68k/scatterlist.h
> > needs to include <asm/types.h>
> > 
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > ---
> >  include/asm-m68k/scatterlist.h |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > --- linux-m68k-2.6.21.orig/include/asm-m68k/scatterlist.h
> > +++ linux-m68k-2.6.21/include/asm-m68k/scatterlist.h
> > @@ -1,6 +1,8 @@
> >  #ifndef _M68K_SCATTERLIST_H
> >  #define _M68K_SCATTERLIST_H
> >  
> > +#include <asm/types.h>
> > +
> 
> Unless required otherwise please use <linux/types.h>

Fine for me! I just mimicked asm-i386/scatterlist.h.

Subject: [PATCH] m68k: <asm/scatterlist.h> needs <linux/types.h>

The recent <linux/pci.h> cleanup uncovered that include/asm-m68k/scatterlist.h
needs to include <linux/types.h>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/asm-m68k/scatterlist.h |    2 ++
 1 file changed, 2 insertions(+)

--- linux-m68k-2.6.21.orig/include/asm-m68k/scatterlist.h
+++ linux-m68k-2.6.21/include/asm-m68k/scatterlist.h
@@ -1,6 +1,8 @@
 #ifndef _M68K_SCATTERLIST_H
 #define _M68K_SCATTERLIST_H
 
+#include <linux/types.h>
+
 struct scatterlist {
 	struct page *page;
 	unsigned int offset;

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
