Return-Path: <linux-kernel-owner+w=401wt.eu-S1757676AbZEDPMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676AbZEDPMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 11:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757044AbZEDPMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 11:12:08 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:61426 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673AbZEDPMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 11:12:07 -0400
Subject: Re: [PATCH] btrfs: remove the improper comment for
 btrfs_ioctl_resize()
From: Chris Mason <chris.mason@oracle.com>
To: Li Hong <lihong.hi@gmail.com>
Cc: linux-btrfs@vger.kernel.org, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <3a3680030905032205u2c3490e8r62e66c48aff97fee@mail.gmail.com>
References: <3a3680030905032205u2c3490e8r62e66c48aff97fee@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 04 May 2009 11:11:56 -0400
Message-Id: <1241449916.7244.15.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt003.oracle.com [141.146.116.12]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.49FF05BF.00AC,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-04 at 01:05 -0400, Li Hong wrote:
> In Li Zefan's commit dae7b665cf6d6e6e733f1c9c16cf55547dd37e33,
> a combination call of kmalloc() and copy_from_user() is replaced by
> memdup_user(). So btrfs_ioctl_resize() doesn't use GFP_NOFS any more.
> 
> Signed-off-by: Li Hong <lihong.hi@gmail.com>
> ---
>  fs/btrfs/ioctl.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 5e94ea6..2624b53 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -437,10 +437,6 @@ out_unlock:
>  	return 0;
>  }
> 
> -/*
> - * Called inside transaction, so use GFP_NOFS
> - */
> -
>  static int btrfs_ioctl_resize(struct btrfs_root *root, void __user *arg)
>  {
>  	u64 new_size;

Thanks, I've queued this one up.

-chris


