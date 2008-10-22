Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbYJVGXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbYJVGXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 02:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYJVGWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 02:22:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51204 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbYJVGWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 02:22:53 -0400
Date: Wed, 22 Oct 2008 08:22:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Russ Anderson <rja@sgi.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] x86: Add UV memory protection bios call
Message-ID: <20081022062235.GD651@elte.hu>
References: <20081021200112.GD32545@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021200112.GD32545@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Russ Anderson <rja@sgi.com> wrote:

> Add UV bios call to change memory protections.
> 
> Signed-off-by: Russ Anderson <rja@sgi.com>
> 
> ---
>  arch/x86/kernel/bios_uv.c |    8 ++++++++
>  include/asm-x86/uv/bios.h |   10 +++++++++-
>  2 files changed, 17 insertions(+), 1 deletion(-)

> -	UV_BIOS_WATCHLIST_FREE
> +	UV_BIOS_WATCHLIST_FREE,
> +	UV_BIOS_MEMPROTECT

> +enum uv_memprotect {
> +	UV_MEMPROT_RESTRICT_ACCESS,
> +	UV_MEMPROT_ALLOW_AMO,
> +	UV_MEMPROT_ALLOW_RW

hm, what does this do? Does it twiddle the southbridge to protect given 
physical RAM rages from the CPU altogether?

	Ingo
