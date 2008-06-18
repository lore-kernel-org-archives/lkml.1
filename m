Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbYFRMM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbYFRMM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 08:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYFRMMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 08:12:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60305 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbYFRMMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 08:12:49 -0400
Date: Wed, 18 Jun 2008 14:12:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andi Kleen <andi@firstfloor.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 1/1] MM: virtual address debug
Message-ID: <20080618121221.GB13714@elte.hu>
References: <1213271800-1556-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213271800-1556-1-git-send-email-jirislaby@gmail.com>
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


* Jiri Slaby <jirislaby@gmail.com> wrote:

> Add some (configurable) expensive sanity checking to catch wrong address
> translations on x86.
> 
> - create linux/mmdebug.h file to be able include this file in
>   asm headers to not get unsolvable loops in header files
> - __phys_addr on x86_32 became a function in ioremap.c since
>   PAGE_OFFSET, is_vmalloc_addr and VMALLOC_* non-constasts are undefined
>   if declared in page_32.h
> - add __phys_addr_const for initializing doublefault_tss.__cr3

applied, thanks Jiri. I have created a new tip/x86/mm-debug topic for 
this because the patch touches mm/vmalloc.c and other MM bits.

Andrew, is that fine for you, can we push it into linux-next via 
auto-x86-next if it passes testing?

	Ingo
