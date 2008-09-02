Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbYIBH0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbYIBH0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 03:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbYIBH0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 03:26:47 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:48188 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbYIBH0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 03:26:46 -0400
Date: Tue, 2 Sep 2008 09:26:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Osterlund <petero2@telia.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Cox <alan@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       viro@zeniv.linux.org.uk
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
Message-ID: <20080902072642.GX20055@kernel.dk>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <alpine.LFD.1.10.0808241120460.3363@nehalem.linux-foundation.org> <m3k5e2qkk2.fsf@telia.com> <alpine.LFD.1.10.0808271335260.3363@nehalem.linux-foundation.org> <20080828135245.GA12410@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080828135245.GA12410@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28 2008, Christoph Hellwig wrote:
> On Wed, Aug 27, 2008 at 01:40:10PM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Wed, 27 Aug 2008, Peter Osterlund wrote:
> > > 
> > > Why not just revert the offending change and try again during the next
> > > merge window, assuming someone has figured out an acceptable way to
> > > handle this mess by then?
> > 
> > Well,, for 2.6.27 that's what we'll have to do. But there's actually a 
> > real problem here - the unlocked ioctl's (which we _should_ prefer) have a 
> > strictly weaker and worse interface. I also wonder if any other 
> > block_ioctl users were converted..
> 
> Actually both interfaces are a fscking disaster.  The right things to
> pass is neither and inode nor a file but a struct block_device.  Al had
> all this work done a while and it just needs rebasing to a current tree:
> 
> 	http://git.kernel.org/?p=linux/kernel/git/viro/bdev.git;a=summary

Completely agreed. Al, I remember talking to you about this at the
storage summit back in february. What are your current plans wrt moving
this forward?

-- 
Jens Axboe

