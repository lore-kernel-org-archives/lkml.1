Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbXDJIAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbXDJIAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 04:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbXDJIAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 04:00:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:48190 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbXDJIAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 04:00:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,388,1170662400"; 
   d="scan'208"; a="227562671:sNHT671757933"
Subject: Re: [patch 0/8] [Intel IOMMU] Support for Intel Virtualization
	Technology for Directed I/O
From: Shaohua Li <shaohua.li@intel.com>
To: Andi Kleen <ak@suse.de>
Cc: Ashok Raj <ashok.raj@intel.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com
In-Reply-To: <200704100949.56130.ak@suse.de>
References: <20070409215552.221374000@intel.com>
	 <200704100949.56130.ak@suse.de>
Content-Type: text/plain
Date: Tue, 10 Apr 2007 15:57:28 +0800
Message-Id: <1176191848.6781.3.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-10 at 09:49 +0200, Andi Kleen wrote:
> On Monday 09 April 2007 23:55:52 Ashok Raj wrote:
> 
> > Please help review and provide feedback.
> 
> High level question: how did you solve the "user X server needs IOMMU bypass"
> problem?
Please see patch 5. We have two workarounds for graphics. One is
completely bypass dma remapping for gfx, this option only works for gfx
card with dedicated dma remapping engine. The other is doing 1-1 mapping
for whole physical memory address, then virtual dma address will equal
to physical address, so gfx can ignore iommu in the case.

Thanks,
Shaohua
