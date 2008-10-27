Return-Path: <linux-kernel-owner+w=401wt.eu-S1752874AbYJ0NWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbYJ0NWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 09:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYJ0NWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 09:22:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52568 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbYJ0NWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 09:22:11 -0400
Date: Mon, 27 Oct 2008 14:21:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] timers: Handle HRTIMER_CB_IRQSAFE_UNLOCKED correctly
	from softirq context
Message-ID: <20081027132159.GF25371@elte.hu>
References: <20081023215003.GC1480@in.ibm.com> <20081025023303.GD6248@linux.vnet.ibm.com> <20081025045238.GA27934@in.ibm.com> <20081025142325.GB8446@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081025142325.GB8446@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> > > > Fix this by emulating hardirq context while running these callbacks from
> > > > the hrtimer softirq.
> > > 
> > > Good catch!!!  One confusion (probably on my part) below.
> > 
> > Hmm.. Let's see...
> 
> Gah!!!
> 
> I am so used to seeing sequences of code that disable irqs and then 
> re-enable them that I misread the original, failing to see that you 
> were -enabling- irqs and then re-disabling them.  :-/
> 
> Never mind!!!  Sorry for the noise...

ok - i've applied Gautham's fix to tip/timers/urgent, with your and 
Peter's Acked-by lines.

	Ingo
