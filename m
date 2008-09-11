Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbYIKNrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbYIKNrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 09:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756253AbYIKNrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 09:47:00 -0400
Received: from rn-out-0910.google.com ([64.233.170.191]:44272 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239AbYIKNq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 09:46:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YLvXRpm9YiQoRVCX32FWgMORITZoIwaqlKMW3b76fkj/TwMoyzw7r2PpHhGaolIL6z
         c1Zcy2EZtaEvjnIAoBV/xoDnxjA7OLryBN4/HI+7e5jWg0UEBkMsMuG7Xzz1bO47HysK
         MvLoTj8A2ZlOnDFqwliV4lcb44sh7z4/nr9YU=
Message-ID: <80b317760809110646m703f126cv9da4bd840a41b2a8@mail.gmail.com>
Date: Thu, 11 Sep 2008 15:46:57 +0200
From: "Richard Genoud" <richard.genoud@gmail.com>
To: "Julia Lawall" <julia@diku.dk>
Subject: Re: [PATCH 3/5] fs/namespace.c: Drop code after return
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       vigneshbabu@gmail.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0809111433270.9593@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0809111433270.9593@pc-004.diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/11 Julia Lawall <julia@diku.dk>:
> From: Julia Lawall <julia@diku.dk>
>
> The extra semicolon serves no purpose.
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
Reviewed-by: Richard Genoud <richard.genoud@gmail.com>
> ---
>
>  fs/namespace.c                |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 6e283c9..7e6151a 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1993,7 +1993,7 @@ static struct mnt_namespace *dup_mnt_ns(struct mnt_namespace *mnt_ns,
>        if (!new_ns->root) {
>                up_write(&namespace_sem);
>                kfree(new_ns);
> -               return ERR_PTR(-ENOMEM);;
> +               return ERR_PTR(-ENOMEM);
>        }
>        spin_lock(&vfsmount_lock);
>        list_add_tail(&new_ns->list, &new_ns->root->mnt_list);
>
