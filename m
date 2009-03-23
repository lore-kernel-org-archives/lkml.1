Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbZCWFXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbZCWFXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 01:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbZCWFXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 01:23:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519AbZCWFX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 01:23:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/utrace
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, utrace-devel@redhat.com,
       Frank Eigler <fche@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
In-Reply-To: Ingo Molnar's message of  Saturday, 21 March 2009 10:12:35 +0100 <20090321091235.GA29678@elte.hu>
References: <20090321013946.890F4FC3AB@magilla.sf.frob.com>
	<20090321014244.9ADF1FC3AB@magilla.sf.frob.com>
	<20090321074301.GA19384@elte.hu>
	<20090321013912.ed6039c9.akpm@linux-foundation.org>
	<20090321091235.GA29678@elte.hu>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20090323044940.870ECFC3AB@magilla.sf.frob.com>
Date: Sun, 22 Mar 2009 21:49:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> kernel/utrace.c should probably be introduced as 
> kernel/trace/utrace.c not kernel/utrace.c. It also overlaps pending 
> work in the tracing tree and cooperation would be nice and desired.

Of course I would like to cooperate with everyone.  And of course it does
not really matter much where a source file lives.  But IMHO utrace really
does not fit in with the kernel/trace/ code much at all.  Sure, its hooks
can be used by tracer implementations that use CONFIG_TRACING stuff.  But
it is a general API about user thread state.  It belongs in kernel/trace/
"naturally" far less than, say, kprobes.  utrace will in future be used to
implement userland features (ptrace et al) that are just aspects of the
basics of what an operating system does: mediate userland for userland.
Those uses will have nothing to do with "kernel tracing".


Thanks,
Roland
