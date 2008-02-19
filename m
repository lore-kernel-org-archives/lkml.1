Return-Path: <linux-kernel-owner+w=401wt.eu-S1758198AbYBSQsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbYBSQsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 11:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbYBSQsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 11:48:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54759 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754796AbYBSQsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 11:48:21 -0500
Date: Tue, 19 Feb 2008 17:48:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: Linux 2.6.25-rc2
Message-ID: <20080219164803.GA9148@elte.hu>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org> <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com> <20080219061107.GA23229@elte.hu> <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com> <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com> <20080219140230.GA32236@Krystal> <84144f020802190621s509dbe7gc8e5609d94aca9b4@mail.gmail.com> <84144f020802190638i4a364d19o8986a457e76ec187@mail.gmail.com> <alpine.LFD.1.00.0802190806330.7833@woody.linux-foundation.org> <20080219164525.GA4396@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219164525.GA4396@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> Earlier today i turned off local-cmpxchg and havent had a crash or 
> hang since then - but at 200 bootups and 4-5 crashes in a week that's 
> not conclusive yet. I think others might have workloads that trigger 
> this bug more often.

i mean, today i've only done 200 randconfig bootups since i did the 
cmpxchg SLUB revert, and given the statistics of the bug (thousands of 
bootups and just 3 provable crashes) i cannot yet conclude that the bug 
is truly gone.

	Ingo
