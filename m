Return-Path: <linux-kernel-owner+w=401wt.eu-S1763718AbZAOR5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763718AbZAOR5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 12:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759556AbZAOR5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 12:57:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51040 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759310AbZAOR5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 12:57:40 -0500
Date: Thu, 15 Jan 2009 18:57:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UV: cpu_relax in uv_wait_completion
Message-ID: <20090115175735.GH22472@elte.hu>
References: <E1LNUV6-00025f-Q7@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LNUV6-00025f-Q7@eag09.americas.sgi.com>
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


* Cliff Wickman <cpw@sgi.com> wrote:

> 
> From: Cliff Wickman <cpw@sgi.com>
> 
> The function uv_wait_completion() spins on reads of a memory-mapped
> register, waiting for completion of BAU hardware replies.
> It should call "cpu_relax()" between those reads to improve performance
> on hyperthreaded configurations.
> 
> Signed-off-by: Cliff Wickman <cpw@sgi.com>
> Acked-by: Jack Steiner <steiner@sgi.org>
> 
> ---
>  arch/x86/kernel/tlb_uv.c |    1 +
>  1 file changed, 1 insertion(+)

applied to tip/x86/urgent, thanks Cliff!

	Ingo
