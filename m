Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbZFRS2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbZFRS2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 14:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbZFRS2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 14:28:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:64665 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbZFRS2F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 14:28:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,246,1243839600"; 
   d="scan'208";a="467623931"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "'Chris Wright'" <chrisw@sous-sol.org>
CC: "'David Woodhouse'" <dwmw2@infradead.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'Christopher Wright'" <chrisw@redhat.com>,
       "Kay, Allen M" <allen.m.kay@intel.com>,
       "'iommu'" <iommu@lists.linux-foundation.org>,
       "'lkml'" <linux-kernel@vger.kernel.org>
Date: Thu, 18 Jun 2009 11:28:06 -0700
Subject: RE: [PATCH 1/2] IOMMU Identity Mapping Support:
	iommu_identity_mapping definition
Thread-Topic: [PATCH 1/2] IOMMU Identity Mapping Support:
	iommu_identity_mapping definition
Thread-Index: AcnwQLzCJyXyAkxXR/yXmqkW09C/4wAAGL9w
Message-ID: <A6AD88C3F2289247BE726C37303E1EB8B0044F04@orsmsx505.amr.corp.intel.com>
References: <20090327212241.234500000@intel.com>
 <20090327212321.070229000@intel.com>
 <20090416001957.GA1527@linux-os.sc.intel.com>
 <1240135508.3589.75.camel@macbook.infradead.org>
 <A6AD88C3F2289247BE726C37303E1EB8A4DF7DB1@orsmsx505.amr.corp.intel.com>
 <20090513231351.GA22386@linux-os.sc.intel.com>
 <1242314271.3393.11.camel@macbook.infradead.org>
 <20090514175944.GA5168@linux-os.sc.intel.com>
 <20090618180514.GA24082@linux-os.sc.intel.com>
 <20090618181335.GB19771@sequoia.sous-sol.org>
In-Reply-To: <20090618181335.GB19771@sequoia.sous-sol.org>
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

>>
>> The first patch defines iommu_identity_mapping varialbe which controls
>the
>> identity mapping code and is 0 by default.
>
>The only real difference between "pt" and "identity" is hardware support.
>We should have a single value we don't have to tell users to do different
>things depending on their hardware (they won't even know what they have)
>to achieve the same result.

Technically keeping two separate options in base kernel might be clear and easy to understand. A distro might merge them together or have other usage model.

Thanks.

-Fenghua
