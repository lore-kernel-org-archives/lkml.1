Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbZHMRaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbZHMRaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 13:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227AbZHMRay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 13:30:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:20335 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755164AbZHMRax convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 13:30:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,375,1246863600"; 
   d="scan'208";a="716574803"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "'David Woodhouse'" <dwmw2@infradead.org>,
       "'Luming Yu'" <luming.yu@gmail.com>
CC: "'FUJITA Tomonori'" <fujita.tomonori@lab.ntt.co.jp>,
       "Luck, Tony" <tony.luck@intel.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'akpm@linux-foundation.org'" <akpm@linux-foundation.org>
Date: Thu, 13 Aug 2009 10:30:46 -0700
Subject: RE: [RFC patch] init default dma_ops to prepare intel_iommu_init
  failure
Thread-Topic: [RFC patch] init default dma_ops to prepare intel_iommu_init
  failure
Thread-Index: AcocOK56QyUyEZTiQquctGeqDdhf5wAASi3g
Message-ID: <A6AD88C3F2289247BE726C37303E1EB8B3B2F7CB@orsmsx505.amr.corp.intel.com>
References: <3877989d0908130003i295cc7f2q343ad2446d0d51ff@mail.gmail.com>
	 <20090813161407A.fujita.tomonori@lab.ntt.co.jp>
	 <3877989d0908130037j5f9b1594q61e51c544a254b68@mail.gmail.com>
	 <20090813170227V.fujita.tomonori@lab.ntt.co.jp>
	 <3877989d0908130111m1a7d8625ha84ed1732a7eae81@mail.gmail.com>
	 <1250153373.29180.225.camel@macbook.infradead.org>
	 <3877989d0908130200k6d016a74w1947dc6bcd368a7f@mail.gmail.com>
 <1250183298.29180.853.camel@macbook.infradead.org>
In-Reply-To: <1250183298.29180.853.camel@macbook.infradead.org>
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

>-----Original Message-----
>From: David Woodhouse [mailto:dwmw2@infradead.org]
>Sent: Thursday, August 13, 2009 10:08 AM
>To: Luming Yu
>Cc: FUJITA Tomonori; Yu, Fenghua; Luck, Tony; linux-kernel@vger.kernel.org;
>akpm@linux-foundation.org
>Subject: Re: [RFC patch] init default dma_ops to prepare intel_iommu_init
>failure
>
>On Thu, 2009-08-13 at 17:00 +0800, Luming Yu wrote:
>> Yes the flood of dmar_fault on my HP compaq Dc7800u (my x86_64 linux
>> desktop) has been fixed. But I still have an iommu casued boot problem
>> on a ia64 box.
>
>Really? Even after http://git.kernel.org/linus/51b89f7a6615 ?]
>
>Fenghua will be very interested if that's true. I'm not -- I just hate
>you for having the hardware. :)
>

The latest upstream tree has three patches to fix the iommu boot issue on ia64. Except the above one, the other two patches are:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=33041ec049d39a6e0463c7edc7b6f631d24559e3

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f532959b77e5e567c84c914cb7c7b07d2582448b

Please checkout the latest upstream tree and have a try.

Thanks.

-Fenghua
