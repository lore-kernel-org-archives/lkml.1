Return-Path: <linux-kernel-owner+w=401wt.eu-S1752421AbYJTDdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbYJTDdc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 23:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbYJTDdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 23:33:23 -0400
Received: from sh.osrg.net ([192.16.179.4]:56989 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbYJTDdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 23:33:23 -0400
Date: Mon, 20 Oct 2008 12:32:43 +0900
To: joro@8bytes.org
Cc: dwmw2@infradead.org, mingo@elte.hu, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, fenghua.yu@intel.com, tony.luck@intel.com,
       suresh.b.siddha@intel.com, sfr@canb.auug.org.au,
       andreas.herrmann3@amd.com, joseph.cihula@intel.com,
       akpm@linux-foundation.org, jbarnes@virtuousgeek.org, tglx@linutronix.de,
       torvalds@linux-foundation.org
Subject: Re: [ANNOUNCE] iommu-2.6.git tree
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081019212327.GI21841@8bytes.org>
References: <20081019124732.GA21115@elte.hu>
	<1224422474.6770.1475.camel@macbook.infradead.org>
	<20081019212327.GI21841@8bytes.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081020123245J.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Oct 2008 23:23:27 +0200
Joerg Roedel <joro@8bytes.org> wrote:

> On Sun, Oct 19, 2008 at 02:21:14PM +0100, David Woodhouse wrote:
> > I thought you and Thomas were working together, and I spoke to Thomas
> > about it during the Kernel Summit. Unless I'm very much mistaken, he
> > agreed that it makes sense to have a separate, real, git tree for
> > cross-platform IOMMU-related work.
> 
> Is there any cross-platform IOMMU-related work outside the Intel IOMMU
> development?

IA64 and PARISC uses the same IOMMU hardware but they duplicate the
driver for them (the drivers are very similar). Calgary and POWER also
have similar IOMMU drivers. But I don't think it's worth merging them.

Unless a new cross-platform IOMMU git tree handles DMA-API changes,
there is no point in having such new tree. There is very little
non-architecture-specific IOMMU stuff.
