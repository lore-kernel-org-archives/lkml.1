Return-Path: <linux-kernel-owner+w=401wt.eu-S1760848AbYDOTZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760848AbYDOTZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 15:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbYDOTZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 15:25:44 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:58381 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980AbYDOTZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 15:25:43 -0400
Date: Tue, 15 Apr 2008 22:24:32 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Woodhouse <dwmw2@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, me@bobcopeland.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-ID: <20080415192432.GB1677@cs181133002.pp.htv.fi>
References: <20080413012001.8d7967f4.akpm@linux-foundation.org> <20080413082815.GA20108@infradead.org> <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu> <1208121358.2700.4.camel@shinybook.infradead.org> <20080413154459.4b2f125d.akpm@linux-foundation.org> <20080413234920.63711ca7@core> <20080413161014.cb06964c.akpm@linux-foundation.org> <20080415151643.GD2454@cs181133002.pp.htv.fi> <20080415165727.GA8783@infradead.org> <20080415113452.e9eacb54.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080415113452.e9eacb54.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 11:34:52AM -0700, Andrew Morton wrote:
> On Tue, 15 Apr 2008 12:57:27 -0400 Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Tue, Apr 15, 2008 at 06:16:43PM +0300, Adrian Bunk wrote:
> > > We are talking about a filesystem even Christoph considers OK.
> > > 
> > > And who asked about the costs of merging crap like 
> > > drivers/infiniband/hw/nes/ ?
> > > 
> > > Speaking about the latter, with Linus' logic one might argue that OMFS 
> > > must not be rejected since it adds support for some hardware...
> > 
> > Excatly.  I find it very strange to even consider rejecting a rather
> > small and very well written driver for let's say "political" reasons.
> 
> "economic" would be a far more accurate term.
> 
> Look, I have repeatedly described the reason why it is probable a poor
> tradeoff to merge code such as this.  The only response has been "well
> we've done it before", which is largely a non-reason.
>...

It seems you missed the first point in my email:

We do not have a stable API for external modules, and part of the deal 
is that external modules have the chance of entering the kernel where 
they will get API changes automatically.


Plus my other point that one might argue that OMFS adds support for some 
hardware in which case a recent commandment by Linus would require it 
has to be merged...


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

