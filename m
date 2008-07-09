Return-Path: <linux-kernel-owner+w=401wt.eu-S1754454AbYGIW6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbYGIW6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 18:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbYGIW6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 18:58:08 -0400
Received: from www.tglx.de ([62.245.132.106]:34171 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851AbYGIW6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 18:58:06 -0400
Date: Thu, 10 Jul 2008 00:57:57 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: =?utf-8?B?SGFucy1Kw4PFknJnZW4=?= Koch <hjk@linutronix.de>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH] uio_pdrv: fix memory leak and license specification.
Message-ID: <20080709225757.GB3232@local>
References: <DOR-SMS-MAIL1KqnjYT00000466@dor-sms-mail1.digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DOR-SMS-MAIL1KqnjYT00000466@dor-sms-mail1.digi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 08:13:23AM +0200, Uwe Kleine-König wrote:
> Thanks to Magnus Damm for pointing that out.

Yep, good catch.

Thanks,
Hans

> 
> Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>

Acked-by: Hans J. Koch <hjk@linutronix.de>

> ---
> Hi,
> 
> Greg, this bases on uio-add-generic-uio-platform-driver.patch that is
> already in your queue.
> 
> IMHO the best is to squash these two patches together.  Can you do that?
> 
> Best regards
> Uwe
> 
>  drivers/uio/uio_pdrv.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/uio/uio_pdrv.c b/drivers/uio/uio_pdrv.c
> index 5d0d2e8..0b4ef39 100644
> --- a/drivers/uio/uio_pdrv.c
> +++ b/drivers/uio/uio_pdrv.c
> @@ -88,6 +88,8 @@ static int uio_pdrv_remove(struct platform_device *pdev)
>  
>  	uio_unregister_device(pdata->uioinfo);
>  
> +	kfree(pdata);
> +
>  	return 0;
>  }
>  
> @@ -114,5 +116,5 @@ module_exit(uio_pdrv_exit);
>  
>  MODULE_AUTHOR("Uwe Kleine-Koenig");
>  MODULE_DESCRIPTION("Userspace I/O platform driver");
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_ALIAS("platform:" DRIVER_NAME);
> -- 
> 1.5.6
