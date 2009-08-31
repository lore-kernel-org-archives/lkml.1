Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbZHaT4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbZHaT4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 15:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbZHaT4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 15:56:00 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34985 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbZHaT4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 15:56:00 -0400
Date: Mon, 31 Aug 2009 21:56:02 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, akpm@linux-foundation.org,
       jack@suse.cz
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads v15
Message-ID: <20090831195602.GB12579@kernel.dk>
References: <1251747693-32354-1-git-send-email-jens.axboe@oracle.com> <20090831195148.GA26130@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090831195148.GA26130@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31 2009, Christoph Hellwig wrote:
> On Mon, Aug 31, 2009 at 09:41:26PM +0200, Jens Axboe wrote:
> > Christoph, let me know if there are things you are still not happy
> > with and I will reply/address them. Note that this series has only
> > received a light testing. This means that it boots and seems to work
> > (flushes data on sync and at intervals) and does not corrupt data,
> > but it hasn't received a thorough testing yet. That will come tomorrow.
> > But I wanted to push this out there, so we can settle the code base
> > quickly again.
> 
> I'll slowly look over it later.  But I think it would be extremly
> helpful if we could get it into -next ASAP for wider testing.

Yeah, will update my for-next branch. It _should_ be functionally
equivalent to the previous posting which has recieved a LOT of testing,
but there can be new bugs of course. So far it still seems fine, so
should be safe...

-- 
Jens Axboe

