Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211AbZC2ATS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbZC2ATS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 20:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbZC2ATB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 20:19:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052AbZC2ATA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 20:19:00 -0400
Date: Sat, 28 Mar 2009 17:15:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 updates for v2.6.30, final bits
In-Reply-To: <20090328220307.GA16314@elte.hu>
Message-ID: <alpine.LFD.2.00.0903281708180.3994@localhost.localdomain>
References: <20090328220307.GA16314@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Mar 2009, Ingo Molnar wrote:
> 
> [ The sched.c bit is an odd one out: due to previous cpumask changes 
>   it developed a dependency/conflict on the cpumask tree which 
>   depended on the x86 tree. Should i have started a separate branch 
>   for it? I didnt want to merge the x86 tree into the scheduler 
>   tree. We had really excessive dependencies and cross-merges in
>   this cycle around the x86 tree and i very much hope this is an
>   exception

The problem is that you've been hoping for this "exception" for the last 
three kernel releases. 

The details differ, but you do seem to mix things up too much. I'm not at 
all happy. I think quality control is slipping, because there's this 
absolutely _humongous_ amount of crap that gets in through you. You seem 
to have a hard time saying "no".

And yes, you boot-test things pretty well, but I really wish you had more 
focus. This "everything under the sun" thing is very annoying, and I think 
you are too damn eager to merge the random new feature of the day.

So instead of "hoping", how about you look at making sure it really _does_ 
become an exception. And that really fundamentally means that it can't 
happen every release.

How about trying one release to just say "no" if you start seeing all 
these kinds of things. We don't allow non-x86 architectures to just tie 
things together this way. The fact that you have the same tree seems to 
just encourage badness by making it "easier" to just mix things up.

		Linus
