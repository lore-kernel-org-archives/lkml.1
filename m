Return-Path: <linux-kernel-owner+w=401wt.eu-S1764493AbXJOQFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764493AbXJOQFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 12:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761629AbXJOQFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 12:05:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:10138 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761345AbXJOQFU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 12:05:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,278,1188802800"; 
   d="scan'208";a="174307839"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] drivers/pci, drivers/dma: kill unused vars
Date: Mon, 15 Oct 2007 09:05:18 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C03393355@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20071013190724.GA20132@havoc.gtf.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/pci, drivers/dma: kill unused vars
Thread-Index: AcgNzEvHljxyxmu1TKm1oK80yEcdQABeANUQ
References: <20071013190724.GA20132@havoc.gtf.org>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Jeff Garzik" <jeff@garzik.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>, "Greg KH" <greg@kroah.com>,
       "Williams, Dan J" <dan.j.williams@intel.com>
X-OriginalArrivalTime: 15 Oct 2007 16:05:19.0710 (UTC) FILETIME=[2F149FE0:01C80F45]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Jeff Garzik [mailto:jeff@garzik.org] 
>Sent: Saturday, October 13, 2007 12:07 PM
>To: Andrew Morton; Linus Torvalds
>Cc: LKML; Greg KH; Nelson, Shannon; Williams, Dan J
>Subject: [PATCH] drivers/pci, drivers/dma: kill unused vars
>
>
>Kill two never-used (not even in hidden debug macros) variables,
>noticed by the compiler.
>
>Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
>---
> drivers/dma/ioatdma.c                  |    1 -
> drivers/pci/hotplug/pci_hotplug_core.c |    2 --
> 2 files changed, 3 deletions(-)
>
>diff --git a/drivers/dma/ioatdma.c b/drivers/dma/ioatdma.c
>index 41b18c5..d9db64b 100644
>--- a/drivers/dma/ioatdma.c
>+++ b/drivers/dma/ioatdma.c
>@@ -244,7 +244,6 @@ static void 
>ioat_dma_free_chan_resources(struct dma_chan *chan)
> 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
> 	struct ioat_device *ioat_device = to_ioat_device(chan->device);
> 	struct ioat_desc_sw *desc, *_desc;
>-	u16 chanctrl;
> 	int in_use_descs = 0;
> 
> 	ioat_dma_memcpy_cleanup(ioat_chan);

Acked-by: Shannon Nelson <shannon.nelson@intel.com>

FYI - this code gets heavily revised by ioat patches in -mm that Andrew
is planning on merging soon.

sln

>diff --git a/drivers/pci/hotplug/pci_hotplug_core.c 
>b/drivers/pci/hotplug/pci_hotplug_core.c
>index f0eba53..01c351c 100644
>--- a/drivers/pci/hotplug/pci_hotplug_core.c
>+++ b/drivers/pci/hotplug/pci_hotplug_core.c
>@@ -689,8 +689,6 @@ int pci_hp_deregister (struct hotplug_slot *slot)
> int __must_check pci_hp_change_slot_info(struct hotplug_slot *slot,
> 					 struct hotplug_slot_info *info)
> {
>-	int retval;
>-
> 	if ((slot == NULL) || (info == NULL))
> 		return -ENODEV;
> 
>
