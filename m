Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbZHTKkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbZHTKkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 06:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbZHTKj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 06:39:59 -0400
Received: from brick.kernel.dk ([93.163.65.50]:54181 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbZHTKj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 06:39:58 -0400
Date: Thu, 20 Aug 2009 12:40:00 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, zach.brown@oracle.com, hch@infradead.org
Subject: Re: [PATCH 0/4] Page based O_DIRECT v2
Message-ID: <20090820104000.GH12579@kernel.dk>
References: <1250584501-31140-1-git-send-email-jens.axboe@oracle.com> <1250708742.5589.23.camel@cail> <20090819220640.GW12579@kernel.dk> <1250720604.5589.50.camel@cail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250720604.5589.50.camel@cail>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19 2009, Alan D. Brunelle wrote:
> On Thu, 2009-08-20 at 00:06 +0200, Jens Axboe wrote:
> 
> > 
> > Thanks a lot for the test run, Alan. I wonder why writes are down while
> > reads are up. One possibility could be a WRITE vs WRITE_ODIRECT
> > difference, though I think they should be the same. The patches I posted
> > have not been benchmarked at all, it's still very much a work in
> > progress. I just wanted to show the general direction that I thought
> > would be interesting. So I have done absolutely zero performance
> > testing, it's only been tested for whether it still worked or not (to
> > some degree :-)...
> > 
> > I'll poke a bit at it here, too. I want to finish the unplug/wait
> > problem first. Is your test case using read/write or readv/writev?
> > 
> 
> Hi Jens - I just had some extra cycles, so figured what the heck... :-)
> 
> Actually, this is using asynchronous direct I/Os (libaio/Linux native
> AIO). If I get a chance tomorrow, I'll play with read/write (and/or
> readv/writev). 

OK, then I wonder what the heck is up... Did you catch any io metrics?

-- 
Jens Axboe

