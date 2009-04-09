Return-Path: <linux-kernel-owner+w=401wt.eu-S1765229AbZDIJy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765229AbZDIJy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 05:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759559AbZDIJxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:53:52 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43729 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754939AbZDIJxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:53:51 -0400
X-Sasl-enc: 7TXEtxsaKtkV0C2S5aJPgLIlZwpSzBkWmGHM6QFg6/mT 1239270829
Message-ID: <49DDC5AA.9090808@fastmail.fm>
Date: Thu, 09 Apr 2009 10:53:46 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jeff@garzik.org, kernel-janitors@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 11/56] freevxfs: Remove void casts
References: <> <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
In-Reply-To: <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
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
>  fs/freevxfs/vxfs_inode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/freevxfs/vxfs_inode.c b/fs/freevxfs/vxfs_inode.c
> index 03a6ea5..9811217 100644
> --- a/fs/freevxfs/vxfs_inode.c
> +++ b/fs/freevxfs/vxfs_inode.c
> @@ -138,7 +138,7 @@ __vxfs_iget(ino_t ino, struct inode *ilistp)
>  	if (!IS_ERR(pp)) {
>  		struct vxfs_inode_info	*vip;
>  		struct vxfs_dinode	*dip;
> -		caddr_t			kaddr = (char *)page_address(pp);
> +		caddr_t			kaddr = page_address(pp);
>  
>  		if (!(vip = kmem_cache_alloc(vxfs_inode_cachep, GFP_KERNEL)))
>  			goto fail;
>   

