Return-Path: <linux-kernel-owner+w=401wt.eu-S1755064AbZHFL4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064AbZHFL4B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 07:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZHFL4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 07:56:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45645 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbZHFLz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 07:55:59 -0400
Date: Thu, 6 Aug 2009 13:55:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] perf_counter/powerpc: Check oprofile_cpu_type for NULL
	before using it
Message-ID: <20090806115553.GA10734@elte.hu>
References: <19066.48028.446975.501454@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19066.48028.446975.501454@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> If the current CPU doesn't support performance counters,
> cur_cpu_spec->oprofile_cpu_type can be NULL.  The current perf_counter
> modules don't test for that case and would thus crash at boot time.
> 
> Bug reported by David Woodhouse.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Reported-by: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
> Ingo, this needs to go in for .31 since it fixes a boot-time oops.
> Are you going to be sending a batch to Linus shortly or should I send
> this to him separately?

Yeah, wanted to send a batch of fixes later today - so i've queued 
this one up too in perfcounters/urgent.

Thanks,

	Ingo
