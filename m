Return-Path: <linux-kernel-owner+w=401wt.eu-S1763564AbYF0WP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763564AbYF0WP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 18:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760259AbYF0WPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 18:15:18 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51739 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759413AbYF0WPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:15:16 -0400
Message-ID: <4865666A.9040306@garzik.org>
Date: Fri, 27 Jun 2008 18:15:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Add PCI IDs for AMD Barcelona PCI devices
References: <20080627140905.EBD1C83D4@erda.amd.com>
In-Reply-To: <20080627140905.EBD1C83D4@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Richter wrote:
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  include/linux/pci_ids.h |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index eafc9d6..4a2557c 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -497,6 +497,11 @@
>  #define PCI_DEVICE_ID_AMD_K8_NB_ADDRMAP	0x1101
>  #define PCI_DEVICE_ID_AMD_K8_NB_MEMCTL	0x1102
>  #define PCI_DEVICE_ID_AMD_K8_NB_MISC	0x1103
> +#define PCI_DEVICE_ID_AMD_10H_NB_HT	0x1200
> +#define PCI_DEVICE_ID_AMD_10H_NB_MAP	0x1201
> +#define PCI_DEVICE_ID_AMD_10H_NB_DRAM	0x1202
> +#define PCI_DEVICE_ID_AMD_10H_NB_MISC	0x1203
> +#define PCI_DEVICE_ID_AMD_10H_NB_LINK	0x1204
>  #define PCI_DEVICE_ID_AMD_LANCE		0x2000
>  #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001

Are these constants going to be used in future kernels?

We don't necessarily want to create constants for each PCI ID in 
existence.  A more comprehensive database is kept at 
http://pciids.sourceforge.net/

	Jeff



