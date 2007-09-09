Return-Path: <linux-kernel-owner+w=401wt.eu-S1753311AbXIIWWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbXIIWWJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 18:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbXIIWV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 18:21:57 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57170 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751925AbXIIWV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 18:21:57 -0400
Date: Mon, 10 Sep 2007 00:22:03 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, perex@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] unexport sys_{open,read}
Message-ID: <20070909222202.GB3563@stusta.de>
References: <20070909202527.GT3563@stusta.de> <20070909203920.GA11764@infradead.org> <20070909145940.0b41c8a5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070909145940.0b41c8a5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2007 at 02:59:40PM -0700, Andrew Morton wrote:
> On Sun, 9 Sep 2007 21:39:20 +0100 Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Sun, Sep 09, 2007 at 10:25:28PM +0200, Adrian Bunk wrote:
> > > sys_{open,read} can finally be unexported.
> > 
> > Andrew, can you please put this in?  Having these exports for syscalls around
> > hsa been a long-time annoyance that can finally be fixed now.
> 
> Sure.  But I think it is better to give people some warning when we're
> planning on breaking out-of-tree things.  I do occasionally receive reports
> of "hey, the X driver which I get from Y doesn't work any more".  Often
> it's open-source stuff, too.  I see no point in irritating our users more than
> we need to.
> 
> If we're changing an API or removing a function then there's nothing we can
> do, but in the case where we're simply deleting an export, it's exceedingly
> easy for us to EXPORT_UNUSED_SYMBOL (and __deprecated_for_modules?) for a
> few months.
> 
> Adrian knows this, yet he habitually sends zero-warning export-removal
> patches and I habitually ignore them.  I guess we must both enjoy this or
> something.

You might rename EXPORT_UNUSED_SYMBOL to EXPORT_UNUSED_SYMBOL_ADRIAN 
because AFAIK I am still the only person who was ever dumb enough to
use it after you wanted me to do so...

Everyone else is allowed to always add, remove and change exports
as he likes, but I should go through this special process.

It makes no sense (except for keeping me busy) to treat some patches I 
send special while changes made by other people that break the modules 
API are still allowed.

Andrew, please define API rules, IOW rules for addition, removal and 
changing of exported code, that are valid for *everyone* or go to hell 
with your EXPORT_UNUSED_SYMBOL.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

