Return-Path: <linux-kernel-owner+w=401wt.eu-S1751889AbXHAEC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbXHAEC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 00:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbXHAECS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 00:02:18 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43719 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750718AbXHAECR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 00:02:17 -0400
X-Sasl-enc: 9Ba3iAQcjvO+0Z88+OK3OdAPwRpFC8Wpxh58TRfQuzxW 1185940934
Subject: Re: [PATCH 34] fs/autofs4/inode.c: kmalloc + memset conversion to
	kzalloc
From: Ian Kent <raven@themaw.net>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, autofs@linux.kernel.org
In-Reply-To: <200707312005.44495.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
	 <200707312005.44495.m.kozlowski@tuxland.pl>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 12:02:09 +0800
Message-Id: <1185940929.3211.25.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 20:05 +0200, Mariusz Kozlowski wrote:
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

ACK.

> 
>  fs/autofs4/inode.c | 10467 -> 10435 (-32 bytes)
>  fs/autofs4/inode.o | 98576 -> 98552 (-24 bytes)
> 
>  fs/autofs4/inode.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> --- linux-2.6.23-rc1-mm1-a/fs/autofs4/inode.c	2007-07-26 13:07:46.000000000 +0200
> +++ linux-2.6.23-rc1-mm1-b/fs/autofs4/inode.c	2007-07-29 23:56:08.000000000 +0200
> @@ -312,13 +312,11 @@ int autofs4_fill_super(struct super_bloc
>  	struct autofs_sb_info *sbi;
>  	struct autofs_info *ino;
> 
> -	sbi = kmalloc(sizeof(*sbi), GFP_KERNEL);
> +	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
>  	if (!sbi)
>  		goto fail_unlock;
>  	DPRINTK("starting up, sbi = %p",sbi);
> 
> -	memset(sbi, 0, sizeof(*sbi));
> -
>  	s->s_fs_info = sbi;
>  	sbi->magic = AUTOFS_SBI_MAGIC;
>  	sbi->pipefd = -1;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

