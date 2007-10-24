Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbXJXFHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbXJXFHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 01:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbXJXFHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 01:07:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47051
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754056AbXJXFHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 01:07:12 -0400
Date: Tue, 23 Oct 2007 22:06:56 -0700 (PDT)
Message-Id: <20071023.220656.55724970.davem@davemloft.net>
To: mchan@broadcom.com
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, barkalow@iabervon.org,
       linas@austin.ibm.com, chunhao.huang@hotmail.com, gregkh@suse.de,
       htejun@gmail.com, brice.goglin@gmail.com, david.gaarenstroom@gmail.com,
       linux-pci@atrey.karlin.mff.cuni.cz, shane.huang@amd.com,
       linux-ide@vger.kernel.org, brice@myri.com
Subject: Re: [PATCH 3/4]: [PCI]: Add quirk for devices which disable MSI
 when INTX_DISABLE is set.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1551EAE59135BE47B544934E30FC4FC002AABB0A@nt-irva-0751.brcm.ad.broadcom.com>
References: <20071023.195310.131105752.davem@davemloft.net>
	<1551EAE59135BE47B544934E30FC4FC002AABB0A@nt-irva-0751.brcm.ad.broadcom.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael Chan" <mchan@broadcom.com>
Date: Tue, 23 Oct 2007 21:59:39 -0700

> David Miller wrote:
> 
> > +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
> > +			PCI_DEVICE_ID_TIGON3_5780,
> > +			quirk_msi_intx_disable_bug);
> > +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
> > +			PCI_DEVICE_ID_TIGON3_5780S,
> > +			quirk_msi_intx_disable_bug);
> > +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
> > +			PCI_DEVICE_ID_TIGON3_5714,
> > +			quirk_msi_intx_disable_bug);
> > +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
> > +			PCI_DEVICE_ID_TIGON3_5714S,
> > +			quirk_msi_intx_disable_bug);
> > +
> 
> Please add PCI_DEVICE_ID_TIGON3_5715 and
> PCI_DEVICE_ID_TIGON3_5715S as well.

I will.

> Other than that,
> Acked-by: Michael Chan <mchan@broadcom.com>

Thanks for reviewing.
