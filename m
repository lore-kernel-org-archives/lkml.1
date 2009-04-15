Return-Path: <linux-kernel-owner+w=401wt.eu-S1759706AbZDOM7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759706AbZDOM7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 08:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbZDOM7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 08:59:14 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:32337 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbZDOM7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 08:59:14 -0400
Subject: Re: [PATCH] Btrfs: setting variable out of order
From: Chris Mason <chris.mason@oracle.com>
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: Yan Zheng <zheng.yan@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20090415091126.GA13323@kernel.sg>
References: <20090415091126.GA13323@kernel.sg>
Content-Type: text/plain
Date: Wed, 15 Apr 2009 08:59:05 -0400
Message-Id: <1239800345.31633.1.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.49E5DA1C.01FD:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-15 at 17:11 +0800, Eugene Teo wrote:
> This doesn't look intentional.
>
> Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
> ---
>  fs/btrfs/ctree.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index e5b2533..6aa2468 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -3376,8 +3376,8 @@ int btrfs_insert_some_items(struct
> btrfs_trans_handle *trans,
>         for (i = 0; i < nr; i++) {
>                 if (total_size + data_size[i] + sizeof(struct btrfs_item) >
>                     BTRFS_LEAF_DATA_SIZE(root)) {
> -                       break;
>                         nr = i;
> +                       break;
>                	}

Thanks,

This function isn't used anymore, I'll drop it.

-chris


