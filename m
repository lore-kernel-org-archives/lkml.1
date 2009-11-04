Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbZKDMPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbZKDMPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 07:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308AbZKDMPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 07:15:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55749 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959AbZKDMPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 07:15:30 -0500
Date: Wed, 4 Nov 2009 13:15:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 4/14] cpumask: use struct cpumask rather than the
	deprecated cpumask_t
Message-ID: <20091104121520.GC16993@elte.hu>
References: <200911031454.09261.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911031454.09261.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> To: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/include/asm/msr.h |    4 ++--
>  arch/x86/lib/msr.c         |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)

Mind sending this against latest -tip? We already have:

  b8a4754: x86, msr: Unify rdmsr_on_cpus/wrmsr_on_cpus

which makes your patch not apply:

 patching file arch/x86/include/asm/msr.h
 Hunk #1 FAILED at 247.
 1 out of 1 hunk FAILED -- rejects in file arch/x86/include/asm/msr.h
 patching file arch/x86/lib/msr.c
 Hunk #1 FAILED at 78.
 Hunk #2 FAILED at 107.
 2 out of 2 hunks FAILED -- rejects in file arch/x86/lib/msr.c

Thanks,

	Ingo
