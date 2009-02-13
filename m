Return-Path: <linux-kernel-owner+w=401wt.eu-S1759324AbZBMMuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324AbZBMMuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 07:50:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbZBMMtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 07:49:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45083 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbZBMMtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 07:49:52 -0500
Date: Fri, 13 Feb 2009 13:49:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Thomas Gleixner <tglx@tglx.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
Subject: Re: [patch] rt: sysprof hrtimer fix
Message-ID: <20090213124928.GC5483@elte.hu>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain> <20090213004812.GA5824@nowhere> <20090213021626.GA5807@nowhere> <20090213030919.GA5826@nowhere> <20090213072601.GA26946@elte.hu> <20090213120451.GA5782@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213120451.GA5782@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> So, just a thing.
> -rt make the hrtimer's timers running on softirq context because the hrtimer_interrupt
> doesn't run as a threaded interrupt, and then it is not preemptible right?
> 
> In that case, sysprof will continue to run in hardirq context, as before, and
> it will considerably increase the latency. And that matters here.
> So I think it is important to put it on the reminder:

hm, not sure. Do you know it numerically how much worst-case overhead it
induces?

	Ingo
