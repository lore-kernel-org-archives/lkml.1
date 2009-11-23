Return-Path: <linux-kernel-owner+w=401wt.eu-S1756584AbZKWJp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbZKWJp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 04:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755995AbZKWJp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 04:45:58 -0500
Received: from www.tglx.de ([62.245.132.106]:57301 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906AbZKWJp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 04:45:58 -0500
Date: Mon, 23 Nov 2009 10:45:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: indexer <indexer@internode.on.net>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Feng Tang <feng.tang@intel.com>, bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [Bug 14658] Regression in efi.c
In-Reply-To: <4B09F685.2080201@internode.on.net>
Message-ID: <alpine.LFD.2.00.0911231034090.24119@localhost.localdomain>
References: <bug-14658-6666@http.bugzilla.kernel.org/> <200911212017.nALKHLSC029634@demeter.kernel.org> <alpine.LFD.2.00.0911221817200.24119@localhost.localdomain> <4B09F685.2080201@internode.on.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009, indexer wrote:
> > while the bisect should have be done with
> > 
> > good 2.6.30
> > bad  2.6.31
> > 
> > William, could you please go through the bisect pain again?
>> 
> I had already done a similar bisect to this in private conversation to Huang
> Ying, and is what prompted me to expand my bisect out. I redid it regardless
> and will send you the information.
> 
> commit 74fca6a42863ffacaf7ba6f1936a9f228950f657
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Wed Sep 9 15:13:59 2009 -0700
> 
>    Linux 2.6.31
> 
> Makefile |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)

So you are saying that 
 
> # good: [7135a71b19be1faf48b7148d77844d03bc0717d6] aoe: allocate unused
> request_queue for sysfs
> git bisect good 7135a71b19be1faf48b7148d77844d03bc0717d6

which is the last code changing commit before the 2.6.31 release is
booting fine, but with the release commit which merily changes the
Makefile it is not ?

> PS - The fact remains i still cant efi boot in 2.6.32-rc7, so this bug still
> exists, and I will keep doing what i can to help track this down.

Sure, but I hope we agree that it does not make much sense to search
2.6.31..now when we already know that 2.6.31 is not booting and the
change which causes the problem is between 2.6.30 and 2.6.31.

Thanks,

	tglx

