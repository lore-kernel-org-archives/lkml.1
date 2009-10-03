Return-Path: <linux-kernel-owner+w=401wt.eu-S1755612AbZJCABH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbZJCABH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 20:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbZJCABG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 20:01:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:47751 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715AbZJCABF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 20:01:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,496,1249282800"; 
   d="scan'208";a="732615033"
Date: Fri, 2 Oct 2009 17:01:09 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Francois Isabelle <Francois.Isabelle@ca.kontron.com>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] pciehp_driver.c: PCIe hot plug for Intel iommu - call IOMMU API in hot remove
Message-ID: <20091003000109.GA19963@linux-os.sc.intel.com>
References: <72D8A09E39A89147BE9CFBB6F0C73C306073445396@rrsmsx501.amr.corp.intel.com> <6E2431EDEB6AE64F827F8A1B0D0DA1A603C322CF@azsmsx501.amr.corp.intel.com> <72D8A09E39A89147BE9CFBB6F0C73C30607344552A@rrsmsx501.amr.corp.intel.com> <20091002211844.GA14352@linux-os.sc.intel.com> <20091002215019.GB23379@8bytes.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091002215019.GB23379@8bytes.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> NACK!
> 
> This breaks with AMD IOMMU driver.
> Just implement a VT-d specific notifier callback for device removal on
> the pci bus.

You are right. Will change to AMD's method.

Thanks.

-Fenghua
