Return-Path: <linux-kernel-owner+w=401wt.eu-S1759345AbZA2PKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345AbZA2PKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 10:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbZA2PKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 10:10:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53836 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbZA2PKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 10:10:01 -0500
Date: Thu, 29 Jan 2009 16:09:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       powertop ml <power@bughost.org>,
       Arjan van de Ven <arjan@linux.intel.com>, srostedt@redhat.com,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>, utrace-devel@redhat.com,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] tracer for sys_open() - sreadahead
Message-ID: <20090129150934.GF6512@elte.hu>
References: <497F69A4.2070007@intel.com> <20090127224303.GB5850@nowhere> <20090127225048.GA4652@nowhere> <20090129140451.GM24391@elte.hu> <c62985530901290629i168ac12cjc4b22140caceff58@mail.gmail.com> <20090129143120.GS24391@elte.hu> <c62985530901290640j10e63127s59ce22e860a508f8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530901290640j10e63127s59ce22e860a508f8@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2009/1/29 Ingo Molnar <mingo@elte.hu>:
> >>
> >> Several people talked me about utrace and gave some examples about it in
> >> this discussion. The Api is very convenient to fetch syscall numbers,
> >> arguments and return values. And the hooks are done in the generic core
> >> code, so it is arch independent.
> >>
> >> The only drawback I can see is that it is not yet merged upstream, in
> >> need of in-kernel users. If it only depends on this condition, we could
> >> be these users...
> >>
> >> What do you think?
> >
> > sure - how do the minimal bits/callbacks look like which enable syscall
> > tracing?
> >
> >        Ingo
> 
> 
> There is a very straightforward example provided by Ananth in there:
> http://lkml.org/lkml/2009/1/28/59

I mean, how does the infrastructure patch look like - what code does this 
add to the kernel - just to get the syscall tracing bits. Lets get some 
progress here - it's clear that tracing syscalls is good, we just need to 
do it and look at actual patches.

	Ingo
