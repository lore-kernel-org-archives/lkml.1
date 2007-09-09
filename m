Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbXIIXSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbXIIXSr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 19:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbXIIXSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 19:18:39 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:41036 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752632AbXIIXSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 19:18:38 -0400
Date: Mon, 10 Sep 2007 01:18:45 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, perex@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] unexport sys_{open,read}
Message-ID: <20070909231845.GC3563@stusta.de>
References: <20070909202527.GT3563@stusta.de> <20070909203920.GA11764@infradead.org> <20070909145940.0b41c8a5.akpm@linux-foundation.org> <20070909222202.GB3563@stusta.de> <20070909234118.43d75f6f@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070909234118.43d75f6f@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2007 at 11:41:18PM +0100, Arjan van de Ven wrote:
> On Mon, 10 Sep 2007 00:22:03 +0200
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Sun, Sep 09, 2007 at 02:59:40PM -0700, Andrew Morton wrote:
> > > On Sun, 9 Sep 2007 21:39:20 +0100 Christoph Hellwig
> > > <hch@infradead.org> wrote:
> 
> > > Adrian knows this, yet he habitually sends zero-warning
> > > export-removal patches and I habitually ignore them.  I guess we
> > > must both enjoy this or something.
> > 
> > You might rename EXPORT_UNUSED_SYMBOL to EXPORT_UNUSED_SYMBOL_ADRIAN 
> > because AFAIK I am still the only person who was ever dumb enough to
> > use it after you wanted me to do so...
> > 
> > Everyone else is allowed to always add, remove and change exports
> > as he likes, but I should go through this special process.
> > 
> > It makes no sense (except for keeping me busy) to treat some patches
> > I send special while changes made by other people that break the
> > modules API are still allowed.
> > 
> > Andrew, please define API rules, IOW rules for addition, removal and 
> > changing of exported code, that are valid for *everyone* or go to
> > hell with your EXPORT_UNUSED_SYMBOL.
> 
> 
> Adrian,
> 
> as much as I personally disagree with Andrew's policy here (esp for
> these symbols, they have been deprecated for years now), it's trivial
> to just follow his requirements and get this over with.
>...

Andrew wants a deprecation period for these symbols where the few users 
are most likely doing something wrong when using them, but if someone 
e.g. changes the IRQ API in a way that breaks most external modules no 
deprecation period is required.

If the kernel should get some module API stability processes like 
EXPORT_UNUSED_SYMBOL() deprecation periods have to be made mandatory
for *all* API changes and removals.

But forcing EXPORT_UNUSED_SYMBOL on me while allowing other people to do 
bigger API changes without deprecation periods is not a policy, it's a 
personal offence.

> Greetings,
>     Arjan van de Ven

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

