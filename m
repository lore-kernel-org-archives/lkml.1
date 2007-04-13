Return-Path: <linux-kernel-owner+w=401wt.eu-S965380AbXDMXJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965380AbXDMXJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 19:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965673AbXDMXJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 19:09:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:12674 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965380AbXDMXJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 19:09:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=P5k0sR6uc5wZc4pX0uVtwCYx49Y6q5N+nyOIieXDSDdSD2CFnMz3XZ8Uhj+rxWd1hWFmTMj4X7KQZ7AfpgvMKXk0A3Rrg1t3BN6G0+qQhjZHe6E2ppT6cUG1miFhZUF4DHIN2OVPLwH8QiAbw36MMozChMfNCfA1GBThcrjyeGc=
Message-ID: <46200D47.70108@googlemail.com>
Date: Sat, 14 Apr 2007 01:07:51 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070207)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <20070413202100.GA9957@elte.hu>
In-Reply-To: <20070413202100.GA9957@elte.hu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> [announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
>
> i'm pleased to announce the first release of the "Modular Scheduler Core
> and Completely Fair Scheduler [CFS]" patchset:
>
>    http://redhat.com/~mingo/cfs-scheduler/sched-modular+cfs.patch
>
>   
[...]
> as usual, any sort of feedback, bugreports, fixes and suggestions are
> more than welcome,
>   

Compile error here.

...

CC kernel/sched.o
kernel/sched.c: In function '__rq_clock':
kernel/sched.c:219: error: 'struct rq' has no member named 'cpu'
kernel/sched.c:219: warning: type defaults to 'int' in declaration of 
'__ret_warn_once'
kernel/sched.c:219: error: 'struct rq' has no member named 'cpu'
kernel/sched.c: In function 'rq_clock':
kernel/sched.c:230: error: 'struct rq' has no member named 'cpu'
kernel/sched.c: In function 'sched_init':
kernel/sched.c:6013: warning: unused variable 'j'
make[1]: *** [kernel/sched.o] Error 1
make: *** [kernel] Error 2
==> ERROR: Build Failed. Aborting...

...

There the config :

http://frugalware.org/~crazy/other/kernel/config

> 	Ingo
> -
>
>   

Regards,

Gabriel
