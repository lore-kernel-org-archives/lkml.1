Return-Path: <linux-kernel-owner+w=401wt.eu-S1761444AbXHQQlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761444AbXHQQlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 12:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbXHQQk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 12:40:57 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:37487 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751195AbXHQQk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 12:40:57 -0400
Date: Fri, 17 Aug 2007 18:40:34 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Nelson, Shannon" <shannon.nelson@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Williams, Dan J" <dan.j.williams@intel.com>, ssatyam@cse.iitk.ac.in
Subject: Re: [-mm PATCH] DMA engine kconfig improvements (rev2)
Message-ID: <20070817164033.GA32595@stusta.de>
References: <20070817001025.5634.54557.stgit@localhost.localdomain> <20070817004819.GB3786@stusta.de> <BAE9DCEF64577A439B3A37F36F9B691C02E18CCD@orsmsx418.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BAE9DCEF64577A439B3A37F36F9B691C02E18CCD@orsmsx418.amr.corp.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2007 at 08:59:29AM -0700, Nelson, Shannon wrote:
> >From: Adrian Bunk [mailto:bunk@kernel.org] 
> >Sent: Thursday, August 16, 2007 5:48 PM
> >To: Nelson, Shannon
> >Cc: akpm@linux-foundation.org; linux-kernel@vger.kernel.org; 
> >Williams, Dan J; ssatyam@cse.iitk.ac.in
> >Subject: Re: [-mm PATCH] DMA engine kconfig improvements (rev2)
> >
> >On Thu, Aug 16, 2007 at 05:10:25PM -0700, Shannon Nelson wrote:
> >> From: Adrian Bunk <bunk@stusta.de>
> >> 
> >> This patch contains the following changes to the DMA engine menus:
> >>...
> >> - make it clear in the INTEL_IOATDMA help text that this 
> >driver is for
> >>   rare hardware the user most likely doesn't has
> >>...
> >> +config INTEL_IOATDMA
> >> +	tristate "Intel I/OAT DMA support"
> >> +	depends on PCI && X86
> >> +	select DMA_ENGINE
> >> +	select DCA
> >> +	help
> >> +	  Enable support for the Intel(R) I/OAT DMA engine present
> >> +	  in recent chipsets.
> >>...
> >
> >It seems the string "Xeon" somehow got lost, or is it now also 
> >available with other hardware?
> >
> >"in recent Intel Xeon chipsets"?
> >
> >cu
> >Adrian
> 
> Good catch - however, it is probably best not to limit these things.

Since the effects of CONFIG_NET_DMA are considered big enough to warrant 
all these #ifdef's in the net code it should be made clear for the user 
that this is only for hardware he most likely doesn't has.

And it's not about any kind of kconfig dependency, it's simply about the 
help text.

> sln

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

