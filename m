Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbYEYUXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbYEYUXg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 16:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbYEYUX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 16:23:28 -0400
Received: from www.tglx.de ([62.245.132.106]:41681 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141AbYEYUX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 16:23:27 -0400
Date: Sun, 25 May 2008 22:21:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, akpm@osdl.org,
       Ingo Molnar <mingo@elte.hu>, Clark Williams <clark.williams@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Gregory Haskins <ghaskins@novell.com>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: enable preemption in delay
In-Reply-To: <Pine.LNX.4.58.0805250915410.20625@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.1.10.0805252217580.3295@apollo.tec.linutronix.de>
References: <Pine.LNX.4.58.0805242306280.3977@gandalf.stny.rr.com> <alpine.LFD.1.10.0805251406260.3295@apollo.tec.linutronix.de> <Pine.LNX.4.58.0805250915410.20625@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 May 2008, Steven Rostedt wrote:
> 
> On Sun, 25 May 2008, Thomas Gleixner wrote:
> >
> > +/*
> > + * 5 usec on a 1GHZ machine. Not necessarily correct, but not too long
> > + * either.
> 
> And what happens when we have 10GHz boxes that can do migration in 1us,
> and the delay that is asked for is 2us. We can return early.  I don't like
> to place assumptions of this kind that can hurt with future hardware
> enhancements.

Do the math. It's 500ns on a 10GHz machine then. So nothing to worry
about and future proof. 

Also when those 10GHZ machines arrive the synchronized TSC should have
finally become reality.

Thanks,

	tglx
