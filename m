Return-Path: <linux-kernel-owner+w=401wt.eu-S1765482AbZDIKHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765482AbZDIKHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760426AbZDIKHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:07:23 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50144 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760882AbZDIKHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:07:21 -0400
X-Sasl-enc: YGvmslE2EC+nSTACsLneH9KJNax3Db8pwyMsBCkqcGH8 1239271639
Message-ID: <49DDC8D4.3070209@fastmail.fm>
Date: Thu, 09 Apr 2009 11:07:16 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jeff@garzik.org, kernel-janitors@vger.kernel.org, vandrove@vc.cvut.cz
Subject: Re: [PATCH 26/56] ncpfs: Remove void casts
References: <> <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-24-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-25-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-26-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-27-git-send-email-jwjstone@fastmail.fm>
In-Reply-To: <1239189748-11703-27-git-send-email-jwjstone@fastmail.fm>
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
>  fs/ncpfs/inode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
> index d642f0e..7d33658 100644
> --- a/fs/ncpfs/inode.c
> +++ b/fs/ncpfs/inode.c
> @@ -53,7 +53,7 @@ static struct kmem_cache * ncp_inode_cachep;
>  static struct inode *ncp_alloc_inode(struct super_block *sb)
>  {
>  	struct ncp_inode_info *ei;
> -	ei = (struct ncp_inode_info *)kmem_cache_alloc(ncp_inode_cachep, GFP_KERNEL);
> +	ei = kmem_cache_alloc(ncp_inode_cachep, GFP_KERNEL);
>  	if (!ei)
>  		return NULL;
>  	return &ei->vfs_inode;
>   

