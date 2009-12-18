Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbZLROdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbZLROdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 09:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbZLROdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 09:33:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57613 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792AbZLROdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 09:33:39 -0500
Date: Fri, 18 Dec 2009 15:33:38 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Shaun Patterson <shaunpatterson@gmail.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Staging: Fixed spelling mistake
In-Reply-To: <1260070252-19445-1-git-send-email-shaunpatterson@gmail.com>
Message-ID: <alpine.LNX.2.00.0912181532560.3755@pobox.suse.cz>
References: <1260070252-19445-1-git-send-email-shaunpatterson@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Dec 2009, Shaun Patterson wrote:

> 
> Signed-off-by: Shaun Patterson <shaunpatterson@gmail.com>
> ---
>  arch/x86/kernel/vmiclock_32.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/vmiclock_32.c b/arch/x86/kernel/vmiclock_32.c
> index 611b9e2..a58ccae 100644
> --- a/arch/x86/kernel/vmiclock_32.c
> +++ b/arch/x86/kernel/vmiclock_32.c
> @@ -171,7 +171,7 @@ static int vmi_timer_next_event(unsigned long delta,
>  {
>  	/* Unfortunately, set_next_event interface only passes relative
>  	 * expiry, but we want absolute expiry.  It'd be better if were
> -	 * were passed an aboslute expiry, since a bunch of time may
> +	 * were passed an absolute expiry, since a bunch of time may
>  	 * have been stolen between the time the delta is computed and
>  	 * when we set the alarm below. */
>  	cycle_t now = vmi_timer_ops.get_cycle_counter(vmi_counter(VMI_ONESHOT));

As this seems to be present in current Linus' tree still, I have applied 
it to trivial queue (after fixing the subject, nothing to do with 
staging).

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
