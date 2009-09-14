Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbZINJkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbZINJkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 05:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbZINJka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 05:40:30 -0400
Received: from brick.kernel.dk ([93.163.65.50]:54565 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248AbZINJkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 05:40:24 -0400
Date: Mon, 14 Sep 2009 11:40:27 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, liml@rtr.ca, matthew@wil.cx,
       dwmw2@infradead.org
Subject: Re: [PATCH 2/7] block: use blkdev_issue_discard in
	blk_ioctl_discard
Message-ID: <20090914094027.GY14984@kernel.dk>
References: <20090829230332.017137693@bombadil.infradead.org> <20090829231121.385741993@bombadil.infradead.org> <20090911222644.GA7197@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911222644.GA7197@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11 2009, Christoph Hellwig wrote:
> Jens, can we put this one and possible Dave's treat discard requests
> as writes patch in early for 2.6.32?  That'll make the discard patch
> queue quite a bit smaller and will allow easier experimenting.

Looks fine from a review, I'll include it in the for-2.6.32 branch. I
plan on asking for a pull of that tomorrow.

-- 
Jens Axboe

