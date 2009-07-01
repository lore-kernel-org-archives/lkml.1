Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbZGALqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbZGALqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 07:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755002AbZGALqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 07:46:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47404 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbZGALqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 07:46:21 -0400
Date: Wed, 1 Jul 2009 13:45:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT-PULL -tip][PATCH 0/6] perf_counter patches
Message-ID: <20090701114559.GH15958@elte.hu>
References: <1246440815.3403.3.camel@hpdv5.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246440815.3403.3.camel@hpdv5.satnam>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> Ingo,
> 
> Please pull perf_counter patches :
> The following changes since commit 092304de242705abf24edcb0fc7beed4c4276865:
>   Ingo Molnar (1):
>         Merge branch 'perfcounters/urgent'
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master
> 
> Jaswinder Singh Rajput (6):
>       perf stat: define MATCH_EVENT for easy attrs checking
>       perf stat: treat same behaviour for all CYCLES and CLOCKS
>       perf_counter: Add Generalized Hardware vectored co-processor support for AMD
>       perf_counter: Add Generalized Hardware interrupt support for AMD
>       perf_counter: Add hardware vector events for nehalem
>       perf_counter: Add hardware interrupt events for nehalem, core2 and atom

A patch nit-picking sidenote, please try to use more consistent 
capitalization in commit titles. I fixed the first commit's title
to be:

   b9ebdcc: perf stat: Define MATCH_EVENT for easy attr checking

Also, the way we want to refer to the above Intel CPU models is 
"Corei7/Nehalem, Core2 and Atom".

	Ingo
