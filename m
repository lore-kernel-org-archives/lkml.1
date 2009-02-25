Return-Path: <linux-kernel-owner+w=401wt.eu-S1762637AbZBYKgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762637AbZBYKgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 05:36:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760678AbZBYKfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 05:35:54 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:56018 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757349AbZBYKfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 05:35:52 -0500
Message-ID: <49A51EFF.4020600@garzik.org>
Date: Wed, 25 Feb 2009 05:35:43 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch][rfc] fs: move bdev code out of buffer.c
References: <20090225094419.GF22785@wotan.suse.de>
In-Reply-To: <20090225094419.GF22785@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Move some block device related code out from buffer.c and put it in
> block_dev.c. I'm trying to move non-buffer_head code out of buffer.c
> 
> Is this OK?
> 
> ---
>  fs/block_dev.c              |  146 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/buffer.c                 |  145 -------------------------------------------
>  include/linux/buffer_head.h |    7 --
>  include/linux/fs.h          |    7 ++
>  4 files changed, 153 insertions(+), 152 deletions(-)

If you are going to churn all this old code, maybe the blkdev stuff 
better belongs in block/ dir?

	Jeff



