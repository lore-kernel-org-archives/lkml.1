Return-Path: <linux-kernel-owner+w=401wt.eu-S1763646AbXHPLPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763646AbXHPLPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 07:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbXHPLPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 07:15:39 -0400
Received: from ns.suse.de ([195.135.220.2]:47505 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbXHPLPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 07:15:38 -0400
From: Neil Brown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 16 Aug 2007 21:15:31 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18116.12755.587269.111597@notabene.brown>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 002 of 5] Replace bio_data with blk_rq_data
In-Reply-To: message from Jens Axboe on Thursday August 16
References: <20070816150445.30843.patches@notabene>
	<1070816051337.31344@suse.de>
	<20070816070255.GJ23758@kernel.dk>
	<18115.63917.990694.904646@notabene.brown>
	<20070816072114.GK23758@kernel.dk>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday August 16, jens.axboe@oracle.com wrote:
> > 2 and 3 are very simple changes that - I think - make it clearer what
> > is happening.
> 
> To be honest, I don't see much win in using blk_rq_data() over
> bio_data() at all. I'd much much rather just see it go away!
> 

Well, as it is always the data at the (current) head of the request...

But I can make it go a way if you like.. What does it become?
bvec_kmap ??

> > And I felt 5 was a sufficient improvement to justify it and 4...
> 
> 5 is nice, I would like to apply that :-)
> 

OK, here comes '5' at the top of a small set of patches.  Take it and
any of the following that you like.

NeilBrown
