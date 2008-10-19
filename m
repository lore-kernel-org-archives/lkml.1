Return-Path: <linux-kernel-owner+w=401wt.eu-S1752136AbYJSVO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbYJSVO7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 17:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYJSVOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 17:14:52 -0400
Received: from 8bytes.org ([88.198.83.132]:56761 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbYJSVOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 17:14:51 -0400
Date: Sun, 19 Oct 2008 23:14:49 +0200
From: Joerg Roedel <joro@8bytes.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       fenghua.yu@intel.com, tony.luck@intel.com, suresh.b.siddha@intel.com,
       sfr@canb.auug.org.au, andreas.herrmann3@amd.com,
       joseph.cihula@intel.com, akpm@linux-foundation.org,
       jbarnes@virtuousgeek.org, tglx@linutronix.de,
       torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: [ANNOUNCE] iommu-2.6.git tree
Message-ID: <20081019211449.GG21841@8bytes.org>
References: <1224343843.6770.1378.camel@macbook.infradead.org> <20081019111203.GB29705@8bytes.org> <1224415198.6770.1464.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224415198.6770.1464.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2008 at 12:19:58PM +0100, David Woodhouse wrote:
> On Sun, 2008-10-19 at 13:12 +0200, Joerg Roedel wrote:
> > On Sat, Oct 18, 2008 at 04:30:43PM +0100, David Woodhouse wrote:
> > > As previously threatened, I've created an iommu-2.6.git tree:
> > > 	git://git.infradead.org/iommu-2.6.git
> > > 	http://git.infradead.org/iommu-2.6.git
> > 
> > Is there a specific reason why IOMMU stuff should go to Linus without
> > testing them in the x86 tree before? The DMA layer and IOMMU drivers are
> > an integral component of the architecture and patches for it are best
> > placed in the architecture tree instead of a seperate one, imho.
> 
> This is the purpose that linux-next serves, not the x86 forest-of-doom.
> 
> And I thought Ingo said his old iommu tree wasn't in there anyway? He
> said it was somewhere else, although I haven't actually managed to
> _find_ it.

Its quite easy to learn the workflow of the x86 maintainers with the
-tip tree. Just ask them, they are very responsive and friendly. I
personally like that workflow with lots of topic branches.  It gives a
clear history of development.

> The Intel IOMMU appears on IA64 too, and doesn't want to be developed
> and tested off in an x86-specific corner by itself.

This is a reason for a seperate Intel IOMMU tree which is pulled by
Linus. But I don't think that this is a reason to take over control of
all IOMMU development.

> And I'm going to be looking at other generic things we can do to
> improve IOMMU-related performance, which will touch on other
> architectures too.

As IOMMU infrastructure is architecture-local in Linux (except the
very high level interface -> DMA-API) there is not much room for
optimization which will touch multiple architectures. If Intel IOMMU is
available on x86 and ia64 its definitly different for that driver. This
is another reason for a seperate Intel IOMMU tree.

Joerg

