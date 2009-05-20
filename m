Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbZETJ1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbZETJ1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 05:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbZETJ0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 05:26:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:57237 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793AbZETJ0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 05:26:49 -0400
Subject: Re: [tip:perfcounters/core] perf_counter tools: tidy up in-kernel
 dependencies
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, fengguang.wu@intel.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-4d1b100b57e8d472ca3b3a628e03c24d66cb782c@git.kernel.org>
References: <20090323172417.677932499@chello.nl>
	 <tip-4d1b100b57e8d472ca3b3a628e03c24d66cb782c@git.kernel.org>
Content-Type: text/plain
Date: Wed, 20 May 2009 14:56:06 +0530
Message-Id: <1242811566.3260.58.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-23 at 20:57 +0000, Ingo Molnar wrote:
> Commit-ID:  4d1b100b57e8d472ca3b3a628e03c24d66cb782c
> Gitweb:     http://git.kernel.org/tip/4d1b100b57e8d472ca3b3a628e03c24d66cb782c
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Mon, 23 Mar 2009 21:49:25 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 23 Mar 2009 21:51:35 +0100
> 
> perf_counter tools: tidy up in-kernel dependencies
> 
> Remove now unified perfstat.c and perf_counter.h, and link to the
> in-kernel perf_counter.h.
> 
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <20090323172417.677932499@chello.nl>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  Documentation/perf_counter/Makefile       |    2 +-
>  Documentation/perf_counter/kerneltop.c    |    2 +-
>  Documentation/perf_counter/perfcounters.h |  142 ----------------
>  Documentation/perf_counter/perfstat.c     |  251 -----------------------------
>  4 files changed, 2 insertions(+), 395 deletions(-)
> 
> diff --git a/Documentation/perf_counter/Makefile b/Documentation/perf_counter/Makefile
> index b457497..666da95 100644
> --- a/Documentation/perf_counter/Makefile
> +++ b/Documentation/perf_counter/Makefile
> @@ -2,7 +2,7 @@ BINS = kerneltop perfstat
>  
>  all: $(BINS)
>  
> -kerneltop: kerneltop.c perfcounters.h
> +kerneltop: kerneltop.c ../../include/linux/perf_counter.h
>  	cc -O6 -Wall -lrt `pkg-config --cflags --libs glib-2.0` -o $@ $<
>  
>  perfstat: kerneltop


Can we support Documentation/perf_counter/Makefile to use
Documentation/Makefile so that we can also get these perf_counter user
apps along with new kernel.

--
JSR

