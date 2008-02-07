Return-Path: <linux-kernel-owner+w=401wt.eu-S932220AbYBGUBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220AbYBGUBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:01:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760246AbYBGUAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:00:48 -0500
Received: from phunq.net ([64.81.85.152]:42563 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759342AbYBGUAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:00:46 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [git pull] x86 arch updates for v2.6.25
Date: Thu, 7 Feb 2008 12:00:18 -0800
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Phil Oester <kernel@linuxace.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jason Wessel <jason.wessel@windriver.com>
References: <20080130011550.GA31853@elte.hu> <20080204205412.466a883c.akpm@linux-foundation.org> <47A9A356.8080400@siemens.com>
In-Reply-To: <47A9A356.8080400@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802071200.19533.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 February 2008 04:08, Jan Kiszka wrote:
> While too many people consider a debugger as _the_ tool for kernel
> development, which it clearly isn't, it remains a fairly useful
> feature, and I don't see any regression, technically or
> organizationally, it may introduce to Linux. IMHO, it would be a pity
> if kgdb have to remain out off tree and may potentially fall back at
> quality levels that many of us had fought with in the past.

I do pretty much all my debugging with printk, not just because it is a 
pain to go find a working kgdb patch, but also because tools like uml 
make printk style debugging really fast.  That said, I often find my 
development time sinking away into tedious activity like putting in a 
printk after each line of code, just to find out where some bad thing 
started going bad.  At that point a source level debugger would save me 
a bunch of time and I would not have to remove the printks afterwards.  

However, if the time required to patch the kernel with kgdb is more than 
the time spent putting in prinks then I will just grit my teeth and put 
in the printks.  Never mind that I will end up going through the printk 
insertion process many times, while only needing to apply the kgdb 
patch once.  Ahem, that is once per kernel version, and I change kernel 
versions like I change socks (that means "often" for the wags among 
you.)

One thing I like to do with a source level debugger besides debugging is 
take a walk once through some new algorithm I have implemented.  Not 
because I think there is a bug, but more for the same reason that I 
like to do a side by side walkthrough of new code with another 
developer before ever running it.  This just provides a different 
perspective, so that perhaps some little blemishes, inefficiencies and 
redundancies will show themselves, and the code quality usually 
improves because of it.

Not that this is the only way I review my own code, it is just another 
way.  More ways of reviewing code are better.  In this sense, the 
debugger is like a mechanical friend who always has time available to 
join in a side by side code review.

Regards,

Daniel
