Return-Path: <linux-kernel-owner+w=401wt.eu-S1761485AbYDUOab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761485AbYDUOab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 10:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758814AbYDUOaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 10:30:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59593 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790AbYDUOaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 10:30:22 -0400
Date: Mon, 21 Apr 2008 16:29:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, andi@firstfloor.org,
       joern@logfs.org, w@1wt.eu, lkml@rtr.ca, bunk@kernel.org,
       alan@lxorguk.ukuu.org.uk, shawn.bohrer@gmail.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: x86: 4kstacks default
Message-ID: <20080421142948.GV9554@elte.hu>
References: <20080420124717.GH8474@1wt.eu> <480B44C4.4060104@rtr.ca> <20080420133857.GB26536@1wt.eu> <480B50F1.8040309@firstfloor.org> <20080420164133.GB20694@logfs.org> <480B7B1E.7010707@firstfloor.org> <20080420174249.GC20694@logfs.org> <480B8932.1090308@firstfloor.org> <20080420115053.7151ef8d@laptopd505.fenrus.org> <20080420145020.217ecdd4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080420145020.217ecdd4.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > On Sun, 20 Apr 2008 11:50:53 -0700 Arjan van de Ven <arjan@infradead.org> wrote:
> > On Sun, 20 Apr 2008 20:19:30 +0200
> > Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > In theory if you e.g. convert a recursive algorithm
> > > to iterative you might save some cache foot print, but I don't
> > > think that really happens in kernel code.
> > > 
> > 
> > this is what Al did for the symlink recursion thing, and Jens did 
> > for the block layer... so yes this conversion does happen for real.
> 
> md got mostly-fixed too, via Neil's patch which sat in -mm for nearly 
> two years.

had we done the de-obfuscate-4K-stacks Kconfig change earlier it might 
have gotten upstream faster.

	Ingo
