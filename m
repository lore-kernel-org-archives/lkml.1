Return-Path: <linux-kernel-owner+w=401wt.eu-S1751726AbZFLPBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbZFLPBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbZFLPBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:01:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41026 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbZFLPBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:01:47 -0400
Date: Fri, 12 Jun 2009 17:00:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Yinghai Lu <yinghai@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: use zalloc_cpumask_var in arch_early_irq_init
Message-ID: <20090612150042.GB31667@elte.hu>
References: <4A318034.3010102@kernel.org> <200906122110.01032.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906122110.01032.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Fri, 12 Jun 2009 07:37:48 am Yinghai Lu wrote:
> > So could make sure MAXSMP get clearred cpumask
> >
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> Ingo, this only applies to your tree; can you take it?

should apply to upstream too so could go into your tree with the 
other cpumask changes, right?

	Ingo
