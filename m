Return-Path: <linux-kernel-owner+w=401wt.eu-S1760311AbXHPHDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760311AbXHPHDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 03:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbXHPHC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 03:02:59 -0400
Received: from brick.kernel.dk ([87.55.233.238]:5759 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbXHPHC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 03:02:58 -0400
Date: Thu, 16 Aug 2007 09:02:55 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 002 of 5] Replace bio_data with blk_rq_data
Message-ID: <20070816070255.GJ23758@kernel.dk>
References: <20070816150445.30843.patches@notabene> <1070816051337.31344@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1070816051337.31344@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16 2007, NeilBrown wrote:
> 
> Almost every call to bio_data is for the first bio
> in a request.  A future patch will add some accounting
> information to 'struct request' which will need to be
> used to find the start of the request in the bio.
> So replace bio_data with blk_rq_data which takes a 'struct request *'
> 
> The one exception is in dm-emc were using
>    page_address(bio->bi_io_vec[0].bv_page);
> is appropriate.

This (and 3+4) just look like preparatory patches if we want to merge
the full patchset, not bug fixes. I seem to recall you had more bug
fixes or cleanups in your patchset, maybe I was mistaken. So nak for now
for 2-4, I'd apply 5 but it depends on the previous.

-- 
Jens Axboe

