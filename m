Return-Path: <linux-kernel-owner+w=401wt.eu-S1764755AbZDHLdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764755AbZDHLdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758398AbZDHL0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:26:09 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:46842 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764441AbZDHL0G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:26:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QzWe9FeeMDwm4ipp3FZ184uHM2kdzCbWbT86loMEQpcpCo5GEWFGs+ZyU6hqMfGDTy
         0QNqr/obGd8yxJlVKr6u2zB+9fscRAgBP3kiqjN1zu8plXo3ENBeB5di2//mNLY1B9/u
         ro9ooteoXc8ohFHsOoQ/xixTdDyE3U9vbE/nY=
MIME-Version: 1.0
In-Reply-To: <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
Date: Wed, 8 Apr 2009 13:26:03 +0200
Message-ID: <36ca99e90904080426p71cf193ei5e3806e3781336d2@mail.gmail.com>
Subject: Re: [PATCH 04/56] befs: Remove void casts
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 13:21, Jack Stone <jwjstone@fastmail.fm> wrote:
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>  fs/befs/linuxvfs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
> index 76afd0d..cfd9698 100644
> --- a/fs/befs/linuxvfs.c
> +++ b/fs/befs/linuxvfs.c
> @@ -277,7 +277,7 @@ static struct inode *
>  befs_alloc_inode(struct super_block *sb)
>  {
>         struct befs_inode_info *bi;
> -        bi = (struct befs_inode_info *)kmem_cache_alloc(befs_inode_cachep,
> +        bi = kmem_cache_alloc(befs_inode_cachep,
>                                                        GFP_KERNEL);
                                                         ^^^^^^^^^^^^
This can now be one line up.

Bert
>         if (!bi)
>                 return NULL;
> --
> 1.5.4.3
