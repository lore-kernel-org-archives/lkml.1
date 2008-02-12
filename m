Return-Path: <linux-kernel-owner+w=401wt.eu-S1761549AbYBLJEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761549AbYBLJEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 04:04:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755478AbYBLJDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 04:03:46 -0500
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:4339 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755080AbYBLJDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 04:03:44 -0500
Date: Tue, 12 Feb 2008 10:03:38 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Greg KH <gregkh@suse.de>
Cc: Jason Gaston <jason.d.gaston@intel.com>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, i2c@lm-sensors.nu
Subject: Re: [PATCH 2.6.24] pci_ids: patch for Intel ICH10 DeviceID's
Message-ID: <20080212100338.21c0adf5@hyperion.delvare>
In-Reply-To: <200801281720.37350.jason.d.gaston@intel.com>
References: <200801281720.37350.jason.d.gaston@intel.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 17:20:36 -0800, Jason Gaston wrote:
> This patch adds the Intel ICH10 LPC and SMBus Controller DeviceID's.
> 
> Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>
> 
> --- linux-2.6.24/include/linux/pci_ids.h.orig	2008-01-24 14:58:37.000000000 -0800
> +++ linux-2.6.24/include/linux/pci_ids.h	2008-01-28 15:05:41.000000000 -0800
> @@ -2339,6 +2339,12 @@
>  #define PCI_DEVICE_ID_INTEL_MCH_PC1	0x359a
>  #define PCI_DEVICE_ID_INTEL_E7525_MCH	0x359e
>  #define PCI_DEVICE_ID_INTEL_IOAT_CNB	0x360b
> +#define PCI_DEVICE_ID_INTEL_ICH10_0	0x3a14
> +#define PCI_DEVICE_ID_INTEL_ICH10_1	0x3a16
> +#define PCI_DEVICE_ID_INTEL_ICH10_2	0x3a18
> +#define PCI_DEVICE_ID_INTEL_ICH10_3	0x3a1a
> +#define PCI_DEVICE_ID_INTEL_ICH10_4	0x3a30
> +#define PCI_DEVICE_ID_INTEL_ICH10_5	0x3a60
>  #define PCI_DEVICE_ID_INTEL_IOAT_SNB	0x402f
>  #define PCI_DEVICE_ID_INTEL_IOAT_SCNB	0x65ff
>  #define PCI_DEVICE_ID_INTEL_TOLAPAI_0	0x5031

Greg, please pick this patch quickly so that it makes it to -mm and the
other patches that depend on it can be pushed there as well.

Thanks,
-- 
Jean Delvare
