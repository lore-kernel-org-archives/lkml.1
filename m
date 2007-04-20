Return-Path: <linux-kernel-owner+w=401wt.eu-S1767271AbXDTViJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767271AbXDTViJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 17:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767272AbXDTViJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 17:38:09 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:63393 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767271AbXDTViH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 17:38:07 -0400
Date: Fri, 20 Apr 2007 17:37:58 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, v4
In-reply-to: <20070420140457.GA14017@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>
Message-id: <200704201738.00684.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <20070420140457.GA14017@elte.hu>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 April 2007, Ingo Molnar wrote:
>i'm pleased to announce release -v4 of the CFS patchset. The patch
>against v2.6.21-rc7 can be downloaded from:
>
>    http://redhat.com/~mingo/cfs-scheduler/
>
>this CFS release too is mainly about fixing regressions and improving
>interactivity, so the rate of change is relatively low:
>
>    11 files changed, 136 insertions(+), 72 deletions(-)
>
>in particular the preemption fix could resolve the 'desktop slows down
>under IO load' reports and the 'firefox does not switch tabs fast
>enough' reports as well. The suspend2 crash and the yield related
>Kaffeine hangs should be resolved as well.
>
>Changes since -v3:
>
> - usability fix: automatic renicing of kernel threads such as keventd,
>   OOM tasks and tasks doing privileged hardware access (such as Xorg).
>   (This is a substitute for group scheduling until the group scheduling
>    details have been worked out.)
>
> - bugfix: buggy yield() caused suspend2 problems
>
> - preemption fix: it caused desktop app latencies
>
>As usual, any sort of feedback, bugreport, fix and suggestion is more
>than welcome,

I've been running this one for several hours now, with amanda running in the 
background due a typu in one of my scripts, so now its playing catchup.

This one is another keeper IMO, or as we are fond of saying around here, its 
good enough for the girls I go with.  If this isn't the best one so far, its 
very very close and I'm getting pickier.  kmail is the only thing that's 
lagging, and that's just kmail, which I believe is single threaded.  Even 
with gzip eating 95% of the cpu, graphics animations like the cards in 
patience are moving at at least 80% speed.  Nice, keep this one and use it 
for the reference. 

>	Ingo



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
In order to dial out, it is necessary to broaden one's dimension.
