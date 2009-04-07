Return-Path: <linux-kernel-owner+w=401wt.eu-S1761573AbZDGP0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761573AbZDGP0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757321AbZDGPNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:13:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39471 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760000AbZDGPNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:13:19 -0400
Date: Tue, 7 Apr 2009 17:12:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-iommu: fix build with CONFIG_BRANCH_TRACER=y
Message-ID: <20090407151224.GA14486@elte.hu>
References: <1239083045.22733.383.camel@macbook.infradead.org> <20090407054818.GA5557@elte.hu> <20090407055245.GA10406@elte.hu> <1239084280.22733.404.camel@macbook.infradead.org> <20090407061558.GA31261@elte.hu> <20090407084950.GA1467@elte.hu> <20090407090229.GA2467@elte.hu> <1239104035.22733.443.camel@macbook.infradead.org> <alpine.LFD.2.00.0904070751510.4010@localhost.localdomain> <alpine.LFD.2.00.0904070759050.4010@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904070759050.4010@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 7 Apr 2009, Linus Torvalds wrote:
> > 
> > Can we please do it something like the following instead:
> > 
> > 	#define if(a, ...) \
> > 		__trace_if( (a, ## __VA_ARGS__) )
> > 
> > so that you don't need to do that ", ## __VA_ARGS__" thing three times?
> 
> IOW, does this (TOTALLY UNTESTED) patch work?

i've done some (very light) testing and it works here.

	Ingo
