Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbYG2Foa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbYG2Foa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 01:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbYG2FoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 01:44:05 -0400
Received: from sh.osrg.net ([192.16.179.4]:47097 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633AbYG2FoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 01:44:04 -0400
Date: Tue, 29 Jul 2008 14:42:48 +0900
To: davem@davemloft.net
Cc: sfr@canb.auug.org.au, fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu,
       joerg.roedel@amd.com, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       jbarnes@virtuousgeek.org, linux-next@vger.kernel.org
Subject: Re: [PATCH] add iommu_num_pages helper function
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080728.222439.176200666.davem@davemloft.net>
References: <20080729104722H.fujita.tomonori@lab.ntt.co.jp>
	<20080729135652.f89042c1.sfr@canb.auug.org.au>
	<20080728.222439.176200666.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080729144330C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 22:24:39 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 29 Jul 2008 13:56:52 +1000
> 
> > Um, did you see the linux-next build report I posted (possibly not):
> > 
> > arch/powerpc/kernel/iommu.c:56: error: static declaration of 'iommu_num_pages' follows non-static declaration
> > include/linux/iommu-helper.h:11: error: previous declaration of 'iommu_num_pages' was here
> > 
> > This is now a build of 2.6.27-rc1 for powerpc64 ppc64_defconfig ...
> 
> It breaks sparc64 the same exact way. :-/

Yeah, it breaks both. It's not a proper helper function that all the
architectures can use so how about making it x86 stuff?

http://marc.info/?l=linux-kernel&m=121730644704448&w=2
