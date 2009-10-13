Return-Path: <linux-kernel-owner+w=401wt.eu-S1758575AbZJMLbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575AbZJMLbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 07:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbZJMLbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 07:31:38 -0400
Received: from brick.kernel.dk ([93.163.65.50]:47878 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbZJMLbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 07:31:37 -0400
Date: Tue, 13 Oct 2009 13:31:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blkdev: flush disk cache on ->fsync
Message-ID: <20091013113101.GZ9228@kernel.dk>
References: <20090820182432.GA31520@lst.de> <20091010161531.GA30289@lst.de> <20091012150713.GM9228@kernel.dk> <20091013014128.GB7931@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013014128.GB7931@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13 2009, Christoph Hellwig wrote:
> On Mon, Oct 12, 2009 at 05:07:13PM +0200, Jens Axboe wrote:
> > On Sat, Oct 10 2009, Christoph Hellwig wrote:
> > > Is anyone going to pick up this patch?
> > 
> > I can pick it up for .33. I think it looks good, but it's probably
> > something we should add up front.
> 
> Given that it's impossible to get data to a raw block device reliably
> without this I think it's .32 material.  Especially given how small
> the patch is and how long it's been out there..

Yes I agree, but it's also not a regression since this has been the
situation for eternity. So why not just accept .33 and we can push it to
-stable after that?

-- 
Jens Axboe

