Return-Path: <linux-kernel-owner+w=401wt.eu-S1752246AbXDQRPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbXDQRPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 13:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbXDQRPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 13:15:47 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:40051 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbXDQRPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 13:15:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=d4j2XpaYTD1E1Mpl02qeYDK/zAtGPDoxC/o/3Pmq7/K7+dFiq7EhbwraMs6naR13/k0TB3R7OaPTRcRD7SxlI7VnKyy3NaHzB3HcEd0sE5/WysZWfekuEMss/IGeVy5PAFDo4xE5PKA/4oE5wDSnj22kPk7No5Lb9Mt3s7qv+WI=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
Date: Tue, 17 Apr 2007 13:15:39 -0400
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
Message-Id: <200704171315.39748.gene.heskett@gmail.com>
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
Ahh, so many cats, and so few recipes here Ingo.  In this case cats=patches & 
recipes=time to test adequately.  I do have another box, but it would 
probably take a week & about a big buck to get that old rh7.3 brought up to 
date & suitable, and its only a 500MHZ K-III, which might make the diffs more 
obvious.  It would need a video card to replace its dinosaur Diamond and a 
fresh dvd drive.  And its motherboard has very buggy usb chips.  TYAN S-1590.  
Never could get anything bigger than a mouse packet through them.

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
Q:	What's the difference between a dead dog in the road and a dead
	lawyer in the road?
A:	There are skid marks in front of the dog.
