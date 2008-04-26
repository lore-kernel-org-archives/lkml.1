Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbYDZQnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbYDZQnz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 12:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759831AbYDZQnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 12:43:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759826AbYDZQnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 12:43:41 -0400
Date: Sat, 26 Apr 2008 09:43:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [git pull] x86 PAT changes
In-Reply-To: <20080426154123.GA7295@elte.hu>
Message-ID: <alpine.LFD.1.10.0804260940290.2813@woody.linux-foundation.org>
References: <20080424225625.GB8717@elte.hu> <481330C6.7040109@googlemail.com> <20080426144203.GA19635@elte.hu> <48134C45.806@googlemail.com> <20080426154123.GA7295@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 26 Apr 2008, Ingo Molnar wrote:
> * Gabriel C <nix.or.die@googlemail.com> wrote:
> >
> > It seems like the update triggers some compiler bug.
> > 
> > Setting CC_OPTIMIZE_FOR_SIZE=n fixed that btw.
> > 
> > I don't have the time right now but later on today I will compile 
> > gcc43_svn_branch and test again with CC_OPTIMIZE_FOR_SIZE=y and see 
> > what I get.
> > 
> > Ingo sorry for the noise.
> 
> no problem and it's not noise even if it turns out to be a compiler 
> problem - we very much want to know about them when they affect the 
> kernel.

Indeed. Often these kinds of compiler issues are also actually our bugs, 
where some code generation thing just happened to hide the fact that we 
did something wrong.

So Gabriel, it would be wondeful if you could try to pinpoint where the 
problem happens. That said, especially if you are using something like a 
self-compiled gcc from the current SVN tree, that obviously does make it a 
*lot* more likely that you are hitting a real compiler bug.

(But even then, if you can pinpoint it, I bet the gcc people would be 
really happy to hear about it.)

			Linus
