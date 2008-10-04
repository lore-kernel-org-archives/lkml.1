Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbYJDAVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbYJDAVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 20:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbYJDAVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 20:21:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:29168 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbYJDAVk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 20:21:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,359,1220252400"; 
   d="scan'208";a="54837838"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: "Luck, Tony" <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Date: Fri, 3 Oct 2008 17:21:36 -0700
Subject: RE: [PATCH 1/2]Add Variable Page Size and IA64 Support in Intel
 IOMMU: Generic Part
Thread-Topic: [PATCH 1/2]Add Variable Page Size and IA64 Support in Intel
 IOMMU: Generic Part
Thread-Index: AcklbV5MAZpOn9dVQ12fpl9B/z8RpQASNXHw
Message-ID: <A6AD88C3F2289247BE726C37303E1EB8844A637F@orsmsx505.amr.corp.intel.com>
References: <BAE9DCEF64577A439B3A37F36F9B691C0339372B@orsmsx418.amr.corp.intel.com>
 <200810020931.48952.bjorn.helgaas@hp.com>
 <A6AD88C3F2289247BE726C37303E1EB88408ADFF@orsmsx505.amr.corp.intel.com>
 <200810030933.10627.bjorn.helgaas@hp.com>
In-Reply-To: <200810030933.10627.bjorn.helgaas@hp.com>
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

>> >> The current Intel IOMMU code assumes that both host page size and Intel IOMMU page size are 4K. The first patch supports variable page size. This provides support for IA64 which has multiple page sizes.
>> >>
> >> This patch also adds some other code hooks for IA64 platform including DMAR_OPERATION_TIMEOUT definition, .
>>
>> >Can you split this patch up?  It contains several logically separate
>> changes:
>> >  - casting things to unsigned long long
>> >  - adding stuff under #ifdef CONFIG_IA64
>> >  - page size changes
>> >  - whitespace changes
>>
>> Depends on who is picking up the generic patch. If it's needed, I can >split it into multiple patches.

>Regardless of who's picking up the patch, splitting it makes it
>easier to review and easier to spot bugs, and makes bisection yield
>better information.

Since more than 95% of code in the patch is directly related to page size changes, splitting the patch will generate one big patch (95% of current patch size) and a few small patches. I would like to still send one single updated patch based on collected comments.

Thanks.

-Fenghua
