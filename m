Return-Path: <linux-kernel-owner+w=401wt.eu-S932478AbXD2IHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478AbXD2IHi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 04:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932962AbXD2IHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 04:07:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40711 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932812AbXD2IGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 04:06:52 -0400
Date: Sun, 29 Apr 2007 10:05:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Willy Tarreau <w@1wt.eu>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070429080559.GB9988@elte.hu>
References: <1177596399.14496.1.camel@localhost> <200704261041.04838.gene.heskett@gmail.com> <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu> <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost> <1177809512.9756.10.camel@localhost> <20070429053022.GB23638@1wt.eu> <20070429065900.GB32281@elte.hu> <1177833575.9756.22.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177833575.9756.22.camel@localhost>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Kasper Sandberg <lkml@metanurb.dk> wrote:

> If you have some ideas on how these problems might be fixed i'd surely 
> try fixes and stuff, or if you have some data you need me to collect 
> to better understand whats going on. But i suspect any somewhat 
> demanding 3d application will do, and the difference is so staggering 
> that when you see it in effect, you cant miss it.

it would be great if you could try a simple experiment: does something 
as simple as glxgears resized to a large window trigger this 
'stuttering' phenomenon when other stuff is running? If not, could you 
try to find the simplest 3D stuff under Linux that already triggers it 
so that i can reproduce it?

(Also, as an independent debug-test, could you try CONFIG_PREEMPT too 
perhaps? I.e. is this 'stuttering' behavior independent of the 
preemption model and a general property of CFS?)

	Ingo
