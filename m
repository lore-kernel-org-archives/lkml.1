Return-Path: <linux-kernel-owner+w=401wt.eu-S935461AbZLGRJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935461AbZLGRJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:09:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758120AbZLGRJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:09:08 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:45637 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757954AbZLGRJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:09:07 -0500
Message-ID: <4B1D3669.4020204@oracle.com>
Date: Mon, 07 Dec 2009 09:07:53 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: IIO: add selection of IIO_SW_RING to LIS3L02DQ
 as needed
References: <20091204203014.e8ee54ca.sfr@canb.auug.org.au> <20091206101225.7d8ce4a4.randy.dunlap@oracle.com> <4B1D1CF5.6030502@cam.ac.uk>
In-Reply-To: <4B1D1CF5.6030502@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B1D36AC.0103:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Cameron wrote:
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.


> ---
> 
>  Thanks to Randy for the report. Sorry for the slow response.
>  I've been meaning to carefully check for any remaining cases like
>  this.
>  Here I've kept the selection of IIO_SW_RING separate from
>  IIO_TRIGGER as it will go away fairly shortly when the ring buffer
>  type becomes configurable on a per device basis, whereas the
>  IIO_TRIGGER select will remain. Whether to retain the option to
>  remove the support for ring buffers entirely is one for after that
>  support is in place.
> 
>  Touch wood I think this is the last one, but I'll try a selection of
>  unusual combinations now and post others as replies to this email.
> 
>  drivers/staging/iio/accel/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/iio/accel/Kconfig b/drivers/staging/iio/accel/Kconfig
> index 4044663..3d3c333 100644
> --- a/drivers/staging/iio/accel/Kconfig
> +++ b/drivers/staging/iio/accel/Kconfig
> @@ -14,6 +14,7 @@ config LIS3L02DQ
>  	tristate "ST Microelectronics LIS3L02DQ Accelerometer Driver"
>  	depends on SPI
>  	select IIO_TRIGGER if IIO_RING_BUFFER
> +	select IIO_SW_RING if IIO_RING_BUFFER
>  	help
>  	  Say yes here to build SPI support for the ST microelectronics
>  	  accelerometer. The driver supplies direct access via sysfs files


-- 
~Randy
