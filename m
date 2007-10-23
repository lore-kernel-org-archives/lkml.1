Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbXJWVpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbXJWVpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 17:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbXJWVpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 17:45:06 -0400
Received: from brick.kernel.dk ([87.55.233.238]:5936 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502AbXJWVpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 17:45:05 -0400
Date: Tue, 23 Oct 2007 23:44:59 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, tomof@acm.org
Subject: Re: IDE crash...
Message-ID: <20071023214459.GM14671@kernel.dk>
References: <20071023.004321.74750417.davem@davemloft.net> <20071023195255S.fujita.tomonori@lab.ntt.co.jp> <20071023105710.GJ5059@kernel.dk> <20071023.141800.59467535.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023.141800.59467535.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, David Miller wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Tue, 23 Oct 2007 12:57:11 +0200
> 
> > On Tue, Oct 23 2007, FUJITA Tomonori wrote:
> > > BTW, we avoid calling sg_init_table() for every I/O request due to Jens'
> > > trick. And Jens will remove the code to clear sg_dma_len/addr in
> > > blk_rq_map_sg(). So sparc64 iommu needs to do that for itself?
> > > 
> > > http://marc.info/?l=linux-scsi&m=119261920425120&w=2
> > 
> > It does - Dave, do you agree with the patch? I think it should be added,
> > so that sparc64 isn't the odd-arch-out in this respect. I've tentatively
> > applied the patch, Davem?
> 
> No objections.

Great, thanks Dave.

-- 
Jens Axboe

