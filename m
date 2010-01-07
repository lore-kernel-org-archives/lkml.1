Return-Path: <linux-kernel-owner+w=401wt.eu-S932699Ab0AGCQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab0AGCQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 21:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932287Ab0AGCQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 21:16:38 -0500
Received: from exprod6og101.obsmtp.com ([64.18.1.181]:54784 "HELO
	exprod6og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932266Ab0AGCQh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 21:16:37 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] mtd/nand: Fix build failure caused by typo
Date: Wed, 6 Jan 2010 21:16:35 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909020894AF@mi8nycmail19.Mi8.com>
In-Reply-To: <201001070301.58260.PeterHuewe@gmx.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] mtd/nand: Fix build failure caused by typo
Thread-Index: AcqPPWhDBCQDac+oTyu+SHGruka51AAAahCw
References: <201001070301.58260.PeterHuewe@gmx.de>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: =?iso-8859-1?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>,
       "David Woodhouse" <dwmw2@infradead.org>
Cc: "Nicolas Pitre" <nico@marvell.com>,
       =?iso-8859-1?Q?Uwe__Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 07 Jan 2010 02:16:35.0739 (UTC) FILETIME=[6FF306B0:01CA8F3F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 06, 2010 7:02 PM, Peter Hüwe wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> Date: Thu, 7 Jan 2010 02:51:13 +0100
> 
> This patch fixes a build failure[1] introduced by the patch
>     mtd: orion_nand.c: add error handling and use resource_size()
>     by H Hartley Sweeten [2]
> The patch assigns something to a undeclared variable 'err', whereas the
> rest of the code uses 'ret' for this task.
> 
> This patch fixes this typo and thus removes the build failure.
> 
> References:
> [1] http://kisskb.ellerman.id.au/kisskb/buildresult/1983354/
> [2] http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commitdiff;h=e99030609e27abff7e1a868cb56384c678b09984
> 
> Patch against linux-next of Do 7. Jan 02:58:41 CET 2010
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>  drivers/mtd/nand/orion_nand.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mtd/nand/orion_nand.c b/drivers/mtd/nand/orion_nand.c
> index 9903460..f16050c 100644
> --- a/drivers/mtd/nand/orion_nand.c
> +++ b/drivers/mtd/nand/orion_nand.c
> @@ -92,7 +92,7 @@ static int __init orion_nand_probe(struct platform_device *pdev)
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!res) {
> -		err = -ENODEV;
> +		ret = -ENODEV;
>  		goto no_res;
>  	}

Sorry about that.

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>
