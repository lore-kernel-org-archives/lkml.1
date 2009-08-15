Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbZHOJ45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbZHOJ45 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 05:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbZHOJ45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 05:56:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34446 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbZHOJ44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 05:56:56 -0400
Date: Sat, 15 Aug 2009 11:56:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Valdis.Kletnieks@vt.edu, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/1] perf record: Fix typo in
	pid_synthesize_comm_event
Message-ID: <20090815095638.GC15831@elte.hu>
References: <20090814182632.GF3490@ghostprotocols.net> <28379.1250276831@turing-police.cc.vt.edu> <20090814201048.GG3490@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090814201048.GG3490@ghostprotocols.net>
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


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Fri, Aug 14, 2009 at 03:07:11PM -0400, Valdis.Kletnieks@vt.edu escreveu:
> > On Fri, 14 Aug 2009 15:26:32 -0300, Arnaldo Carvalho de Melo said:
> > > We were using 'fd' locally, but there was a global 'fd' too, so when
> > > converting from open to fopen the test made against fd should be made
> > > against 'fp', but since we have that global...
> > 
> > If the kernel was -Wshadow safe by default, this sort of thing 
> > would happen less often... :)
> 
> I would love to have that kind of problem spotted by the compiler, 
> but this is no kernel code, the CFLAGS we use is different than 
> the kernel ones, I guess a patch for tools/perf/ would be gladly 
> accepted by Ingo, but let him say so :-)

Yeah. We are using -Wall and -Wextra right now - but -Wshadow is not 
turned on by them.

Does gcc ignore non-existent warnings or do we have to probe them in 
the Makefile, to support older versions of GCC?

	Ingo
