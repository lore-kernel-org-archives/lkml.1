Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbYHIOBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbYHIOBB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 10:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbYHIOAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 10:00:53 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:42349 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbYHIOAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 10:00:52 -0400
Date: Sat, 9 Aug 2008 16:00:40 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Seth Heasley <seth.heasley@intel.com>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 2.6.26.2] pci_ids: patch for Intel Ibex Peak DeviceIDs
Message-ID: <20080809160040.6c8618a0@hyperion.delvare>
In-Reply-To: <200808081616.08158.seth.heasley@intel.com>
References: <200808081616.08158.seth.heasley@intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008 16:16:07 -0700, Seth Heasley wrote:
> This patch adds the Intel Ibex Peak (PCH) LPC and SMBus Controller DeviceIDs.
> 
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
> 
> --- linux-2.6.26.2/include/linux/pci_ids.h.orig 2008-08-08 11:07:41.000000000 -0700
> +++ linux-2.6.26.2/include/linux/pci_ids.h      2008-08-08 11:22:31.000000000 -0700
> @@ -2385,6 +2385,9 @@
>  #define PCI_DEVICE_ID_INTEL_ICH10_3    0x3a1a
>  #define PCI_DEVICE_ID_INTEL_ICH10_4    0x3a30
>  #define PCI_DEVICE_ID_INTEL_ICH10_5    0x3a60
> +#define PCI_DEVICE_ID_INTEL_PCH_0      0x3b10
> +#define PCI_DEVICE_ID_INTEL_PCH_1      0x3b11
> +#define PCI_DEVICE_ID_INTEL_PCH_2      0x3b30
>  #define PCI_DEVICE_ID_INTEL_IOAT_SNB   0x402f
>  #define PCI_DEVICE_ID_INTEL_5400_ERR   0x4030
>  #define PCI_DEVICE_ID_INTEL_5400_FBD0  0x4035

Acked-by: Jean Delvare <khali@linux-fr.org>

Would be a good idea to send such a patch to the maintainer of the PCI
subsystem (Cc added.)

Note that the other patch you just sent for i2c-i801 depends on this
one, so I will have to wait for Jesse to pick it first.

-- 
Jean Delvare
