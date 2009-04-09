Return-Path: <linux-kernel-owner+w=401wt.eu-S1764349AbZDIKGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764349AbZDIKGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760426AbZDIKGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:06:43 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39680 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759096AbZDIKGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:06:41 -0400
X-Sasl-enc: aW0w0tgZCLVLb0+5p+GOPeDgJMHyF7L9PFx0lvX77X1b 1239271600
Message-ID: <49DDC8AC.8090300@fastmail.fm>
Date: Thu, 09 Apr 2009 11:06:36 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jeff@garzik.org, kernel-janitors@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 25/56] mm: Remove void casts
References: <> <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-24-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-25-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-26-git-send-email-jwjstone@fastmail.fm>
In-Reply-To: <1239189748-11703-26-git-send-email-jwjstone@fastmail.fm>
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
>  mm/shmem.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index d94d2e9..4febea9 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2357,7 +2357,7 @@ static struct kmem_cache *shmem_inode_cachep;
>  static struct inode *shmem_alloc_inode(struct super_block *sb)
>  {
>  	struct shmem_inode_info *p;
> -	p = (struct shmem_inode_info *)kmem_cache_alloc(shmem_inode_cachep, GFP_KERNEL);
> +	p = kmem_cache_alloc(shmem_inode_cachep, GFP_KERNEL);
>  	if (!p)
>  		return NULL;
>  	return &p->vfs_inode;
>   

