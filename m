Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbYJDAxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbYJDAxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 20:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbYJDAxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 20:53:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:50351 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518AbYJDAxN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 20:53:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,359,1220252400"; 
   d="scan'208";a="343657349"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: "Luck, Tony" <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Date: Fri, 3 Oct 2008 17:53:04 -0700
Subject: RE: [PATCH 2/2]Add Variable Page Size and IA64 Support in Intel
 IOMMU: IA64 Specific Part
Thread-Topic: [PATCH 2/2]Add Variable Page Size and IA64 Support in Intel
 IOMMU: IA64 Specific Part
Thread-Index: AcklbpY/PXcsvRYFQGiMg1WYlb4xDAADl/NA
Message-ID: <A6AD88C3F2289247BE726C37303E1EB8844A6398@orsmsx505.amr.corp.intel.com>
References: <20081001165750.GA21272@linux-os.sc.intel.com>
 <200810020951.08408.bjorn.helgaas@hp.com>
 <A6AD88C3F2289247BE726C37303E1EB88408AA3E@orsmsx505.amr.corp.intel.com>
 <200810030941.42800.bjorn.helgaas@hp.com>
In-Reply-To: <200810030941.42800.bjorn.helgaas@hp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> >This patch adds clflush_cache_range(), but it's not used anywhere.
>> Clflush_cache_range() is used in __iommu_flush_cache() in include/linux/intel-iommu.h.

>Oh, OK.  I didn't look hard enough to find __iommu_flush_cache()
> (currently in drivers/pci/intel-iommu.c).

>Architecturally, I'm surprised that ia64 would need to actually do a
>cache flush.  I would think the VT-d hardware would do coherent accesses
>which would make the cache flush unnecessary.

VT-d hardware supports both non cache coherency and cache coherency by bit Coherency in Extended Capabilities Register.

Could you please point me to the doc that explicitly says that architecturally ia64 doesn't need cache flush?

Thanks.

-Fenghua
