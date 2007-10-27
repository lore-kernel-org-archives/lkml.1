Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbXJ0NQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbXJ0NQm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 09:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbXJ0NQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 09:16:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35671 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbXJ0NQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 09:16:34 -0400
Date: Sat, 27 Oct 2007 15:16:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [2.6.23-rt3] NMI watchdog trace of deadlock
Message-ID: <20071027131618.GA22589@elte.hu>
References: <1193245634.20679.8.camel@localhost.localdomain> <1193462494.25330.7.camel@Homer.simpson.net> <200710271915.42363.nickpiggin@yahoo.com.au> <20071027094407.GA12047@elte.hu> <1193480269.8374.3.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193480269.8374.3.camel@Homer.simpson.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> > it's not atomic interrupt context but irq thread context - and -rt 
> > remaps kmap_atomic() to kmap() internally.
> 
> Hm.  Looking at the change to mm/bounce.c, perhaps I should do this 
> instead?

yeah, this looks better.

	Ingo
