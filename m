Return-Path: <linux-kernel-owner+w=401wt.eu-S1762082AbXGWV31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762082AbXGWV31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755053AbXGWV3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:29:12 -0400
Received: from smtpa1.netcabo.pt ([212.113.174.16]:28527 "EHLO
	exch01smtp04.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754783AbXGWV3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:29:10 -0400
Message-ID: <46A51D9E.8040104@rncbc.org>
Date: Mon, 23 Jul 2007 22:29:02 +0100
From: Rui Nuno Capela <rncbc@rncbc.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: v2.6.22.1-rt5
References: <20070723210236.GA25104@elte.hu>
In-Reply-To: <20070723210236.GA25104@elte.hu>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 23 Jul 2007 21:29:06.0124 (UTC) FILETIME=[7F6D28C0:01C7CD70]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> we are pleased to announce the v2.6.22.1-rt5 kernel (collected and 
> assembled by Thomas), which can be downloaded from the usual place:
>   
>   http://redhat.com/~mingo/realtime-preempt/
>   
> more info about the -rt patchset can be found in the RT wiki:
>    
>   http://rt.wiki.kernel.org
> 
> Changes since -rt4:
> 
>  - MM fix: PCP pages locking (Peter Zijlstra)
> 
>  - yield() fix: remove stale RCU-unlock (Daniel Walker)
> 
>  - dont do check_pgt_cache() in idle (found by Daniel Walker)
> 
>  - moved 8 patches, created 6 new patches out of larger patches to 
>    make the -rt queue more bisectable (Daniel Walker)
> 
>  - cleanup (Daniel Walker)
> 
>  - fix the latency tracer under paravirt
> 
> to build a 2.6.22.1-rt5 tree, the following patches should be applied:
>   
>   http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.22.1.tar.bz2
>   http://redhat.com/~mingo/realtime-preempt/patch-2.6.22.1-rt5
>   
> 	Ingo
> -

Maybe I was too quick, but `make all` on is failing here:

...
In file included from arch/i386/mm/pgtable.c:16:
include/linux/quicklist.h: In function ‘quicklist_alloc’:
include/linux/quicklist.h:50: warning: unused variable ‘q’
include/linux/quicklist.h: In function ‘__quicklist_free’:
include/linux/quicklist.h:79: error: ‘per_cpu__quicklist’ undeclared
(first use in this function)
include/linux/quicklist.h:79: error: (Each undeclared identifier is
reported only once
include/linux/quicklist.h:79: error: for each function it appears in.)
include/linux/quicklist.h:79: warning: type defaults to ‘int’ in
declaration of ‘type name’
include/linux/quicklist.h:79: error: invalid type argument of ‘unary *’
make[1]: *** [arch/i386/mm/pgtable.o] Error 1
make: *** [arch/i386/mm] Error 2
...

.config is from previous -rt4:
http://www.rncbc.org/datahub/config-2.6.22.1-rt4.0

Bye now.
-- 
rncbc aka Rui Nuno Capela
rncbc@rncbc.org
