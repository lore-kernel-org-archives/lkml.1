Return-Path: <linux-kernel-owner+w=401wt.eu-S1761043AbXFDVKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761043AbXFDVKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 17:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbXFDVJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 17:09:54 -0400
Received: from havoc.gtf.org ([69.61.125.42]:37494 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbXFDVJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 17:09:53 -0400
Date: Mon, 4 Jun 2007 17:09:52 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, davem@davemloft.net
Subject: Re: [ATA]: Don't allow to enable this for SPARC64 without PCI.
Message-ID: <20070604210952.GI20299@havoc.gtf.org>
References: <200706042059.l54Kx6jR031700@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706042059.l54Kx6jR031700@hera.kernel.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 08:59:06PM +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=899b69d079713d0f568fb2700b86987aa94f29b2
> Commit:     899b69d079713d0f568fb2700b86987aa94f29b2
> Parent:     e11a6c236b3070ed05b079f91a9b3defa48b54d3
> Author:     David S. Miller <davem@sunset.davemloft.net>
> AuthorDate: Sun Jun 3 17:39:56 2007 -0700
> Committer:  David S. Miller <davem@sunset.davemloft.net>
> CommitDate: Sun Jun 3 18:09:42 2007 -0700
> 
>     [ATA]: Don't allow to enable this for SPARC64 without PCI.
>     
>     Based upon a report from Meelis Roos.
>     
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  drivers/ata/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index b4a8d60..7d893a6 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -8,6 +8,7 @@ menuconfig ATA
>  	depends on BLOCK
>  	depends on !(M32R || M68K) || BROKEN
>  	depends on !SUN4 || BROKEN
> +	depends on !(SPARC64 && !PCI)
>  	select SCSI

Um, this was NAK'd:

libata uses generic DMA and generic struct device.  Neither of which
are specific to SPARC64 or PCI.

Did you read the code?
Did you read the thread on which you were CC'd?
Did you see the NAKs from me and Alan (and others)?

	Jeff



