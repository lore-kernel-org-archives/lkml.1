Return-Path: <linux-kernel-owner+w=401wt.eu-S1031248AbXDQRS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031248AbXDQRS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 13:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031250AbXDQRS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 13:18:27 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:41561 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031248AbXDQRS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 13:18:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=coLD4LQjmpU4i7n2MHIqtpZWpCbPDYWWmefKpSv8UypiZslCPjWAzbU35sqpHYqZWub999jNNuGZoPdKdiF8oBiqK97SabobJEiK/VdI5dwBZ7hxISW0F4efiEXS94ms+Imdzw9cK1xKIW856dDXyxtO/uiGg0WO6oCWG3y4Qgk=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
Date: Tue, 17 Apr 2007 13:18:22 -0400
User-Agent: KMail/1.9.6
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Dmitry Adamushko <dmitry.adamushko@gmail.com>
References: <20070416220715.GA4071@elte.hu> <Pine.LNX.4.64.0704170029350.30516@alien.or.mcafeemobile.com> <20070417073922.GA3233@elte.hu>
In-Reply-To: <20070417073922.GA3233@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704171318.22758.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 April 2007, Ingo Molnar wrote:
>* Davide Libenzi <davidel@xmailserver.org> wrote:
>> > ok, i've got something better to test: i separated the delta out
>> > into a more finegrained stack of 3 patches. You can pick them up
>> > from:
>> >
>> >  http://redhat.com/~mingo/cfs-scheduler/older/sched-cfs-v2-rc0.patch
>> > 
>> > http://redhat.com/~mingo/cfs-scheduler/older/sched-cfs-v2-rc0-preempt-fi
>> >x.patch
>> > http://redhat.com/~mingo/cfs-scheduler/older/sched-cfs-v2-rc0-child-runs
>> >-first.patch
>> > http://redhat.com/~mingo/cfs-scheduler/older/sched-cfs-v2-rc0-misc.patch
>>
>> Isn't that easier for everyone if you keep them as quilt series (ala
>> syslets)?
>
>i _do_ have a quilt tree, but i never had the clean splitup above. Why?
>Because i worked on all of these aspects (and a whole lot of other
>aspects as well) in parallel during the past 2 days, back and forth,
>often mixing changes, etc. and there was never any clean splitup.
>
>Now it turned out that the clean splitup of -rc0->final delta would ease
>Gene's testing so i created it. Note that this is just 30% of the total
>v1->v2 delta and i just saved the work of having to do a clean splitup
>of the other 70%. (and note that this splitup will be undone because it
>makes no sense for any potential upstream merge at all, it's only to
>ease testing for Gene)

Now he tells me.  :-)  But I have some CHO stuff to do, so it will be about 36 
hours before I can get back to this.

>	Ingo



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Support the Girl Scouts!
	(Today's Brownie is tomorrow's Cookie!)
