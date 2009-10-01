Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbZJAJic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbZJAJic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 05:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756015AbZJAJib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 05:38:31 -0400
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:44169 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011AbZJAJib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 05:38:31 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4AC478B2.5020707@cam.ac.uk>
Date: Thu, 01 Oct 2009 10:38:58 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.22 (X11/20090803)
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 33/34] move lis3l02dq_remove to .devexit.text
References: <20091001082607.GA2181@pengutronix.de> <1254385718-14254-33-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1254385718-14254-33-git-send-email-u.kleine-koenig@pengutronix.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Uwe

Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> The function lis3l02dq_remove is used only wrapped by __devexit_p so
> define it using __devexit.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Jonathan Cameron <jic23@cam.ac.uk>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/staging/iio/accel/lis3l02dq_core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/iio/accel/lis3l02dq_core.c b/drivers/staging/iio/accel/lis3l02dq_core.c
> index f008837..80e89a6 100644
> --- a/drivers/staging/iio/accel/lis3l02dq_core.c
> +++ b/drivers/staging/iio/accel/lis3l02dq_core.c
> @@ -871,7 +871,7 @@ err_ret:
>  }
>  
>  /* fixme, confirm ordering in this function */
> -static int lis3l02dq_remove(struct spi_device *spi)
> +static int __devexit lis3l02dq_remove(struct spi_device *spi)
>  {
>  	int ret;
>  	struct lis3l02dq_state *st = spi_get_drvdata(spi);

