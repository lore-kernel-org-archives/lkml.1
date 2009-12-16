Return-Path: <linux-kernel-owner+w=401wt.eu-S1763156AbZLPTZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763156AbZLPTZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 14:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762876AbZLPTZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 14:25:18 -0500
Received: from kroah.org ([198.145.64.141]:46136 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761062AbZLPTZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 14:25:15 -0500
Date: Wed, 16 Dec 2009 11:19:38 -0800
From: Greg KH <greg@kroah.com>
To: Keng-Yu Lin <keng-yu.lin@canonical.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [stable] [2.6.31.stable] Input: atkbd - add force relese key
 quirk for Samsung R59P/R60P/R61P
Message-ID: <20091216191938.GB16321@kroah.com>
References: <1260178014-16741-1-git-send-email-keng-yu.lin@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260178014-16741-1-git-send-email-keng-yu.lin@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't see the git commit id for the patch below, which is needed if it
is to be accepted into the -stable kernel tree.

Do you have it?

thanks,

greg k-h

On Mon, Dec 07, 2009 at 05:26:54PM +0800, Keng-Yu Lin wrote:
> OriginalAuthor:
>     Moiseev Vladimir <cdb@linkycat.com>
>     Alexander Huhlaev <sancheolz@gmail.com>
> 
> BugLink: http://bugs.launchpad.net/bugs/253874
> 
> Signed-off-by: Keng-Yu Lin <keng-yu.lin@canonical.com>
> ---
>  drivers/input/keyboard/atkbd.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
> index 6c6a09b..abc314f 100644
> --- a/drivers/input/keyboard/atkbd.c
> +++ b/drivers/input/keyboard/atkbd.c
> @@ -1608,6 +1608,15 @@ static struct dmi_system_id atkbd_dmi_quirk_table[] __initdata = {
>  		.driver_data = atkbd_samsung_forced_release_keys,
>  	},
>  	{
> +		.ident = "Samsung R59P/R60P/R61P",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "R59P/R60P/R61P"),
> +		},
> +		.callback = atkbd_setup_forced_release,
> +		.driver_data = atkbd_samsung_forced_release_keys,
> +	},
> +	{
>  		.ident = "Fujitsu Amilo PA 1510",
>  		.matches = {
>  			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
> -- 
> 1.6.3.3
> 
> _______________________________________________
> stable mailing list
> stable@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable
