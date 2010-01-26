Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896Ab0AZWDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab0AZWDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 17:03:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864Ab0AZWDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 17:03:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50101 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab0AZWDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 17:03:06 -0500
Date: Tue, 26 Jan 2010 23:03:01 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, tromey@redhat.com,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kyle Moffett <kyle@moffetthome.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100126220301.GG6567@basil.fritz.box>
References: <20100122221348.GA4263@redhat.com> <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain> <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain> <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com> <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain> <m33a1tnbd9.fsf@fleche.redhat.com> <877hr4g49l.fsf@basil.nowhere.org> <alpine.LFD.2.00.1001261038150.3574@localhost.localdomain> <20100126210232.GF6567@basil.fritz.box> <20100126215349.GB19146@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100126215349.GB19146@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Simple example. Try to debug/strace strace ot gdb itself. Not trivial,
> you can't attach to strace's tracees. Recently I spent 2 days trying to
> understand why strace -f hangs. I was able to attach to strace, but
> I wasn't able to see what its tracees do.

But what would the semantics be inside the tracees even if you could?

> And, it was not possible to even trace strace until it hangs, with
> ptrace the tracee (strace) must stop to report the event and this
> shadowed the race.

"Shadowing the race" was the second surname of strace I thought anyways @)
Basically if you care about races never use strace in the first place.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
