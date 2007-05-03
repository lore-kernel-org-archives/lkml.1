Return-Path: <linux-kernel-owner+w=401wt.eu-S965513AbXECJaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965513AbXECJaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 05:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965576AbXECJaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 05:30:04 -0400
Received: from styx.suse.cz ([82.119.242.94]:50698 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965513AbXECJaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 05:30:00 -0400
Date: Thu, 3 May 2007 11:39:37 +0200
From: Jan Kara <jack@suse.cz>
To: Mike Frysinger <vapier@gentoo.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] hide spinlock in linux/quota.h behind __KERNEL__
Message-ID: <20070503093936.GA12229@duck.suse.cz>
References: <200705021853.39952.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705021853.39952.vapier@gentoo.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 02-05-07 18:53:39, Mike Frysinger wrote:
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
  Acked-by: Jan Kara <jack@suse.cz>

> ---
> diff --git a/include/linux/quota.h b/include/linux/quota.h
> index 77db80a..6243982 100644
> --- a/include/linux/quota.h
> +++ b/include/linux/quota.h
> @@ -44,8 +44,6 @@
>  typedef __kernel_uid32_t qid_t; /* Type in which we store ids in memory */
>  typedef __u64 qsize_t;          /* Type in which we store sizes */
>  
> -extern spinlock_t dq_data_lock;
> -
>  /* Size of blocks in which are counted size limits */
>  #define QUOTABLOCK_BITS 10
>  #define QUOTABLOCK_SIZE (1 << QUOTABLOCK_BITS)
> @@ -139,6 +137,8 @@ struct if_dqinfo {
>  #include <linux/dqblk_v1.h>
>  #include <linux/dqblk_v2.h>
>  
> +extern spinlock_t dq_data_lock;
> +
>  /* Maximal numbers of writes for quota operation (insert/delete/update)
>   * (over VFS all formats) */
>  #define DQUOT_INIT_ALLOC max(V1_INIT_ALLOC, V2_INIT_ALLOC)
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
