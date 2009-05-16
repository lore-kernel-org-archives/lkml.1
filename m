Return-Path: <linux-kernel-owner+w=401wt.eu-S1757155AbZEPKCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155AbZEPKCq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 06:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbZEPKCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 06:02:38 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:6109 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098AbZEPKCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 06:02:37 -0400
Date: Sat, 16 May 2009 12:02:29 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] hwmon: (lm78) add missing __devexit_p()
Message-ID: <20090516120229.4bc622b7@hyperion.delvare>
In-Reply-To: <1242413423-26654-1-git-send-email-vapier@gentoo.org>
References: <1242413423-26654-1-git-send-email-vapier@gentoo.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Fri, 15 May 2009 14:50:23 -0400, Mike Frysinger wrote:
> The remove function uses __devexit, so the .remove assignment needs
> __devexit_p() to fix a build error with hotplug disabled.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> CC: Jean Delvare <khali@linux-fr.org>
> ---
>  drivers/hwmon/lm78.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hwmon/lm78.c b/drivers/hwmon/lm78.c
> index b5e3b28..a1787fd 100644
> --- a/drivers/hwmon/lm78.c
> +++ b/drivers/hwmon/lm78.c
> @@ -182,7 +182,7 @@ static struct platform_driver lm78_isa_driver = {
>  		.name	= "lm78",
>  	},
>  	.probe		= lm78_isa_probe,
> -	.remove		= lm78_isa_remove,
> +	.remove		= __devexit_p(lm78_isa_remove),
>  };
>  
>  

Good catch. Applied, thanks!

-- 
Jean Delvare
