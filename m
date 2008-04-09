Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbYDISyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbYDISyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 14:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbYDISyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 14:54:44 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:45429 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751432AbYDISyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 14:54:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMFAC+t/EdMQWoK/2dsb2JhbACBXKpY
Date: Wed, 9 Apr 2008 14:54:41 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Jason Baron <jbaron@redhat.com>,
       Adrian Bunk <bunk@stusta.de>, Christoph Hellwig <hch@infradead.org>,
       akpm@osdl.org
Subject: Re: [patch 09/17] Add all cpus option to stop machine run
Message-ID: <20080409185441.GA30202@Krystal>
References: <20080409150829.855195878@polymtl.ca> <20080409152049.513274847@polymtl.ca> <20080409181010.GA4924@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080409181010.GA4924@martell.zuzino.mipt.ru>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:44:17 up 40 days, 14:55,  6 users,  load average: 0.73, 0.83,
	0.81
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexey Dobriyan (adobriyan@gmail.com) wrote:
> Please, stop Cc'ing me on this.
> 

Fixed.

> I continue to think that all this so-called "immediate" infrastructure
> is an absolute overkill and declared D-cache line savings will _never_
> matter and will never be measured on real life workloads. Right now you
> claim 1 (one) cacheline saving in schedule() which can be trivially
> moved under CONFIG_PROFILING umbrella. On the other hand is more ugly
> assembler code. Sorry, people add infra with much better good/bad ratios.
> 
> Also, my gut feeling of a guy who is also on receiveing end of bugreports
> at SWsoft that line with .text games was crossed by SMP alternatives and
> fooprobes. The rest won't matter because programs like firefox will fuck
> up L1, L2 caches in one blow just by showing animation.
> 

I did not know the only thing we should ever care about as kernel
developers was Firefox ? ;)

I find it quite amusing that at one end of the spectrum we have Ingo
fearing about a few bytes added to the scheduler object even when they
are never loaded in cache, and that at the complete other extreme we
find people arguing that cache lines used by the kernel does not matter
because this and this userspace app is-oh-so-bloated.

Am I the only one interested in finally getting a tracer infrastructure
in the Linux kernel ? (yes, this is the original objective behind
immediate values by the way)

Mathieu

> We don't need bugs when immediate update screwed up fighting for
> cacheline.
> 
> And bugs when screwup happened out of the window of "Code:" printout, so
> you won't have a chance to compare relevant vmlinux .text and printout.
> 
> And bugs when CPU executed bullshit and silently rebooted.
> 
> And so on.
> 
> 	Alexey, more and more liking OpenBSD
> 		where such games won't even
> 	        hit mailing lists
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
