Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbZAKE3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbZAKE3e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 23:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbZAKE30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 23:29:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58810 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbZAKE3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 23:29:25 -0500
Date: Sun, 11 Jan 2009 05:28:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sparseirq: make some func to be used with genirq
Message-ID: <20090111042857.GA7195@elte.hu>
References: <496534B1.6080902@kernel.org> <20090108120619.GF1539@elte.hu> <1231435078.3178.278.camel@calx> <20090111034646.GA28520@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090111034646.GA28520@elte.hu>
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


Yinghai, the crossbuild to Alpha fails with:

/home/mingo/tip/kernel/fork.c: In function 'copy_signal':
/home/mingo/tip/kernel/fork.c:825: warning: unused variable 'ret'
/home/mingo/tip/drivers/char/random.c: In function 'get_timer_rand_state':
/home/mingo/tip/drivers/char/random.c:584: error: dereferencing pointer to incomplete type
/home/mingo/tip/drivers/char/random.c: In function 'set_timer_rand_state':
/home/mingo/tip/drivers/char/random.c:594: error: dereferencing pointer to incomplete type
make[3]: *** [drivers/char/random.o] Error 1

	Ingo
