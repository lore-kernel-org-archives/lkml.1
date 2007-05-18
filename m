Return-Path: <linux-kernel-owner+w=401wt.eu-S1759143AbXERGAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143AbXERGAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 02:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbXERGAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:00:15 -0400
Received: from ik-out-1112.google.com ([66.249.90.179]:6405 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbXERGAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:00:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fVA1Djqc4K6V+oiXi0H36b2XXhv+Dbs//u4Wu04b2AefFhvp4nQDWS3KVcp92kSh0T0SUYOcldjWepgLOj65kAk6uqcK+J4xUwFcL+46GO+n1XAwAEIcBFioIIWMJU8PRyE1F1TWZPOhAhMkAzYsGqehNFOkcAwdsgCxpwMzMLY=
Message-ID: <a781481a0705172300l5be15a13hb6d64a5b708d5471@mail.gmail.com>
Date: Fri, 18 May 2007 11:30:10 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: BUG in mm/slab.c
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <464D3F50.3080505@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464D3F50.3080505@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

On 5/18/07, Jeff Garzik <jeff@garzik.org> wrote:
>
> Platform:  Fedora Core 6/x86-64 (lspci, kconfig, dmesg attached)
>
> dmesg shows:
> > PCI: Using ACPI for IRQ routing
> > PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
> > BUG: at mm/slab.c:777 __find_general_cachep()
> >
> > Call Trace:
> >  [<ffffffff802819b7>] __kmalloc+0xa7/0xe0
> >  [<ffffffff8021b7bd>] cache_k8_northbridges+0x9d/0x120
> >  [<ffffffff8053bb03>] gart_iommu_init+0x33/0x5b0
> >  [<ffffffff80228673>] __wake_up+0x43/0x70
> >  [<ffffffff803e01a0>] genl_rcv+0x0/0x70
> >  [<ffffffff803de768>] netlink_kernel_create+0x158/0x170
> >  [<ffffffff803dffd0>] genl_unlock+0x10/0x50
> >  [<ffffffff80535879>] pci_iommu_init+0x9/0x20
> >  [<ffffffff8052c6d4>] kernel_init+0x154/0x330
> >  [<ffffffff8020a958>] child_rip+0xa/0x12
> >  [<ffffffff803212ac>] acpi_ds_init_one_object+0x0/0x7c
> >  [<ffffffff8052c580>] kernel_init+0x0/0x330
> >  [<ffffffff8020a94e>] child_rip+0x0/0x12
> >
> > PCI-GART: No AMD northbridge found.
> > hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> > hpet0: 3 64-bit timers, 14318180 Hz
>
> but the machine continues to work (I'm typing on it right now).  In
> fact, I only noticed while checking on some SATA stuff :)

Does http://lkml.org/lkml/2007/5/16/350 fix this?

Satyam
