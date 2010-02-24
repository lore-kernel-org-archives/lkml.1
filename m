Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab0BXOAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 09:00:51 -0500
Received: from kroah.org ([198.145.64.141]:57742 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757163Ab0BXOAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 09:00:40 -0500
Date: Wed, 24 Feb 2010 06:00:06 -0800
From: Greg KH <greg@kroah.com>
To: Tom Van Braeckel <tomvanbraeckel@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Staging: samsung-laptop: fix coding style
Message-ID: <20100224140006.GA22446@kroah.com>
References: <1266325775-30119-1-git-send-email-tomvanbraeckel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266325775-30119-1-git-send-email-tomvanbraeckel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 02:09:35PM +0100, Tom Van Braeckel wrote:
> 
> Signed-off-by: Tom Van Braeckel <tomvanbraeckel@gmail.com>
> ---
>  drivers/staging/samsung-laptop/samsung-laptop.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/samsung-laptop/samsung-laptop.c b/drivers/staging/samsung-laptop/samsung-laptop.c
> index 4877138..dd7ea4c 100644
> --- a/drivers/staging/samsung-laptop/samsung-laptop.c
> +++ b/drivers/staging/samsung-laptop/samsung-laptop.c
> @@ -99,7 +99,8 @@ static struct rfkill *rfk;
>  
>  static int force;
>  module_param(force, bool, 0);
> -MODULE_PARM_DESC(force, "Disable the DMI check and forces the driver to be loaded");
> +MODULE_PARM_DESC(force,
> +		"Disable the DMI check and forces the driver to be loaded");

Sorry, someone sent this same fix to me a week ago and it's in the
linux-next tree now.

You might want to work off of that tree to prevent this type of
duplication.

thanks,

greg k-h
