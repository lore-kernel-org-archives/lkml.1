Return-Path: <linux-kernel-owner+w=401wt.eu-S1759668AbYFDPlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759668AbYFDPlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 11:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755073AbYFDPlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 11:41:09 -0400
Received: from mail.gmx.net ([213.165.64.20]:54090 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754983AbYFDPlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 11:41:08 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18dvmZvGSodUl/3GVpVqWiQ2q+CIDTftYYjDjrJt6
	iw6IwuknIYpypF
Date: Wed, 4 Jun 2008 17:41:27 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
X-X-Sender: lyakh@axis700.grange
To: Adrian Bunk <bunk@kernel.org>
cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net
Subject: Re: [PATCH] spi: two bug-fixes
In-Reply-To: <20080604153132.GB4189@cs181133002.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0806041737550.32657@axis700.grange>
References: <Pine.LNX.4.64.0806041705430.32657@axis700.grange>
 <20080604153132.GB4189@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008, Adrian Bunk wrote:

> On Wed, Jun 04, 2008 at 05:11:14PM +0200, Guennadi Liakhovetski wrote:
> > Index: linux-2.6/drivers/gpio/mcp23s08.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/gpio/mcp23s08.c	2008-06-04 12:11:26.000000000 +0200
> > +++ linux-2.6/drivers/gpio/mcp23s08.c	2008-06-04 12:11:50.000000000 +0200
> > @@ -178,7 +178,7 @@
> >  
> >  	mutex_lock(&mcp->lock);
> >  	t = mcp23s08_read_regs(mcp, 0, mcp->cache, sizeof mcp->cache);
> > -	if (t < 0) {
> > +	if ((int)t < 0) {
> >  		seq_printf(s, " I/O ERROR %d\n", t);
> >  		goto done;
> >  	}
> >...
> 
> The better fix of making "t" signed by Roel Kluin is already as
> commit 1d1c1d9b557a12320174058d2d313ffb0f8611f4 in Linus' tree.

Good, thanks for letting know! David, please, let me know if you want me 
to resubmit the second part of the patch separately, or if you can just 
extract it from the original one.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
