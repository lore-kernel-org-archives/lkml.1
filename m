Return-Path: <linux-kernel-owner+w=401wt.eu-S933103AbXHaPt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103AbXHaPt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 11:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757258AbXHaPtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 11:49:47 -0400
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:3870 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756737AbXHaPtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 11:49:47 -0400
Date: Fri, 31 Aug 2007 17:50:45 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jason Gaston <jason.d.gaston@intel.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, i2c@lm-sensors.org
Subject: Re: [PATCH 2.6.23-rc4][reRESEND] i2c-i801: SMBus patch for Intel
 Tolapai
Message-ID: <20070831175045.37938669@hyperion.delvare>
In-Reply-To: <200708302042.59104.jason.d.gaston@intel.com>
References: <200708302042.59104.jason.d.gaston@intel.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Thu, 30 Aug 2007 20:42:58 -0700, Jason Gaston wrote:
> Resend with uppercase define.
> 
> This updated patch adds the Intel Tolapai SMBus Controller DID's.
> This patch relies on the Tolapai patch to pci_ids.h 
> 
> Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>
> 
> --- linux-2.6.23-rc4/drivers/i2c/busses/i2c-i801.c.orig	2007-08-27 18:32:35.000000000 -0700
> +++ linux-2.6.23-rc4/drivers/i2c/busses/i2c-i801.c	2007-08-30 20:25:10.000000000 -0700
> @@ -34,6 +34,7 @@
>      ESB2		269B
>      ICH8		283E
>      ICH9		2930
> +    Tolapai		5032
>      This driver supports several versions of Intel's I/O Controller Hubs (ICH).
>      For SMBus support, they are similar to the PIIX4 and are part
>      of Intel's '810' and other chipsets.
> @@ -543,6 +544,7 @@
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB2_17) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_5) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH9_6) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_TOLAPAI_1) },
>  	{ 0, }
>  };
>  
> @@ -563,6 +565,7 @@
>  	case PCI_DEVICE_ID_INTEL_ESB2_17:
>  	case PCI_DEVICE_ID_INTEL_ICH8_5:
>  	case PCI_DEVICE_ID_INTEL_ICH9_6:
> +	case PCI_DEVICE_ID_INTEL_TOLAPAI_1:
>  		isich4 = 1;
>  		break;
>  	default:

Applied together with the Documentation patch (no need for a separate
patch). Note that I will have to wait for Greg to pick the pci_ids.h
patch before I can push this one.

-- 
Jean Delvare
