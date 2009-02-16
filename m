Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbZBPOTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbZBPOTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 09:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbZBPOTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 09:19:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33949 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbZBPOTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 09:19:30 -0500
Date: Mon, 16 Feb 2009 15:19:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Manish Katiyar <mkatiyar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Remove errors caught by checkpatch.pl in
	kernel/kallsyms.c
Message-ID: <20090216141917.GA8981@elte.hu>
References: <ea11fea30902151034s5444efabw455c1dac1b875086@mail.gmail.com> <20090215184752.GA4970@uranus.ravnborg.org> <4999650C.6030700@s5r6.in-berlin.de> <20090216132822.GC17996@elte.hu> <4999717F.7090205@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4999717F.7090205@s5r6.in-berlin.de>
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


* Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Ingo Molnar wrote:
> > * Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> >> Furthermore, the changelog is bad (non-exiting in fact).
> >> 
> >> The fact that the issues where discovered using checkpatch is absolutely
> >> uninteresting.  The changelog should describe /what/ is fixed, [...]
> > 
> > The commit log definitely needs enhancements but it's not uninteresting 
> > at all what tools were used to arrive to a change. [...] if a
> > good and acceptable commit results out of a tool's usage then that tool 
> > needs to be advertised some more.)
> 
> Fine, then the author could mention it below the --- delimitor in the 
> patch posting.  The changelog however, as annotation of the source 
> history, is not a billboard.  We also don't describe for example that 
> a nice cup of hot Earl Grey or whatever was vital to the creation of a 
> patch.

Well there's a difference between a nice cup of tea (that really has no 
direct connection to kernel development) and a tool that is in the Linux 
kernel specifically for the purpose of helping keep code clean, and that 
was used to come up with a cleanup.

We routinely mention Sparse, lockdep, Coverity, Coccinelle, kmemleak, 
ftrace, kmemcheck and other tools as well when it motives to fix a bug 
or uncleanliness. We routinely mention checkpatch as well when it 
catches an uncleanliness in a submitted patch. It is absolutely fine to 
mention checkpatch when it catches uncleanliness in code that already 
got merged. I dont understand your point.

	Ingo
