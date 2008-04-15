Return-Path: <linux-kernel-owner+w=401wt.eu-S1765364AbYDOU2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765364AbYDOU2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 16:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbYDOU23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 16:28:29 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:46942 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbYDOU22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 16:28:28 -0400
Date: Tue, 15 Apr 2008 23:27:15 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hch@infradead.org, alan@lxorguk.ukuu.org.uk, dwmw2@infradead.org,
       miklos@szeredi.hu, me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-ID: <20080415202715.GC1677@cs181133002.pp.htv.fi>
References: <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu> <1208121358.2700.4.camel@shinybook.infradead.org> <20080413154459.4b2f125d.akpm@linux-foundation.org> <20080413234920.63711ca7@core> <20080413161014.cb06964c.akpm@linux-foundation.org> <20080415151643.GD2454@cs181133002.pp.htv.fi> <20080415165727.GA8783@infradead.org> <20080415113452.e9eacb54.akpm@linux-foundation.org> <20080415192432.GB1677@cs181133002.pp.htv.fi> <20080415131120.f1bab12a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080415131120.f1bab12a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 01:11:20PM -0700, Andrew Morton wrote:
> On Tue, 15 Apr 2008 22:24:32 +0300
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > > Look, I have repeatedly described the reason why it is probable a poor
> > > tradeoff to merge code such as this.  The only response has been "well
> > > we've done it before", which is largely a non-reason.
> > >...
> > 
> > It seems you missed the first point in my email:
> > 
> > We do not have a stable API for external modules, and part of the deal 
> > is that external modules have the chance of entering the kernel where 
> > they will get API changes automatically.
> > 
> > 
> > Plus my other point that one might argue that OMFS adds support for some 
> > hardware in which case a recent commandment by Linus would require it 
> > has to be merged...
> 
> That's lawyerly trickery, sorry.  Take some set of guidelines and then say
> "you are thereby committed to doing X".
> 
> We're not committed to doing anything and it would be bad if we were. 
> Let's apply common sense and judgement to each case on its own.

My favorite gems from the stuff even checkpatch finds in the 
INFINIBAND_NES driver, for which Linus has stated explicitely that 
merging it in this state in 2.6.25 was correct, can be seen with

  grep -C4 volatile drivers/infiniband/hw/nes/nes_nic.c


When we have the resources to maintain this kind of code, how could a 
small filesystem be a problem?


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

