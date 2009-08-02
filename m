Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596AbZHBUde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbZHBUde (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 16:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbZHBUde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 16:33:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60287 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbZHBUdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 16:33:33 -0400
Date: Sun, 2 Aug 2009 22:33:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Anton Blanchard <anton@samba.org>,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, benh@kernel.crashing.org,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, paulus@samba.org,
       williams@redhat.com
Subject: Re: [PATCH] basic perf support for sparc
Message-ID: <20090802203314.GA3986@elte.hu>
References: <20090729112509.GN4148@kernel.dk> <20090729192814.GT4148@kernel.dk> <20090801011429.GA4685@kryten> <20090801082048.GX12579@kernel.dk> <20090801182216.GA25334@ghostprotocols.net> <20090802184148.GB17241@elte.hu> <20090802194454.GC28572@bombadil.infradead.org> <20090802195043.GD24486@elte.hu> <20090802201132.GE28572@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090802201132.GE28572@bombadil.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kyle McMartin <kyle@mcmartin.ca> wrote:

> On Sun, Aug 02, 2009 at 09:50:43PM +0200, Ingo Molnar wrote:
> > We are sticking to a given version of the API. We could turn that 
> > into a function pointer and fill it in during startup via dlopen(). 
> > If it's NULL then we dont call it and assume a value of NULL.
> > 
> > Mind submitting such a version of your fix? It would nicely decrease 
> > the build requirements cross section surface of perf.
> > 
> 
> Assuming I remember how to use dlopen/dlsym, this might work. 
> Unfortunately I can't easily test anything this weekend, so I 
> don't actually know if it works... but it links ok.

looks good to me. Arnaldo, mind picking this up?

	Ingo
