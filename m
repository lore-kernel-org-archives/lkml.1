Return-Path: <linux-kernel-owner+w=401wt.eu-S1760251AbXGQHid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251AbXGQHid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 03:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbXGQHiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 03:38:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36855 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbXGQHiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 03:38:25 -0400
Date: Tue, 17 Jul 2007 09:37:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Markus <lists4me@web.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch] CFS scheduler, -v19
Message-ID: <20070717073709.GA12465@elte.hu>
References: <20070706173319.GA2356@elte.hu> <200707141711.25272.lists4me@web.de> <20070716094158.GA19491@elte.hu> <200707161959.17750.lists4me@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707161959.17750.lists4me@web.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Markus <lists4me@web.de> wrote:

> The dmesg output is not differing in any interesting point (just some 
> numbers, like raid-benchmark, some irqs or usb-numbers...)

could you please send me the cfs-debug-info output nevertheless?

> Nothing is printed for a disapeared app for me.
> 
> Is there anything more I can try?

sure - could you start one of those apps via:

	strace -ttt -TTT -o trace.log -f <app>

and wait for it to "disappear"? Then compress the trace.log via bzip2 -9 
(it's probably going to be a really large file) and send me it?

	Ingo
