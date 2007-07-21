Return-Path: <linux-kernel-owner+w=401wt.eu-S939002AbXGUCkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939002AbXGUCkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 22:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936159AbXGUCjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 22:39:42 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:7640 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935608AbXGUCjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 22:39:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lNmSLkJ+9sb1aF5nrtj/ATP3BZscH/ZpSC2MCUkzytj62iXhYubQkwrgbiAySFiMY/w99mHMCFM4mSErJJ+2gMfR1r3Z0M4HphDGWxgpmVc9Mce9Pi90oHIQ6MF+JZgodI4eY6GQGsPuHhRBTcWTQx/0EzpUv1fKgXT8UTmOK9Y=
Message-ID: <5d6222a80707201939s6e5a088br1d6ada9088e9a939@mail.gmail.com>
Date: Fri, 20 Jul 2007 23:39:33 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@osdl.org>, "Andrew Morton" <akpm@osdl.org>,
       "Andi Kleen" <ak@suse.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Chris Wright" <chrisw@sous-sol.org>, arjan@linux.intel.com
In-Reply-To: <Pine.LNX.4.58.0707201922210.21951@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1184970779.4012.38.camel@chaos>
	 <1184972499.2692.9.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.58.0707201922210.21951@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, Steven Rostedt <rostedt@goodmis.org> wrote:

> > I really like the idea of a unified source tree for the 2 x86 variants.
> > The technical differences are really small (of course there are
> > differences, especially in the boot sequence), and striving to unify as
> > much as possible while having a clean way to do per 32/64 bit parts as
> > well is something that imo is the right thing.
> >
>
> Not to mention all the paravirt stuff that's going on. Having a single
> x86 arch to work with would be greatly beneficial to the work being done
> to port paravirt to x86_64.

As for paravirt, it'd really help. As I had the tree lagged behind by
so much, a great part of the work now is checking where i386 is,
seeing if it applies for 64-bit, and so on. The differences are not so
huge, and I'm trying my best to not let them deviate too much. It
could mostly be built incrementally.

And I bet a huge part of the tree could be like this too: In most
places, they are different for no particular reason, just because two
people implemented it separately. There'd be a huge effort to bring
those differences into an end, but I think I'd pay in future
development speed. (not to mention the duplicate bugs linus have
already talked about)

> Way to go, Thomas and Ingo!
I am pretty much for it too.


-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
