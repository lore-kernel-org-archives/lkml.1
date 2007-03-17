Return-Path: <linux-kernel-owner+w=401wt.eu-S1752184AbXCQGqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbXCQGqu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 02:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbXCQGqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 02:46:50 -0400
Received: from 1wt.eu ([62.212.114.60]:1215 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbXCQGqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 02:46:49 -0400
Date: Sat, 17 Mar 2007 07:46:37 +0100
From: Willy Tarreau <w@1wt.eu>
To: "Korolev, Alexey" <alexey.korolev@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Linux 2.4.x MTD CFI P30/P33 support
Message-ID: <20070317064637.GA14739@1wt.eu>
References: <523F3D8D8C97554AA47E53DF1A05466A666249@nnsmsx411.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523F3D8D8C97554AA47E53DF1A05466A666249@nnsmsx411.ccr.corp.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

On Sat, Mar 17, 2007 at 02:45:13AM +0300, Korolev, Alexey wrote:
> Hello Willy,
> 
> The following patch adds support of P30 and P33 NOR FLASH support in
> Linux 2.4
> This flash is substitution of J3 flash which is widely used it on Linux
> 2.4 kernels. Currently many customers wishing to substitute J3 for P3x
> face issues on Linux 2.4. This patch resolves issues with P3x on all
> generic Linux kernels versions since 2.4.21.
> 
> The patch just allows using minor version "4" in CFI driver. Since
> differences between CFI minor version "3" and minor version "4" are
> small the CFI driver is not affected by this. Patch has been verified on
> Mainstone (PXA27x based) platform.

OK, it seems trivial enough to me. I have no problem merging this. Your
mailer has wrapped lines, but I'll fix this by hand.

David, are you OK too ?

Thanks,
Willy

> Signed-off-by: Alexey Korolev <alexey.korolev@intel.com>
> ==================================================
> --- a/drivers/mtd/chips/cfi_cmdset_0001.c	2003-06-13
> 18:51:34.000000000 +0400
> +++ b/drivers/mtd/chips/cfi_cmdset_0001.c	2007-02-16
> 21:39:50.000000000 +0300
> @@ -152,7 +152,7 @@
>  		}
>  		
>  		if (extp->MajorVersion != '1' || 
> -		    (extp->MinorVersion < '0' || extp->MinorVersion >
> '3')) {
> +		    (extp->MinorVersion < '0' || extp->MinorVersion >
> '4')) {
>  			printk(KERN_WARNING "  Unknown IntelExt Extended
> Query "
>  			       "version %c.%c.\n",  extp->MajorVersion,
>  			       extp->MinorVersion);
> ===================================================
> 
> Thanks,
> Alexey
