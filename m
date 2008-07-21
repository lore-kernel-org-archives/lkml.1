Return-Path: <linux-kernel-owner+w=401wt.eu-S1759184AbYGULZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759184AbYGULZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 07:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbYGULZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 07:25:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58725 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbYGULZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 07:25:07 -0400
Date: Mon, 21 Jul 2008 13:24:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86-rest: fix sparse warnings
Message-ID: <20080721112453.GB23095@elte.hu>
References: <1215913730.2711.1.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215913730.2711.1.camel@jaswinder.satnam>
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

> CHECK   arch/x86/mm/init_32.c
> arch/x86/mm/init_32.c:290:13: warning: symbol 'add_one_highpage_init' was not declared. Should it be static?
> arch/x86/mm/init_32.c:437:6: warning: symbol 'zap_low_mappings' was not declared. Should it be static?
> arch/x86/mm/init_32.c:774:6: warning: symbol 'free_initmem' was not declared. Should it be static?
> 
> CHECK   arch/x86/mm/fault.c
> arch/x86/mm/fault.c:581:16: warning: symbol 'do_page_fault' was not declared. Should it be static?
> 
> CHECK   arch/x86/mm/pat.c
> arch/x86/mm/pat.c:566:6: warning: symbol 'map_devmem' was not declared. Should it be static?
> arch/x86/mm/pat.c:583:6: warning: symbol 'unmap_devmem' was not declared. Should it be static?
> 
> CHECK   arch/x86/mm/pgtable_32.c
> arch/x86/mm/pgtable_32.c:115:6: warning: symbol 'set_pmd_pfn' was not declared. Should it be static?
> 
> CHECK   arch/x86/mach-default/setup.c
> arch/x86/mach-default/setup.c:19:5: warning: symbol 'no_broadcast' was not declared. Should it be static?
> 
> Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
> ---
>  arch/x86/mach-default/setup.c |    2 +-
>  include/asm-x86/pat.h         |    3 +++
>  include/asm-x86/pgtable_32.h  |    6 ++++++
>  include/asm-x86/setup.h       |    1 +
>  4 files changed, 11 insertions(+), 1 deletions(-)

please split this up too into individual commits, against tip/master. 
Cleanups are generally more manageable if they are finegrained.

	Ingo
