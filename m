Return-Path: <linux-kernel-owner+w=401wt.eu-S1760270AbYFJKUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270AbYFJKUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 06:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755557AbYFJKT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 06:19:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37058 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461AbYFJKT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 06:19:56 -0400
Date: Tue, 10 Jun 2008 12:19:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Cliff Wickman <cpw@sgi.com>, sivanich@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] hotplug cpus on ia64
Message-ID: <20080610101945.GA19136@elte.hu>
References: <E1K1l2y-0007bu-44@eag09.americas.sgi.com> <1212154614.12349.244.camel@twins> <20080603221759.GA19039@sgi.com> <1212670198.23439.45.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212670198.23439.45.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0061]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > > does:
> > > 
> > > echo -1 > /proc/sys/kernel/sched_rt_runtime_us
> > > 
> > > fix the problem?
> > 
> > Yes! It does. 
> > 
> > Dimitri Sivanich has run into what looks like a similar problem.
> > Hope the above workaround is a good clue to its solution.
> 
> Does the below fix it?

while it's not the full fix i've applied it to tip/sched-devel for more 
testing. Thanks,

	Ingo
