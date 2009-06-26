Return-Path: <linux-kernel-owner+w=401wt.eu-S1759396AbZFZSVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396AbZFZSVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 14:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755046AbZFZSVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 14:21:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:44689 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbZFZSVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 14:21:46 -0400
Subject: RE: [PATCH v2] IA64 Compilation Error Fix for Intel IOMMU Identity
 Mapping Support
From: David Woodhouse <dwmw2@infradead.org>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: "'FUJITA Tomonori'" <fujita.tomonori@lab.ntt.co.jp>,
       "'chrisw@redhat.com'" <chrisw@redhat.com>,
       "'torvalds@linux-foundation.org'" <torvalds@linux-foundation.org>,
       "'akpm@linux-foundation.org'" <akpm@linux-foundation.org>,
       "Luck, Tony" <tony.luck@intel.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'linux-ia64@vger.kernel.org'" <linux-ia64@vger.kernel.org>
In-Reply-To: <A6AD88C3F2289247BE726C37303E1EB8B0216BF5@orsmsx505.amr.corp.intel.com>
References: <20090625003841.GA12226@linux-os.sc.intel.com>
	 <20090625095643F.fujita.tomonori@lab.ntt.co.jp>
	 <20090625041605.GA9330@linux-os.sc.intel.com>
	 <20090625134827W.fujita.tomonori@lab.ntt.co.jp>
	 <1245913886.17089.91.camel@macbook.infradead.org>
	 <1245966743.30355.42.camel@macbook.infradead.org>
	 <A6AD88C3F2289247BE726C37303E1EB8B0216BF5@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 19:21:28 +0100
Message-Id: <1246040488.663.51.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 14:56 -0700, Yu, Fenghua wrote:
> 
> >(Fenghua, why are we doing the whole setup per pci dev anyway -- why
> not
> >set up the page tables once and point all devices at the same page
> >tables?)
> >
> 
> That's what the ia64 fix patch does...the first pci device set up the
> page table. Then all following pci devices use that page table by
> setting up the context mapping.

I've sorted that out separately -- it's not necessarily part of this
fix, although it _would_ be nice to have it in 2.6.31, since your
original 1:1 mapping patch is quite slow (and takes quite a lot of
memory) without it.

This time, I _am_ going to let it bake in linux-next for a while first
though.

Until Linus pulls the IA64 build fix from the real iommu-2.6.git tree,
I've put this into git://git.infradead.org/~dwmw2/iommu-pt.git

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

