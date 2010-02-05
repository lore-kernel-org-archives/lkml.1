Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933615Ab0BERW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 12:22:56 -0500
Received: from cantor.suse.de ([195.135.220.2]:32898 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932282Ab0BERWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 12:22:52 -0500
Date: Fri, 5 Feb 2010 09:14:43 -0800
From: Greg KH <gregkh@suse.de>
To: Chihau Chau <chihau@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: samsung-laptop: fix coding style issues
Message-ID: <20100205171443.GE14145@suse.de>
References: <1265346708-9633-1-git-send-email-chihau@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265346708-9633-1-git-send-email-chihau@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05, 2010 at 02:11:48AM -0300, Chihau Chau wrote:
> From: Chihau Chau <chihau@gmail.com>
> 
> This fixes some lines over 80 characters coding style issues
> 
> Signed-off-by: Chihau Chau <chihau@gmail.com>
> ---
>  drivers/staging/samsung-laptop/samsung-laptop.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/samsung-laptop/samsung-laptop.c b/drivers/staging/samsung-laptop/samsung-laptop.c
> index 4877138..87ec773 100644
> --- a/drivers/staging/samsung-laptop/samsung-laptop.c
> +++ b/drivers/staging/samsung-laptop/samsung-laptop.c
> @@ -99,7 +99,8 @@ static struct rfkill *rfk;
>  
>  static int force;
>  module_param(force, bool, 0);
> -MODULE_PARM_DESC(force, "Disable the DMI check and forces the driver to be loaded");
> +MODULE_PARM_DESC(force, "Disable the DMI check and forces the driver to be "
> +								"loaded");

Um, care to move the whole string down one line to make it nicer to look
at?

>  static int debug;
>  module_param(debug, bool, S_IRUGO | S_IWUSR);
> @@ -370,7 +371,8 @@ static struct dmi_system_id __initdata samsung_dmi_table[] = {
>  	{
>  		.ident = "N128",
>  		.matches = {
> -			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
> +			DMI_MATCH(DMI_SYS_VENDOR,
> +					"SAMSUNG ELECTRONICS CO., LTD."),

Like this, what you did here was fine, can you do this above as well and
resubmit the whole thing to me so I can apply it?

thanks,

greg k-h
