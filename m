Return-Path: <linux-kernel-owner+w=401wt.eu-S1763202AbXHPHQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763202AbXHPHQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 03:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbXHPHQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 03:16:06 -0400
Received: from mail.suse.de ([195.135.220.2]:53703 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819AbXHPHQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 03:16:05 -0400
From: Neil Brown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 16 Aug 2007 17:15:57 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18115.63917.990694.904646@notabene.brown>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 002 of 5] Replace bio_data with blk_rq_data
In-Reply-To: message from Jens Axboe on Thursday August 16
References: <20070816150445.30843.patches@notabene>
	<1070816051337.31344@suse.de>
	<20070816070255.GJ23758@kernel.dk>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday August 16, jens.axboe@oracle.com wrote:
> On Thu, Aug 16 2007, NeilBrown wrote:
> > 
> > Almost every call to bio_data is for the first bio
> > in a request.  A future patch will add some accounting
> > information to 'struct request' which will need to be
> > used to find the start of the request in the bio.
> > So replace bio_data with blk_rq_data which takes a 'struct request *'
> > 
> > The one exception is in dm-emc were using
> >    page_address(bio->bi_io_vec[0].bv_page);
> > is appropriate.
> 
> This (and 3+4) just look like preparatory patches if we want to merge
> the full patchset, not bug fixes. I seem to recall you had more bug
> fixes or cleanups in your patchset, maybe I was mistaken. So nak for now
> for 2-4, I'd apply 5 but it depends on the previous.
> 

I don't remember other bug fixes, but I'll look through and check.

2 and 3 are very simple changes that - I think - make it clearer what
is happening.

And I felt 5 was a sufficient improvement to justify it and 4...

I'll go hunting and see what other preliminaries I can find.

NeilBrown
