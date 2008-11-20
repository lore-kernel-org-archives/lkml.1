Return-Path: <linux-kernel-owner+w=401wt.eu-S1757840AbYKTUxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840AbYKTUxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756796AbYKTUvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:51:42 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:22354 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756564AbYKTUvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:51:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wIJSe2ocS/t8rW5xXsL5+8liVxVquwvGAQ1nQP3aMDJR9nx7P7dQms0m+lSyx9r5BggeJ6Ql/Nwa2VPfK4WI7Ytn7IDokdrfFJ1gKP+cccdw0AqOr6kbIMZhs9ib7jS24TY8XDI8TvomRL/ozN/JWGQgXh4Rmoy4C0uW3UKqSDE=  ;
X-YMail-OSG: Rk3Crr4VM1lM7M1vWSv3xfnKNeD7WcgdZGyJmqwy_nE5FaKABcjn9rUcC2FQ4OkgzXtSL.cciSjAWaTmjEcq.yMc3Kih5Nurf57NO_rn5GahoW7VBibRY7v1.5LZODO__dcFTrZYxI5NFa8J4rTCvvPX
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH 07/16] Blackfin SPI Driver: drop bogus cast and touchup dma label
Date: Thu, 20 Nov 2008 12:34:02 -0800
User-Agent: KMail/1.9.10
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org> <1226994760-4301-8-git-send-email-cooloney@kernel.org>
In-Reply-To: <1226994760-4301-8-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811201234.02701.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2008, Bryan Wu wrote:
> From: Mike Frysinger <vapier.adi@gmail.com>
> 
> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

... again, please to include real patch comments
not just long $SUBJECT lines

> ---
>  drivers/spi/spi_bfin5xx.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
> index df424a2..a7c8976 100644
> --- a/drivers/spi/spi_bfin5xx.c
> +++ b/drivers/spi/spi_bfin5xx.c
> @@ -1076,13 +1076,13 @@ static int setup(struct spi_device *spi)
>  	 */
>  	if (chip->enable_dma && !drv_data->dma_requested) {
>  		/* register dma irq handler */
> -		if (request_dma(drv_data->dma_channel, "BF53x_SPI_DMA") < 0) {
> +		if (request_dma(drv_data->dma_channel, "BFIN_SPI_DMA") < 0) {
>  			dev_dbg(&spi->dev,
>  				"Unable to request BlackFin SPI DMA channel\n");
>  			return -ENODEV;
>  		}
>  		if (set_dma_callback(drv_data->dma_channel,
> -			(void *)dma_irq_handler, drv_data) < 0) {
> +		    dma_irq_handler, drv_data) < 0) {
>  			dev_dbg(&spi->dev, "Unable to set dma callback\n");
>  			return -EPERM;
>  		}
> -- 
> 1.5.6.3
> 
> 


