Return-Path: <linux-kernel-owner+w=401wt.eu-S1756831AbYG2Kcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbYG2Kcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 06:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbYG2Kcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 06:32:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58229 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266AbYG2Kcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 06:32:45 -0400
Date: Tue, 29 Jul 2008 12:31:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: davem@davemloft.net, joerg.roedel@amd.com, sfr@canb.auug.org.au,
       mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       robert.richter@amd.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, jbarnes@virtuousgeek.org,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] add iommu_num_pages helper function
Message-ID: <20080729103146.GA32407@elte.hu>
References: <20080729164523.bfd2d539.sfr@canb.auug.org.au> <20080729095027.GA4851@amd.com> <20080729.031005.203132019.davem@davemloft.net> <20080729192834M.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729192834M.fujita.tomonori@lab.ntt.co.jp>
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


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Tue, 29 Jul 2008 03:10:05 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
> 
> > From: Joerg Roedel <joerg.roedel@amd.com>
> > Date: Tue, 29 Jul 2008 11:50:27 +0200
> > 
> > > I think moving that function to x86-only code is the best solution for
> > > now. Before moving it back to generic code we need an architecture
> > > independent way to find out the IOMMU page size.
> > 
> > My suggestion (again) is to pass it in as a "const unsigned long
> > io_page_size" argument and update the callers.
> 
> Either is fine by me.
> 
> Joerg, if you like, please finish this (for all the architectures, 
> please). As I said before, I planed to work on this cleanup after rc1 
> (and this should have been 2.6.28 stuff). But I'd appreciate if you 
> would do.

i've queued up your quick fix in tip/x86/urgent to resolve the immediate 
-git build breakage. The wider patch can then be done on top of that, 
without being rushed. Any objections to this approach?

	Ingo
