Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbYFEIyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbYFEIyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 04:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbYFEIyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 04:54:46 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:26481 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbYFEIyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 04:54:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HOpX3Z84y//Hsf2ISKZaIYwjQgBaK9wScvs48NUJt4ysbPXwMg5EctXYgqd+zf+eku
         RiCp23A2z6/gTkHfS1cyVVyqUsvQMAWVLEVqUwlAIBHfWA3Hxb8sW+O1R3nZrAVg/9NA
         ZZmNHtSN4hU5inTwIbo1vkiZSuxR7Xwi8jN/c=
Message-ID: <f17812d70806050154u90fe08cu5ac1e29dbb2ae4d4@mail.gmail.com>
Date: Thu, 5 Jun 2008 16:54:44 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@pengutronix.de>
Subject: Re: [PATCH] spi: fix list scan success verification in PXA ssp driver
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       "eric miao" <eric.miao@marvell.com>,
       spi-devel-general@lists.sourceforge.net,
       "ARM Linux" <linux-arm-kernel@lists.arm.linux.org.uk>
In-Reply-To: <Pine.LNX.4.64.0806051027340.6598@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0806051027340.6598@axis700.grange>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Eric Miao <eric.miao@marvell.com>

And this should really go through the ARM tree, please submit the
patch to RMK's patch system. Thanks.

(I have to send this again through my gmail account, please ignore the
other copy if any,
sorry for this)

On Thu, Jun 5, 2008 at 4:37 PM, Guennadi Liakhovetski
<g.liakhovetski@pengutronix.de> wrote:
> The list search success check in arch/arm/mach-pxa/ssp.c is wrong: for
> example, it didn't recognise failure for me when I requested port 0.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
>
> ---
>
>  arch/arm/mach-pxa/ssp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux-2.6/arch/arm/mach-pxa/ssp.c
> ===================================================================
> --- linux-2.6.orig/arch/arm/mach-pxa/ssp.c      2008-06-04 12:11:26.000000000 +0200
> +++ linux-2.6/arch/arm/mach-pxa/ssp.c   2008-06-04 12:11:50.000000000 +0200
> @@ -330,7 +330,7 @@
>
>        mutex_unlock(&ssp_lock);
>
> -       if (ssp->port_id != port)
> +       if (&ssp->node == &ssp_list)
>                return NULL;
>
>        return ssp;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Cheers
- eric
