Return-Path: <linux-kernel-owner+w=401wt.eu-S1761526AbYDUTx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761526AbYDUTx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755814AbYDUTxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:53:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:51727 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbYDUTxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:53:15 -0400
Date: Mon, 21 Apr 2008 21:52:00 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Rick Jones <rick.jones2@hp.com>
cc: 7eggert@gmx.de, Kok@vger.kernel.org, Auke <auke-jan.h.kok@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anton Titov <a.titov@host.bg>, Chris Snook <csnook@redhat.com>,
       "H. Willstrand" <h.willstrand@gmail.com>, netdev@vger.kernel.org,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Re: Bad network performance over 2Gbps
In-Reply-To: <480CC3D8.3040700@hp.com>
Message-ID: <alpine.LSU.0.999.0804212141050.4235@be1.lrz>
References: <aiXVe-Yn-7@gated-at.bofh.it> <ajGfA-7rt-9@gated-at.bofh.it>
 <ajGfA-7rt-11@gated-at.bofh.it> <ajGfA-7rt-13@gated-at.bofh.it>
 <ajGfA-7rt-15@gated-at.bofh.it> <ajGfA-7rt-7@gated-at.bofh.it>
 <E1JnEcl-0000xc-D9@be1.7eggert.dyndns.org> <480CC3D8.3040700@hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18TkEvcs6u62iz98mybBtKHEMKNHlHKMGnE7E/
 MEe4PhEyMjqlRjZ4n/Tb3el7rjAYvnZJ+YhwZ8sJ5foMn3nnwJ
 8gpCM+CMgLymvWvPFkPZw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2008, Rick Jones wrote:
> Bodo Eggert wrote:
> > Kok, Auke <auke-jan.h.kok@intel.com> wrote:

> > > [X86] IRQBALANCE: Mark as BROKEN and disable by default
> > > 
> > > The IRQBALANCE option causes interrupts to bounce all around on SMP
> > > systems
> > > quickly burying the CPU in migration cost and cache misses. Mainly
> > > affected
> > > are network interrupts and this results in one CPU pegged in softirqd
> > > completely.
> > 
> > 
> > If this is the problem, maybe it would help to only balance the IRQs each
> > e.g. ten seconds? Unfortunately I have no SMP system to try it out.
> 
> Be it kernel or user space, for consistent benchmark results it needs to be
> able to be turned-off without turning the code.  That leaves me in agreement
> with Stephen that if it must exist, the user space one would be preferable.
> It can be easily terminated with extreme prejudice.

I agree that having a full-featured userspace balancer daemon with lots of 
intelligence will be theoretically better, but if you can have a simple
daemon doing OK on many machines for less than the userspace daemon's
kernel stack, why not?
-- 
Funny quotes:
31. Why do "overlook" and "oversee" mean opposite things?
