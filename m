Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbYI0SPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbYI0SPI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 14:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbYI0SO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 14:14:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51264 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbYI0SO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 14:14:56 -0400
Date: Sat, 27 Sep 2008 20:14:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 3/3] x86/iommu: use __GFP_ZERO instead of memset for
	GART
Message-ID: <20080927181438.GF1108@elte.hu>
References: <1222337635-28285-1-git-send-email-joerg.roedel@amd.com> <1222337635-28285-4-git-send-email-joerg.roedel@amd.com> <20080925102012.GA13631@elte.hu> <20080925104212.GA27928@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925104212.GA27928@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0021]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> > > -		if (iommu_leak_tab)
> > > -			memset(iommu_leak_tab, 0, iommu_pages * 8);
> > >  		else
> > >  			printk(KERN_DEBUG
> > >  			       "PCI-DMA: Cannot allocate leak trace area\n");
> > 
> > hm, that looks broken.
> 
> Argh, yes. Please try this one:

applied these patches to tip/x86/iommu:

 0114267: x86/iommu: use __GFP_ZERO instead of memset for GART
 3610f21: x86/iommu: convert GART need_flush to bool
 237a622: x86/iommu: make GART driver checkpatch clean

thanks Joerg!

Fujita, do they look fine to you too?

	Ingo
