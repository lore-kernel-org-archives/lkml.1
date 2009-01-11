Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbZAKDz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbZAKDz7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 22:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZAKDzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 22:55:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41954 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbZAKDzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 22:55:50 -0500
Date: Sun, 11 Jan 2009 04:55:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jj@chaosbits.net,
       weiyi.huang@gmail.com, Becky Bruce <beckyb@kernel.crashing.org>
Subject: Re: [PATCH 0/2] Re: swiotlb: remove duplicated #include
Message-ID: <20090111035527.GC28520@elte.hu>
References: <1231524630.27350.79.camel@zakaz.uk.xensource.com> <1231525930-14087-1-git-send-email-Ian.Campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231525930-14087-1-git-send-email-Ian.Campbell@citrix.com>
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


* Ian Campbell <Ian.Campbell@citrix.com> wrote:

> On Fri, 2009-01-09 at 18:10 +0000, Ian Campbell wrote:
> 
> > Patch is against Jeremy's Xen patch queue which is based on a pre-Xmas
> > tip tree so fairly out of date, I hope it is somewhat useful though.
> 
> Here's a version again tip-latest, only compile tested though since my
> testing relies on the Xen dom0 patch queue.

Applied them to tip/core/iommu:

 961d7d0: swiotlb: do not use sg_virt()
 0b8698a: swiotlb: range_needs_mapping should take a physical address.

thanks Ian!

	Ingo
