Return-Path: <linux-kernel-owner+w=401wt.eu-S1758316AbZKYHrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316AbZKYHrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 02:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbZKYHrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 02:47:22 -0500
Received: from fallback.mail.elte.hu ([157.181.151.13]:35244 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbZKYHrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 02:47:21 -0500
Date: Wed, 25 Nov 2009 08:25:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: yinghai@kernel.org, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix gart iommu using for amd 64 bit system
Message-ID: <20091125072504.GA6568@elte.hu>
References: <4B0BB892.9080401@kernel.org>
 <20091124225000H.fujita.tomonori@lab.ntt.co.jp>
 <20091124152645.GD21821@elte.hu>
 <20091125085730S.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125085730S.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Tue, 24 Nov 2009 16:26:45 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > 
> > > > don't think user will like to use SWIOTLB instead of swiotlb.
> > > 
> > > I doubt that users care about a way to fix their problems.
> > 
> > As far as swiotlb vs. GART goes, arguably a non-bouncing hw based 
> > solution (GART) is superior to a bouncing one (swiotlb), right?
> 
> Yeah, but GART is not a real IOMMU that always does address 
> translation. If users want performance, they need 64bit DMA capable 
> devices to skip GART. With such devices, GART and SWIOTLB are same.
> 
> So this hacky GART workaround is useful for only people who use non 
> 64bit DMA devices and broken BIOS with GART. IMO, it's not worth 
> having the workaround.

Well, what Yinghai is saying that for that (nonzero) subset of people 
this change is a regression, and his patch fixes that. We dont do 
regressions so this needs to be addressed.

Thanks,

	Ingo
