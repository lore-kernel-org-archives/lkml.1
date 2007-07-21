Return-Path: <linux-kernel-owner+w=401wt.eu-S932199AbXGUICi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbXGUICi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 04:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760767AbXGUICU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 04:02:20 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:40017 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760398AbXGUICT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 04:02:19 -0400
Date: Sat, 21 Jul 2007 10:01:43 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andi Kleen <ak@suse.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
Message-ID: <20070721080143.GF3801@stusta.de>
References: <1184970779.4012.38.camel@chaos> <200707210806.12880.ak@suse.de> <20070721073533.GE3801@stusta.de> <200707210942.48444.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200707210942.48444.ak@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 09:42:48AM +0200, Andi Kleen wrote:
> On Saturday 21 July 2007 09:35:33 Adrian Bunk wrote:
> 
> > The problem with the current "merging" is that it's extremely hard to 
> > figure out whether some code in x86_64 might be using some code in i386 
> > since there are currently 5 (five) different mechanisms used for sharing 
> > code between the two architectures.
> > 
> > It happens so often that someone accidentally breaks one architecture 
> > because he didn't notice the code also gets used on the other 
> > architecture.
> 
> That's not changing at all. Especially with even more sharing, (than I think
> would be prudent) like Thomas treated, you'll likely have to test compile both
> for most changes.

It's not about compilation, it's about seeing that this code might be 
shared.

When e.g. changing a file under arch/i386/kernel/cpu/mtrr/ it's highly 
surprising that this file might also be used on x86_64.

> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

