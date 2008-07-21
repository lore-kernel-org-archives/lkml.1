Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbYGUVDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbYGUVDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 17:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbYGUVDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 17:03:45 -0400
Received: from gw.goop.org ([64.81.55.164]:52641 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbYGUVDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 17:03:44 -0400
Message-ID: <4884F9A4.8060201@goop.org>
Date: Mon, 21 Jul 2008 14:03:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Christian Limpach <Christian.Limpach@xensource.com>,
       Jens Axboe <jens.axboe@oracle.com>, xen-devel@lists.xensource.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] xen-blkfront.c: make blkif_ioctl() static
References: <20080721193339.GC14846@cs181140183.pp.htv.fi>
In-Reply-To: <20080721193339.GC14846@cs181140183.pp.htv.fi>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch makes the needlessly global blkif_ioctl() static.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>   
Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

> ---
> c3e35790145bb28443ccb672fb46318e845c5f05 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 9ae05c5..3ca643c 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -154,8 +154,8 @@ static int blkif_getgeo(struct block_device *bd, struct hd_geometry *hg)
>  	return 0;
>  }
>  
> -int blkif_ioctl(struct inode *inode, struct file *filep,
> -		unsigned command, unsigned long argument)
> +static int blkif_ioctl(struct inode *inode, struct file *filep,
> +		       unsigned command, unsigned long argument)
>  {
>  	struct blkfront_info *info =
>  		inode->i_bdev->bd_disk->private_data;
>
>   


