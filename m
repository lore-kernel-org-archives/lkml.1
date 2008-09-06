Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbYIFRKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbYIFRKK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 13:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbYIFRJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 13:09:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44114 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbYIFRJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 13:09:58 -0400
Date: Sat, 6 Sep 2008 19:09:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dyn_array: using %pF instead of
	print_fn_descriptor_symbol
Message-ID: <20080906170944.GG4856@elte.hu>
References: <1220047669-15029-1-git-send-email-yhlu.kernel@gmail.com> <20080829152053.92fa6fd4.akpm@linux-foundation.org> <86802c440808291532r15dd581cj3f69755985578c2b@mail.gmail.com> <20080829155319.dc76b1c0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080829155319.dc76b1c0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0021]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> >	ptr = __alloc_bootmem_nopanic(total_size, max_align, 0);
> >	if (!ptr)
> >		panic("Can not alloc dyn_alloc\n");
> 
> Why duplicate the panic()?  Just call __alloc_bootmem().

agreed.

> > #ifdef CONFIF_GENERIC_HARDIRQS
> 
> That doesn't appear to have been very well tested?

on non-genirq systems? Most likely. If then most testing they get is 
from cross-build tools. Few if any actual users.

> The code has a few coding-style glitches which checkpatch can detect.

yeah. Yinghai, could you please fix them?

	Ingo
