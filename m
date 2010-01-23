Return-Path: <linux-kernel-owner+w=401wt.eu-S1754992Ab0AWALu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab0AWALu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401Ab0AWALs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:11:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751628Ab0AWALq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:11:46 -0500
Date: Fri, 22 Jan 2010 16:11:03 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Frank Ch. Eigler" <fche@redhat.com>
cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
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
In-Reply-To: <20100122221348.GA4263@redhat.com>
Message-ID: <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain>
References: <20100121013822.28781960.sfr@canb.auug.org.au> <20100122111747.3c224dfd.sfr@canb.auug.org.au> <20100121163004.8779bd69.akpm@linux-foundation.org> <20100121163145.7e958c3f.akpm@linux-foundation.org> <20100122005147.GD22003@redhat.com>
 <20100121170541.7425ff10.akpm@linux-foundation.org> <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain> <20100122182827.GA13185@redhat.com> <20100122200129.GG22003@redhat.com> <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain>
 <20100122221348.GA4263@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 22 Jan 2010, Frank Ch. Eigler wrote:
> 
> The point is that the intermediate api will allow (and, as the part
> you clipped out about utrace-gdbstub said, *already has allowed*)
> alternative plausible interfaces that coexist just fine.

And my point is that multiple interfaces are BAD. 

There is one interface we _have_ to have: the traditional ptrace one. That 
one we can't get away from.

"Multiple interfaces" on its own is just confusion with no upside. 

You need a _reason_ to have other interfaces. They need to have that 
killer feature. Just being "different" is not a feature at all.

> So all this is about *naming* utrace?  It was never built "for
> tracing", but for (efficient/multiplexed) *control*.  That wasn't even
> its original name -- one of your lieutenants asked roland to change it
> to utrace.

No. It's not about naming. It's about the downside of having amorphous 
interfaces that apparently don't even have rules, and are then used to 
implement random crap.

Yes, the SNL skit about "It's a dessert topping _and_ a floor wax" was 
funny, but it was funny exactly because it was crazy.

The fact that you can do crazy things is not a good thing. You need to 
find the "goodness" somewhere else, and that's what I'm trying to tell 
you.

You just seem to have trouble listening. 

			Linus
