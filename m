Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbYHGMW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbYHGMW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbYHGMWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:22:08 -0400
Received: from yorgi.telenet-ops.be ([195.130.133.69]:56119 "EHLO
	yorgi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbYHGMWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:22:04 -0400
Date: Thu, 7 Aug 2008 13:22:42 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH]: radeonfb: Fix copyarea for R300 and later.
In-Reply-To: <1218088369.24157.268.camel@pasglop>
Message-ID: <Pine.LNX.4.64.0808071322080.23641@anakin>
References: <20080806.003536.204220123.davem@davemloft.net>
 <20080806084329.9d7e6d50.akpm@linux-foundation.org>
 <20080806.141920.30577822.davem@davemloft.net> <1218074816.24157.266.camel@pasglop>
 <1218088369.24157.268.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Ben,

On Thu, 7 Aug 2008, Benjamin Herrenschmidt wrote:
> > +	/* Ensure the dst cache is flushed and the engine idle before
> > +	 * issuing the operation.
> > +	 *
> > +	 * This works around engine lockups on some cards
> > +	 */
> > +	OUTREG(DSTCACHE_CTLSTAT, RB2D_DC_FLUSH_ALL);
> > +	OUTREG(WAIT_UNTIL, (WAIT_2D_IDLECLEAN | WAIT_DMA_GUI_IDLE));
> > +
> >  	radeon_fifo_wait(2);  
> 
> Typo in the patch, missing radeon_fifo_wait before the cache flush.
> 
> Fixed version on it's way, sorry.

Can we please get a CC: linux-fbdev-devel on the fixed version?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
