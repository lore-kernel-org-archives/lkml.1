Return-Path: <linux-kernel-owner+w=401wt.eu-S1765269AbYD3UHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765269AbYD3UHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761275AbYD3UHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:07:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38760 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759929AbYD3UHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:07:00 -0400
Date: Wed, 30 Apr 2008 22:06:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland Dreier <rdreier@cisco.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] kmemcheck
Message-ID: <20080430200638.GA14164@elte.hu>
References: <20080429203446.GA18314@elte.hu> <adazlrb8fxq.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adazlrb8fxq.fsf@cisco.com>
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


* Roland Dreier <rdreier@cisco.com> wrote:

>  >       kmemcheck: enable in the x86 Kconfig
> 
> This patch does:
> 
>  > +config KMEMCHECK
>  > +	bool "kmemcheck: trap use of uninitialized memory"
>  > +	depends on X86_32
> 
> So it's only possible to select kmemcheck on 32-bit builds, But you 
> also seem to have 64-bit stuff, eg
> 
>  >       kmemcheck: support for 64-bit
>  >       kmemcheck: add missing pte_hidden() for x86-64
> 
> so is the Kconfig patch slightly out-of-date?

no, 64-bit kmemcehck is still work in progress, so it's not Kconfig 
selectable.

	Ingo
