Return-Path: <linux-kernel-owner+w=401wt.eu-S1760276AbZAMOaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760276AbZAMOaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 09:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZAMOaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 09:30:06 -0500
Received: from brick.kernel.dk ([93.163.65.50]:12279 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbZAMOaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 09:30:05 -0500
Date: Tue, 13 Jan 2009 15:28:47 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Fix documentation for blkdev_issue_flush()
Message-ID: <20090113142846.GW30821@kernel.dk>
References: <20090113140706.GV30821@kernel.dk> <1231856786-32685-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231856786-32685-1-git-send-email-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13 2009, Theodore Ts'o wrote:
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  block/blk-barrier.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/block/blk-barrier.c b/block/blk-barrier.c
> index 8eba4e4..f7dae57 100644
> --- a/block/blk-barrier.c
> +++ b/block/blk-barrier.c
> @@ -302,7 +302,7 @@ static void bio_end_empty_barrier(struct bio *bio, int err)
>   * Description:
>   *    Issue a flush for the block device in question. Caller can supply
>   *    room for storing the error offset in case of a flush error, if they
> - *    wish to.  Caller must run wait_for_completion() on its own.
> + *    wish to.
>   */
>  int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
>  {

Thanks Ted, applied.

-- 
Jens Axboe

