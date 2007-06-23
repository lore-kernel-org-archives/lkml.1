Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbXFWN50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbXFWN50 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757751AbXFWN5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:57:04 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37275 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757595AbXFWN5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:57:03 -0400
Date: Sat, 23 Jun 2007 15:57:21 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Denis Cheng <crquan@gmail.com>, trivial@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: the memset operation on a automatic array
	variable should be optimized out by data initialization
Message-ID: <20070623135721.GP23017@stusta.de>
References: <467cac85.081b600a.5b88.457f@mx.google.com> <E1I20Wr-00064i-T0@flower> <20070623131355.GO23017@stusta.de> <20070623134126.GN19904@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070623134126.GN19904@flower.upol.cz>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 03:41:26PM +0200, Oleg Verych wrote:
> On Sat, Jun 23, 2007 at 03:13:55PM +0200, Adrian Bunk wrote:
> > On Sat, Jun 23, 2007 at 09:59:33AM +0200, Oleg Verych wrote:
> []
> > > > From: Denis Cheng <crquan@gmail.com>
> > > >
> > > > the explicit memset call could be optimized out by data initialization,
> > > > thus all the fill working can be done by the compiler implicitly.
> > > 
> > > Can be optimized and can be done by compiler are just words;
> > > 
> > > > and C standard guaranteed all the unspecified data field initialized to zero.
> > > 
> > > standards and implementation are on opposite poles of magnet
> > 
> > Bullshit.
> > 
> > We expect a C compiler, and if a C compiler violates the C standard 
> > that's a bug in the compiler that has to be fixed.
> 
> If you are serious, please consider last kernel headers vs ANSI C
> discussion,

If only Joerg would tell us where the problem exactly is...

There might be a bug in the kernel header, but this simply has to be 
fixed.

> then GNU extensions of the GCC C compiler and relevant "if
> ICC doesn't support GCC extensions it's ICC's bug".

gcc is a C compiler and claims to follow the C standard.
The kernel does not claim to be compilable by a plain C compiler.

Spot the difference?

> That was about
> implementation. About standards you are not serious, aren't you?
> (Please don't see this as for this particular case, but as general
> viewpoint)

And as with many generalizations, that's often wrong...

> > And gcc is usually quite good in following the C standard.
> 
> > > > Signed-off-by: Denis Cheng <crquan@gmail.com>
> > > >
> > > > ---
> > > > After comments in the former threads:
> > > > http://lkml.org/lkml/2007/6/18/119
> > > 
> > > i see a patch
> > > 
> > > > http://lkml.org/lkml/2007/6/18/48
> > > 
> > > same patch.
> > >...
> > 
> > Open your eyes and you'll find thread overviews at the left side of 
> > the URLs he gave...
> 
> Two threads with *different* URLs but with *same* patch...
>...

The comments are in the _threads_.
The patches are only the roots of the threads.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

