Return-Path: <linux-kernel-owner+w=401wt.eu-S1765370AbZDIJzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765370AbZDIJzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 05:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932169AbZDIJyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:54:39 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:49874 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932112AbZDIJyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:54:38 -0400
X-Sasl-enc: XuH5QgtAnsPwECUfd8ad8pKGQs4s2ZiUldndpD03B2uh 1239270876
Message-ID: <49DDC5DA.8070408@fastmail.fm>
Date: Thu, 09 Apr 2009 10:54:34 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       mikulas@artax.karlin.mff.cuni.cz
Subject: Re: [PATCH 12/56] hpfs: Remove void casts
References: <> <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
In-Reply-To: <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
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
>  fs/hpfs/super.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
> index fecf402..ab539dc 100644
> --- a/fs/hpfs/super.c
> +++ b/fs/hpfs/super.c
> @@ -164,7 +164,7 @@ static struct kmem_cache * hpfs_inode_cachep;
>  static struct inode *hpfs_alloc_inode(struct super_block *sb)
>  {
>  	struct hpfs_inode_info *ei;
> -	ei = (struct hpfs_inode_info *)kmem_cache_alloc(hpfs_inode_cachep, GFP_NOFS);
> +	ei = kmem_cache_alloc(hpfs_inode_cachep, GFP_NOFS);
>  	if (!ei)
>  		return NULL;
>  	ei->vfs_inode.i_version = 1;
>   

