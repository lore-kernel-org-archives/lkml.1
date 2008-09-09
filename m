Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbYIIHOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbYIIHOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 03:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbYIIHOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 03:14:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51256 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492AbYIIHOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:14:03 -0400
Date: Tue, 9 Sep 2008 09:13:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: steven@uplinklabs.net, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       hpa@zytor.com
Subject: Re: [PATCH] x86: unused variable in dma_alloc_coherent_gfp_flags()
Message-ID: <20080909071338.GB3412@elte.hu>
References: <1220915951-11434-2-git-send-email-steven@uplinklabs.net> <1220915951-11434-3-git-send-email-steven@uplinklabs.net> <20080909065736.GC27747@elte.hu> <20080909160455J.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080909160455J.fujita.tomonori@lab.ntt.co.jp>
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

> On Tue, 9 Sep 2008 08:57:36 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Steven Noonan <steven@uplinklabs.net> wrote:
> > 
> > > Fixed a warning caused by a badly placed ifdef.
> > > 
> > > Signed-off-by: Steven Noonan <steven@uplinklabs.net>
> > 
> > applied to tip/x86/iommu - thanks Steven,
> 
> Did you apply the same patch yesterday?
> 
> http://lkml.org/lkml/2008/9/8/274

yes, but i havent pushed it out in time yesterday night. In such 
scenarios i generally zap the patch i generated and replace it with the 
fix that is being sent against the last publicly available tree. That is 
what happened here too. This makes it all symmetric and fair (i as a 
maintainer have no time advantage to get fixes in first) and it also 
teaches me to push out fixes faster :-)

	Ingo
