Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbZFRTKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbZFRTKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 15:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbZFRTJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 15:09:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:33401 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbZFRTJ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 15:09:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,246,1243839600"; 
   d="scan'208";a="156136862"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "'Chris Wright'" <chrisw@redhat.com>,
       "'Muli Ben-Yehuda'" <muli@il.ibm.com>
CC: "'David Woodhouse'" <dwmw2@infradead.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Ingo Molnar'" <mingo@elte.hu>, "Kay, Allen M" <allen.m.kay@intel.com>,
       "'lkml'" <linux-kernel@vger.kernel.org>,
       "'iommu'" <iommu@lists.linux-foundation.org>
Date: Thu, 18 Jun 2009 12:09:56 -0700
Subject: RE: [PATCH 1/2] IOMMU Identity Mapping Support:
	iommu_identity_mapping definition
Thread-Topic: [PATCH 1/2] IOMMU Identity Mapping Support:
	iommu_identity_mapping definition
Thread-Index: AcnwRd+5WZBLTONITv2GHwCGn2svUQAAdHhw
Message-ID: <A6AD88C3F2289247BE726C37303E1EB8B0044FC5@orsmsx505.amr.corp.intel.com>
References: <A6AD88C3F2289247BE726C37303E1EB8A4DF7DB1@orsmsx505.amr.corp.intel.com>
 <20090513231351.GA22386@linux-os.sc.intel.com>
 <1242314271.3393.11.camel@macbook.infradead.org>
 <20090514175944.GA5168@linux-os.sc.intel.com>
 <20090618180514.GA24082@linux-os.sc.intel.com>
 <20090618180835.GB6838@il.ibm.com>
 <A6AD88C3F2289247BE726C37303E1EB8B0044EC0@orsmsx505.amr.corp.intel.com>
 <20090618182545.GC6838@il.ibm.com> <20090618183121.GB2500@x200.localdomain>
 <20090618184101.GE6838@il.ibm.com> <20090618185115.GC2500@x200.localdomain>
In-Reply-To: <20090618185115.GC2500@x200.localdomain>
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

>> mapping. Instead of a global command line option, we need to provide a
>> way to enable/disable pt or identity mapping (I agree that the user
>> shouldn't know or care which is used, the kernel should pick the best
>> one automatically) on a per BDF basis.
>
>Yeah, that's a possible enhancement.  Although once you've disabled one
>device's isolation you've created a hole...
>
The isolation hole is not much better than a global 1:1 mapping. If one device is 1:1 mapped to all memory. All of other devices can access part of this device's DMA range. And this device can access all of other devices' DMA range. Only better place than a global 1:1 mapping is all of other devices are isolated from each other.

Thanks.

-Fenghua
