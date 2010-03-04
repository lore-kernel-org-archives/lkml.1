Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab0CDAms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 19:42:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751924Ab0CDAml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 19:42:41 -0500
Date: Wed, 3 Mar 2010 16:42:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stephen Rothwell <sfr@canb.auug.org.au>, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, roland@redhat.com,
       suresh.b.siddha@intel.com, hjl.tools@gmail.com,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next requirements
Message-Id: <20100303164202.3e5b7435.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1003032312000.2014@localhost.localdomain>
References: <20100211195614.886724710@sbs-t61.sc.intel.com>
	<201002271323.14402.rjw@sisk.pl>
	<20100227124710.GA21164@elte.hu>
	<201002272007.43042.rjw@sisk.pl>
	<20100228072357.GB14205@elte.hu>
	<20100303215314.GC2579@ucw.cz>
	<alpine.LFD.2.00.1003032312000.2014@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Mar 2010 01:35:43 +0100 (CET) Thomas Gleixner <tglx@linutronix.de> wrote:

> As a side note: We created checkpatch.pl, to have a tool which helps
> us to alert developers about stuff which is deprecated and as a
> byproduct the coding style rules. I think it's a useful tool in
> general, just the outcome is an utter trainwreck:
> 
> We have hordes of whitespace, spelling and codingstyle cleanup
> maniacs, while the hard stuff of replacing deprecated interfaces like
> semaphore based mutexes / completions, cleaning up the BKL horror,
> etc. is left to a few already overworked people who care.
> 
> What's even worse is it that developers of new code and the
> maintainers who are merging it simply ignore its existance for
> whatever reasons. I can accept the whitespace argument, but I have no
> grasp why deprecation warnings are ignored at will.

um, write checkpatch rules to detect new additions of deprecated features.

I take patches.
