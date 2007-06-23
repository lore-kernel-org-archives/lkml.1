Return-Path: <linux-kernel-owner+w=401wt.eu-S1761967AbXFWNcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761967AbXFWNcy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761244AbXFWN2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:28:47 -0400
Received: from barikada.upol.cz ([158.194.242.200]:53630 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761242AbXFWN2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:28:46 -0400
Date: Sat, 23 Jun 2007 15:41:26 +0200
To: Adrian Bunk <bunk@stusta.de>
Cc: Denis Cheng <crquan@gmail.com>, trivial@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: the memset operation on a automatic array variable should be optimized out by data initialization
Message-ID: <20070623134126.GN19904@flower.upol.cz>
References: <467cac85.081b600a.5b88.457f@mx.google.com> <E1I20Wr-00064i-T0@flower> <20070623131355.GO23017@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070623131355.GO23017@stusta.de>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 03:13:55PM +0200, Adrian Bunk wrote:
> On Sat, Jun 23, 2007 at 09:59:33AM +0200, Oleg Verych wrote:
[]
> > > From: Denis Cheng <crquan@gmail.com>
> > >
> > > the explicit memset call could be optimized out by data initialization,
> > > thus all the fill working can be done by the compiler implicitly.
> > 
> > Can be optimized and can be done by compiler are just words;
> > 
> > > and C standard guaranteed all the unspecified data field initialized to zero.
> > 
> > standards and implementation are on opposite poles of magnet
> 
> Bullshit.
> 
> We expect a C compiler, and if a C compiler violates the C standard 
> that's a bug in the compiler that has to be fixed.

If you are serious, please consider last kernel headers vs ANSI C
discussion, then GNU extensions of the GCC C compiler and relevant "if
ICC doesn't support GCC extensions it's ICC's bug". That was about
implementation. About standards you are not serious, aren't you?
(Please don't see this as for this particular case, but as general
viewpoint)

> And gcc is usually quite good in following the C standard.

> > > Signed-off-by: Denis Cheng <crquan@gmail.com>
> > >
> > > ---
> > > After comments in the former threads:
> > > http://lkml.org/lkml/2007/6/18/119
> > 
> > i see a patch
> > 
> > > http://lkml.org/lkml/2007/6/18/48
> > 
> > same patch.
> >...
> 
> Open your eyes and you'll find thread overviews at the left side of 
> the URLs he gave...

Two threads with *different* URLs but with *same* patch...
> 
> cu
> Adrian

Where's constructive context and support of yet another patch author,
Adrian?

> -- 
> 
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
> 
____
