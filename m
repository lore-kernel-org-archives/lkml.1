Return-Path: <linux-kernel-owner+w=401wt.eu-S1760638AbYFFPeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760638AbYFFPeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757454AbYFFPeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:34:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42721 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755824AbYFFPeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:34:05 -0400
Date: Fri, 6 Jun 2008 17:33:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 5
Message-ID: <20080606153346.GB18359@elte.hu>
References: <20080606115759.GA29321@elte.hu> <19f34abd0806060533x6d3ff66tc29306143103fc40@mail.gmail.com> <48493CBD.1000202@sgi.com> <19f34abd0806060650q203bef48rd3b20c0cabec4774@mail.gmail.com> <19f34abd0806060707x7570c835u4b1837b54dfa36ba@mail.gmail.com> <484947A9.5050804@sgi.com> <19f34abd0806060736m10424455kfbc3e6272d18646e@mail.gmail.com> <20080606145717.GA5300@elte.hu> <484951E6.1030207@sgi.com> <484955B9.5070704@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484955B9.5070704@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> The patch ordering was incorrect as I removed the node_to_cpumask_map 
> before I replaced the MAX_NUMNODES, should have been the opposite.

It needed the combination 4 failures along the line: the debug check was 
not complete, the ordering was bad and thus the splitup was bad as well 
- and then one component went missing in linux-next and the combined 
effect created this bug that needed a bisection by Andrew and Vegard to 
figure out.

the moral: we now tightened the debug check, fixed the integration bug 
and tightened the checks we have for patch propagation. (Thomas just 
added the new tip-check-integration script to tip/tip that implements 
this)

	Ingo
