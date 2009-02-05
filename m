Return-Path: <linux-kernel-owner+w=401wt.eu-S1759349AbZBER3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349AbZBER3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbZBER3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:29:05 -0500
Received: from kroah.org ([198.145.64.141]:58529 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752061AbZBER3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:29:04 -0500
Date: Thu, 5 Feb 2009 09:28:59 -0800
From: Greg KH <greg@kroah.com>
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com,
       anil.s.keshavamurthy@intel.com, fenghua.yu@intel.com,
       akpm@linux-foundation.org, frank@f-seidel.de,
       Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] PCI: add missing KERN_* constants to printks
Message-ID: <20090205172859.GA20558@kroah.com>
References: <498B2116.6010707@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498B2116.6010707@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 06:25:42PM +0100, Frank Seidel wrote:
> From: Frank Seidel <frank@f-seidel.de>
> 
> According to kerneljanitors todo list all printk calls (beginning
> a new line) should have an according KERN_* constant.
> Those are the missing pieces here for the pci subsystem.
> 
> Signed-off-by: Frank Seidel <frank@f-seidel.de>
> ---
>  drivers/pci/hotplug/pciehp_core.c |    6 +++---
>  drivers/pci/hotplug/shpchp_core.c |    4 ++--
>  drivers/pci/intel-iommu.c         |    2 +-
>  3 files changed, 6 insertions(+), 6 deletions(-)
> 
> --- a/drivers/pci/hotplug/pciehp_core.c
> +++ b/drivers/pci/hotplug/pciehp_core.c
> @@ -526,16 +526,16 @@ static int __init pcied_init(void)
>  
>  	pciehp_firmware_init();
>  	retval = pcie_port_service_register(&hpdriver_portdrv);
> - 	dbg("pcie_port_service_register = %d\n", retval);
> +	dbg(KERN_DEBUG "pcie_port_service_register = %d\n", retval);

dbg() already sets the KERN_ level, right?

thanks,

greg k-h
