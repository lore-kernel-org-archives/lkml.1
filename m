Return-Path: <linux-kernel-owner+w=401wt.eu-S1754150AbZKBJXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbZKBJXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 04:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbZKBJXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 04:23:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58972 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990AbZKBJXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 04:23:32 -0500
Date: Mon, 2 Nov 2009 10:23:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gleb Natapov <gleb@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Nick Piggin <npiggin@suse.de>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/11] Export __get_user_pages_fast.
Message-ID: <20091102092316.GC8933@elte.hu>
References: <1257076590-29559-1-git-send-email-gleb@redhat.com> <1257076590-29559-5-git-send-email-gleb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257076590-29559-5-git-send-email-gleb@redhat.com>
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


* Gleb Natapov <gleb@redhat.com> wrote:

> 
> Signed-off-by: Gleb Natapov <gleb@redhat.com>
> ---
>  arch/x86/mm/gup.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
> index 71da1bc..cea0dfe 100644
> --- a/arch/x86/mm/gup.c
> +++ b/arch/x86/mm/gup.c
> @@ -8,6 +8,7 @@
>  #include <linux/mm.h>
>  #include <linux/vmstat.h>
>  #include <linux/highmem.h>
> +#include <linux/module.h>
>  
>  #include <asm/pgtable.h>
>  
> @@ -274,6 +275,7 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
>  
>  	return nr;
>  }
> +EXPORT_SYMBOL_GPL(__get_user_pages_fast);

Lack of explanation in the changelog and lack of Cc:s. I fixed the 
latter.

	Ingo
