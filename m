Return-Path: <linux-kernel-owner+w=401wt.eu-S1757343AbXIJJq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbXIJJq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 05:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbXIJJqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 05:46:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45698 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866AbXIJJqU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 05:46:20 -0400
Date: Mon, 10 Sep 2007 02:45:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Gaston <jason.d.gaston@intel.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, khali@linux-fr.org,
       i2c@lm-sensors.nu
Subject: Re: [PATCH 2.6.23-rc4][RESEND] irq: irq and pci_ids patch for Intel
 Tolapai
Message-Id: <20070910024525.4e90b29d.akpm@linux-foundation.org>
In-Reply-To: <200708301750.57189.jason.d.gaston@intel.com>
References: <200708301750.57189.jason.d.gaston@intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2007 17:50:56 -0700 Jason Gaston <jason.d.gaston@intel.com> wrote:

> Resend without wordwrap.
> 
> This updated patch adds the Intel Tolapai LPC and SMBus Controller DID's.
> 
> Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>
> 
> --- linux-2.6.23-rc4/arch/i386/pci/irq.c.orig	2007-08-27 18:32:35.000000000 -0700
> +++ linux-2.6.23-rc4/arch/i386/pci/irq.c	2007-08-28 16:58:31.000000000 -0700
> @@ -550,6 +550,7 @@
>  		case PCI_DEVICE_ID_INTEL_ICH9_3:
>  		case PCI_DEVICE_ID_INTEL_ICH9_4:
>  		case PCI_DEVICE_ID_INTEL_ICH9_5:
> +		case PCI_DEVICE_ID_INTEL_Tolapai_0:
>  			r->name = "PIIX/ICH";
>  			r->get = pirq_piix_get;
>  			r->set = pirq_piix_set;
> --- linux-2.6.23-rc4/include/linux/pci_ids.h.orig	2007-08-27 18:32:35.000000000 -0700
> +++ linux-2.6.23-rc4/include/linux/pci_ids.h	2007-08-28 16:58:31.000000000 -0700
> @@ -2293,6 +2293,8 @@
>  #define PCI_DEVICE_ID_INTEL_MCH_PC	0x3599
>  #define PCI_DEVICE_ID_INTEL_MCH_PC1	0x359a
>  #define PCI_DEVICE_ID_INTEL_E7525_MCH	0x359e
> +#define PCI_DEVICE_ID_INTEL_Tolapai_0	0x5031
> +#define PCI_DEVICE_ID_INTEL_Tolapai_1	0x5032
>  #define PCI_DEVICE_ID_INTEL_82371SB_0	0x7000
>  #define PCI_DEVICE_ID_INTEL_82371SB_1	0x7010
>  #define PCI_DEVICE_ID_INTEL_82371SB_2	0x7020

I agree with Matthew that the lower-case shouldn't be in there, so I queued
a patch to fix that up.

Given that your I2C patch (and potentially others?) depend upon this one, I
shall plan on getting this patch into mainline this week to make everyone's
life simpler.

