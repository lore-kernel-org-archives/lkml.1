Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbYJCRoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbYJCRoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 13:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbYJCRnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 13:43:43 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:31658 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbYJCRnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 13:43:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=f5wD/Ck3c4k9WPzkC3swjnmefjXjx5pEsMnbYaE1b4jXi3I+fZfgAVbAXRDbCUqzMC
         dzYfljn/9kK/VNDvHfPmEXO4cJB5QPs/Slztuqme7TmMZ0DnQaP6vpaXM8G/nf2VQ6l9
         dQaahcKX1hHqIXP3Tawp+fx4HfmYr1fFhFft4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 2/3] ide-cd: small drive type print fix
Date: Fri, 3 Oct 2008 19:18:15 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1222669799-6565-1-git-send-email-petkovbb@gmail.com> <1222669799-6565-3-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1222669799-6565-3-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810031918.15455.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 September 2008, Borislav Petkov wrote:
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied (though I fail to see "an added value" of this change)

> ---
>  drivers/ide/ide-cd.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> index 9ffce7f..e41b94d 100644
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -1784,7 +1784,7 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
>  	if ((cdi->mask & CDC_DVD_R) == 0 || (cdi->mask & CDC_DVD_RAM) == 0)
>  		printk(KERN_CONT " DVD%s%s",
>  				 (cdi->mask & CDC_DVD_R) ? "" : "-R",
> -				 (cdi->mask & CDC_DVD_RAM) ? "" : "-RAM");
> +				 (cdi->mask & CDC_DVD_RAM) ? "" : "/RAM");
>  
>  	if ((cdi->mask & CDC_CD_R) == 0 || (cdi->mask & CDC_CD_RW) == 0)
>  		printk(KERN_CONT " CD%s%s",
