Return-Path: <linux-kernel-owner+w=401wt.eu-S932306AbXDJIKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbXDJIKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 04:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932190AbXDJIKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 04:10:06 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:6521 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306AbXDJIKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 04:10:03 -0400
Date: Tue, 10 Apr 2007 11:09:58 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Andi Kleen <ak@suse.de>, Ashok Raj <ashok.raj@intel.com>,
       linux-kernel@vger.kernel.org, akpm@osdl.org, gregkh@suse.de,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com
Subject: Re: [patch 0/8] [Intel IOMMU] Support for Intel Virtualization Technology for Directed I/O
Message-ID: <20070410080958.GM2972@rhun.haifa.ibm.com>
References: <20070409215552.221374000@intel.com> <200704100949.56130.ak@suse.de> <1176191848.6781.3.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1176191848.6781.3.camel@sli10-conroe.sh.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2007 at 03:57:28PM +0800, Shaohua Li wrote:
> On Tue, 2007-04-10 at 09:49 +0200, Andi Kleen wrote:
> > On Monday 09 April 2007 23:55:52 Ashok Raj wrote:
> > 
> > > Please help review and provide feedback.
> > 
> > High level question: how did you solve the "user X server needs IOMMU bypass"
> > problem?

> Please see patch 5. We have two workarounds for graphics. One is
> completely bypass dma remapping for gfx, this option only works for
> gfx card with dedicated dma remapping engine. The other is doing 1-1
> mapping for whole physical memory address, then virtual dma address
> will equal to physical address, so gfx can ignore iommu in the case.

Apologies but I've not had a chance to review the patches yet. Do you
special case the BDF of the graphics adpater (via PCI ID?), or does
the user need to provide a command line option to specify the graphics
adapter?

Cheers,
Muli
