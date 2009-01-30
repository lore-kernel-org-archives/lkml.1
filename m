Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555AbZA3JAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbZA3JAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 04:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZA3JAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 04:00:35 -0500
Received: from mout.perfora.net ([74.208.4.195]:50739 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbZA3JAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 04:00:34 -0500
Subject: Re: scheduler nice 19 versus 'idle' behavior / static low-priority
	scheduling
From: Nathanael Hoyle <nhoyle@hoyletech.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1233305433.4495.154.camel@laptop>
References: <1233294584.28741.2.camel@localhost>
	 <1233305433.4495.154.camel@laptop>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 04:00:30 -0500
Message-Id: <1233306030.17301.36.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+Lnz0oK5BWnXyO1x0bd/CMacqNkqkLumjqpGF
 +Snd1MFW+LF2/t50NfRqQ9WsT3OnUQO55Pe8eM8FDnOrbCrTeU
 XmjBUYMJH4c6P/LadtqCop6h3zXSN/v
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 09:50 +0100, Peter Zijlstra wrote:
> On Fri, 2009-01-30 at 00:49 -0500, Nathanael Hoyle wrote:
> > 
> > 1) Is my problem 'expected' based on others' understanding of the
> > current design of the scheduler, or do I have a one-off problem to
> > troubleshoot here?
> 
> What kernel are you running (or did my eye glance over that detail in
> your longish email) ?
> 

I didn't include it, I should have:

$ uname -a
Linux nightmare 2.6.27-gentoo-r7-nhoyle #2 SMP Wed Jan 28 19:04:37 EST
2009 x86_64 Intel(R) Core(TM)2 Quad CPU Q9450 @ 2.66GHz GenuineIntel
GNU/Linux

> > 2) Am I overlooking obvious alternative (but clean) fixes?
> 
> Maybe, we fixed a glaring bug in this department recently (or more even,
> if you're on older than .28).
> 

Yep, .27 atm.

> > 3) Does anyone else see the need for static, but low process priorities?
> 
> Yep, its rather common.
> 
> > 4) What is the view of introducing a new scheduler class to handle this?
> 
> We should have plenty available, SCHED_IDLE should just work -- as
> should nice 19 for that matter.
> 

Thanks!
-Nathanael

