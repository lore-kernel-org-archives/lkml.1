Return-Path: <linux-kernel-owner+w=401wt.eu-S1757131AbZCZWaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131AbZCZWaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 18:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbZCZWaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 18:30:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40219 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbZCZWaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 18:30:06 -0400
Date: Thu, 26 Mar 2009 23:29:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/2] tracing: add average time in function to function
	profiler
Message-ID: <20090326222924.GA28755@elte.hu>
References: <20090326010737.611522983@goodmis.org> <20090326010811.510051401@goodmis.org> <20090327091507.f133257e.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090327091507.f133257e.sfr@canb.auug.org.au>
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Steve,
> 
> On Wed, 25 Mar 2009 21:07:39 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Show the average time in the function (Time / Hit)
> 
> Just wondering why we need to do this in the kernel ... there is 
> already enough information for a user to figure these averages 
> out.

Well, this argument can be applied to a lot of information exposed 
in /proc and /sys. For example in theory there's no need for 
/proc/interrupts at all, because the IRQ mappings are present in the 
syslog and in /sys enumerations and the IRQ counts are present in 
/proc/stat already.

I still find /proc/interrupts very handy, despite purist arguments 
that it is redundant and that it thus should not be there.

So we provide such things when it's easy to do, when it's a 
meaningful piece of information and it is convenient to users and 
developers.

Note that the function profiler is a double-non-default item in 
/debug (you need to enable two non-default options in the .config to 
get it), so you cannot stumble on it accidentally.

	Ingo
