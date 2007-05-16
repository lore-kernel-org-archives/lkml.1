Return-Path: <linux-kernel-owner+w=401wt.eu-S1760996AbXEPIMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760996AbXEPIMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 04:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757537AbXEPIMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 04:12:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35768 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757566AbXEPIML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 04:12:11 -0400
Date: Wed, 16 May 2007 10:08:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>
Subject: Re: [patch] CFS scheduler, -v12
Message-ID: <20070516080843.GA8909@elte.hu>
References: <20070513153853.GA19846@elte.hu> <464A6698.3080400@bigpond.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464A6698.3080400@bigpond.net.au>
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


* Peter Williams <pwil3058@bigpond.net.au> wrote:

> >As usual, any sort of feedback, bugreport, fix and suggestion is more 
> >than welcome,
> 
> Load balancing appears to be badly broken in this version.  When I 
> started 4 hard spinners on my 2 CPU machine one ended up on one CPU 
> and the other 3 on the other CPU and they stayed there.

hm, i cannot reproduce this on 4 different SMP boxen, trying various 
combinations of SCHED_SMT/MC and other .config options that might make a 
difference to balancing. Could you send me your .config?

	Ingo
