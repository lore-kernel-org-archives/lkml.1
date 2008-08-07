Return-Path: <linux-kernel-owner+w=401wt.eu-S1758292AbYHGVZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292AbYHGVZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757538AbYHGVZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:25:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:55296 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757620AbYHGVZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:25:16 -0400
Subject: Re: [PATCH]: radeonfb: Fix copyarea for R300 and later.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <Pine.LNX.4.64.0808071322080.23641@anakin>
References: <20080806.003536.204220123.davem@davemloft.net>
	 <20080806084329.9d7e6d50.akpm@linux-foundation.org>
	 <20080806.141920.30577822.davem@davemloft.net>
	 <1218074816.24157.266.camel@pasglop> <1218088369.24157.268.camel@pasglop>
	 <Pine.LNX.4.64.0808071322080.23641@anakin>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 07:24:26 +1000
Message-Id: <1218144266.24157.300.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-07 at 13:22 +0200, Geert Uytterhoeven wrote:
> 	Hi Ben,
> 
> On Thu, 7 Aug 2008, Benjamin Herrenschmidt wrote:
> > > +	/* Ensure the dst cache is flushed and the engine idle before
> > > +	 * issuing the operation.
> > > +	 *
> > > +	 * This works around engine lockups on some cards
> > > +	 */
> > > +	OUTREG(DSTCACHE_CTLSTAT, RB2D_DC_FLUSH_ALL);
> > > +	OUTREG(WAIT_UNTIL, (WAIT_2D_IDLECLEAN | WAIT_DMA_GUI_IDLE));
> > > +
> > >  	radeon_fifo_wait(2);  
> > 
> > Typo in the patch, missing radeon_fifo_wait before the cache flush.
> > 
> > Fixed version on it's way, sorry.
> 
> Can we please get a CC: linux-fbdev-devel on the fixed version?

I CCed the list on the final patch.

Ben.


