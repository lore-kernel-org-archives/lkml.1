Return-Path: <linux-kernel-owner+w=401wt.eu-S1423290AbXDYIYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423290AbXDYIYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 04:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423289AbXDYIYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 04:24:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58244 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423285AbXDYIYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 04:24:16 -0400
Date: Wed, 25 Apr 2007 10:22:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Mark Lord <lkml@rtr.ca>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Con Kolivas <kernel@kolivas.org>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070425082247.GA21546@elte.hu>
References: <20070420140457.GA14017@elte.hu> <20070421121235.GA2044@1wt.eu> <200704220155.20856.kernel@kolivas.org> <20070421160008.GA28783@elte.hu> <Pine.LNX.4.61.0704211913130.9989@yvahk01.tjqt.qr> <20070421190026.GA25720@elte.hu> <462B60A1.1020407@rtr.ca> <20070422132732.GB18471@elte.hu> <20070425081602.GA7255@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425081602.GA7255@ucw.cz>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> > it into some xorg.conf field. (It also makes sure that X isnt 
> > preempted by other userspace stuff while it does timing-sensitive 
> > operations like setting the video modes up or switching video modes, 
> > etc.)
> 
> X is priviledged. It can just cli around the critical section.

yes, that is a tool that can be used too (and is used by most drivers) - 
my point was rather that besides the disadvantages, not preempting X can 
be an advantage too - not that there are no other (and often more 
suitable) tools to do the same.

	Ingo
