Return-Path: <linux-kernel-owner+w=401wt.eu-S1759855AbXIVDQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855AbXIVDQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 23:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbXIVDQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 23:16:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:32930 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509AbXIVDQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 23:16:18 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] [11/45] x86_64: Remove rogue default m in drivers/video/Kconfig
Date: Fri, 21 Sep 2007 23:15:59 -0400
User-Agent: KMail/1.9.5
Cc: luming.yu@gmail.com, patches@x86-64.org, linux-kernel@vger.kernel.org
References: <200709211044.901175000@suse.de> <20070921204452.985B614F09@wotan.suse.de>
In-Reply-To: <20070921204452.985B614F09@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709212315.59594.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Len Brown <len.brown@intel.com>

Sorry, i thought we fixed this earlier.

thanks,
-Len

On Friday 21 September 2007 16:44, Andi Kleen wrote:
> 
> default m is near always wrong, like here. For some reason ACPI
> likes to reintroduce these and I like to immediately squash them again 
> before they pollute too many .configs.
> 
> Cc: len.brown@intel.com
> Cc: luming.yu@gmail.com
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  drivers/video/Kconfig |    1 -
>  1 file changed, 1 deletion(-)
> 
> Index: linux/drivers/video/Kconfig
> ===================================================================
> --- linux.orig/drivers/video/Kconfig
> +++ linux/drivers/video/Kconfig
> @@ -14,7 +14,6 @@ config VGASTATE
>  
>  config VIDEO_OUTPUT_CONTROL
>  	tristate "Lowlevel video output switch controls"
> -	default m
>  	help
>  	  This framework adds support for low-level control of the video 
>  	  output switch.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
