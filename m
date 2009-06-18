Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbZFRSO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbZFRSO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 14:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbZFRSOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 14:14:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:13481 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355AbZFRSOu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 14:14:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,246,1243839600"; 
   d="scan'208";a="525956500"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "'Muli Ben-Yehuda'" <muli@il.ibm.com>
CC: "'David Woodhouse'" <dwmw2@infradead.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'Christopher Wright'" <chrisw@redhat.com>,
       "Kay, Allen M" <allen.m.kay@intel.com>,
       "'lkml'" <linux-kernel@vger.kernel.org>,
       "'iommu'" <iommu@lists.linux-foundation.org>
Date: Thu, 18 Jun 2009 11:14:51 -0700
Subject: RE: [PATCH 1/2] IOMMU Identity Mapping Support:
	iommu_identity_mapping definition
Thread-Topic: [PATCH 1/2] IOMMU Identity Mapping Support:
	iommu_identity_mapping definition
Thread-Index: AcnwQD5RhOXrHh/NTPuInTelsfnY3QAAAfgA
Message-ID: <A6AD88C3F2289247BE726C37303E1EB8B0044EC0@orsmsx505.amr.corp.intel.com>
References: <20090327212241.234500000@intel.com>
 <20090327212321.070229000@intel.com>
 <20090416001957.GA1527@linux-os.sc.intel.com>
 <1240135508.3589.75.camel@macbook.infradead.org>
 <A6AD88C3F2289247BE726C37303E1EB8A4DF7DB1@orsmsx505.amr.corp.intel.com>
 <20090513231351.GA22386@linux-os.sc.intel.com>
 <1242314271.3393.11.camel@macbook.infradead.org>
 <20090514175944.GA5168@linux-os.sc.intel.com>
 <20090618180514.GA24082@linux-os.sc.intel.com>
 <20090618180835.GB6838@il.ibm.com>
In-Reply-To: <20090618180835.GB6838@il.ibm.com>
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

>
>On Thu, Jun 18, 2009 at 11:05:14AM -0700, Fenghua Yu wrote:
>
>> IOMMU Identity Mapping Support: iommu_identity_mapping definition
>>
>> Identity mapping for IOMMU defines a single domain to 1:1 map all
>> pci devices to all usable memory.
>
>Why use VT-d at all in this case? Do you have a use-case in mind?

Some users want to use VT-d in KVM but are concerned of DMA remapping performance. They can use identity mapping and still have KVM on VT-d. They can also use pass through patch (sent out before) if hardware supports pass through.

By default, identity mapping is turned off. "iommu=identity" can turn it on

Thanks.

-Fenghua
