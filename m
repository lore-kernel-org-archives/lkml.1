Return-Path: <linux-kernel-owner+w=401wt.eu-S1752205AbZDOPLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbZDOPLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbZDOPLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:11:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53085 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbZDOPLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:11:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090415140959.GD12760@elte.hu>
References: <20090415140959.GD12760@elte.hu> <20090415120307.GB17775@elte.hu> <alpine.LFD.2.00.0904141103550.18124@localhost.localdomain> <alpine.LFD.2.00.0904140954160.18124@localhost.localdomain> <20090414161053.28145.1209.stgit@warthog.procyon.org.uk> <15312.1239731865@redhat.com> <14172.1239795632@redhat.com> <1488.1239801659@redhat.com> 
To: Ingo Molnar <mingo@elte.hu>
Cc: dhowells@redhat.com, Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, tj@kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Fix the section attribute on UP DECLARE_PER_CPU()
Date: Wed, 15 Apr 2009 16:09:10 +0100
Message-ID: <9843.1239808150@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:

> > > Please create include/linux/percpu_types.h for basic data types 
> > > and simple, self-sufficient primitives. Also have an 
> > > include/linux/percpu_api.h or include/linux/percpu.h include 
> > > file for convenience/speedup inlines. The latter will only be 
> > > included in .c files, where 'combination' of type spaces is not 
> > > a problem.
> > 
> > Not so.  The problem is that various header files make use of 
> > per-cpu variable accessors (asm/current.h and asm/thread_info.h to 
> > name a couple) to build inline asm.
> 
> Hm, what portion did you mark with 'not so'?

The statement that "The latter will only be included in .c files, where
'combination' of type spaces is not a problem".

> I dont disagree, but i'd like to warn that such patches need _way_ 
> more testing, these are never same-day obvious patches.

I can't argue with that.

I'd like Linus to pull my first patch, if he will.  That'll at least allow FRV
to build.  Could you review it?  That's the email that started this thread,
ensubjected:

	[PATCH] FRV: Fix the section attribute on UP DECLARE_PER_CPU()

David
