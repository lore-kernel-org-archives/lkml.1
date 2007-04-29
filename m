Return-Path: <linux-kernel-owner+w=401wt.eu-S932690AbXD2IGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690AbXD2IGh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 04:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932478AbXD2IGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 04:06:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56516 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932690AbXD2IE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 04:04:56 -0400
Date: Sun, 29 Apr 2007 10:03:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Willy Tarreau <w@1wt.eu>, Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070429080359.GA10844@elte.hu>
References: <200704261041.04838.gene.heskett@gmail.com> <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu> <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost> <1177809512.9756.10.camel@localhost> <20070429053022.GB23638@1wt.eu> <20070429065900.GB32281@elte.hu> <20070429071627.GC23638@1wt.eu> <20070429075436.GZ31925@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429075436.GZ31925@holomorphy.com>
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


* William Lee Irwin III <wli@holomorphy.com> wrote:

> I think it'd be a good idea to merge scheduler classes before changing 
> over the policy so future changes to policy have smaller code impact. 
> Basically, get scheduler classes going with the mainline scheduler.

i've got a split up patch for the class stuff already, but lets first 
get some wider test-coverage before even thinking about upstream 
integration. This is all v2.6.22 stuff at the earliest.

	Ingo
