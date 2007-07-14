Return-Path: <linux-kernel-owner+w=401wt.eu-S1759978AbXGNI2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759978AbXGNI2n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 04:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbXGNI2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 04:28:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbXGNI2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 04:28:34 -0400
Date: Sat, 14 Jul 2007 10:28:07 +0200
From: Nick Piggin <npiggin@suse.de>
To: Mel Gorman <mel@skynet.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, kenchen@google.com,
       jschopp@austin.ibm.com, apw@shadowen.org,
       kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl,
       y-goto@jp.fujitsu.com, clameter@sgi.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add a movablecore= parameter for sizing ZONE_MOVABLE
Message-ID: <20070714082807.GC1198@wotan.suse.de>
References: <20070710102043.GA20303@skynet.ie> <20070712122925.192a6601.akpm@linux-foundation.org> <20070712213241.GA7279@skynet.ie> <20070713155610.GD14125@skynet.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713155610.GD14125@skynet.ie>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 04:56:10PM +0100, Mel Gorman wrote:
> On (12/07/07 22:32), Mel Gorman didst pronounce:
> 
> > > Should we at least go for
> > > 
> > > add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
> > > create-the-zone_movable-zone.patch
> > > allow-huge-page-allocations-to-use-gfp_high_movable.patch
> > > handle-kernelcore=-generic.patch
> > > 
> > > in 2.6.23?
> > 
> > Well, yes please from me obviously :) . There is one additional patch
> > I would like to send on tomorrow and that is providing the movablecore=
> 
> This is the patch. It has been boot-tested on a number of machines and
> behaves as expected. Nick, with this in addition, do you have any
> objection to the ZONE_MOVABLE patches going through to 2.6.23?

What's the status of making it configurable? I didn't see something
in -mm for that yet?

But that's not as important as ensuring the concept and user visible
stuff is in good shape, which I no longer have any problems with. So
yeah I think it would be good to get this in and get people up and
running with it.
