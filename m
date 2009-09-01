Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbZIAUj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbZIAUj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 16:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbZIAUj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 16:39:28 -0400
Received: from brick.kernel.dk ([93.163.65.50]:46188 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376AbZIAUj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 16:39:27 -0400
Date: Tue, 1 Sep 2009 22:39:29 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow changing max_sectors_kb above the default 512
Message-ID: <20090901203929.GI12579@kernel.dk>
References: <200909011815.45979.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909011815.45979.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01 2009, Nikanth Karthikesan wrote:
> The patch "block: Use accessor functions for queue limits"
> (ae03bf639a5027d27270123f5f6e3ee6a412781d) changed queue_max_sectors_store()
> to use blk_queue_max_sectors() instead of directly assigning the value.
> 
> But blk_queue_max_sectors() differs a bit
> 1. It sets both max_sectors_kb, and max_hw_sectors_kb
> 2. Never allows one to change max_sectors_kb above BLK_DEF_MAX_SECTORS. If one
> specifies a value greater then max_hw_sectors is set to that value but
> max_sectors is set to BLK_DEF_MAX_SECTORS
> 
> I am not sure whether blk_queue_max_sectors() should be changed, as it seems
> to be that way for a long time. And there may be callers dependent on that
> behaviour.
> 
> This patch simply reverts to the older way of directly assigning the value to
> max_sectors as it was before.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

Good catch! Applied for 2.6.31.

-- 
Jens Axboe

