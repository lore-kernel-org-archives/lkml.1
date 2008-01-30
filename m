Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbYA3VvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbYA3VvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:51:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbYA3Vuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:50:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40254 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbYA3Vut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:50:49 -0500
Date: Wed, 30 Jan 2008 22:50:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: travis@sgi.com
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andi Kleen <ak@suse.de>,
       Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
       Sam Ravnborg <sam@ravnborg.org>, Rusty Russell <rusty@rustcorp.com.au>,
       linuxppc-dev@ozlabs.org, linux-ia64@vger.kernel.org
Subject: Re: [PATCH 2/6] percpu: Change Kconfig to HAVE_SETUP_PER_CPU_AREA
	linux-2.6.git
Message-ID: <20080130215015.GA28242@elte.hu>
References: <20080130180940.022172000@sgi.com> <20080130180940.369732000@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130180940.369732000@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* travis@sgi.com <travis@sgi.com> wrote:

> Change:
> 	config ARCH_SETS_UP_PER_CPU_AREA
> to:
> 	config HAVE_SETUP_PER_CPU_AREA

undocumented change:

>  config ARCH_NO_VIRT_TO_BUS
> --- a/init/main.c
> +++ b/init/main.c
> @@ -380,6 +380,8 @@ static void __init setup_per_cpu_areas(v
>  
>  	/* Copy section for each CPU (we discard the original) */
>  	size = ALIGN(PERCPU_ENOUGH_ROOM, PAGE_SIZE);
> +	printk(KERN_INFO
> +	    "PERCPU: Allocating %lu bytes of per cpu data (main)\n", size);
>  	ptr = alloc_bootmem_pages(size * nr_possible_cpus);

but looks fine to me.

	Ingo
