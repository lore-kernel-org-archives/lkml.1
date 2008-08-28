Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbYH1Ht4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbYH1Ht4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 03:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbYH1Hts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 03:49:48 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:2704 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbYH1Htr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 03:49:47 -0400
Date: Thu, 28 Aug 2008 09:49:35 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Seth Heasley <seth.heasley@intel.com>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       seth.heasley@intel.com
Subject: Re: [PATCH 2.6.27-rc4] irq: irq and pci_ids patch for Intel Ibex 
 Peak DeviceIDs
Message-ID: <20080828094935.0f50af24@hyperion.delvare>
In-Reply-To: <200808271658.26313.seth.heasley@intel.com>
References: <200808271658.26313.seth.heasley@intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth,

On Wed, 27 Aug 2008 16:58:26 -0700, Seth Heasley wrote:
> This patch updates the Intel Ibex Peak (PCH) LPC and SMBus Controller DeviceIDs.
> 
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
> 
> --- linux-2.6/include/linux/pci_ids.h.orig	2008-08-27 11:54:07.000000000 -0700
> +++ linux-2.6/include/linux/pci_ids.h	2008-08-27 12:01:53.000000000 -0700
> @@ -2428,9 +2428,39 @@
>  #define PCI_DEVICE_ID_INTEL_ICH10_3	0x3a1a
>  #define PCI_DEVICE_ID_INTEL_ICH10_4	0x3a30
>  #define PCI_DEVICE_ID_INTEL_ICH10_5	0x3a60
> -#define PCI_DEVICE_ID_INTEL_PCH_0	0x3b10
> -#define PCI_DEVICE_ID_INTEL_PCH_1	0x3b11
> -#define PCI_DEVICE_ID_INTEL_PCH_2	0x3b30
> +#define PCI_DEVICE_ID_INTEL_PCH_0	0x3b00
> +#define PCI_DEVICE_ID_INTEL_PCH_1	0x3b01
> +#define PCI_DEVICE_ID_INTEL_PCH_2	0x3b02

Changing device ID definitions that way is really bad practice. It
needs to be synchronized between all involved subsystems.

> +#define PCI_DEVICE_ID_INTEL_PCH_3	0x3b03
> +#define PCI_DEVICE_ID_INTEL_PCH_4	0x3b04
> +#define PCI_DEVICE_ID_INTEL_PCH_5	0x3b05
> +#define PCI_DEVICE_ID_INTEL_PCH_6	0x3b06
> +#define PCI_DEVICE_ID_INTEL_PCH_7	0x3b07
> +#define PCI_DEVICE_ID_INTEL_PCH_8	0x3b08
> +#define PCI_DEVICE_ID_INTEL_PCH_9	0x3b09
> +#define PCI_DEVICE_ID_INTEL_PCH_10	0x3b0a
> +#define PCI_DEVICE_ID_INTEL_PCH_11	0x3b0b
> +#define PCI_DEVICE_ID_INTEL_PCH_12	0x3b0c
> +#define PCI_DEVICE_ID_INTEL_PCH_13	0x3b0d
> +#define PCI_DEVICE_ID_INTEL_PCH_14	0x3b0e
> +#define PCI_DEVICE_ID_INTEL_PCH_15	0x3b0f
> +#define PCI_DEVICE_ID_INTEL_PCH_16	0x3b10
> +#define PCI_DEVICE_ID_INTEL_PCH_17	0x3b11
> +#define PCI_DEVICE_ID_INTEL_PCH_18	0x3b12
> +#define PCI_DEVICE_ID_INTEL_PCH_19	0x3b13
> +#define PCI_DEVICE_ID_INTEL_PCH_20	0x3b14
> +#define PCI_DEVICE_ID_INTEL_PCH_21	0x3b15
> +#define PCI_DEVICE_ID_INTEL_PCH_22	0x3b16
> +#define PCI_DEVICE_ID_INTEL_PCH_23	0x3b17
> +#define PCI_DEVICE_ID_INTEL_PCH_24	0x3b18
> +#define PCI_DEVICE_ID_INTEL_PCH_25	0x3b19
> +#define PCI_DEVICE_ID_INTEL_PCH_26	0x3b1a
> +#define PCI_DEVICE_ID_INTEL_PCH_27	0x3b1b
> +#define PCI_DEVICE_ID_INTEL_PCH_28	0x3b1c
> +#define PCI_DEVICE_ID_INTEL_PCH_29	0x3b1d
> +#define PCI_DEVICE_ID_INTEL_PCH_30	0x3b1e
> +#define PCI_DEVICE_ID_INTEL_PCH_31	0x3b1f
> +#define PCI_DEVICE_ID_INTEL_PCH_32	0x3b30
>  #define PCI_DEVICE_ID_INTEL_IOAT_SNB	0x402f
>  #define PCI_DEVICE_ID_INTEL_5100_16	0x65f0
>  #define PCI_DEVICE_ID_INTEL_5100_21	0x65f5

