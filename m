Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbXKSDlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbXKSDlm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 22:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbXKSDle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 22:41:34 -0500
Received: from paragon.brong.net ([74.52.187.94]:44406 "EHLO paragon.brong.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676AbXKSDld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 22:41:33 -0500
Date: Mon, 19 Nov 2007 14:41:29 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Daniel Phillips <phillips@phunq.net>
Cc: Rob Mueller <robm@fastmail.fm>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Bron Gondwana <brong@fastmail.fm>,
       Christian Kujau <lists@nerdbynature.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       riel <riel@redhat.com>, Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: mmap dirty limits on 32 bit kernels (Was: [BUG] New Kernel
	Bugs)
Message-ID: <20071119034129.GA15954@brong.net>
References: <20071113.043207.44732743.davem@davemloft.net> <alpine.LFD.0.9999.0711151342100.4260@woody.linux-foundation.org> <1ddf01c827d6$40106500$0a01a8c0@robmhp> <200711181513.19559.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711181513.19559.phillips@phunq.net>
Organization: brong.net
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2007 at 04:13:18PM -0700, Daniel Phillips wrote:
> On Thursday 15 November 2007 14:24, Rob Mueller wrote:
> > > That's my personal opinion, and I realize that some of the
> > > commercial vendors may care about their insane customers'
> > > satisfaction, but I'm simply not interested in insane users. If
> > > they have that much RAM (and bought it a few years ago when a
> > > 64-bit CPU wasn't an option), they can't be poor.
> >
> > From our perspective, the main issue is that some of these machines
> > we spent quite a bit of money on the big RAM (for it's day) + lots of
> > 15k RPM SCSI drives + multi-year support contracts. They're highly IO
> > bound, and barely use 10-20% of their old 2.4Ghz Prestonia Xeon CPUs.
> > It's hard to justify junking those machines < 5 years.
> >
> > We have a couple of 6G machines and some 8G machines using PAE. On
> > the whole, they actually have been working really well (hmmm, apart
> > from the recent dirty pages issue + reiserfs data=journal leaks +
> > inodes in lowmem limits)
> 
> Junk everything except the 15K drives, you will be glad you did.  Too 
> bad about those multi-year support contracts, hopefully you got a deal 
> on them.

Actually, the 15K drives are the bit we're getting the least use out
of now, since we're moving everything to external SATA units that
are more easily swapable.
 
> Prediction: after these dirty pages issues are gone, there will be more 
> dirty page issues because the notion of dirty page limit is 
> fundamentally broken.  Your smartest recourse is to re-motherboard to a 
> place where the dirty page limit borkage does not hurt as much, and in 
> the process you will get a cheap hardware upgrade.  Everybody will be 
> happy, the sun will come out, the birds will sing.

Or just keep running 2.6.16 where it's all been working quite fine
thanks very much, or maintain a simple patch that rips all that out
since we don't care too much about "fairness" - we only run a couple
of things on that machine and they run fine.

Bron ( going to settle down and really test this stuff to make sure
       we have an acceptable "fix" for us then do it! )
