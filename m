Return-Path: <linux-kernel-owner+w=401wt.eu-S1758281AbYKWKEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281AbYKWKEt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 05:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbYKWKEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 05:04:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42465 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbYKWKEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 05:04:40 -0500
Date: Sun, 23 Nov 2008 11:04:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joe Korty <joe.korty@ccur.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] create /proc/timer-wheel-list
Message-ID: <20081123100424.GW30453@elte.hu>
References: <20081121221113.GA13566@tsunami.ccur.com> <20081122173423.GC2748@x200.localdomain> <20081123015923.GA26478@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123015923.GA26478@tsunami.ccur.com>
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


* Joe Korty <joe.korty@ccur.com> wrote:

> On Sat, Nov 22, 2008 at 12:34:23PM -0500, Alexey Dobriyan wrote:
> > On Fri, Nov 21, 2008 at 05:11:13PM -0500, Joe Korty wrote:
> > > Create /proc/timer_wheel_list.
> > >
> > > This does for the timer wheel what /proc/timer_list
> > > does for hrtimers -- provide a way of displaying what
> > > timers are running on what cpus, and their attributes.
> > 
> > The fact that it's called a timer wheel is just an implementation detail
> > unsuitable for permanent file.
> 
> Agreed.  I'll come up with something else.  lrtimer_list is a good 
> candidate.

no - please include it in /proc/timer_list instead. It already lists 
clockevents and hrtimers - listing timer-list timers would be a 
natural extension of that facility.

	Ingo
