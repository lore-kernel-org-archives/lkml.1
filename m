Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbZJAJjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbZJAJjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 05:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756016AbZJAJjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 05:39:16 -0400
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:44874 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021AbZJAJjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 05:39:15 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4AC478E2.20202@cam.ac.uk>
Date: Thu, 01 Oct 2009 10:39:46 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.22 (X11/20090803)
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 34/34] move sca3000_remove to .devexit.text
References: <20091001082607.GA2181@pengutronix.de> <1254385718-14254-34-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1254385718-14254-34-git-send-email-u.kleine-koenig@pengutronix.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe, 

Thanks,

Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> The function sca3000_remove is used only wrapped by __devexit_p so define
> it using __devexit.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Jonathan Cameron <jic23@cam.ac.uk>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/staging/iio/accel/sca3000_core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/iio/accel/sca3000_core.c b/drivers/staging/iio/accel/sca3000_core.c
> index e27e3b7..5ea736a 100644
> --- a/drivers/staging/iio/accel/sca3000_core.c
> +++ b/drivers/staging/iio/accel/sca3000_core.c
> @@ -1393,7 +1393,7 @@ error_ret:
>  
>  }
>  
> -static int sca3000_remove(struct spi_device *spi)
> +static int __devexit sca3000_remove(struct spi_device *spi)
>  {
>  	struct sca3000_state *st =  spi_get_drvdata(spi);
>  	struct iio_dev *indio_dev = st->indio_dev;

