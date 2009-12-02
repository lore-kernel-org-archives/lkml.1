Return-Path: <linux-kernel-owner+w=401wt.eu-S1755501AbZLBTfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbZLBTfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 14:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbZLBTff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 14:35:35 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59800 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbZLBTfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 14:35:34 -0500
Subject: Re: [PATCH 2.6.32] regulator: Initialise wm831x structure pointor
 for ISINK driver
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1259589716-14007-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1259589716-14007-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Dec 2009 19:35:32 +0000
Message-ID: <1259782532.3588.192.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 14:01 +0000, Mark Brown wrote:
> The version that made it into mainline missed the initialisation of the
> chip handle.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/wm831x-isink.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/regulator/wm831x-isink.c b/drivers/regulator/wm831x-isink.c
> index 1d8d987..4885700 100644
> --- a/drivers/regulator/wm831x-isink.c
> +++ b/drivers/regulator/wm831x-isink.c
> @@ -167,6 +167,8 @@ static __devinit int wm831x_isink_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
>  
> +	isink->wm831x = wm831x;
> +
>  	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
>  	if (res == NULL) {
>  		dev_err(&pdev->dev, "No I/O resource\n");

Applied.

Thanks

Liam

