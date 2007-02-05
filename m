Return-Path: <linux-kernel-owner+w=401wt.eu-S933214AbXBEURO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214AbXBEURO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 15:17:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933231AbXBEURO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 15:17:14 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:52949 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933187AbXBEURN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 15:17:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=I0q4TvZSZ9ZGosghkLNAMg03Gxt1N2fCInnSnkvk0qch4++vtwx0nrqoikFMdKBe90aJ8StwfA0FYlb3/xeTqv9qO5fjujZLUhhVq2/fXwHOZTLoHk/KUVavCnkxWiUguTwSCgw5XK/QE6OrCQbyTx+32OoMMv772ulYl0PXaGY=
Date: Mon, 5 Feb 2007 23:17:09 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: jt@hpl.hp.com, linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.20] wavelan: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070205201709.GB11055@martell.zuzino.mipt.ru>
References: <20070205165429.GD3896@Ahmed> <20070205170044.GM3896@Ahmed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205170044.GM3896@Ahmed>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 07:00:44PM +0200, Ahmed S. Darwish wrote:
> A trivial patch to use ARRAY_SIZE macro.

You're supposed to remove it ans use ARRAY_SIZE where old macro is used.

> --- a/drivers/net/wireless/wavelan.p.h
> +++ b/drivers/net/wireless/wavelan.p.h
> @@ -450,7 +450,7 @@ static const char	*version	= "wavelan.c : v24 (SMP + wireless extensions) 11/12/
>  #define	WATCHDOG_JIFFIES	(512*HZ/100)
>
>  /* Macro to get the number of elements in an array */
> -#define	NELS(a)				(sizeof(a) / sizeof(a[0]))
> +#define	NELS(a)				ARRAY_SIZE(a)

