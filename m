Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876Ab0AVCgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab0AVCgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 21:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755859Ab0AVCgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 21:36:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755702Ab0AVCgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 21:36:52 -0500
Date: Thu, 21 Jan 2010 18:35:26 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Frank Ch. Eigler" <fche@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
In-Reply-To: <20100122022255.GF22003@redhat.com>
Message-ID: <alpine.LFD.2.00.1001211826060.13231@localhost.localdomain>
References: <20100120062834.GB12165@elte.hu> <20100120072925.GA11395@elte.hu> <20100121013822.28781960.sfr@canb.auug.org.au> <20100122111747.3c224dfd.sfr@canb.auug.org.au> <20100121163004.8779bd69.akpm@linux-foundation.org> <20100121163145.7e958c3f.akpm@linux-foundation.org>
 <20100122005147.GD22003@redhat.com> <20100121170541.7425ff10.akpm@linux-foundation.org> <20100122012516.GE22003@redhat.com> <alpine.LFD.2.00.1001211729080.13231@localhost.localdomain> <20100122022255.GF22003@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Jan 2010, Frank Ch. Eigler wrote:
> 
> Less passionate analysis would identify a long history of contribution
> by the the greater affiliated team, including via merged code and by
> and passing on requirements and experiences.

The reason I'm so passionate is that I dislike the turn the discussion was 
taking, as if "utrace" was somehow _good_ because it allowed various other 
interfaces to hide behind it. And I'm not at all convinced that is true. 

And I really didn't want to single out system tap, I very much feel the 
same way abotu some seccomp-replacement "security model that the kernel 
doesn't even need to know about" thing.

So don't take the systemtap part to be the important part, it's the bigger 
issue of "I'd much rather have explicit interfaces than have generic hooks 
that people can then use in any random way".

I realize that my argument is very anti-thetical to the normal CS teaching 
of "general-purpose is good". I often feel that very specific code with 
very clearly defined (and limited) applicability is a good thing - I'd 
rather have just a very specific ptrace layer that does nothing but 
ptrace, than a "generic plugin layer that can be layered under ptrace and 
other things".

In one case, you know exactly what the users are, and what the semantics 
are going to be. In the other, you don't. 

So I really want to see a very big and immediate upside from utrace. 
Because to me, the "it's a generic layer with any application you want to 
throw at it" is a _downside_.

			Linus
