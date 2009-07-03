Return-Path: <linux-kernel-owner+w=401wt.eu-S1755061AbZGCIQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbZGCIQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbZGCIQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:16:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33574 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbZGCIQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:16:16 -0400
Date: Fri, 3 Jul 2009 10:15:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 0/4] perf_counter tools: support annotation of live
	kernel modules
Message-ID: <20090703081556.GA21833@elte.hu>
References: <1246514639.13293.40.camel@marge.simson.net> <20090702064712.GA26690@elte.hu> <1246519076.6384.22.camel@marge.simson.net> <1246524170.7113.20.camel@marge.simson.net> <20090703072941.GC7943@elte.hu> <1246608058.6257.25.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246608058.6257.25.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> > We need to calculate and cache the objdump annotation output 
> > once, but after that it should be pretty fast as we just display 
> > updated counts with the same lines over and over again. No 
> > repeated objdump runs are needed.
> 
> But active files follow symbols, which change on the fly.
> 
> Besides, as mentioned previously, while displayed annotation was 
> very cool, it took a lot of display space.  For me, top with the 
> ability to emit bic-disposable mini-reports would be my primary 
> perf tools usage. I'd only use big brothers when I needed their 
> power/detail.

Ok, then how about putting some sort of interactivity into perf top?

Up and down arrows would allow the walking of the histogram, and 
hitting enter on a symbol would show the annotated function? It 
would be way cool and more usable and more flexible than some 
side-channel for mini-reports.

PowerTop has a lot of good text interactivity code that might be 
reused. (assuming it's under a kernel compatible license?)

There's also the 'tig' tool - an interactive tool to walk Git 
trees/commits. If it's under a compatible license that would be a 
nice place to look for clues too - it has a very mature and 
well-thought-out TUI in my opinion.

	Ingo
