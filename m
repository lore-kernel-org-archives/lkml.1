Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbXKMM6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbXKMM6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 07:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbXKMM6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 07:58:30 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:36385 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751932AbXKMM63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 07:58:29 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAGMuOUdMROHU/2dsb2JhbACBWw
Date: Tue, 13 Nov 2007 07:53:26 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, ananth@in.ibm.com, linux-kernel@vger.kernel.org,
       hch@infradead.org, randy.dunlap@oracle.com,
       anil.s.keshavamurthy@intel.com, prasanna@in.ibm.com
Subject: Re: [PATCH] Move kprobes examples to samples/ (resend)
Message-ID: <20071113125326.GA16455@Krystal>
References: <20071021123919.GA7648@in.ibm.com> <20071113040045.0440e575.akpm@linux-foundation.org> <20071113.040342.178304306.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071113.040342.178304306.davem@davemloft.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:52:07 up 9 days, 17:57,  2 users,  load average: 0.57, 2.02,
	2.18
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller (davem@davemloft.net) wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Tue, 13 Nov 2007 04:00:45 -0800
> 
> > On Sun, 21 Oct 2007 18:09:19 +0530 Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:
> > 
> > > Move kprobes examples from Documentation/kprobes.txt to under samples/.
> > > Patch originally by Randy Dunlap.
> > > 
> > > In addition, I have
> > > 
> > > o Updated the patch to apply on 2.6.23-mm1
> > > o Modified examples code to build on multiple architectures. Currently,
> > >   the examples code works for x86_64, x86_32 and powerpc
> > > o Cleaned up unneeded #includes
> > 
> > Could you please take a look at what's needed to get this working on sparc64?
> > 
> > samples/kprobes/kretprobe_example.c: In function `ret_handler':
> > samples/kprobes/kretprobe_example.c:19: error: implicit declaration of function `regs_return_value'
> 
> kretprobes support most likely, it's on my todo list to implement
> but it will take a while since I'm busy fixing networking bugs
> but I can stop doing that if you like.
> 
> :-)

I wonder if compiling this example makes sense when
ARCH_SUPPORTS_KRETPROBES is not defined ? We could just use a
obj-$ARCH_SUPPORTS_KRETPROBES to compile the example conditionally.

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
