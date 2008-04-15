Return-Path: <linux-kernel-owner+w=401wt.eu-S1765028AbYDOPSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765028AbYDOPSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 11:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759656AbYDOPRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 11:17:55 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:56381 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759657AbYDOPRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 11:17:54 -0400
Date: Tue, 15 Apr 2008 18:16:43 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Woodhouse <dwmw2@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org,
       me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-ID: <20080415151643.GD2454@cs181133002.pp.htv.fi>
References: <20080413033344.GA27494@hash.localnet> <20080412205544.5e12a7d4.akpm@linux-foundation.org> <20080413080130.GA9622@infradead.org> <20080413012001.8d7967f4.akpm@linux-foundation.org> <20080413082815.GA20108@infradead.org> <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu> <1208121358.2700.4.camel@shinybook.infradead.org> <20080413154459.4b2f125d.akpm@linux-foundation.org> <20080413234920.63711ca7@core> <20080413161014.cb06964c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080413161014.cb06964c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 04:10:14PM -0700, Andrew Morton wrote:
> On Sun, 13 Apr 2008 23:49:20 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > > I guess I can keep making this point in various ways until someone
> > > actually notices it:
> > > 
> > > 	This filesystem has only 20 users.
> > 
> > At the moment. And that probably exceeds Amiga users, 386 users, some of
> > the serial port users, several network card users ...
> > 
> > In the past we've merged drivers for network cards where only two
> > existed in the world. Linus has repeatedly stated he wants to see stuff
> > people are using getting in.
> 
> None of that means that merging this filesystem is the best decision.
> 
> > Good clean code that doesn't affect the core
> > is good reference material.
> 
> The reference block filesystem is ext2 (used to be minixfs) - there is no
> need for another.
> 
> > I think you are (unusually) the one out of step here ?
> 
> I appear to be the only one who is looking at the whole picture.
> 
> Merging a new filesystem has costs - I don't need to enumerate them.  Do
> the benefits of OMFS exceed them?

We do not have a stable API for external modules, and part of the deal 
is that external modules have the chance of entering the kernel where 
they will get API changes automatically.

We are talking about a filesystem even Christoph considers OK.

And who asked about the costs of merging crap like 
drivers/infiniband/hw/nes/ ?

Speaking about the latter, with Linus' logic one might argue that OMFS 
must not be rejected since it adds support for some hardware...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

