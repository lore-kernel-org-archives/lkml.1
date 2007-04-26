Return-Path: <linux-kernel-owner+w=401wt.eu-S1031496AbXDZUMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031496AbXDZUMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031497AbXDZUMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:12:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41705 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031496AbXDZUL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:11:58 -0400
Date: Thu, 26 Apr 2007 22:11:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070426201114.GB27031@elte.hu>
References: <20070425214704.GA32572@elte.hu> <1177615646.25960.42.camel@localhost.localdomain> <20070426193544.GA18512@elte.hu> <1177616541.25960.45.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177616541.25960.45.camel@localhost.localdomain>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> > thanks, applied! :-) (Did you manage to test whether PI works?)
> 
> Yup, all tests of the kernel tester scripts work as well as the glibc 
> tests.

great! I think this fix was the last one needed to make CFS fully 
compatible with the vanilla scheduler.

	Ingo
