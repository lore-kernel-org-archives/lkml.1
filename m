Return-Path: <linux-kernel-owner+w=401wt.eu-S1755101Ab0AWLs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab0AWLs5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 06:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786Ab0AWLs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 06:48:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab0AWLsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 06:48:55 -0500
Date: Sat, 23 Jan 2010 06:47:29 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kyle Moffett <kyle@moffetthome.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100123114729.GA7828@redhat.com>
References: <20100121170541.7425ff10.akpm@linux-foundation.org> <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain> <20100122182827.GA13185@redhat.com> <20100122200129.GG22003@redhat.com> <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain> <20100122221348.GA4263@redhat.com> <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain> <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain> <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com> <20100123112333.GA15455@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100123112333.GA15455@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

mingo wrote:
> [...]
> > Now how do we get from here to a moderately portable API for interrogating, 
> > controlling, and intercepting process state? Essentially it would need to 
> > support all of the things that a powerful debugger would want to do, 
> > including modifying registers and memory, substituting syscall return 
> > values, etc.  I believe that "utrace" is the kernel side of that API.
> 
> The problem is, utrace does not do that really.

In fact, it is exactly designed for that.

> What utrace does is that it provides an opaque set of APIs for
> unspecified and out of tree _kernel_ modules (such as systemtap). It
> doesnt support any 'application' per se. It basically removes the
> kernel's freedom at shaping its own interaction with debug
> application.

This claim is hard to take any more seriously than emoting that the
blockio layer is "opaque" because device drivers "remove freedom" for
the kernel to "shape its interaction" with hardware.  If you have any
*real evidence* about how any present user of utrace misuses that
capability, or interferes with the "kernel's freedom", show us please.


- FChE
