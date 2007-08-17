Return-Path: <linux-kernel-owner+w=401wt.eu-S1761883AbXHQAsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761883AbXHQAsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 20:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbXHQAsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 20:48:37 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:55362 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751326AbXHQAsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 20:48:36 -0400
Date: Fri, 17 Aug 2007 02:48:19 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Shannon Nelson <shannon.nelson@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       dan.j.williams@intel.com, ssatyam@cse.iitk.ac.in
Subject: Re: [-mm PATCH] DMA engine kconfig improvements (rev2)
Message-ID: <20070817004819.GB3786@stusta.de>
References: <20070817001025.5634.54557.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070817001025.5634.54557.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 05:10:25PM -0700, Shannon Nelson wrote:
> From: Adrian Bunk <bunk@stusta.de>
> 
> This patch contains the following changes to the DMA engine menus:
>...
> - make it clear in the INTEL_IOATDMA help text that this driver is for
>   rare hardware the user most likely doesn't has
>...
> +config INTEL_IOATDMA
> +	tristate "Intel I/OAT DMA support"
> +	depends on PCI && X86
> +	select DMA_ENGINE
> +	select DCA
> +	help
> +	  Enable support for the Intel(R) I/OAT DMA engine present
> +	  in recent chipsets.
>...

It seems the string "Xeon" somehow got lost, or is it now also 
available with other hardware?

"in recent Intel Xeon chipsets"?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

