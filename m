Return-Path: <linux-kernel-owner+w=401wt.eu-S1759522AbXHPHBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522AbXHPHBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 03:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbXHPHB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 03:01:28 -0400
Received: from brick.kernel.dk ([87.55.233.238]:5752 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbXHPHB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 03:01:28 -0400
Date: Thu, 16 Aug 2007 09:01:25 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 001 of 5] Don't update bi_hw_*_size if we aren't going to merge.
Message-ID: <20070816070125.GI23758@kernel.dk>
References: <20070816150445.30843.patches@notabene> <1070816051332.31325@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1070816051332.31325@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16 2007, NeilBrown wrote:
> 
> ll_merge_requests_fn can update bi_hw_*_size in one case where we end
> up not merging.  This is wrong.

This looks good, obviously. Applied.

-- 
Jens Axboe

