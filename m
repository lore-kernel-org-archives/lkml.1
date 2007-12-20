Return-Path: <linux-kernel-owner+w=401wt.eu-S1765438AbXLTOjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765438AbXLTOjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965124AbXLTO31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:29:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38172 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965090AbXLTO3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:29:25 -0500
Date: Thu, 20 Dec 2007 15:29:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Mike Travis <travis@sgi.com>
Subject: Re: not needed patch
Message-ID: <20071220142906.GA20794@elte.hu>
References: <200712192057.02500.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712192057.02500.yinghai.lu@sun.com>
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


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> Ingo.
> 
> commit fbdcf18df73758b2e187ab94678b30cd5f6ff9f9 is not needed. another 
> patch (by you !! commit 699d934d5f958d7944d195c03c334f28cc0b3669 x86: 
> fixup cpu_info array conversion) already removed clearing of 
> c->cpu_index. in identify_cpu
> also it is not consisent to smpboot_32.c. (it will assign id to 
> cpu_index right after
>
>  	*c = boot_cpu_data;
> )

well, it might in the worst-case be a superfluous change, but not cause 
any problems in 2.6.24, right?

> by revert commit fbdcf18df73758b2e187ab94678b30cd5f6ff9f9, we could 
> use c->cpu_index in identify_cpu.

but that's 2.6.25 stuff, right? Travis?

	Ingo
