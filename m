Return-Path: <linux-kernel-owner+w=401wt.eu-S1761427AbZDJL6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761427AbZDJL6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 07:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbZDJL6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 07:58:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46206 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbZDJL6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 07:58:30 -0400
Date: Fri, 10 Apr 2009 13:58:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Luis Henriques <henrix@sapo.pt>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Avi Kivity <avi@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Problem with kvm on -tip
Message-ID: <20090410115803.GL21506@elte.hu>
References: <20090409210738.GA4566@hades.domain.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090409210738.GA4566@hades.domain.com>
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


* Luis Henriques <henrix@sapo.pt> wrote:

> Hi,
> 
> Since I am not sure if this problem has already been reported, here it goes.
> 
> My log gets the following messages in -tip tree.  I don't know for 
> how long this issue is around and whether the problem is on 
> lockdep or on kvm.  After the first lockdep message, I get a huge 
> amount of BUGs from kvm (which stop only when I kill kvm).  So, I 
> believe issue is on kvm.

Jeremy, have you considered (and tested) KVM when doing the MMU/CPU 
notifier changes? It's these changes:

224101e: x86/paravirt: finish change from lazy cpu to context switch start/end
b407fc5: x86/paravirt: flush pending mmu updates on context switch
7fd7d83: x86/pvops: replace arch_enter_lazy_cpu_mode with arch_start_context_switch

	Ingo
