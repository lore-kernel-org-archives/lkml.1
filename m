Return-Path: <linux-kernel-owner+w=401wt.eu-S932476AbXIAVUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476AbXIAVUI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 17:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756149AbXIAVT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 17:19:57 -0400
Received: from colo.lackof.org ([198.49.126.79]:49316 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756062AbXIAVT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 17:19:57 -0400
Date: Sat, 1 Sep 2007 15:19:39 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Jason Gaston <jason.d.gaston@intel.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, khali@linux-fr.org,
       i2c@lm-sensors.nu
Subject: Re: [PATCH 2.6.23-rc4] irq: irq and pci_ids patch for Intel Tolapai
Message-ID: <20070901211939.GA10442@colo.lackof.org>
References: <200708301546.56998.jason.d.gaston@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708301546.56998.jason.d.gaston@intel.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2007 at 03:46:56PM -0700, Jason Gaston wrote:
> This updated patch adds the Intel Tolapai LPC and SMBus Controller DID's.
> 
> Signed-off-by: ?Jason Gaston <jason.d.gaston@intel.com>
> 
> --- linux-2.6.23-rc4/arch/i386/pci/irq.c.orig	2007-08-27 18:32:35.000000000 
> -0700
> +++ linux-2.6.23-rc4/arch/i386/pci/irq.c	2007-08-28 16:58:31.000000000 -0700
> @@ -550,6 +550,7 @@
>  		case PCI_DEVICE_ID_INTEL_ICH9_3:
>  		case PCI_DEVICE_ID_INTEL_ICH9_4:
>  		case PCI_DEVICE_ID_INTEL_ICH9_5:
> +		case PCI_DEVICE_ID_INTEL_Tolapai_0:

If this is the only place it's used, the prefence is to define the
constant locally (in the file) and not in pci_ids.h.

Please do submit new PCI device IDs to pciids.sf.net project.

thanks,
grant

>  			r->name = "PIIX/ICH";
>  			r->get = pirq_piix_get;
>  			r->set = pirq_piix_set;
> --- linux-2.6.23-rc4/include/linux/pci_ids.h.orig	2007-08-27 
> 18:32:35.000000000 -0700
> +++ linux-2.6.23-rc4/include/linux/pci_ids.h	2007-08-28 16:58:31.000000000 
> -0700
> @@ -2293,6 +2293,8 @@
>  #define PCI_DEVICE_ID_INTEL_MCH_PC	0x3599
>  #define PCI_DEVICE_ID_INTEL_MCH_PC1	0x359a
>  #define PCI_DEVICE_ID_INTEL_E7525_MCH	0x359e
> +#define PCI_DEVICE_ID_INTEL_Tolapai_0	0x5031
> +#define PCI_DEVICE_ID_INTEL_Tolapai_1	0x5032
>  #define PCI_DEVICE_ID_INTEL_82371SB_0	0x7000
>  #define PCI_DEVICE_ID_INTEL_82371SB_1	0x7010
>  #define PCI_DEVICE_ID_INTEL_82371SB_2	0x7020
