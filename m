Return-Path: <linux-kernel-owner+w=401wt.eu-S1762478AbXGNNCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762478AbXGNNCU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 09:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757089AbXGNNCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 09:02:12 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:37105 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbXGNNCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 09:02:11 -0400
Date: Sat, 14 Jul 2007 14:02:08 +0100
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, kenchen@google.com,
       jschopp@austin.ibm.com, apw@shadowen.org,
       kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl,
       y-goto@jp.fujitsu.com, clameter@sgi.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add a movablecore= parameter for sizing ZONE_MOVABLE
Message-ID: <20070714130207.GA15864@skynet.ie>
References: <20070710102043.GA20303@skynet.ie> <20070712122925.192a6601.akpm@linux-foundation.org> <20070712213241.GA7279@skynet.ie> <20070713155610.GD14125@skynet.ie> <20070714082807.GC1198@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070714082807.GC1198@wotan.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (14/07/07 10:28), Nick Piggin didst pronounce:
> On Fri, Jul 13, 2007 at 04:56:10PM +0100, Mel Gorman wrote:
> > On (12/07/07 22:32), Mel Gorman didst pronounce:
> > 
> > > > Should we at least go for
> > > > 
> > > > add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
> > > > create-the-zone_movable-zone.patch
> > > > allow-huge-page-allocations-to-use-gfp_high_movable.patch
> > > > handle-kernelcore=-generic.patch
> > > > 
> > > > in 2.6.23?
> > > 
> > > Well, yes please from me obviously :) . There is one additional patch
> > > I would like to send on tomorrow and that is providing the movablecore=
> > 
> > This is the patch. It has been boot-tested on a number of machines and
> > behaves as expected. Nick, with this in addition, do you have any
> > objection to the ZONE_MOVABLE patches going through to 2.6.23?
> 
> What's the status of making it configurable? I didn't see something
> in -mm for that yet?
> 

I have a patch that makes it configurable but Kamezawa-san posted a very
promising patch about making all zones configurable in a very clever way
which is more general than what I did. He posted it as an RFC[1] and there
was feedback from Andy Whitcroft on how it could be made better so it wouldn't
have been picked up for -mm but something is in the pipeline.

I've tested his patch for zone movable and it worked as advertised so I
intended to see post-merge window what else could be done with it clean-up
wise. I am curious to see if it can also make ZONE_NORMAL configurable on
machines that only have ZONE_DMA for example.

> But that's not as important as ensuring the concept and user visible
> stuff is in good shape, which I no longer have any problems with.

Excellent.

> So
> yeah I think it would be good to get this in and get people up and
> running with it.

Thanks Nick.

[1] http://marc.info/?l=linux-mm&m=118405871911268&w=2

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
