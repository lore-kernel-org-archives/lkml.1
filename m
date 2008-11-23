Return-Path: <linux-kernel-owner+w=401wt.eu-S1752775AbYKWUlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbYKWUlX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 15:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750866AbYKWUlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 15:41:13 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42972 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbYKWUlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 15:41:13 -0500
Date: Sun, 23 Nov 2008 21:51:22 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/4] trace: profile all if conditionals
Message-ID: <20081123205122.GV6703@one.firstfloor.org>
References: <20081121071213.365288293@goodmis.org> <20081121071328.462456268@goodmis.org> <87iqqei5ys.fsf@basil.nowhere.org> <alpine.DEB.1.10.0811231455090.13888@gandalf.stny.rr.com> <20081123202434.GU6703@one.firstfloor.org> <alpine.DEB.1.10.0811231523070.13888@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811231523070.13888@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My work evolves around not adding any userspace tool that is not already
> supported by busybox. I'm not against anyone else doing this work. It's 

That seems very limiting and arbitary, like tieing your hands behind your back.
Why is it ok to add code to the kernel and ok not adding code
to userland?

> This all sounds great, and perhaps someone might decide to do this. The 
> full branch tracer I added, I did in a few hours and tested on both x86 
> and PPC. That was because I was waiting on output from a test running on 
> another box that was taking a couple of hours, and I got bored.
> 
> I'm not against any of the suggestions you make. I'm just waiting for 
> someone else to do it ;-)

I just suggested the perfctr method for completeness. It actually
doesn't need much work, you can probably quite easily do it 
with the existing oprofile infrastructure to get the data,
although the output is not very nice with opreport.

But gcov is already done and existing for some time. And for
most usages unless you require minimal runtime overhead it is 
likely the better option. We also used it successfully for some 
testing here. It also has hit l-k some time ago. I don't know the 
latest merge status, but I think it hit -mm at least at some point.

-Andi

