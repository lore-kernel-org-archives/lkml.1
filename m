Return-Path: <linux-kernel-owner+w=401wt.eu-S1754164AbZCER0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbZCER0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 12:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbZCER0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 12:26:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40095 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbZCER0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 12:26:04 -0500
Date: Thu, 5 Mar 2009 18:25:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Paul Mackerras <paulus@samba.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perfcounters: IRQ and NMI support on AMD CPUs
Message-ID: <20090305172545.GA18947@elte.hu>
References: <1236273633.5187.286.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236273633.5187.286.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> Subject: perfcounters: IRQ and NMI support on AMD CPUs
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Thu Mar 05 18:08:27 CET 2009
> 
> The below completes the K7+ performance counter support.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  arch/x86/kernel/cpu/perf_counter.c |  272 +++++++++++++++++++++++++++++++------
>  1 file changed, 228 insertions(+), 44 deletions(-)

Great work, thanks Peter! I've applied it to 
tip:perfcounters/core and tip:master.

	Ingo
