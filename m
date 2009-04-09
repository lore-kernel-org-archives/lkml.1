Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbZDIJj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbZDIJj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 05:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756766AbZDIJjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:39:18 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47843 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756613AbZDIJjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:39:17 -0400
X-Sasl-enc: VVaTe0vIKplfF8NpxfyS5shT9S6f+2a7mmqSbDQ4teFS 1239269956
Message-ID: <49DDC241.5020905@fastmail.fm>
Date: Thu, 09 Apr 2009 10:39:13 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org, rathamahata@php4.ru
Subject: Re: [PATCH 04/56] befs: Remove void casts
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080426p71cf193ei5e3806e3781336d2@mail.gmail.com> <49DCAB84.4030802@fastmail.fm>
In-Reply-To: <49DCAB84.4030802@fastmail.fm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added maintainer CC]

Jack Stone wrote:
> Heres the fixed patch
>
> Thanks
>
> Jack
>
> befs: Remove void casts
>
> From: Jack Stone <jwjstone@fastmail.fm>
>
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>
>  fs/befs/linuxvfs.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
> index 76afd0d..e8b56a1 100644
> --- a/fs/befs/linuxvfs.c
> +++ b/fs/befs/linuxvfs.c
> @@ -277,8 +277,7 @@ static struct inode *
>  befs_alloc_inode(struct super_block *sb)
>  {
>          struct befs_inode_info *bi;
> -        bi = (struct befs_inode_info *)kmem_cache_alloc(befs_inode_cachep,
> -                            GFP_KERNEL);
> +        bi = kmem_cache_alloc(befs_inode_cachep, GFP_KERNEL);
>          if (!bi)
>                  return NULL;
>          return &bi->vfs_inode;
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

