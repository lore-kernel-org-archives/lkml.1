Return-Path: <linux-kernel-owner+w=401wt.eu-S1762257AbZD3NkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762257AbZD3NkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 09:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761157AbZD3NkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 09:40:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39532 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbZD3NkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 09:40:00 -0400
Date: Thu, 30 Apr 2009 15:38:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, thomas.pi@arcor.dea,
       Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca
Subject: Re: [PATCH] Fix dirty page accounting in
	redirty_page_for_writepage()
Message-ID: <20090430133859.GB8329@elte.hu>
References: <20090429232546.GB15782@Krystal> <alpine.LFD.2.00.0904291701450.22156@localhost.localdomain> <20090430024303.GB19875@Krystal> <alpine.DEB.1.10.0904300921290.22262@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904300921290.22262@qirst.com>
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


* Christoph Lameter <cl@linux.com> wrote:

> On Wed, 29 Apr 2009, Mathieu Desnoyers wrote:
> 
> > to have a good look at the memory accounting code. We could 
> > probably benefit of Christoph Lameter's cpu ops (using segment 
> > registers to address per-cpu variables with atomic inc/dec) in 
> > there. Or at least removing interrupt disabling by using preempt 
> > disable and local_t variables for the per-cpu counters could 
> > bring some benefit.
> 
> Guess we are ready for atomic per cpu ops now that the new per cpu 
> allocator is in? Segment register issues with the PDA are also 
> solved right?

it's all done, implemented and upstream already. You are a bit late 
to the party ;-)

	Ingo
