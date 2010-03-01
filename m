Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751159Ab0CALDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 06:03:33 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64625 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab0CALDb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 06:03:31 -0500
From: Karsten Keil <isdn@linux-pingi.de>
Reply-To: isdn@linux-pingi.de
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: repost [PATCH 1/1] mISDN: Add PCI ID for HFC-4S Beronet Card PCIe
Date: Mon, 1 Mar 2010 12:03:23 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.27.42-0.1-default; KDE/4.4.0; x86_64; ; )
Cc: "David S. Miller" <davem@davemloft.net>,
       Andreas Eversberg <andreas@eversberg.eu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20100301103845.GD4321@soda.linbit>
In-Reply-To: <20100301103845.GD4321@soda.linbit>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003011203.24092.isdn@linux-pingi.de>
X-Provags-ID: V01U2FsdGVkX1/6o0rJcDMov6BG7hR2VAVRJtG/uliA6wE0i+Y
 LT301EK4o6bCCU9dQphSCZNVmh1K/fIQEc/j6/Aqfqj+curHjo
 GL3W8DJPyXaRuEPX27cIY6bdN1d1htn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I will send a new version with all IDs.
So far I see only the 2 PCIe cards from Beronet are missing (0xb761,0xb762).

Karsten
 
On Montag, 1. März 2010 11:38:45 Lars Ellenberg wrote:
> A few subdevice IDs seem to have been dropped when hfc_multi was
> included upstream, just compare the list at
> http://www.openvox.cn/viewvc/misdn/trunk/hfc_multi.c?revision=75&view=annot
> ate#l175 with the IDs in drivers/isdn/hardware/mISDN/hfcmulti.c
> 
> I only have access to the 0xB762 hardware, so I only added that ID.
> 
> Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> 
> ---
> 
> *BUMP*
> 
> Repost, first posted
>  Date: Wed, 3 Feb 2010 22:20:55 +0100
>  Message-ID: <20100203212055.GB28234@soda.linbit>
> 
> As all our daily phone calls run over these cards, I can confirm this
> particular card as working just fine, once the driver feels responsible.
> But someone should consider to also include the rest of the IDs,
> unless there has been a reason to drop them.
> 
> 
> 
> 
> diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c
>  b/drivers/isdn/hardware/mISDN/hfcmulti.c index 1a1420d..446a29c 100644
> --- a/drivers/isdn/hardware/mISDN/hfcmulti.c
> +++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
> @@ -5265,6 +5265,7 @@ static const struct hm_map hfcm_map[] = {
>  /*31*/	{VENDOR_CCD, "XHFC-4S Speech Design", 5, 4, 0, 0, 0, 0,
>  		HFC_IO_MODE_EMBSD, XHFC_IRQ},
>  /*32*/	{VENDOR_JH, "HFC-8S (junghanns)", 8, 8, 1, 0, 0, 0, 0, 0},
> +/*33*/	{VENDOR_CCD, "HFC-4S Beronet Card PCIe", 4, 4, 1, 0, 0, 0, 0, 0},
>  };
> 
>  #undef H
> @@ -5300,6 +5301,8 @@ static struct pci_device_id hfmultipci_ids[]
>  __devinitdata = { PCI_SUBDEVICE_ID_CCD_OV4S, 0, 0, H(28)}, /* OpenVox 4 */
>  	{ PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_HFC4S, PCI_VENDOR_ID_CCD,
>  		PCI_SUBDEVICE_ID_CCD_OV2S, 0, 0, H(29)}, /* OpenVox 2 */
> +	{ PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_HFC4S, PCI_VENDOR_ID_CCD,
> +		PCI_SUBDEVICE_ID_CCD_BN4SE, 0, 0, H(33)}, /* BN4S PCIe */
> 
>  	/* Cards with HFC-8S Chip */
>  	{ PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_HFC8S, PCI_VENDOR_ID_CCD,
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index cca8a04..c171690 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -1924,6 +1924,7 @@
>  #define PCI_SUBDEVICE_ID_CCD_HFC8S	0xB622
>  #define PCI_DEVICE_ID_CCD_B700		0xb700
>  #define PCI_DEVICE_ID_CCD_B701		0xb701
> +#define PCI_SUBDEVICE_ID_CCD_BN4SE	0xb762
>  #define PCI_SUBDEVICE_ID_CCD_HFCE1	0xC523
>  #define PCI_SUBDEVICE_ID_CCD_OV2S	0xE884
>  #define PCI_SUBDEVICE_ID_CCD_OV4S	0xE888
> 
