Return-Path: <linux-kernel-owner+w=401wt.eu-S933149AbXJSSQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149AbXJSSQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 14:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761739AbXJSSQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 14:16:07 -0400
Received: from www.tglx.de ([62.245.132.106]:42730 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759548AbXJSSQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 14:16:05 -0400
Date: Fri, 19 Oct 2007 20:15:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Carlos Corbacho <cathectic@slackadelic.com>
cc: linux-kernel@vger.kernel.org, Mikko Tiihonen <mikko.tiihonen@iki.fi>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] x86: Fix resume for nVidia and force_hpet
In-Reply-To: <200710191907.43789.cathectic@slackadelic.com>
Message-ID: <alpine.LFD.0.9999.0710192014070.22770@localhost.localdomain>
References: <200710190423.31714.cathectic@slackadelic.com> <200710191851.28639.cathectic@slackadelic.com> <alpine.LFD.0.9999.0710191957420.22770@localhost.localdomain> <200710191907.43789.cathectic@slackadelic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007, Carlos Corbacho wrote:

> From: Carlos Corbacho <cathectic@gmail.com>
> 
> Actually set force_hpet_resume_type.
> ---
> Whoops, just noticed I forgot to re-add this to the patch before submitting it.
> 
>  arch/x86/kernel/quirks.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
> index cb21bcb..df01a1e 100644
> --- a/arch/x86/kernel/quirks.c
> +++ b/arch/x86/kernel/quirks.c
> @@ -344,6 +344,7 @@ static void nvidia_force_enable_hpet(struct pci_dev *dev)
>  	printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
>  		force_hpet_address);
>  	cached_dev = dev;
> +	force_hpet_resume_type = NVIDIA_FORCE_HPET_RESUME;
>  	return;
>  }

Yep, noticed it when I pushed it into the queue. Fixed it up
already. Please be more careful next time.

Btw, I'm happy to take a follow up patch for platforms which you can
not test and stick them into -mm for a while.

Thanks,

	 tglx
