Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823AbYJTXxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbYJTXxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 19:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbYJTXxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 19:53:04 -0400
Received: from sh.osrg.net ([192.16.179.4]:56699 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbYJTXxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 19:53:02 -0400
Date: Tue, 21 Oct 2008 08:51:44 +0900
To: fenghua.yu@intel.com
Cc: fujita.tomonori@lab.ntt.co.jp, joro@8bytes.org, dwmw2@infradead.org,
       mingo@elte.hu, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, tony.luck@intel.com,
       suresh.b.siddha@intel.com, sfr@canb.auug.org.au,
       andreas.herrmann3@amd.com, joseph.cihula@intel.com,
       akpm@linux-foundation.org, jbarnes@virtuousgeek.org, tglx@linutronix.de,
       torvalds@linux-foundation.org
Subject: RE: [ANNOUNCE] iommu-2.6.git tree
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <A6AD88C3F2289247BE726C37303E1EB8848EC07E@orsmsx505.amr.corp.intel.com>
References: <20081019212327.GI21841@8bytes.org>
	<20081020123245J.fujita.tomonori@lab.ntt.co.jp>
	<A6AD88C3F2289247BE726C37303E1EB8848EC07E@orsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081021085211D.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2008 11:06:15 -0700
"Yu, Fenghua" <fenghua.yu@intel.com> wrote:

> >IA64 and PARISC uses the same IOMMU hardware but they duplicate the
> >driver for them (the drivers are very similar). Calgary and POWER also
> >have similar IOMMU drivers. But I don't think it's worth merging them.
> 
> If you are talking about IA64 HP ZX1, then it does have same IOMMU hardware as PARISC.

Yeah, I was talking about SBA.


> But now David is pushing Intel VT-d IOMMU code for IA64. The
> hardware and driver are different from HP or PARISC. The hardware is
> same as x86 VT-d and the driver is ported from x86 IOMMU driver.

Yeah, I know that.

I just tried to point out that there is no cross-platform
(architecture independent) IOMMU stuff and David's new git tree should
be VT-d git tree, not a tree for architecture independent IOMMU stuff.
