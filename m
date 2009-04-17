Return-Path: <linux-kernel-owner+w=401wt.eu-S1758894AbZDQAb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbZDQAb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758049AbZDQAbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:31:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55400 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756895AbZDQAbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:31:10 -0400
Date: Fri, 17 Apr 2009 02:30:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] tracing: add #include <linux/delay.h> to fix build
	failure in test_work()
Message-ID: <20090417003042.GD29630@elte.hu>
References: <20090416021830.556671772@goodmis.org> <20090416021928.239106997@goodmis.org> <20090416083934.GB9813@elte.hu> <alpine.DEB.2.00.0904161008080.6495@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904161008080.6495@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> 
> On Thu, 16 Apr 2009, Ingo Molnar wrote:
> > 
> > ------------------------>
> > >From 63c14122a54c26122ccdbe596123f8e2b75c3116 Mon Sep 17 00:00:00 2001
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Thu, 16 Apr 2009 10:26:51 +0200
> > Subject: [PATCH] tracing: add #include <linux/delay.h> to fix build failure in test_work()
> > MIME-Version: 1.0
> > Content-Type: text/plain; charset=utf-8
> > Content-Transfer-Encoding: 8bit
> > 
> > This build failure occured on a few rare configs:
> > 
> >  kernel/trace/trace_events.c: In function ?test_work?:
> >  kernel/trace/trace_events.c:975: error: implicit declaration of function ?udelay?
> >  kernel/trace/trace_events.c:980: error: implicit declaration of function ?msleep?
> > 
> > delay.h is included in way too many other headers, hiding cases
> > where new usage is added without header inclusion.
> > 
> > Impact: build fix
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> Thanks Ingo!
> 
> I don't see this change in tip, do you want me to apply it in my tree?

It's pushed out now.

	Ingo