BTW, what's the point of these defines? I get the idea of giving nice
names to device IDs if these names are explicit and really describe the
device. But the Intel south bridge device names are nothing more than
arbitrary numbers, so you are replacing a set of arbitrary numbers by
another set of arbitrary numbers. I see little benefit in doing this,
given the cost it has. For what it's worth, several subsystems (ata,
sound...) have already stopped using these defines and I understand
them completely: depending on changes done to include/linux/pci_ids.h
is more pain than is worth.

Can't we stop defining these IDs now and start using the hexadecimal
numbers in all the drivers directly?

> --- linux-2.6/arch/x86/pci/irq.c.orig	2008-08-27 11:53:13.000000000 -0700
> +++ linux-2.6/arch/x86/pci/irq.c	2008-08-27 12:07:21.000000000 -0700
> @@ -592,6 +592,36 @@
>  	case PCI_DEVICE_ID_INTEL_ICH10_3:
>  	case PCI_DEVICE_ID_INTEL_PCH_0:
>  	case PCI_DEVICE_ID_INTEL_PCH_1:
> +	case PCI_DEVICE_ID_INTEL_PCH_2:
> +	case PCI_DEVICE_ID_INTEL_PCH_3:
> +	case PCI_DEVICE_ID_INTEL_PCH_4:
> +	case PCI_DEVICE_ID_INTEL_PCH_5:
> +	case PCI_DEVICE_ID_INTEL_PCH_6:
> +	case PCI_DEVICE_ID_INTEL_PCH_7:
> +	case PCI_DEVICE_ID_INTEL_PCH_8:
> +	case PCI_DEVICE_ID_INTEL_PCH_9:
> +	case PCI_DEVICE_ID_INTEL_PCH_10:
> +	case PCI_DEVICE_ID_INTEL_PCH_11:
> +	case PCI_DEVICE_ID_INTEL_PCH_12:
> +	case PCI_DEVICE_ID_INTEL_PCH_13:
> +	case PCI_DEVICE_ID_INTEL_PCH_14:
> +	case PCI_DEVICE_ID_INTEL_PCH_15:
> +	case PCI_DEVICE_ID_INTEL_PCH_16:
> +	case PCI_DEVICE_ID_INTEL_PCH_17:
> +	case PCI_DEVICE_ID_INTEL_PCH_18:
> +	case PCI_DEVICE_ID_INTEL_PCH_19:
> +	case PCI_DEVICE_ID_INTEL_PCH_20:
> +	case PCI_DEVICE_ID_INTEL_PCH_21:
> +	case PCI_DEVICE_ID_INTEL_PCH_22:
> +	case PCI_DEVICE_ID_INTEL_PCH_23:
> +	case PCI_DEVICE_ID_INTEL_PCH_24:
> +	case PCI_DEVICE_ID_INTEL_PCH_25:
> +	case PCI_DEVICE_ID_INTEL_PCH_26:
> +	case PCI_DEVICE_ID_INTEL_PCH_27:
> +	case PCI_DEVICE_ID_INTEL_PCH_28:
> +	case PCI_DEVICE_ID_INTEL_PCH_29:
> +	case PCI_DEVICE_ID_INTEL_PCH_30:
> +	case PCI_DEVICE_ID_INTEL_PCH_31:

I am no PCI IRQ routing expert, but I have to admit that I a bit
skeptical that all the PCH functions are IRQ routers. You're adding as
many entries here for the PCH than there have been for all Intel chips
in the past 10 years or so...

>  		r->name = "PIIX/ICH";
>  		r->get = pirq_piix_get;
>  		r->set = pirq_piix_set;


-- 
Jean Delvare
