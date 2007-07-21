Return-Path: <linux-kernel-owner+w=401wt.eu-S1759090AbXGUW0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090AbXGUW0m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 18:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbXGUW0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 18:26:33 -0400
Received: from waste.org ([66.93.16.53]:43252 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbXGUW0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 18:26:31 -0400
Date: Sat, 21 Jul 2007 17:25:09 -0500
From: Matt Mackall <mpm@selenic.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
Message-ID: <20070721222509.GI11166@waste.org>
References: <1184970779.4012.38.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184970779.4012.38.camel@chaos>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 12:32:59AM +0200, Thomas Gleixner wrote:
> How is the new arch/x86 and include/asm-x86 namespace layed out? Our 
> foremost concern was to enable a 100% smooth transition to the new, 
> shared architecture, while still enabling much more fine-grained future 
> unification of the source code. To do this we consciously aimed for the 
> strictest possible unification strategy: we only 'unified' those source 
> files that are already bit for bit equal between the two architectures 
> today. For all other files we used the following rule: if a file came 
> from arch/i386/foo/bar.c, it gets moved to arch/x86/foo/bar_32.c, if it 
> came from arch/x86_64/foo/bar.c it gets moved to arch/x86/foo/bar_64.c. 
> We also generated arch/x86/foo/bar.c that simply #include's those two 
> files (depending on whether we do a 32-bit or a 64-bit built). If a file 
> only existed in only one of the architectures, it's moved to 
> arch/x86/foo/bar.c straight away. (take a look at our git repository to 
> see how this works out in practice.)

Can we see some stats on:

How many files were auto-merged?
How many files got 32.c and 64.c extensions?
How many existed only in one arch?

-- 
Mathematics is the supreme nostalgia of our time.
