Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbXD2Gre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbXD2Gre (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 02:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbXD2Gre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 02:47:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58665 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993AbXD2Grd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 02:47:33 -0400
Date: Sun, 29 Apr 2007 08:47:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070429064703.GA32281@elte.hu>
References: <20070425214704.GA32572@elte.hu> <1177596399.14496.1.camel@localhost> <200704261041.04838.gene.heskett@gmail.com> <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu> <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost> <1177809512.9756.10.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177809512.9756.10.camel@localhost>
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


* Kasper Sandberg <lkml@metanurb.dk> wrote:

> Okay so i've tried with cfs 7 now, and the completely broken audio 
> behavior is fixed.

great! :) This worried me alot!

> Im not sure im describing properly, but say it takes 35fps for the 3d 
> stuff to seem perfect, the fps monitor updates once every 1 or two 
> seconds, showing average fps(havent looked at the code, but i assume 
> it spans those 1-2 seconds), usually i have like 60 fps, but under 
> load it can go down to 35, [...]

What is this "3D stuff" exactly, and what are you using to monitor the 
framerates? (Also, could you please try another experiment and enable 
CONFIG_PREEMPT? CFS works smoothest with that enabled.)

	Ingo
