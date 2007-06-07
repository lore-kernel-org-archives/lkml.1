Return-Path: <linux-kernel-owner+w=401wt.eu-S937735AbXFGX7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937735AbXFGX7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 19:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936291AbXFGX67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 19:58:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59445 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762685AbXFGX66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 19:58:58 -0400
Date: Thu, 7 Jun 2007 16:58:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: anil.s.keshavamurthy@intel.com
Cc: linux-kernel@vger.kernel.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 07/10] Intel iommu cmdline option - forcedac
Message-Id: <20070607165839.acf76694.akpm@linux-foundation.org>
In-Reply-To: <20070606190042.930671000@askeshav-devel.jf.intel.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com>
	<20070606190042.930671000@askeshav-devel.jf.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2007 11:57:05 -0700
anil.s.keshavamurthy@intel.com wrote:

> --- linux-2.6.22-rc3.orig/Documentation/kernel-parameters.txt	2007-06-04 12:40:29.000000000 -0700
> +++ linux-2.6.22-rc3/Documentation/kernel-parameters.txt	2007-06-04 12:40:41.000000000 -0700
> @@ -785,6 +785,13 @@
>  			bypassed by not enabling DMAR with this option. In
>  			this case, gfx device will use physical address for
>  			DMA.
> +		forcedac

You want
		forcedac [X86-64]

> +			With this option iommu will not optimize to look
> +			for io virtual address below 32 bit forcing dual
> +			address cycle on pci bus for cards supporting greater
> +			than 32 bit addressing. The default is to look
> +			for translation below 32 bit and if not available
> +			then look in the higher range.

