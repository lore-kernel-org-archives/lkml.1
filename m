Return-Path: <linux-kernel-owner+w=401wt.eu-S1757319AbYGKMrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbYGKMrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 08:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbYGKMrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 08:47:37 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:12752 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbYGKMrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 08:47:36 -0400
X-BigFish: VPS-29(zz1432R98dR4015M62a3L7efV1805Mzz10d3izzd6eMz32i6bh87il43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3UE6R-02-0AX-01
Date: Fri, 11 Jul 2008 14:46:59 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [osrc-patches] [PATCH] x86: Add PCI IDs for AMD Barcelona PCI
	devices
Message-ID: <20080711124659.GC7963@erda.amd.com>
References: <20080627140905.EBD1C83D4@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080627140905.EBD1C83D4@erda.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 11 Jul 2008 12:47:01.0385 (UTC) FILETIME=[36A8CF90:01C8E354]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, what about this patch. Could you apply it somewhere to the tip
tree? I will then fix all hardcoded device entries in the code.

Thanks,

-Robert

On 27.06.08 16:04:28, Robert Richter wrote:
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
>  #define PCI_DEVICE_ID_AMD_SCSI		0x2020
> -- 
> 1.5.5.4
> 
> _______________________________________________
> osrc-patches mailing list
> osrc-patches@elbe.amd.com
> https://ddcwww.amd.com/mailman/listinfo/osrc-patches

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

