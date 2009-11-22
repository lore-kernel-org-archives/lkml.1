Return-Path: <linux-kernel-owner+w=401wt.eu-S1755000AbZKVMes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbZKVMes (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 07:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbZKVMes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 07:34:48 -0500
Received: from mga03.intel.com ([143.182.124.21]:48828 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbZKVMer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 07:34:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,266,1257148800"; 
   d="scan'208";a="214413760"
Date: Sun, 22 Nov 2009 20:33:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Jens Axboe <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] writeback: Fix missing kernel-doc notation
Message-ID: <20091122123347.GA19022@localhost>
References: <1258877769.4495.48.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258877769.4495.48.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Wu Fengguang <fengguang.wu@intel.com>

Thanks!

On Sun, Nov 22, 2009 at 04:16:09PM +0800, Jaswinder Singh Rajput wrote:
> 
> Fix the following htmldocs warning:
> 
>   Warning(fs/fs-writeback.c:255): No description found for parameter 'sb'
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  fs/fs-writeback.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 9d5360c..b15c97f 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -242,6 +242,7 @@ static void bdi_sync_writeback(struct backing_dev_info *bdi,
>  /**
>   * bdi_start_writeback - start writeback
>   * @bdi: the backing device to write from
> + * @sb: write inodes from this super_block
>   * @nr_pages: the number of pages to write
>   *
>   * Description:
> -- 
> 1.6.5.3
> 
