Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbYGMJpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbYGMJpe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 05:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbYGMJp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 05:45:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54821 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802AbYGMJpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 05:45:25 -0400
Date: Sun, 13 Jul 2008 11:45:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: max_low_pfn_mapped fix #1
Message-ID: <20080713094514.GB32578@elte.hu>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807092017.51004.yhlu.kernel@gmail.com> <200807102038.26591.yhlu.kernel@gmail.com> <200807121430.35505.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807121430.35505.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> fix crash on Ingo's big box:
> calling  pci_iommu_init+0x0/0x17
> PCI-DMA: Disabling AGP.
> PCI-DMA: aperture base @ d0000000 size 65536 KB
> PCI-DMA: using GART IOMMU.
> PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
> BUG: unable to handle kernel paging request at ffff88000003be88
> IP: [<ffffffff8026d377>] __alloc_pages_internal+0xc3/0x3f2

that indeed solved the crash - thanks Yinghai.

	Ingo
