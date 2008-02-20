Return-Path: <linux-kernel-owner+w=401wt.eu-S934305AbYBTRO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934305AbYBTRO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:14:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761269AbYBTRN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:13:59 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:49200 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760622AbYBTRN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:13:56 -0500
Date: Wed, 20 Feb 2008 19:13:16 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Theodore Tso <tytso@mit.edu>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-ID: <20080220171316.GA4749@cs181133002.pp.htv.fi>
References: <1202791555.20739.6.camel@heimdal.trondhjem.org> <20080212051136.GA12802@mit.edu> <20080211221535.bc0dc9cf.akpm@linux-foundation.org> <20080212225716.cf695fe4.sfr@canb.auug.org.au> <20080214081405.GA20791@flint.arm.linux.org.uk> <20080214232229.f7bdc6ac.sfr@canb.auug.org.au> <alpine.LFD.1.00.0802140949460.6110@woody.linux-foundation.org> <20080221015511.1b54d4d3.sfr@canb.auug.org.au> <47BC498C.6000400@s5r6.in-berlin.de> <20080220154235.GD30305@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080220154235.GD30305@mit.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 10:42:35AM -0500, Theodore Tso wrote:
> On Wed, Feb 20, 2008 at 04:38:52PM +0100, Stefan Richter wrote:
> > Two things may largely eliminate the need for parallel branches.
> > 
> > 1. Do infrastructure changes and whole tree wide refactoring etc. in a
> > compatible manner with a brief but nonzero transition period.
> > 
> > 2. Insert a second merge window right after the usual merge window for
> > changes which cannot be well done with a transition period.
> 
> A third option would be if people add new functions (with no users) in
> -rc2 or -rc3 timeframes as long as it is part of a fully reviewed
> patch with users that will use those new features in various kernel
> development trees.
>...

I don't like suggestions based on unrealistic assumptions like
"a fully reviewed patch".

E.g. userspace ABI's are much more stable and everyone is aware that 
they must be gotten right with the first try since they are then cast in 
stone - but we all remember the recent timerfd fiasco.

> 						- Ted

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

