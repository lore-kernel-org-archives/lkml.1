Return-Path: <linux-kernel-owner+w=401wt.eu-S932141AbZDIKhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141AbZDIKhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761544AbZDIKh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:37:28 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41079 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932169AbZDIKh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:37:27 -0400
X-Sasl-enc: vM8ojYMijlQj7PqtBc0Nx96h9XldQKgkbzch3hEKKZoh 1239273308
Message-ID: <49DDCF58.6050504@fastmail.fm>
Date: Thu, 09 Apr 2009 11:35:04 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jeff@garzik.org, kernel-janitors@vger.kernel.org, dushistov@mail.ru
Subject: Re: [PATCH 52/56] ufs: Remove void casts
References: <> <1239189748-11703-38-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-39-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-40-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-41-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-42-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-43-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-44-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-45-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-46-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-47-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-48-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-49-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-50-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-51-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-52-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-53-git-send-email-jwjstone@fastmail.fm>
In-Reply-To: <1239189748-11703-53-git-send-email-jwjstone@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added maintainer CC]
Jack Stone wrote:
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>  fs/ufs/dir.c   |    2 +-
>  fs/ufs/super.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ufs/dir.c b/fs/ufs/dir.c
> index dbbbc46..17898e3 100644
> --- a/fs/ufs/dir.c
> +++ b/fs/ufs/dir.c
> @@ -585,7 +585,7 @@ int ufs_make_empty(struct inode * inode, struct inode *dir)
>  	}
>  
>  	kmap(page);
> -	base = (char*)page_address(page);
> +	base = page_address(page);
>  	memset(base, 0, PAGE_CACHE_SIZE);
>  
>  	de = (struct ufs_dir_entry *) base;
> diff --git a/fs/ufs/super.c b/fs/ufs/super.c
> index 6035929..2488b6d 100644
> --- a/fs/ufs/super.c
> +++ b/fs/ufs/super.c
> @@ -1304,7 +1304,7 @@ static struct kmem_cache * ufs_inode_cachep;
>  static struct inode *ufs_alloc_inode(struct super_block *sb)
>  {
>  	struct ufs_inode_info *ei;
> -	ei = (struct ufs_inode_info *)kmem_cache_alloc(ufs_inode_cachep, GFP_KERNEL);
> +	ei = kmem_cache_alloc(ufs_inode_cachep, GFP_KERNEL);
>  	if (!ei)
>  		return NULL;
>  	ei->vfs_inode.i_version = 1;
>   

