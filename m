Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab0CAHhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 02:37:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36772 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab0CAHho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 02:37:44 -0500
Date: Mon, 1 Mar 2010 08:37:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: linux-next: manual merge of the oprofile tree with Linus' tree
Message-ID: <20100301073736.GA1453@elte.hu>
References: <20100301182001.f67b21ac.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100301182001.f67b21ac.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Robert,
> 
> Today's linux-next merge of the oprofile tree got a conflict in
> arch/x86/kernel/cpu/perf_event.c between commit
> 8c48e444191de0ff84e85d41180d7bc3e74f14ef ("perf_events, x86: Implement
> intel core solo/duo support") from Linus' tree and commit
> 27d4a358bf5ef730aacf50696b9b5dfc5e2a87a5 ("perf, x86: rename macro in
> ARCH_PERFMON_EVENTSEL_ENABLE") from the oprofile tree.

Robert: the oprofile tree shouldnt be changing perf_event code in any case, 
please dont push out such patches to linux-next but feed them through the 
usual channels.

Thanks,

	Ingo
