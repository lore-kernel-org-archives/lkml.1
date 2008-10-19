Return-Path: <linux-kernel-owner+w=401wt.eu-S1751575AbYJSNVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbYJSNVh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 09:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbYJSNV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 09:21:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45347 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbYJSNV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 09:21:28 -0400
Subject: Re: [ANNOUNCE] iommu-2.6.git tree
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Joerg Roedel <joro@8bytes.org>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, fenghua.yu@intel.com, tony.luck@intel.com,
       suresh.b.siddha@intel.com, sfr@canb.auug.org.au,
       andreas.herrmann3@amd.com, joseph.cihula@intel.com,
       akpm@linux-foundation.org, jbarnes@virtuousgeek.org, tglx@linutronix.de,
       torvalds@linux-foundation.org
In-Reply-To: <20081019124732.GA21115@elte.hu>
References: <1224343843.6770.1378.camel@macbook.infradead.org>
	 <20081019111203.GB29705@8bytes.org>
	 <1224415198.6770.1464.camel@macbook.infradead.org>
	 <20081019124732.GA21115@elte.hu>
Content-Type: text/plain
Date: Sun, 19 Oct 2008 14:21:14 +0100
Message-Id: <1224422474.6770.1475.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-10-19 at 14:47 +0200, Ingo Molnar wrote:
> * David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > On Sun, 2008-10-19 at 13:12 +0200, Joerg Roedel wrote:
> > > On Sat, Oct 18, 2008 at 04:30:43PM +0100, David Woodhouse wrote:
> > > > As previously threatened, I've created an iommu-2.6.git tree:
> > > > 	git://git.infradead.org/iommu-2.6.git
> > > > 	http://git.infradead.org/iommu-2.6.git
> > > 
> > > Is there a specific reason why IOMMU stuff should go to Linus 
> > > without testing them in the x86 tree before? The DMA layer and IOMMU 
> > > drivers are an integral component of the architecture and patches 
> > > for it are best placed in the architecture tree instead of a 
> > > seperate one, imho.
> > 
> > This is the purpose that linux-next serves, not the x86 
> > forest-of-doom.
> > 
> > And I thought Ingo said his old iommu tree wasn't in there anyway? 
> > [...]
> 
> That's weird, where did you get the impression from that i "dropped" the 
> "old" IOMMU tree? It's alive and kicking, all the new IOMMU code that we 
> queued up and tested in the last cycle for v2.6.28 have just gone 
> upstream - about 80 commits.

I cannot find the tree which allegedly already exists -- and unless I'm
mistaken, a number of patches seem to have fallen through the cracks in
the last few weeks. Since I've been asked to start looking after the
Intel IOMMU parts, it seemed sensible to make a git tree and round up
those patches.

I thought you and Thomas were working together, and I spoke to Thomas
about it during the Kernel Summit. Unless I'm very much mistaken, he
agreed that it makes sense to have a separate, real, git tree for
cross-platform IOMMU-related work.

If you want to pull that tree into yours, that's fine by me -- as long
as it gets into linux-next.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

