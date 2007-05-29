Return-Path: <linux-kernel-owner+w=401wt.eu-S1751495AbXE2W0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbXE2W0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbXE2W0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:26:05 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37671 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750717AbXE2W0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:26:03 -0400
Date: Tue, 29 May 2007 15:25:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Gaston <jason.d.gaston@intel.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, stable@kernel.org
Subject: Re: [PATCH 2.6.22-rc2] pci_ids: update patch for Intel ICH9M
Message-Id: <20070529152545.887fda6c.akpm@linux-foundation.org>
In-Reply-To: <200705251203.31985.jason.d.gaston@intel.com>
References: <200705251203.31985.jason.d.gaston@intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007 12:03:31 -0700
Jason Gaston <jason.d.gaston@intel.com> wrote:

> This patch updates the Intel ICH9M LPC Controller DID's, due to a 
> specification change.
> 
> Signed-off-by: __Jason Gaston <jason.d.gaston@intel.com>
> 
> --- linux-2.6.22-rc2/include/linux/pci_ids.h.orig	2007-05-25 
> 11:42:11.000000000 -0700
> +++ linux-2.6.22-rc2/include/linux/pci_ids.h	2007-05-25 11:43:28.000000000 
> -0700
> @@ -2266,11 +2266,11 @@
>  #define PCI_DEVICE_ID_INTEL_ICH8_5	0x283e
>  #define PCI_DEVICE_ID_INTEL_ICH8_6	0x2850
>  #define PCI_DEVICE_ID_INTEL_ICH9_0	0x2910
> -#define PCI_DEVICE_ID_INTEL_ICH9_1	0x2911
> +#define PCI_DEVICE_ID_INTEL_ICH9_1	0x2917
>  #define PCI_DEVICE_ID_INTEL_ICH9_2	0x2912
>  #define PCI_DEVICE_ID_INTEL_ICH9_3	0x2913
>  #define PCI_DEVICE_ID_INTEL_ICH9_4	0x2914
> -#define PCI_DEVICE_ID_INTEL_ICH9_5	0x2915
> +#define PCI_DEVICE_ID_INTEL_ICH9_5	0x2919
>  #define PCI_DEVICE_ID_INTEL_ICH9_6	0x2930
>  #define PCI_DEVICE_ID_INTEL_82855PM_HB	0x3340
>  #define PCI_DEVICE_ID_INTEL_82830_HB	0x3575

I assume we'll need this in 2.6.21.x as well, otherwise those devices just
won't work when someone tries to run this kernel on them?
