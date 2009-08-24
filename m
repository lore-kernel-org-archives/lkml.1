Return-Path: <linux-kernel-owner+w=401wt.eu-S1751909AbZHXHcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbZHXHcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 03:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbZHXHcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 03:32:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42538 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbZHXHcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 03:32:32 -0400
Date: Mon, 24 Aug 2009 09:32:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: tip tree build failure
Message-ID: <20090824073215.GA30040@elte.hu>
References: <20090824165449.559d1597.sfr@canb.auug.org.au> <1251097136.7538.124.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251097136.7538.124.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2009-08-24 at 16:54 +1000, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> > 
> > arch/powerpc/kernel/perf_callchain.c: In function 'perf_callchain_kernel':
> > arch/powerpc/kernel/perf_callchain.c:73: error: implicit declaration of function 'perf_paranoid_anon_ip'
> > 
> > Caused by commit 512cec5d6f2a71e04464bf4fd76a50571bd0dea1 ("perf_counter:
> > powerpc: Support the anonimized kernel callchain bits") which I have
> > reverted for today.
> 
> Yes, that needs to be gone, it relied on another change which 
> never went in. Ingo could you make that commit disappear?

Correct - it's still near the tail of the tree so i zapped it.

	Ingo
