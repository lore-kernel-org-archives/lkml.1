Return-Path: <linux-kernel-owner+w=401wt.eu-S1755133AbZA0RSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbZA0RSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 12:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756995AbZA0RSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 12:18:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:29751 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756865AbZA0RSP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 12:18:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,332,1231142400"; 
   d="scan'208";a="485015704"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Date: Tue, 27 Jan 2009 09:17:58 -0800
Subject: RE: [PATCH -tip] IA64: fix the compile error on IA64_DIG_VTD
Thread-Topic: [PATCH -tip] IA64: fix the compile error on IA64_DIG_VTD
Thread-Index: AcmAjhwcNWA4XVc0TLasEqIj/UP2XwAE7I2g
Message-ID: <57C9024A16AD2D4C97DC78E552063EA35F1F9A94@orsmsx505.amr.corp.intel.com>
References: <20090127233530U.fujita.tomonori@lab.ntt.co.jp>
 <20090127144602.GA12183@elte.hu> <20090127144637.GA14728@elte.hu>
In-Reply-To: <20090127144637.GA14728@elte.hu>
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

> > > ---
> > >  arch/ia64/kernel/dma-mapping.c |    3 +++
> > >  arch/ia64/kernel/pci-swiotlb.c |    3 ---
> > >  2 files changed, 3 insertions(+), 3 deletions(-)
> >
> > Applied to tip/core/iommu, thanks!
>
> Tony, is this fix fine with you too?

It works ... and dma-mapping.c is OK as a location for the
definition.  But there seemes to be some small scope for a
related cleanup:

There are "extern" declarations for "iommu_detected" in both
<asm/iommu.h> (x86 and ia64) and also in <linux/dmar.h>

Does having both of these avoid some #include hell?

-Tony
