Return-Path: <linux-kernel-owner+w=401wt.eu-S1753040AbYLSVhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbYLSVhI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 16:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYLSVg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:36:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42253 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbYLSVgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:36:55 -0500
Date: Fri, 19 Dec 2008 22:36:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>,
       Linux-rt <linux-rt-users@vger.kernel.org>
Subject: Re: [patch 1/7] ftrace: fix task state printout
Message-ID: <20081219213641.GB2351@elte.hu>
References: <20081219155504.735865178@linutronix.de> <20081219155555.919550408@linutronix.de> <c62985530812190825k4e4f5a7apa37e1ab4bc35753a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530812190825k4e4f5a7apa37e1ab4bc35753a@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> Hi Thomas,
> 
> 2008/12/19 Thomas Gleixner <tglx@linutronix.de>:
> > Impact: tracer task state decoding is wrong, size check is buggy
> >
> > The tracing code has interesting varieties of printing out task state.
> > Unfortunalely only one of the instances is correct as it copies the
> > code from sched.c:sched_show_task(). The others are plain wrong as
> > they treatthe bitfield as an integer offset into the character
> > array. Also the size check of the character array is wrong as it
> > includes the trailing \0.
> >
> > Use a common state decoder inline which does the Right Thing.
> >
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> You've already sent it out. It has been applied on -tip :-)

That's why the subject line of the series says "2.6.24.7-rt24 bugfixes" i 
guess :-)

	Ingo
