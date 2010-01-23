Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475Ab0AWHFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab0AWHFu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 02:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218Ab0AWHFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 02:05:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48574 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab0AWHFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 02:05:49 -0500
Date: Sat, 23 Jan 2010 08:04:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: perf regression testing. was Re: [PATCH 1/2] perf symbols: Fix
 inverted logic for showing kallsyms as the source of symbols
Message-ID: <20100123070451.GC15774@elte.hu>
References: <1264178102-4203-1-git-send-email-acme@infradead.org>
 <1264178608.5935.0.camel@marge.simson.net>
 <20100122165101.GA2689@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100122165101.GA2689@ghostprotocols.net>
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


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Em Fri, Jan 22, 2010 at 05:43:28PM +0100, Mike Galbraith escreveu:
> > On Fri, 2010-01-22 at 14:35 -0200, Arnaldo Carvalho de Melo wrote:
> > > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > 
> > > Only if we parsed /proc/kallsyms (or a copy found in the buildid cache)
> > > we should set the dso long name to "[kernel.kallsyms]".
> > 
> > Yup, works just as well as my busted one :)
> 
> yeah :-)
> 
> I'll soon start working on 'perf regtest', to start accumulating regression 
> tests a la 'perf bench', as these silly bugs are worrying me...

Excellent, it's much needed!

The best example i know about is KVM: they have built an impressive regression 
test suite and add testcases for new regressions all the time.

The key is to have something simple to run, which developers (and 
maintainers) can run after every new perf commit or so.

	Ingo
