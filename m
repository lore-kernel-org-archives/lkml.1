Return-Path: <linux-kernel-owner+w=401wt.eu-S1752215AbYJTArO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbYJTArO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 20:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYJTAq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 20:46:58 -0400
Received: from sh.osrg.net ([192.16.179.4]:43358 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbYJTAq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 20:46:58 -0400
Date: Mon, 20 Oct 2008 09:46:06 +0900
To: dwmw2@infradead.org
Cc: joro@8bytes.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, fenghua.yu@intel.com, tony.luck@intel.com,
       suresh.b.siddha@intel.com, sfr@canb.auug.org.au,
       andreas.herrmann3@amd.com, joseph.cihula@intel.com,
       akpm@linux-foundation.org, jbarnes@virtuousgeek.org, tglx@linutronix.de,
       torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: [ANNOUNCE] iommu-2.6.git tree
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1224415198.6770.1464.camel@macbook.infradead.org>
References: <1224343843.6770.1378.camel@macbook.infradead.org>
	<20081019111203.GB29705@8bytes.org>
	<1224415198.6770.1464.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081020094441G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Oct 2008 12:19:58 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> The Intel IOMMU appears on IA64 too, and doesn't want to be developed
> and tested off in an x86-specific corner by itself. And I'm going to be
> looking at other generic things we can do to improve IOMMU-related
> performance, which will touch on other architectures too.

Any plan to replace the current rb tree algorithm that VT-d
IOMMU implementation uses with the bitmap algorithm that the rest of
the IOMMU implementations use?

http://lkml.org/lkml/2008/6/4/250
