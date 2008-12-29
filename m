Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbYL2MMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbYL2MMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 07:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbYL2MMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 07:12:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42431 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbYL2MME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 07:12:04 -0500
Date: Mon, 29 Dec 2008 13:11:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sergio Luis <sergio@larces.uece.br>
Cc: Mike Travis <travis@sgi.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Oleg Nesterov <oleg@tv-sign.ru>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: mark get_cpu_leaves() with __cpuinit
	annotation
Message-ID: <20081229121149.GA9628@elte.hu>
References: <495725B0.30501@larces.uece.br> <495726DA.80301@larces.uece.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495726DA.80301@larces.uece.br>
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


* Sergio Luis <sergio@larces.uece.br> wrote:

> Resending, now including LKML as well. Sorry.
> Sergio.
> 
> ----
> 
>  x86: mark get_cpu_leaves() with __cpuinit annotation
> 
>  Impact: fix section mismatch 
> 
>  Commit b2bb85549134c005e997e5a7ed303bda6a1ae738 introduced 
>  get_cpu_leaves(), which references __cpuinit cpuid4_cache_lookup().
>  Mark get_cpu_leaves() with a __cpuinit annotation.
> 
>  Signed-off-by: Sergio Luis <sergio@larces.uece.br>
>  Cc: Mike Travis <travis@sgi.com>
>  Cc: Rusty Russell <rusty@rustcorp.com.au>
>  Cc: Ingo Molnar <mingo@elte.hu>
>  Cc: Oleg Nesterov <oleg@tv-sign.ru>
>  ---
>  arch/x86/kernel/cpu/intel_cacheinfo.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

applied to tip/cpus4096, thanks Sergio!

	ngo
