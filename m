Return-Path: <linux-kernel-owner+w=401wt.eu-S1751654AbZHSM4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbZHSM4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 08:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbZHSM4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 08:56:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41254 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbZHSM4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 08:56:22 -0400
Date: Wed, 19 Aug 2009 14:56:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       stephane eranian <eranian@googlemail.com>
Subject: Re: [PATCH 4/4][RFC] perf_counter: Allow sharing of output channels
Message-ID: <20090819125613.GA30547@elte.hu>
References: <20090819091823.916851355@chello.nl> <20090819092023.980284148@chello.nl> <19083.61914.571806.395197@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19083.61914.571806.395197@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> Peter Zijlstra writes:
> 
> > Provide the ability to configure a counter to send its output 
> > to another (already existing) counter's output stream.
> 
> What sort of thing might this be useful for?

To share the output buffer - say you have a number of tracepoint 
counters enabled and want a single (coherent) stream of events 
without a post-processing sorting pass.

Right now each counter has to be opened, mmap-ed separately and 
then the result stuffed into the output file.

	Ingo
