Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbZAUUhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbZAUUhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 15:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbZAUUhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 15:37:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34213 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbZAUUhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 15:37:22 -0500
Date: Wed, 21 Jan 2009 21:37:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] x86: optimise page fault entry
Message-ID: <20090121203715.GA17280@elte.hu>
References: <20090120032426.GE16304@wotan.suse.de> <20090121194541.GA22911@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090121194541.GA22911@cmpxchg.org>
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


* Johannes Weiner <hannes@cmpxchg.org> wrote:

> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -419,7 +419,6 @@ static noinline void pgtable_bad(struct 
>  	printk(KERN_ALERT "%s: Corrupted page table at address %lx\n",
>  	       tsk->comm, address);
>  	dump_pagetable(address);
> -	tsk = current;
>  	tsk->thread.cr2 = address;
>  	tsk->thread.trap_no = 14;
>  	tsk->thread.error_code = error_code;

applied to tip/x86/mm, thanks Johannes!

	Ingo
