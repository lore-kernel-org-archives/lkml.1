Return-Path: <linux-kernel-owner+w=401wt.eu-S1760949AbXHNOWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949AbXHNOWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 10:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbXHNOWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 10:22:16 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:49667 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750979AbXHNOWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 10:22:15 -0400
Date: Tue, 14 Aug 2007 16:22:05 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Joe Perches <joe@perches.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch -
	scripts/get_maintainer.pl
Message-ID: <20070814142205.GP18945@stusta.de>
References: <1186984174.10249.7.camel@localhost> <200708131933.10125.m.kozlowski@tuxland.pl> <1187026955.2688.4.camel@laptopd505.fenrus.org> <1187037445.6628.98.camel@heimdal.trondhjem.org> <1187054366.2757.0.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1187054366.2757.0.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 06:19:26PM -0700, Arjan van de Ven wrote:
> 
> On Mon, 2007-08-13 at 16:37 -0400, Trond Myklebust wrote:
> > On Mon, 2007-08-13 at 10:42 -0700, Arjan van de Ven wrote:
> > > The maintainer info should be in the source file itself! That's the only
> > > reasonable way to keep it updated; now I'm all for having it machine
> > > parsable so that tools can use it, but it still really should be in the
> > > code itself, not in some central file that will always just go out of
> > > data, and will be a huge source of needless patch conflicts.
> > 
> > If the problem is to do with people failing to update the MAINTAINERS
> > file, why would moving the same data into 20 or 30 source files motivate
> > them to keep it up to date? As far as I can see, that would just serve
> > to multiply the amount of stale data...
> 
> if each .c file has a MODULE_MAINTAINER() tag... 
> 
> people tend to update .c files a lot better than way off-the-side other
> files.

The move of netdev to vger would have required updating
approx. 1300 C files...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

