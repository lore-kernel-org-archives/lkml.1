Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbZDFRB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbZDFRB2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 13:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbZDFRBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 13:01:19 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45388 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbZDFRBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 13:01:19 -0400
Date: Mon, 6 Apr 2009 19:01:16 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tytso@mit.edu
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
Message-ID: <20090406170116.GH5178@kernel.dk>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com> <alpine.LFD.2.00.0904060803141.4023@localhost.localdomain> <20090406151054.GD5178@kernel.dk> <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06 2009, Linus Torvalds wrote:
> 
> 
> On Mon, 6 Apr 2009, Jens Axboe wrote:
> >
> > > Jens - I can just apply this queue (I want to test it out anyway), or if 
> > > you prefer I can pull from you. Just tell me.
> > 
> > Whatever you want, if you want to pull instead of manually applying,
> > it's:
> > 
> > git://git.kernel.dk/linux-2.6-block.git blk-latency
> 
> Ok, I applied them for testing anyway, so I think I'll just keep the 
> series I have in my tree. I'm keeping my nasty "dd+sync" going in the 

No problem, the end result should be identical :-)

> background, just to verify that things really feel better, but I'm already 
> convinced this is a winner. Especially with the request size limiter, I 
> can really read email _almost_ as if nothing else was going on on the 
> machine. 
> 
> With that request size limiting, my fsync pauses tend to be in the 250ms 
> range, with a one 0.75s outlier in the last few minutes. I can definitely 
> feel that quarter-second thing, and the .75s pause was a real stutter, but 
> boy what a difference. I don't get the uncontrollable urge to kill that 
> nasty background writer any more.

If we can make the dd writer almost unnoticable, then I think we've come
a long way already. That really is a nasty workload.

-- 
Jens Axboe

