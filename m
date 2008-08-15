Return-Path: <linux-kernel-owner+w=401wt.eu-S1760359AbYHOP5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760359AbYHOP5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbYHOP50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:57:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64521 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbYHOP5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:57:25 -0400
Date: Fri, 15 Aug 2008 11:57:24 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] ftrace: update recordmount.pl arch changes
In-Reply-To: <20080815154234.GE27955@elte.hu>
Message-ID: <alpine.DEB.1.10.0808151156170.2188@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0808151136310.2188@gandalf.stny.rr.com> <20080815154234.GE27955@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 15 Aug 2008, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Ingo,
> > 
> > I'm trying to keep all the arch changes in recordmcount.pl in one 
> > place. I moved your code into that area, by adding the flags to the 
> > commands that were passed in.
> > 
> > Does this change still work for you when compiling i386 on a x86_64 
> > box?
> 
> actually, i thought of this as a quick hack to let -tip testing 
> continue. Dont we have all the proper information available in kbuild 
> and should just pass that to scripts/recordmcount.pl when called - like 
> we pass in things like OBJDUMP which might have cross-build overrides, 
> etc.

OK, I'll set up one of my x86_64 boxes to compile the kernel for i386s, 
and see if I can come up with something.

The reason I did this patch, is to get the PPC patches ready to go on top.

I still need to port to ppc32 (I have 64 working).

-- Steve

