Return-Path: <linux-kernel-owner+w=401wt.eu-S1754448Ab0AYRhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab0AYRhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 12:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434Ab0AYRhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 12:37:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754409Ab0AYRhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 12:37:33 -0500
Date: Mon, 25 Jan 2010 09:36:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Frank Ch. Eigler" <fche@redhat.com>
cc: Kyle Moffett <kyle@moffetthome.net>, tytso@mit.edu,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
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
In-Reply-To: <20100125170254.GB22862@redhat.com>
Message-ID: <alpine.LFD.2.00.1001250930320.3574@localhost.localdomain>
References: <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain> <20100122221348.GA4263@redhat.com> <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain> <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
 <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com> <20100123112333.GA15455@elte.hu> <20100123114729.GA7828@redhat.com> <20100123194820.GM21263@thunk.org> <f73f7ab81001241742t1f827ddetd958e1949787020f@mail.gmail.com> <alpine.LFD.2.00.1001250845180.3574@localhost.localdomain>
 <20100125170254.GB22862@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 25 Jan 2010, Frank Ch. Eigler wrote:
> 
> Earlier, you said that you haven't followed utrace "at all".  Upon
> what real information do you infer that it has been over-designed?

Upon the information that people are talking about magic new kernel 
interfaces to do fancy things. And talking about doing things with it that 
are simply not relevant for ptrace/strace.

In fact, in this very thread I've been informed that there are no user 
interfaces to utrace at all, which to me says that it's been TOTALLY 
MISDESIGNED FROM THE VERY START, and has nothing to do with making ptrace 
work for strace/gdb at the same time.

In other words, I may not have followed utrace development, but I sure as 
hell can read. And everything I read about it just makes me less inclined 
to want to merge it. The people who argue "for" it are actually screwing 
themselves by arguing for all the wrong things, and making me convinced I 
don't want to touch it with a ten-foot pole.

If somebody were to argue that "this is a simple series of patches to 
clean up ptrace and make it possible to strace a debugged process", then 
that would have been different. That's not what you or others have been 
doing. You've been pushing exactly the _reverse_ of that, namely how great 
it is for some random totally new features that I'm convinced aren't even 
used by a lot of people.

So give me a populist argument that makes sense for tons of actual users, 
not some f*cking "here's a cool infrastructure that developers can do 
random crazy out-of-tree crap with". Because I'm not interested in crazy 
developers.

			Linus
