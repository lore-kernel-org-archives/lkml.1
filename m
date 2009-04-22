Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbZDVG6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbZDVG6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 02:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZDVG6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 02:58:15 -0400
Received: from brick.kernel.dk ([93.163.65.50]:43984 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbZDVG6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 02:58:14 -0400
Date: Wed, 22 Apr 2009 08:58:13 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Peter Osterlund <petero2@telia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] include/linux/pktcdvd.h: add mempool.h dependency
Message-ID: <20090422065813.GX4593@kernel.dk>
References: <alpine.LFD.2.00.0904212014170.3101@localhost.localdomain> <20090422062053.GA20960@elte.hu> <20090422063833.GA23258@elte.hu> <20090422063954.GW4593@kernel.dk> <20090422065430.GA26384@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422065430.GA26384@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22 2009, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Wed, Apr 22 2009, Ingo Molnar wrote:
> > > 
> > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > A last-minute build error slipped through:
> > > >
> > > >   In file included from fs/compat_ioctl.c:105:
> > > >   include/linux/pktcdvd.h:285: error: expected specifier-qualifier-list before ???mempool_t???
> > > 
> > > Caused by:
> > > 
> > >   1ba0c7d: fs/compat_ioctl: fix build when !BLOCK
> > > 
> > > fixed by the patch below. The build error itself triggers with 
> > > !BLOCK
> > 
> > This fix is already queued up in the block tree, it just didn't 
> > make -rc3.
> 
> ah, i see - it was posted two days ago:
> 
>   [PATCH 2/2] pktcdvd.h should include mempool.h
> 
> but the fix should have been queued up in the tree pushing the 
> compat_ioctl.c change (Viro's). Could have been avoided by insisting 
> on a fuller explanation in the changelog instead of just a "Fix this 
> build error" line.

I didn't realize it was a new build error, so just added both the
patches to my lineup. I see that 1/2 went in through Viro's tree, not
sure why he didn't pick up 2/2 as well.

I'll make sure to get it upstream today.

-- 
Jens Axboe

