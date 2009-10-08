Return-Path: <linux-kernel-owner+w=401wt.eu-S932674AbZJHPQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674AbZJHPQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 11:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932417AbZJHPQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 11:16:51 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:44825 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334AbZJHPQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 11:16:50 -0400
To: Hemant Pedanekar <hemantp@ti.com>
Cc: dwmw2@infradead.org, dbrownell@users.sourceforge.net,
       akpm@linux-foundation.org, Artem.Bityutskiy@nokia.com,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH] mtd: nand: davinci: fix to use mask_ale from pdata
References: <1254407106-19390-1-git-send-email-hemantp@ti.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Thu, 08 Oct 2009 08:16:10 -0700
In-Reply-To: <1254407106-19390-1-git-send-email-hemantp@ti.com> (Hemant Pedanekar's message of "Thu\,  1 Oct 2009 19\:55\:06 +0530")
Message-ID: <87tyy9dih1.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hemant Pedanekar <hemantp@ti.com> writes:

> Correct typo to use mask_ale from platform data when set to non-zero.
>
> Signed-off-by: Hemant Pedanekar <hemantp@ti.com>

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>

Could this fix be queued for the .32-rc series please?

Thanks,

Kevin

> ---
>  drivers/mtd/nand/davinci_nand.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
> index 0fad648..20b04a2 100644
> --- a/drivers/mtd/nand/davinci_nand.c
> +++ b/drivers/mtd/nand/davinci_nand.c
> @@ -571,7 +571,7 @@ static int __init nand_davinci_probe(struct platform_device *pdev)
>  	info->mask_chipsel	= pdata->mask_chipsel;
>  
>  	/* use nandboot-capable ALE/CLE masks by default */
> -	info->mask_ale		= pdata->mask_cle ? : MASK_ALE;
> +	info->mask_ale		= pdata->mask_ale ? : MASK_ALE;
>  	info->mask_cle		= pdata->mask_cle ? : MASK_CLE;
>  
>  	/* Set address of hardware control function */
> -- 
> 1.6.2.4
>
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
