Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbYJTSGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbYJTSGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 14:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYJTSGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 14:06:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:43483 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298AbYJTSGT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 14:06:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,453,1220252400"; 
   d="scan'208";a="393848566"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "'FUJITA Tomonori'" <fujita.tomonori@lab.ntt.co.jp>,
       "'joro@8bytes.org'" <joro@8bytes.org>
CC: "'dwmw2@infradead.org'" <dwmw2@infradead.org>,
       "'mingo@elte.hu'" <mingo@elte.hu>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "Luck, Tony" <tony.luck@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "'sfr@canb.auug.org.au'" <sfr@canb.auug.org.au>,
       "'andreas.herrmann3@amd.com'" <andreas.herrmann3@amd.com>,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       "'akpm@linux-foundation.org'" <akpm@linux-foundation.org>,
       "'jbarnes@virtuousgeek.org'" <jbarnes@virtuousgeek.org>,
       "'tglx@linutronix.de'" <tglx@linutronix.de>,
       "'torvalds@linux-foundation.org'" <torvalds@linux-foundation.org>
Date: Mon, 20 Oct 2008 11:06:15 -0700
Subject: RE: [ANNOUNCE] iommu-2.6.git tree
Thread-Topic: [ANNOUNCE] iommu-2.6.git tree
Thread-Index: AckyZJMelqW9euLUThiN5cPYQ334jAAeJ8NA
Message-ID: <A6AD88C3F2289247BE726C37303E1EB8848EC07E@orsmsx505.amr.corp.intel.com>
References: <20081019124732.GA21115@elte.hu>
	<1224422474.6770.1475.camel@macbook.infradead.org>
	<20081019212327.GI21841@8bytes.org>
 <20081020123245J.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081020123245J.fujita.tomonori@lab.ntt.co.jp>
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

>IA64 and PARISC uses the same IOMMU hardware but they duplicate the
>driver for them (the drivers are very similar). Calgary and POWER also
>have similar IOMMU drivers. But I don't think it's worth merging them.

If you are talking about IA64 HP ZX1, then it does have same IOMMU hardware as PARISC.

But now David is pushing Intel VT-d IOMMU code for IA64. The hardware and driver are different from HP or PARISC. The hardware is same as x86 VT-d and the driver is ported from x86 IOMMU driver.

Thanks.

-Fenghua
