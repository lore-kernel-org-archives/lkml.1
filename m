Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbZAIEwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbZAIEwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 23:52:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbZAIEwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 23:52:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55310 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbZAIEwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 23:52:31 -0500
Date: Thu, 8 Jan 2009 20:52:22 -0800
From: Dirk Hohndel <hohndel@infradead.org>
To: Dirk Hohndel <hohndel@infradead.org>
Cc: "Han, Weidong" <weidong.han@intel.com>,
       "'Grant Grundler'" <grundler@parisc-linux.org>,
       "'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'Jesse Barnes'" <jbarnes@virtuousgeek.org>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'Arjan van de Ven'" <arjan@infradead.org>
Subject: Re: git-latest: kernel oops in IOMMU setup
Message-ID: <20090108205222.2c89dcde@infradead.org>
In-Reply-To: <20090108180515.2f279671@infradead.org>
References: <20090108120538.0176d348@infradead.org>
	<20090108214116.GB20506@colo.lackof.org>
	<715D42877B251141A38726ABF5CABF2C018E8FEA77@pdsmsx503.ccr.corp.intel.com>
	<20090108180515.2f279671@infradead.org>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hohndel@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2009 18:05:15 -0800
Dirk Hohndel <hohndel@infradead.org> wrote:

> On Fri, 9 Jan 2009 08:58:46 +0800 "Han, Weidong"
> 
> I updated to Linus' latest git (as your description made me wonder if
> the async stuff might play a role here). I still get an oops - but at
> a different spot and the system no longer hangs - it partly recovers
> (but things aren't too well - for example my USB keyboard / mouse
> don't work anymore). 

Spoke too soon. Rebooted and had the same hard lockup again. This time
I had my camera within reach, so here's the trace:

device_to_iommu+0x33/0x73
domain_context_mapping_one+0x37/0x335
domain_context_mapping+0x25/0xa7
iommu_prepare_identity+0xd7/0xf3
intel_iommu_init+0x4e4/0x8f3
? mutex_lock
? sysctl_net_init
? pci_iommu_init
pci_iommu_init

I also have stack, code and register values. Let me know if you need
them. Or I can just post the picture :-)

Again, very latest git tree, VT-d enabled.

/D

-- 
Dirk Hohndel
Intel Open Source Technology Center
