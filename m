Return-Path: <linux-kernel-owner+w=401wt.eu-S1756284AbYHVHKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbYHVHKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 03:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbYHVHKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 03:10:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51865 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755659AbYHVHKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 03:10:13 -0400
Date: Fri, 22 Aug 2008 09:09:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, joerg.roedel@amd.com,
       mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com
Subject: Re: [PATCH 0/8] x86 dma_*_coherent rework patchset v2
Message-ID: <20080822070931.GY14110@elte.hu>
References: <20080820094612.GA28492@elte.hu> <20080821120011.GD5615@elte.hu> <20080821231720S.fujita.tomonori@lab.ntt.co.jp> <200808210807.05996.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808210807.05996.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> > Surely, this patchset should be for 2.6.28.
> >
> > Can you send this via the x86 tree instead of pci?
> >
> > - IOMMU code is arch stuff rather than pci.
> > - We can avoid a mistake such as the previous one.
> 
> Yeah I was thinking 2.6.28 too, via the x86 tree.  The problem last 
> time was that I sent it too soon (I misunderstood Ingo when he said it 
> was ready) so we broke the build on some non-x86 platforms.  I don't 
> think that'll be an issue this time, but we may as well push through 
> x86 anyway; I agree that IOMMU is really a platform feature more than 
> a PCI one.

yeah, GART/IOMMU has been historically a more platform specific thing 
although there's certainly no hard boundaries. This code will show up in 
linux-next as well soon, so there's plenty of time to discover and fix 
any cross-arch breakages. (if any)

and if the PCI tree becomes very active in this area that would make the 
movement of these commits over there more practical we can do that too 
at any point of time, it's all kept separate in tip/x86/iommu, purely 
based on Linus's tree. The blessings of 160+ topic branches ;-)

	Ingo
