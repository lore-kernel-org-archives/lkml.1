Return-Path: <linux-kernel-owner+w=401wt.eu-S1752243AbYIWJcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbYIWJcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 05:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbYIWJcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 05:32:22 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:38869 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbYIWJcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 05:32:21 -0400
Date: Tue, 23 Sep 2008 11:32:18 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Martin Steigerwald <ms@teamix.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Aaron Carroll <aaronc@gelato.unsw.edu.au>
Subject: Re: Documentation on CFQ iosched parameters
Message-ID: <20080923093218.GY26460@kernel.dk>
References: <200809221715.33143.ms@teamix.de> <48D85F49.4080001@gelato.unsw.edu.au> <200809231126.51902.ms@teamix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809231126.51902.ms@teamix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23 2008, Martin Steigerwald wrote:
> Am Dienstag, 23. September 2008 schrieb Aaron Carroll:
> > Martin Steigerwald wrote:
> > > Hi!
> > >
> > > I am searching documentation about CFQ io scheduler. I can't find it in
> > > linux 2.6.26 Documentation directory.
> > >
> > > I found about these in german[1]:
> > >
> > > back_seek_max:16384
> > > back_seek_penalty:2
> > > fifo_expire_async:250
> > > fifo_expire_sync:123
> > > quantum:4
> > >
> > > But I am completely missing about these:
> > >
> > > slice_async:40
> >
> > Base length of an asynchronous queue timeslice (that is, how long the
> > queue has to dispatch requests each round).  The actual timeslice
> > length is scaled by the I/O priority.
> 
> [...]
> 
> Thanks. As I do not find documentation about CFQ at all, I think I need to 
> create a new file from scratch... how about 
> Documentation/block/cfq-iosched.txt?

That would be great!

> For that I need some more information about CFQ. I found the following 
> resources:
> 
> - CFQ V3 aka CFQ TS: http://lwn.net/Articles/143474/, 
> http://lwn.net/Articles/114770/ and posts by Jens, 
> http://lwn.net/Articles/113869/
> 
> - CFQ V2: Post by Jens, http://lwn.net/Articles/101029/
> 
> - CFQ: Post by Jens, http://lwn.net/Articles/22429/

You can mention the links for v1 and v2, but as they have even little
historic relevance, don't spend more time on that.

> - Documentation/block/as-iosched.txt / deadline-iosched.txt (as for how an IO 
> scheduler can be documented)
> 
> Would that be what I should read in order to write such an documentation? 

Yes

> How about the relevance of CFQ and CFQ v2 stuff? What of it would be good to 
> mention? I would like to limit documentation to what is still relevant for 
> the current implementation of the IO scheduler. Should I mention its 
> inheritance from SFQ - maybe in a small introduction and historic overview?

Even the very first CFQ posted used per-process queues, so there's
really very little inheritance from SFQ at all. So I don't think it's
particularly interesting to mention. But if you want, go ahead :-)


-- 
Jens Axboe

