Return-Path: <linux-kernel-owner+w=401wt.eu-S1760246AbXFDXCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760246AbXFDXCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 19:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbXFDXB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 19:01:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:26780 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbXFDXB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 19:01:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,382,1175497200"; 
   d="scan'208";a="250790530"
Date: Mon, 4 Jun 2007 15:58:21 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: anil.s.keshavamurthy@intel.com, linux-kernel@vger.kernel.org,
       akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 01/10] DMAR detection and parsing logic
Message-ID: <20070604225820.GA9948@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070604210242.079459000@askeshav-devel.jf.intel.com> <20070604210644.076940000@askeshav-devel.jf.intel.com> <20070604225421.GL20299@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604225421.GL20299@havoc.gtf.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 06:54:21PM -0400, Jeff Garzik wrote:
> On Mon, Jun 04, 2007 at 02:02:43PM -0700, anil.s.keshavamurthy@intel.com wrote:
> > --- linux-2.6.22-rc3.orig/drivers/pci/Makefile	2007-06-04 12:28:13.000000000 -0700
> > +++ linux-2.6.22-rc3/drivers/pci/Makefile	2007-06-04 12:33:15.000000000 -0700
> > @@ -20,6 +20,9 @@
> >  # Build the Hypertransport interrupt support
> >  obj-$(CONFIG_HT_IRQ) += htirq.o
> >  
> > +# Build Intel IOMMU support
> > +obj-$(CONFIG_DMAR) += dmar.o
> 
> It's not Intel IOMMU support though, is it?
Yes, it is Intel IOMMU support.

> 
> It's x86 PCI IOMMU support (as opposed to x86 GART IOMMU).
> 
> I just want to avoid Intel branding on something that will not be
> specific to Intel-manufacured products in the long term.

This DMAR (DMA Remapping unit) is Intel specific and
its spec is available at www.intel.com/technology/virtualization

-Anil
