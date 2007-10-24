Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbXJXFAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbXJXFAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 01:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbXJXE76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 00:59:58 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1538 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124AbXJXE75 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 00:59:57 -0400
X-Server-Uuid: A6C4E0AE-A7F0-449F-BAE7-7FA0D737AC76
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: Re: [PATCH 3/4]: [PCI]: Add quirk for devices which disable MSI
 when INTX_DISABLE is set.
Date: Tue, 23 Oct 2007 21:59:39 -0700
Message-ID: <1551EAE59135BE47B544934E30FC4FC002AABB0A@nt-irva-0751.brcm.ad.broadcom.com>
In-Reply-To: <20071023.195310.131105752.davem@davemloft.net>
Thread-Topic: [PATCH 3/4]: [PCI]: Add quirk for devices which disable
 MSI when INTX_DISABLE is set.
Thread-Index: AcgV6Pjmaoan4M4hQhGGBTHR4MB4zAAESeXg
From: "Michael Chan" <mchan@broadcom.com>
To: "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
cc: jeff@garzik.org, barkalow@iabervon.org, linas@austin.ibm.com,
       chunhao.huang@hotmail.com, gregkh@suse.de, htejun@gmail.com,
       brice.goglin@gmail.com, david.gaarenstroom@gmail.com,
       linux-pci@atrey.karlin.mff.cuni.cz, shane.huang@amd.com,
       linux-ide@vger.kernel.org, brice@myri.com
X-WSS-ID: 6B000EB72FS7169150-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:

> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
> +			PCI_DEVICE_ID_TIGON3_5780,
> +			quirk_msi_intx_disable_bug);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
> +			PCI_DEVICE_ID_TIGON3_5780S,
> +			quirk_msi_intx_disable_bug);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
> +			PCI_DEVICE_ID_TIGON3_5714,
> +			quirk_msi_intx_disable_bug);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
> +			PCI_DEVICE_ID_TIGON3_5714S,
> +			quirk_msi_intx_disable_bug);
> +

Please add PCI_DEVICE_ID_TIGON3_5715 and
PCI_DEVICE_ID_TIGON3_5715S as well.

Other than that,
Acked-by: Michael Chan <mchan@broadcom.com>

