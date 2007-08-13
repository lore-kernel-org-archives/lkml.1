Return-Path: <linux-kernel-owner+w=401wt.eu-S935528AbXHMIpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935528AbXHMIpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966687AbXHMGaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:30:19 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:49896 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966826AbXHMGaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:30:12 -0400
Date: Mon, 13 Aug 2007 09:30:08 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jdmason@kudzu.us, discuss@x86-64.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [118/2many] MAINTAINERS - CALGARY x86-64 IOMMU
Message-ID: <20070813063008.GA3645@rhun.haifa.ibm.com>
References: <46bff942.x4ZM/iFABMD4F1sR%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46bff942.x4ZM/iFABMD4F1sR%joe@perches.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 11:25:06PM -0700, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 482d255..9c26e7b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1148,6 +1148,11 @@ M:	jdmason@kudzu.us
>  L:	linux-kernel@vger.kernel.org
>  L:	discuss@x86-64.org
>  S:	Maintained
> +F:	arch/x86_64/kernel/pci-calgary.c
> +F:	arch/x86_64/kernel/pci-dma.c

pci-dma.c is generic x86-64 code maintained by Andi Kleen.

> +F:	arch/x86_64/kernel/tce.c
> +F:	include/asm-x86_6/calgary.h
> +F:	include/asm-x86_6/pci.h

Likewise pci.h.

You may also want to include 

F:	include/asm-x86_6/tce.h
F:	include/asm-x86_6/rio.h

Rest looks good:

Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>

Cheers,
Muli
