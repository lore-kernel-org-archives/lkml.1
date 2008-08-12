Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbYHLL6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbYHLL6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 07:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbYHLL6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 07:58:12 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:31913 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbYHLL6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 07:58:11 -0400
Date: Tue, 12 Aug 2008 13:58:02 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Seth Heasley <seth.heasley@intel.com>
Cc: linux-kernel@vger.kernel.org, i2c@lm-sensors.org, seth.heasley@intel.com
Subject: Re: [PATCH 2.6.26.2][RESEND] i2c-i801: SMBus patch for Intel Ibex
 Peak DeviceIDs
Message-ID: <20080812135802.53db9a8a@hyperion.delvare>
In-Reply-To: <200808111702.38396.seth.heasley@intel.com>
References: <200808111702.38396.seth.heasley@intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Aug 2008 17:02:38 -0700, Seth Heasley wrote:
> Resend with proper whitespace.
> 
> This patch adds the Intel Ibex Peak (PCH) SMBus Controller DeviceIDs.
> 
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
> 
> --- linux-2.6.26.2/drivers/i2c/busses/i2c-i801.c.orig	2008-08-08 11:28:08.000000000 -0700
> +++ linux-2.6.26.2/drivers/i2c/busses/i2c-i801.c	2008-08-08 11:32:18.000000000 -0700
> @@ -43,6 +43,7 @@
>    Tolapai               0x5032     32     hard     yes     yes     yes
>    ICH10                 0x3a30     32     hard     yes     yes     yes
>    ICH10                 0x3a60     32     hard     yes     yes     yes
> +  PCH                   0x3b30     32     hard     yes     yes     yes
>  
>    Features supported by this driver:
>    Software PEC                     no
> @@ -592,6 +593,7 @@
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_TOLAPAI_1) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH10_4) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH10_5) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PCH_2) },
>  	{ 0, }
>  };
>  
> @@ -615,6 +617,7 @@
>  	case PCI_DEVICE_ID_INTEL_TOLAPAI_1:
>  	case PCI_DEVICE_ID_INTEL_ICH10_4:
>  	case PCI_DEVICE_ID_INTEL_ICH10_5:
> +	case PCI_DEVICE_ID_INTEL_PCH_2:
>  		i801_features |= FEATURE_I2C_BLOCK_READ;
>  		/* fall through */
>  	case PCI_DEVICE_ID_INTEL_82801DB_3:
> --- linux-2.6.26.2/drivers/i2c/busses/Kconfig.orig	2008-08-08 11:27:52.000000000 -0700
> +++ linux-2.6.26.2/drivers/i2c/busses/Kconfig	2008-08-08 11:30:42.000000000 -0700
> @@ -182,6 +182,7 @@
>  	    ICH9
>  	    Tolapai
>  	    ICH10
> +	    PCH
>  
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called i2c-i801.
> 

Looks good, I've added this to my tree. I will have to wait for the PCI
IDs patch to go upstream before I can push it though.


-- 
Jean Delvare
