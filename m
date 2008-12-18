Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753308AbYLRMgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbYLRMgi (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 07:36:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbYLRMg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 07:36:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33830 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbYLRMg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 07:36:27 -0500
Date: Thu, 18 Dec 2008 13:36:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] x86: process.c declare c1e_remove_cpu before they get
	used
Message-ID: <20081218123613.GE25715@elte.hu>
References: <1229536205.23068.6.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229536205.23068.6.camel@jaswinder.satnam>
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


* Jaswinder Singh <jaswinder@infradead.org> wrote:

> Impact: cleanup
> 
> Included asm/idle.h for c1e_remove_cpu declaration.
> 
> Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
> ---
>  arch/x86/kernel/process.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index f50f8bf..25313de 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -10,6 +10,7 @@
>  #include <linux/ftrace.h>
>  #include <asm/system.h>
>  #include <asm/apic.h>
> +#include <asm/idle.h>
>  
>  unsigned long idle_halt;
>  EXPORT_SYMBOL(idle_halt);

hm, why is this needed? Have you seen a compiler warning?

	Ingo
