Return-Path: <linux-kernel-owner+w=401wt.eu-S935464AbXHPLY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935464AbXHPLY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 07:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934239AbXHPLWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 07:22:39 -0400
Received: from brick.kernel.dk ([87.55.233.238]:18144 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763466AbXHPLWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 07:22:36 -0400
Date: Thu, 16 Aug 2007 13:22:32 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 002 of 5] Replace bio_data with blk_rq_data
Message-ID: <20070816112229.GW23758@kernel.dk>
References: <20070816150445.30843.patches@notabene> <1070816051337.31344@suse.de> <20070816070255.GJ23758@kernel.dk> <18115.63917.990694.904646@notabene.brown> <20070816072114.GK23758@kernel.dk> <18116.12755.587269.111597@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18116.12755.587269.111597@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16 2007, Neil Brown wrote:
> On Thursday August 16, jens.axboe@oracle.com wrote:
> > > 2 and 3 are very simple changes that - I think - make it clearer what
> > > is happening.
> > 
> > To be honest, I don't see much win in using blk_rq_data() over
> > bio_data() at all. I'd much much rather just see it go away!
> > 
> 
> Well, as it is always the data at the (current) head of the request...

So is bio_data(bio), and bio_data(rq->bio) is by definition the head of
the request. If anything, you are making it less flexible. Hence my
suggestion to just kill it off completely, it's a long over due cleanup.

-- 
Jens Axboe

