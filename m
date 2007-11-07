Return-Path: <linux-kernel-owner+w=401wt.eu-S1757086AbXKGDSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbXKGDSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 22:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbXKGDSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 22:18:12 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:13272 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbXKGDSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 22:18:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ChHRM0Wc+jmo2tR8MOOtB9gFAJIBRha1DYLPNVlyxhc4FfcoqnH6ata+cMxjql3T3MaMpvAS7sRQ617x9RguOh0X5P/+hAwEaD03jzMggxwBhn/j4tp6+86mnX4gGKPpFR+1cBTIIsstiZvodGTvTY2azHwOoURmcOvbwPcGXWM=
Message-ID: <386072610711061918r4d4435b3n719894eda6d43a19@mail.gmail.com>
Date: Wed, 7 Nov 2007 11:18:09 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] blackfin: unexport get_wchan
Cc: bryan.wu@analog.com, linux-kernel@vger.kernel.org
In-Reply-To: <20071105170753.GX12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071105170753.GX12045@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 6, 2007 1:07 AM, Adrian Bunk <bunk@kernel.org> wrote:
> This patch removes the unused EXPORT_SYMBOL(get_wchan).
>
It should be. "The only user of get_wchan I was able to find is the
proc fs - and proc
can't be built modular." You said before, right?

> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
Acked-by: Bryan Wu <bryan.wu@analog.com>

> ---
> 6acc2faa1f25d2d5fbf6c5e435c222a79f753afa
> diff --git a/arch/blackfin/kernel/bfin_ksyms.c b/arch/blackfin/kernel/bfin_ksyms.c
> index 99ea57c..5dad9d3 100644
> --- a/arch/blackfin/kernel/bfin_ksyms.c
> +++ b/arch/blackfin/kernel/bfin_ksyms.c
> @@ -65,7 +65,6 @@ EXPORT_SYMBOL(memset);
>  EXPORT_SYMBOL(memcmp);
>  EXPORT_SYMBOL(memmove);
>  EXPORT_SYMBOL(memchr);
> -EXPORT_SYMBOL(get_wchan);
>
>  /*
>   * libgcc functions - functions that are used internally by the
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
