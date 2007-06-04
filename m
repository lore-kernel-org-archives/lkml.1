Return-Path: <linux-kernel-owner+w=401wt.eu-S1760655AbXFDXbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760655AbXFDXbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 19:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbXFDXbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 19:31:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:51696 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494AbXFDXbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 19:31:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,382,1175497200"; 
   d="scan'208";a="235510355"
Date: Mon, 4 Jun 2007 16:27:36 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] stop x86 ->sysdata abuse; introduce pci_sysdata
Message-ID: <20070604232736.GA11981@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <11798211643534-git-send-email-muli@il.ibm.com> <11798211643659-git-send-email-muli@il.ibm.com> <11798211643144-git-send-email-muli@il.ibm.com> <11798211663773-git-send-email-muli@il.ibm.com> <1179821166685-git-send-email-muli@il.ibm.com> <11798211661041-git-send-email-muli@il.ibm.com> <20070604113344.0e71ca8c.akpm@linux-foundation.org> <20070604190654.GA20299@havoc.gtf.org> <20070604191346.GL4556@rhun.ibm.com> <20070604210551.GH20299@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604210551.GH20299@havoc.gtf.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 05:05:51PM -0400, Jeff Garzik wrote:
> 
> This patch introduces struct pci_sysdata to x86 and x86-64, and
> converts the existing two users (NUMA, Calgary) to use it.
> 
> This eliminates the conflict between NUMA and Calgary using the same
> pointer for different uses, and lays the groundwork for adding x86
> PCI domain support.
> 
> Signed-off-by: Jeff Garzik <jeff@garzik.org>
> 
> ---
> 
> NOTE:  This patch is untested, extract from the larger changes found in
> jgarzik/misc-2.6.git#pciseg.  Hopefully NUMA and/or Calgary users will
> test and ack this, then build patches on top of it.

Looks like the recently announced Intel-IOMMU too (just like Calgary)
depends on sysdata. I will modify my Intel-IOMMU accordingly and 
will let you know how it goes with your patch.

thanks,
Anil
