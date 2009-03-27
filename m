Return-Path: <linux-kernel-owner+w=401wt.eu-S932874AbZC0ARr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874AbZC0ARr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932835AbZC0AQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:16:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57347 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932814AbZC0AQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:16:54 -0400
Date: Fri, 27 Mar 2009 01:16:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH]: Fix sparc64 build.
Message-ID: <20090327001632.GA10459@elte.hu>
References: <20090326.164417.155660865.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090326.164417.155660865.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> 
> Ingo, didn't we fix this (a few times)? :-)
> 
> Linus, please apply:
> 
> sparc64: Fix build of timer_interrupt().
> 
> arch/sparc/kernel/time_64.c: In function ‘timer_interrupt’:
> arch/sparc/kernel/time_64.c:732: error: ‘struct kernel_stat’ has no member named ‘irqs’
> make[1]: *** [arch/sparc/kernel/time_64.o] Error 1

Oops, sorry! Note that the fix is in a pending pull request (but 
this still does not make it right that i cut trees with this not in 
it).

I did check sparc for that particular pull request:

  aldebaran:~/linux/linux> ./m-arch-all
  [...]
  testing      sparc:  -git:  pass (   2),  -tip:  pass (   2)

So once the pieces are together again, it should all be fine.

	Ingo
