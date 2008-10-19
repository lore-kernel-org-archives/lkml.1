Return-Path: <linux-kernel-owner+w=401wt.eu-S1751974AbYJSRnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbYJSRnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 13:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYJSRnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 13:43:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40659 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbYJSRnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 13:43:05 -0400
Subject: Re: [ANNOUNCE] iommu-2.6.git tree
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Joerg Roedel <joro@8bytes.org>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, fenghua.yu@intel.com, tony.luck@intel.com,
       suresh.b.siddha@intel.com, sfr@canb.auug.org.au,
       andreas.herrmann3@amd.com, joseph.cihula@intel.com,
       akpm@linux-foundation.org, jbarnes@virtuousgeek.org, tglx@linutronix.de,
       torvalds@linux-foundation.org
In-Reply-To: <20081019172651.GA19265@elte.hu>
References: <1224343843.6770.1378.camel@macbook.infradead.org>
	 <20081019111203.GB29705@8bytes.org>
	 <1224415198.6770.1464.camel@macbook.infradead.org>
	 <20081019124732.GA21115@elte.hu>
	 <1224422474.6770.1475.camel@macbook.infradead.org>
	 <20081019172651.GA19265@elte.hu>
Content-Type: text/plain
Date: Sun, 19 Oct 2008 18:42:44 +0100
Message-Id: <1224438164.6770.1493.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-10-19 at 19:26 +0200, Ingo Molnar wrote:
> * David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > On Sun, 2008-10-19 at 14:47 +0200, Ingo Molnar wrote:
> > > * David Woodhouse <dwmw2@infradead.org> wrote:
> > > 
> > > > On Sun, 2008-10-19 at 13:12 +0200, Joerg Roedel wrote:
> > > > > On Sat, Oct 18, 2008 at 04:30:43PM +0100, David Woodhouse wrote:
> > > > > > As previously threatened, I've created an iommu-2.6.git tree:
> > > > > > 	git://git.infradead.org/iommu-2.6.git
> > > > > > 	http://git.infradead.org/iommu-2.6.git
> > > > > 
> > > > > Is there a specific reason why IOMMU stuff should go to Linus 
> > > > > without testing them in the x86 tree before? The DMA layer and IOMMU 
> > > > > drivers are an integral component of the architecture and patches 
> > > > > for it are best placed in the architecture tree instead of a 
> > > > > seperate one, imho.
> > > > 
> > > > This is the purpose that linux-next serves, not the x86 
> > > > forest-of-doom.
> > > > 
> > > > And I thought Ingo said his old iommu tree wasn't in there anyway? 
> > > > [...]
> > > 
> > > That's weird, where did you get the impression from that i "dropped" the 
> > > "old" IOMMU tree? It's alive and kicking, all the new IOMMU code that we 
> > > queued up and tested in the last cycle for v2.6.28 have just gone 
> > > upstream - about 80 commits.
> > 
> > I cannot find the tree which allegedly already exists [...]
> 
> it's tip/auto-iommu-next.

I have no idea what that means.

I tried 'locate auto-iommu-next' on master.kernel.org, but that doesn't
seem to find anything -- is it elsewhere?

Can you give a proper URL for a git tree, with a description explaining
its nature, and everything that one would normally expect from a git
tree?

> > [...] -- and unless I'm mistaken, a number of patches seem to have 
> > fallen through the cracks in the last few weeks. Since I've been asked 
> > to start looking after the Intel IOMMU parts, it seemed sensible to 
> > make a git tree and round up those patches.
> 
> hm, no patches have been lost that i'm aware of - the last ~10 days of 
> inbox is not queued up yet because of the merge window - but those 
> (except for urgent fixes) are v2.6.29 items anyway.

There were patches outstanding which depended on both the interrupt
remapping and the KVM work. And which add IA64 support for VT-d.

> > I thought you and Thomas were working together, and I spoke to Thomas 
> > about it during the Kernel Summit. Unless I'm very much mistaken, he 
> > agreed that it makes sense to have a separate, real, git tree for 
> > cross-platform IOMMU-related work.
> > 
> > If you want to pull that tree into yours, that's fine by me -- as long 
> > as it gets into linux-next.
> 
> okay, we can certainly do that. And if/when all future activities center 
> around your tree, and there's no interaction with x86 platform bits, it 
> will be natural for you to just not go over any middlemen.
> 
> But i'd prefer to at least have some transitionary period - IOMMU 
> changes are not easy topics and they caused subtle breakages a couple of 
> times and it was quite handy that those breakages were generally seen by 
> all x86 developers (and immediately fixed afterwards). 99% of the 
> current iommu development activities are in the x86 space, so there's 
> quite some alignment there.

Again, isn't this what linux-next is for? But if you want to pull it
into your own linux-next-but-only-for-x86 tree, then that's fine too; as
I said.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

