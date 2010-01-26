Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823Ab0AZVCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab0AZVCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 16:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398Ab0AZVCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 16:02:35 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39826 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0AZVCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 16:02:34 -0500
Date: Tue, 26 Jan 2010 22:02:32 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, tromey@redhat.com,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kyle Moffett <kyle@moffetthome.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100126210232.GF6567@basil.fritz.box>
References: <20100122200129.GG22003@redhat.com> <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain> <20100122221348.GA4263@redhat.com> <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain> <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain> <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com> <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain> <m33a1tnbd9.fsf@fleche.redhat.com> <877hr4g49l.fsf@basil.nowhere.org> <alpine.LFD.2.00.1001261038150.3574@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001261038150.3574@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The problem is that anything that is based on reparenting and signals is 
> fundamentally a "one parent only" kind of interface. See?

I was actually thinking about that before I wrote the email.

But when I did that i couldn't come up with a good scenario
where multiple debuggers actually make sense. In a sense
being a debugger is really a very "intimate" thing for process. Do you
really want to have multiple of them messing with each other?

If yes how would they know what to touch and what not?

The only thing I could think of was "user space virtualization"
(like old UML) together with a real debugger, but frankly
these solutions all seemed like big race conditions to me
anyways and should be better done in the kernel or below it, 
so I have a hard time taking them seriously.

Can you think of any scenario where multiple debuggers
on a process make sense?

-Andi

