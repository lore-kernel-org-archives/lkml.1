Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbXGCAgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbXGCAgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 20:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbXGCAfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 20:35:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:36125 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456AbXGCAfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 20:35:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,489,1175497200"; 
   d="scan'208";a="261530148"
Date: Mon, 2 Jul 2007 17:30:57 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [-mm patch] fix duplicate CONFIG_DMAR Makefile line
Message-ID: <20070703003057.GA19939@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org> <20070701202243.GQ10869@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070701202243.GQ10869@stusta.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2007 at 10:22:43PM +0200, Adrian Bunk wrote:
> On Thu, Jun 28, 2007 at 03:43:21AM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.22-rc4-mm2:
> >...
> > +intel-iommu-intel-iommu-driver.patch
> >...
> >  Intel IOMMU support
> >...
> 
> 
> Contrary to popular belief, two identical Makefile lines don't bring any 
> advantages.   ;-)
:). Thanks for the fix.

> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>

> 
> ---
> --- linux-2.6.22-rc6-mm1/drivers/pci/Makefile.old	2007-06-30 03:33:54.000000000 +0200
> +++ linux-2.6.22-rc6-mm1/drivers/pci/Makefile	2007-06-30 03:34:04.000000000 +0200
> @@ -23,9 +23,6 @@
>  # Build Intel IOMMU support
>  obj-$(CONFIG_DMAR) += dmar.o iova.o intel-iommu.o
>  
> -#Build Intel-IOMMU support
> -obj-$(CONFIG_DMAR) += iova.o dmar.o intel-iommu.o
> -
>  #
>  # Some architectures use the generic PCI setup functions
>  #
