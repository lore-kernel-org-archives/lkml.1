Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130AbZK3NT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbZK3NT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 08:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbZK3NT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 08:19:27 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:36840 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbZK3NT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 08:19:27 -0500
Date: Mon, 30 Nov 2009 18:49:28 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Roland McGrath <roland@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC] [PATCH] In-kernel gdbstub based on utrace Infrastructure.
Message-ID: <20091130131928.GC18879@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20091130120345.GA18879@linux.vnet.ibm.com> <1259582952.20516.209.camel@laptop> <20091130123257.GB18879@linux.vnet.ibm.com> <1259584907.20516.246.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259584907.20516.246.camel@laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2009-11-30 13:41:47]:

> > 
> > This is a In-kernel gdbstub to debug user space programs. 
> > This stub doesnt help in debugging kernel.
> > 
> > Hence I am not sure how to compare kgdb gdbstub with this gdbstub.
> > Can you please provide more pointers on what you were referring to?
> 
> Well, not even that much was clear from your changelog, so I wasn't
> really sure wtf I was looking at. All it says was an in-kernel gdb stub,
> what other than to debug the kernel would you need in-kernel stubs for?
> 
> So now my question is, what do you need an in-kernel stub to debug
> userspace for?
> 

This stub would allow users use features provided by utrace but through
a gdb interface.  This idea was brought up in this year's Tracing
roundtable at the Linux Foundation Collaboration summit, April 8-10 in
San Francisco.  Here is the link to the minutes of the
meeting sent by Christoph Hellwig.
http://www.mail-archive.com/utrace-devel@redhat.com/msg00830.html

> In general, tell me about this patch thing, what does it do, why does it
> do it, and how does it improve on the current situation.

This is suppose to be one of the interfaces to use utrace, i.e Allow
gdb to use utrace features without having to change gdb itself.
Though there are not enough features in this patch, intentions include
support multi-threaded debugging, concurrent debugger support for same
process, syscall tracing.

For Breakpoint support(not yet submitted to LKML), it would use
execution out of line rather than the conventional inline-single
stepping.

I guess Christoph, Roland and Frank would be able to explain in a better
fashion the rational and advantages of this stub over convential gdb.

> 
> Your changelog doesn't address any of those things, so wth are we
> supposed to think?

Thanks for pointing out. 
--
Thanks and Regards
Srikar
