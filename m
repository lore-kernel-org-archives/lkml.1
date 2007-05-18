Return-Path: <linux-kernel-owner+w=401wt.eu-S1758982AbXERXGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982AbXERXGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 19:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755821AbXERXGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 19:06:04 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38207 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755626AbXERXGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 19:06:03 -0400
Date: Sat, 19 May 2007 01:05:49 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       linux-kernel@vger.kernel.org, malitzke@metronets.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug 8501] udivdi3  absence with gcc-4.3.0 on kernels
	2.6.20.11 & 2.6.22.-rc1
Message-ID: <20070518230549.GB6291@stusta.de>
References: <200705181941.l4IJfOtf018049@fire-2.osdl.org> <20070518152935.b5a4b3bf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070518152935.b5a4b3bf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 03:29:35PM -0700, Andrew Morton wrote:
>...
> I expect that this optimisation will remain in gcc-4.3 and we'll end up
> having major kernel releases which don't build on i386 with major gcc
> releases, which isn't altogether desirable.  I suspect we'll need to fix this
> fairly urgently, and to backport the fix into a number of kernel releases.
>...

Building old kernels with the latest gcc has never worked [1].

First of all, gcc 4.3 is still one year away from being released, so 
there's zero urgency.

And considering that compile errors are the trivial things, and the real 
problems are new runtime errors caused by incorrect kernel code combined 
with gcc optimization [2] I'd even consider backporting only the compile 
fixes before the real issues have been shaken out a bad idea.

cu
Adrian

[1] the backported gcc 4 support in kernel 2.4 is an exception
[2] look e.g. at commit 8690ba446defe2e2b81803756c099d2943dfd5fd

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

