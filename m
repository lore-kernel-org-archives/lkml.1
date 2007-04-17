Return-Path: <linux-kernel-owner+w=401wt.eu-S1161107AbXDQRWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161107AbXDQRWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 13:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161126AbXDQRWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 13:22:54 -0400
Received: from ag-out-0708.google.com ([72.14.246.249]:44589 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161107AbXDQRWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 13:22:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=YWNfzUIFAAQT0GtiGmMmTUqHCVlzGBGa2jrXHglHVzYzifw8Deq4O8DhkDxr10QSY/BpCqTdTfFDvlGIRcyJ1X99tN0wLjE4MJnyeE73gjigV0LbTIDhBz0PRZC4s1Dj2Y0gcdJXui8oyw01LbcVvCFdPq6DcKuSy83+kXvqc+Y=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
Date: Tue, 17 Apr 2007 13:22:48 -0400
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Dmitry Adamushko <dmitry.adamushko@gmail.com>
References: <20070416220715.GA4071@elte.hu> <20070417061849.GA12385@elte.hu> <20070417070132.GA27261@elte.hu>
In-Reply-To: <20070417070132.GA27261@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704171322.49291.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 April 2007, Ingo Molnar wrote:
>* Ingo Molnar <mingo@elte.hu> wrote:
>> ok - fortunately the delta between -v2-rc0 and -v2-final is pretty
>> small. One difference is the child-runs-first fix. To restore the
>> parent-runs-first logic, do this:
>>
>> 	echo 0 > /proc/sys/kernel/sched_child_runs_first
>>
>> does this make any difference?
>
>ok, i've got something better to test: i separated the delta out into a
>more finegrained stack of 3 patches. You can pick them up from:
>
> http://redhat.com/~mingo/cfs-scheduler/older/sched-cfs-v2-rc0.patch
> http://redhat.com/~mingo/cfs-scheduler/older/sched-cfs-v2-rc0-preempt-fix.p
>atch
> http://redhat.com/~mingo/cfs-scheduler/older/sched-cfs-v2-rc0-child-runs-fi
>rst.patch
> http://redhat.com/~mingo/cfs-scheduler/older/sched-cfs-v2-rc0-misc.patch
>
Got them all saved Ingo, but it will be late tomorrow before I can play again.

>i test-built and test-booted all 4 steps of this. The baseline -v2-rc0
>patch should be the one that works - you might want to double-check it,
>just to be sure. One of the other 3 patches ontop of this baseline
>causes the regression on your desktop. My current bet is on preempt-fix,
>so i have put that one first. The other one would be the second patch,
>child-runs-first. The misc patch should have no effect on behavior - but
>i've included it for completeness. (and i was wrong about the 'nice
>fix', it is not in this delta)
>
>	Ingo



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
This life is yours.  Some of it was given to you; the rest, you made yourself.
