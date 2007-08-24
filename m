Return-Path: <linux-kernel-owner+w=401wt.eu-S1756268AbXHXFja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbXHXFja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 01:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbXHXFjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 01:39:22 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:56074 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbXHXFjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 01:39:21 -0400
Date: Thu, 23 Aug 2007 22:38:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Shannon Nelson <shannon.nelson@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Subject: Re: [PATCH v2 -mm 3/7] I/OAT: code cleanup from checkpatch output
Message-Id: <20070823223833.65fba17e.randy.dunlap@oracle.com>
In-Reply-To: <20070824001506.16997.43452.stgit@localhost.localdomain>
References: <20070824001335.16997.79665.stgit@localhost.localdomain>
	<20070824001506.16997.43452.stgit@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007 17:15:06 -0700 Shannon Nelson wrote:

> Take care of a bunch of little code nits in ioatdma files
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
> Acked-by: David S. Miller <davem@davemloft.net>
> ---
> 
>  drivers/dma/ioat_dma.c |  200 +++++++++++++++++++++++++++---------------------
>  1 files changed, 111 insertions(+), 89 deletions(-)
> 
> diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
> index 55227d4..9a4d154 100644
> --- a/drivers/dma/ioat_dma.c
> +++ b/drivers/dma/ioat_dma.c

> -	printk(KERN_INFO "Intel(R) I/OAT DMA Engine found, %d channels\n",
> -		device->common.chancnt);
> +	printk(KERN_INFO " "
> +		 "ioatdma: Intel(R) I/OAT DMA Engine found, %d channels\n",
> +		 device->common.chancnt);
>  
>  	err = ioat_self_test(device);
>  	if (err)

> @@ -764,7 +784,8 @@ err_set_dma_mask:
>  	pci_disable_device(pdev);
>  err_enable_device:
>  
> -	printk(KERN_ERR "Intel(R) I/OAT DMA Engine initialization failed\n");
> +	printk(KERN_INFO " "
> +		"ioatdma: Intel(R) I/OAT DMA Engine initialization failed\n");
>  
>  	return err;
>  }

What's with these (KERN_INFO " "
			"...more strings");
??

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
