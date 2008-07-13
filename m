Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbYGMRMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbYGMRMx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 13:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbYGMRMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 13:12:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33731 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728AbYGMRMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 13:12:45 -0400
Date: Sun, 13 Jul 2008 19:12:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Mike Travis <travis@sgi.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       mm-commits@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] x86: Change _node_to_cpumask_ptr to return const
	ptr
Message-ID: <20080713171231.GA2988@elte.hu>
References: <19f34abd0807030155x22b0033dj780830bad840216f@mail.gmail.com> <20080703090100.GA10872@elte.hu> <48739E87.2060604@sgi.com> <19f34abd0807081035k2c7a18eckc8aa749a6f015f65@mail.gmail.com> <4873AC5C.1040705@sgi.com> <19f34abd0807081122p20c73cd9p7129d297ac36a3ad@mail.gmail.com> <4873D33B.4040300@sgi.com> <19f34abd0807081421j67771dbclfae1fcfaa9ad4bcd@mail.gmail.com> <4873DD99.7050001@sgi.com> <19f34abd0807081452l587c8388g1cdb2d3c01e0e13a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0807081452l587c8388g1cdb2d3c01e0e13a@mail.gmail.com>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> On Tue, Jul 8, 2008 at 11:35 PM, Mike Travis <travis@sgi.com> wrote:
> > Subject: [PATCH 1/1] x86: Change _node_to_cpumask_ptr to return const ptr
> >
> >  * Strengthen the return type for the _node_to_cpumask_ptr to be
> >    a const pointer.  This adds compiler checking to insure that
> >    node_to_cpumask_map[] is not changed inadvertently.
> >
> > Applies to tip/master with the following patch applied:
> >
> >        "[PATCH 1/1] x86: Add check for node passed to node_to_cpumask V3"
> >
> > Signed-off-by: Mike Travis <travis@sgi.com>
> > ---
> 
> I can successfully cross-compile the asm-generic changes with a NUMA=y 
> config on ia64 without error or warning. So I guess, at long last, you 
> may put, FWIW:
> 
>     Acked-by: Vegard Nossum <vegard.nossum@gmail.com>

thanks - applied to tip/x86/core.

	Ingo
