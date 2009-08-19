Return-Path: <linux-kernel-owner+w=401wt.eu-S1751871AbZHSNBC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbZHSNBC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:01:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbZHSNBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:01:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45687 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbZHSNBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:01:00 -0400
Date: Wed, 19 Aug 2009 15:00:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       stephane eranian <eranian@googlemail.com>
Subject: Re: [PATCH 4/4][RFC] perf_counter: Allow sharing of output channels
Message-ID: <20090819130055.GA14215@elte.hu>
References: <20090819091823.916851355@chello.nl> <20090819092023.980284148@chello.nl> <19083.61914.571806.395197@cargo.ozlabs.ibm.com> <1250686586.8282.12.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250686586.8282.12.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > Does this only apply to sampling counters?
> 
> Yeah, everything that would otherwise go through the mmap() 
> buffer.

Note that this can include sample-driven normal counts as well, 
i.e. PERF_SAMPLE_READ and perf record -s/--stat.

	Ingo
