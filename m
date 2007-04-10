Return-Path: <linux-kernel-owner+w=401wt.eu-S1752700AbXDJIbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbXDJIbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 04:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXDJIbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 04:31:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:1163 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752820AbXDJIbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 04:31:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,389,1170662400"; 
   d="scan'208"; a="227575759:sNHT18577923"
Subject: Re: [patch 0/8] [Intel IOMMU] Support for Intel Virtualization
	Technology for Directed I/O
From: Shaohua Li <shaohua.li@intel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Ashok Raj <ashok.raj@intel.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <461B4925.9080005@garzik.org>
References: <20070409215552.221374000@intel.com>
	 <461B4925.9080005@garzik.org>
Content-Type: text/plain
Date: Tue, 10 Apr 2007 16:27:53 +0800
Message-Id: <1176193673.6781.24.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-10 at 04:21 -0400, Jeff Garzik wrote:
> Ashok Raj wrote:
> > 1. Support for ACPI framework to parse and work with DMA Remapping Tables.
> > 2. Add support for PCI infrastructure to search parent relationships.
> > 3. Hardware support for providing DMA remapping support for Intel Chipsets.
> > 4. Supporting Zero Length Reads on DMAR's not able to support ZLR.
> > 5. Graphics driver workarounds to provide unity map since they dont use dma api.
> > 6. Updates to Documentation area for startup options and some basics.
> > 7. Workaround to provide unity map for ISA bridge device to enable floppy disk.
> > 8. Ability to preserve some mappings for devices not able to address entire 
> >    range.
> 
> I really think it would be best to avoid ACPI for something as critical 
> as DMA remapping!
DMA remapping just uses ACPI table to tell which dma remapping engine a
pci device is controlled by at boot time. At run time, DMA remapping
hasn't any interactive with ACPI.

Thanks,
Shaohua
