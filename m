Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbXLDMSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbXLDMSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 07:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbXLDMSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 07:18:35 -0500
Received: from brick.kernel.dk ([87.55.233.238]:20764 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbXLDMSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:18:33 -0500
Date: Tue, 4 Dec 2007 13:16:23 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com
Subject: Re: [PATCH 00/28] blk_end_request: full I/O completion handler
	(take 3)
Message-ID: <20071204121623.GQ23294@kernel.dk>
References: <20071130.182351.115904044.k-ueda@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071130.182351.115904044.k-ueda@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30 2007, Kiyoshi Ueda wrote:
> Hello Jens,
> 
> The following is the updated patch-set for blk_end_request().
> Changes since the last version are only minor updates to catch up
> with the base kernel changes.
> Do you agree the implementation of blk_end_request()?
> If there's no problem, could you merge it to your tree?
> Or does it have to be merged to -mm tree first?
> 
> 
> Boaz,
> Could you review the newly added PATCH 27 which converts the bidi part,
> and give me your comments?
> It uses blk_end_request_callback() in PATCH 25, which was only for
> the tricky ide-cd driver.
> If bidi added a 'resid' member to struct request instead of reusing
> 'data_len' for the other purpose, it could use the standard
> blk_end_request() instead.
> 
> ------------------ Changes from the previous post ---------------------
> Changes between take2 and take3:
>   o Rebased on top of 2.6.24-rc3-mm2

OK, so this means that I can't apply it unfortunately. It depends on
other patches in -mm (bidi).

SCSI sits on block, so the best approach imho is to base this patchset
on mainline so I can include the block bits.


-- 
Jens Axboe

