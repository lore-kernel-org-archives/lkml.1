Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbZA1Q4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbZA1Q4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 11:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbZA1Q4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 11:56:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37636 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbZA1Q4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 11:56:10 -0500
Date: Wed, 28 Jan 2009 11:56:09 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, jens.axboe@oracle.com
Subject: Re: Buggy IPI and MTRR code on low memory
In-Reply-To: <1233161182.10992.52.camel@laptop>
Message-ID: <alpine.DEB.1.10.0901281153080.25359@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com> <1233161182.10992.52.camel@laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 28 Jan 2009, Peter Zijlstra wrote:

> On Wed, 2009-01-28 at 11:38 -0500, Steven Rostedt wrote:
> 
> > The problem is that if we use the stack, then we must wait for the 
> > function to finish. But in the mtrr code, the called functions are waiting 
> > for the caller to do something after the smp_call_function. Thus we 
> > deadlock!
> 
> You'd have to 'fix' the regular fallback paths to use your scheme as
> well.

Not sure what you mean by that. I booted just fine with the patch, and 
forcing data to NULL. Although, I'm not saying that these should not be 
fixed.

-- Steve

