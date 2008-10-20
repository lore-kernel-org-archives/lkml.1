Return-Path: <linux-kernel-owner+w=401wt.eu-S1753035AbYJTQmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbYJTQmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 12:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbYJTQlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 12:41:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:22277 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbYJTQlw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 12:41:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,453,1220252400"; 
   d="scan'208";a="629418209"
From: "Luck, Tony" <tony.luck@intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
       "andreas.herrmann3@amd.com" <andreas.herrmann3@amd.com>,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Date: Mon, 20 Oct 2008 09:41:34 -0700
Subject: RE: [ANNOUNCE] iommu-2.6.git tree
Thread-Topic: [ANNOUNCE] iommu-2.6.git tree
Thread-Index: AckyMMljl8dG+NCaQfWCGYRD6lye8QAoGC2A
Message-ID: <57C9024A16AD2D4C97DC78E552063EA353345EF3@orsmsx505.amr.corp.intel.com>
References: <1224343843.6770.1378.camel@macbook.infradead.org>
 <20081019111203.GB29705@8bytes.org>
 <1224415198.6770.1464.camel@macbook.infradead.org>
 <20081019124732.GA21115@elte.hu>
 <1224422474.6770.1475.camel@macbook.infradead.org>
 <20081019172651.GA19265@elte.hu>
 <1224438164.6770.1493.camel@macbook.infradead.org>
 <20081019212222.GH21841@8bytes.org>
In-Reply-To: <20081019212222.GH21841@8bytes.org>
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

> The x86 maintainers are not responsible for IA64 patches AFAIK. The KVM
> work will be merged by Avi.
       ^^^^^^^

FYI: This part appears to have already happened:

$ git log v2.6.27.. | grep KVM.*ia64
      KVM: ia64: Add intel iommu support for guests.
      KVM: ia64: add directed mmio range support for kvm guests
      KVM: ia64: Make pmt table be able to hold physical mmio entries.
    KVM: ia64: Add intel iommu support for guests.
    KVM: ia64: add directed mmio range support for kvm guests
    KVM: ia64: Make pmt table be able to hold physical mmio entries.
    KVM: ia64: add support for Tukwila processors
    KVM: ia64: Implement a uniform vps interface
    KVM: ia64: Implement kvm_arch_vcpu_ioctl_{set,get}_mpstate
    KVM: ia64: Enable virtio driver for ia64 in Kconfig
    KVM: ia64: add a dummy irq ack notification

I have some extra ia64 bits queued in my tree (that are in today's
linux-next tree tagged "next-20081020").  These parts build OK by
themselves, but CONFIG_DMAR can't be turned on until the pieces that
David has in his tree are merged too (e.g. the parts that make
the driver work for systems where PAGESIZE may be something other
than 4K).

-Tony
