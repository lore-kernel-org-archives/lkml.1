Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab0CDBSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 20:18:05 -0500
Received: from www.tglx.de ([62.245.132.106]:46845 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890Ab0CDBR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 20:17:57 -0500
Date: Thu, 4 Mar 2010 02:17:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stephen Rothwell <sfr@canb.auug.org.au>, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, roland@redhat.com,
       suresh.b.siddha@intel.com, hjl.tools@gmail.com,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next requirements
In-Reply-To: <20100303164202.3e5b7435.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1003040212110.2014@localhost.localdomain>
References: <20100211195614.886724710@sbs-t61.sc.intel.com> <201002271323.14402.rjw@sisk.pl> <20100227124710.GA21164@elte.hu> <201002272007.43042.rjw@sisk.pl> <20100228072357.GB14205@elte.hu> <20100303215314.GC2579@ucw.cz> <alpine.LFD.2.00.1003032312000.2014@localhost.localdomain>
 <20100303164202.3e5b7435.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Mar 2010, Andrew Morton wrote:

> On Thu, 4 Mar 2010 01:35:43 +0100 (CET) Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > As a side note: We created checkpatch.pl, to have a tool which helps
> > us to alert developers about stuff which is deprecated and as a
> > byproduct the coding style rules. I think it's a useful tool in
> > general, just the outcome is an utter trainwreck:
> > 
> > We have hordes of whitespace, spelling and codingstyle cleanup
> > maniacs, while the hard stuff of replacing deprecated interfaces like
> > semaphore based mutexes / completions, cleaning up the BKL horror,
> > etc. is left to a few already overworked people who care.
> > 
> > What's even worse is it that developers of new code and the
> > maintainers who are merging it simply ignore its existance for
> > whatever reasons. I can accept the whitespace argument, but I have no
> > grasp why deprecation warnings are ignored at will.
> 
> um, write checkpatch rules to detect new additions of deprecated features.
> 
> I take patches.

Guess what ? There are rules already which warn about init_MUTEX,
init_MUTEX_locked for quite a while and that's why I'm ranting at both
developers and maintainers submitting resp. merging code containing
exactly that shit.

But yeah we do not have one for lock/unlock_kernel, will send one.

Thanks,

	tglx
