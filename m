Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbYGJIoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbYGJIoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 04:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbYGJIoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 04:44:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56311 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbYGJIoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 04:44:00 -0400
Date: Thu, 10 Jul 2008 10:43:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] replace CONFIG_IOMMU with CONFIG_GART_IOMMU in iommu.h
Message-ID: <20080710084339.GA12386@elte.hu>
References: <20080709162913H.tomof@acm.org> <20080709085230.GA6267@elte.hu> <20080710082753T.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710082753T.fujita.tomonori@lab.ntt.co.jp>
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


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> > agreed about the cleanups. We are willing to test RFC patches :-)
> 
> Ok, how about this?

a perfect beginning - applied to tip/x86/core, thanks!

> If you are fine with the intention of this, then I'll send the 
> follow-up cleanups.

please do!

> Note that iommu.h includes some gart things that everyone needs. If 
> you like, I'll rename gart.h gart_priv.h (or something) and move the 
> gart stuff in iommu.h to gart.h.

yeah. Or just move it into iommu.h and turn gart.h into the true 
GART-specific include file? (and add iommu.h includes to files that are 
affected)

	Ingo
