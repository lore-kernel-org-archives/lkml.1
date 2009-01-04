Return-Path: <linux-kernel-owner+w=401wt.eu-S1758867AbZADUe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867AbZADUe5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 15:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZADUer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 15:34:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42724 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbZADUeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 15:34:46 -0500
Date: Sun, 4 Jan 2009 21:34:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: setup.c fix style problems
Message-ID: <20090104203433.GC1132@elte.hu>
References: <1231066898.27852.29.camel@jaswinder.satnam> <20090104172114.GA32425@elte.hu> <3f9a31f40901040957g5a391408u5cda93c4acb66e9d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40901040957g5a391408u5cda93c4acb66e9d@mail.gmail.com>
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


* Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:

> On Sun, Jan 4, 2009 at 10:51 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:
> >
> >> Impact: cleanup, fix style problems, more readable
> >>
> >> Fixes style problems:
> >> WARNING: Use #include <linux/smp.h> instead of <asm/smp.h>
> >> WARNING: Use #include <linux/percpu.h> instead of <asm/percpu.h>
> >> WARNING: Use #include <linux/topology.h> instead of <asm/topology.h>
> >> WARNING: externs should be avoided in .c files
> >> ERROR: code indent should use tabs where possible
> >>
> >> total: 2 errors, 4 warnings
> >
> > doesnt build on some configs:
> >
> >  arch/x86/kernel/setup.c:943: error: implicit declaration of function 'prefill_possible_map'
> >
> 
> This problem will only arise if CONFIG_SMP is not defined. Then 
> linux/smp.h will not include asm/smp.h
> 
> But why we are keeping non SMP stuff in asm/smp.h, we need to fix this.

yeah - i mentioned it to you before that there are such cases.

	Ingo
