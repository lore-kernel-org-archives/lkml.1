Return-Path: <linux-kernel-owner+w=401wt.eu-S1762959AbXILBSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762959AbXILBSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 21:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755000AbXILBSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 21:18:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:11711 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875AbXILBSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 21:18:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,240,1186383600"; 
   d="scan'208";a="133320038"
Date: Wed, 12 Sep 2007 18:29:53 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Paul Mackerras <paulus@samba.org>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>, akpm@osdl.org,
       Greg KH <greg@kroah.com>, muli@il.ibm.com,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       kristen.c.accardi@intel.com
Subject: Re: [patch][Intel-IOMMU] Fix for IOMMU early crash
Message-ID: <20070913012952.GA958@askeshav-devel.jf.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070908200523.GA16204@askeshav-devel.jf.intel.com> <18148.12140.21118.252581@cargo.ozlabs.ibm.com> <20070911174231.GC24627@askeshav-devel.jf.intel.com> <20070912192854.GA32610@askeshav-devel.jf.intel.com> <18150.61732.490669.269794@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18150.61732.490669.269794@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 05:48:52AM +1000, Paul Mackerras wrote:
> Keshavamurthy, Anil S writes:
> 
> > Subject: Fix IOMMU early crash
> > 
> > This patch avoids copying pci_bus's->sysdata to
> > pci_dev's->sysdata as one can easily obtain
> > the same through pci_dev->bus->sysdata.
> 
> At the moment this will cause ppc64 to crash, since we rely on
> pci_dev->sysdata pointing to some node in the firmware device tree,
> either the device's node or the node for a parent bus.
> 
> We could change the ppc64 code to use pci_dev->bus->sysdata in the
> case when pci_dev->sysdata is NULL, which would fix the problem.  I
> think that change should be incorporated as part of this patch so that
> we don't break git bisection.
Can I expect the ppc64 code changes from you? 
Once I get your, I will merge with mine and post it again.
> 
> In other words I don't want to see this patch applied as it stands.
Yup, I agree with you.

-Anil
