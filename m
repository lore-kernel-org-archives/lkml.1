Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbZKQQGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbZKQQGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 11:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbZKQQGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 11:06:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38761 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751065AbZKQQGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 11:06:13 -0500
Date: Tue, 17 Nov 2009 16:06:17 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH] wm831x-backup: Remove unused variables
Message-ID: <20091117160616.GA21302@rakim.wolfsonmicro.main>
References: <20091117154449.3801.43579.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117154449.3801.43579.stgit@localhost.localdomain>
X-Cookie: Sentient plasmoids are a gas.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 03:44:54PM +0000, Alan Cox wrote:
> Signed-off-by: Alan Cox <alan@linux.intel.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Adding Anton since this is one for his tree.

> ---
> 
>  drivers/power/wm831x_backup.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/drivers/power/wm831x_backup.c b/drivers/power/wm831x_backup.c
> index f181076..bf4f387 100644
> --- a/drivers/power/wm831x_backup.c
> +++ b/drivers/power/wm831x_backup.c
> @@ -164,7 +164,7 @@ static __devinit int wm831x_backup_probe(struct platform_device *pdev)
>  	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
>  	struct wm831x_backup *devdata;
>  	struct power_supply *backup;
> -	int ret, irq, i;
> +	int ret;
>  
>  	devdata = kzalloc(sizeof(struct wm831x_backup), GFP_KERNEL);
>  	if (devdata == NULL)
> 
