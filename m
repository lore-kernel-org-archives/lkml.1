Return-Path: <linux-kernel-owner+w=401wt.eu-S1754956AbYJ3W0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbYJ3W0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 18:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbYJ3W03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 18:26:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38758 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbYJ3W02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 18:26:28 -0400
Date: Thu, 30 Oct 2008 23:26:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/2] ftrace: handle NMIs safely
Message-ID: <20081030222615.GA20507@elte.hu>
References: <20081030200831.467420488@goodmis.org> <20081030203434.GL27407@elte.hu> <alpine.DEB.1.10.0810301714190.21031@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810301714190.21031@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Thu, 30 Oct 2008, Ingo Molnar wrote:
> 
> > 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > The robustness of ftrace has been the focus of the code modification 
> > > in 2.6.28. There is one remaining issue that needed to be addressed. 
> > > This was the case of NMIs.
> > 
> > applied to tip/tracing/nmisafe, thanks Steve!
> > 
> > this looks a lot nicer approach than either putting some sort of lock 
> > into NMI context (yuck) or the disabling of NMIs (not really possible 
> > in a generic way architecturally).
> > 
> > the impact is quite non-trivial, so i dont think this is v2.6.28 
> > material.
> 
> Ingo,
> 
> Do you want me to send patches on top of these to address Andrew's 
> comements? Or do you want me to resend these with the updates.
> 
> I prefer to send patches on top, that way Andrew can make sure I did 
> his changes correctly ;-)

yeah, please do it that way. It's a separate topic so we can fold them 
back if they are also bugfixes. (and they are all cleanliness related 
and i wanted to see the stability impact ASAP)

	Ingo
