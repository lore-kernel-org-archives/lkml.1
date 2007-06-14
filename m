Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbXFNKLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbXFNKLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 06:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbXFNKKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 06:10:47 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:23774 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbXFNKKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 06:10:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=g9YXuGrlLJrlaJ+9thNUbnKN615GOLnlCVB6K8zYrJzUs07w+prhejHJlRTDDOO01S2HSc0ytA9KxLsypHs8LuvhLNHVZ8xNflkR/h25Do/irDvTOoiGh/Eb5dR77XLJv+RYpxzfs7aGwW5xigknrl7CE7fpt3DU/I12pJB+EOk=
Message-ID: <ea7e82ce0706140310w1fe50d6apf2ba06baabed1f0@mail.gmail.com>
Date: Thu, 14 Jun 2007 22:10:43 +1200
From: "Tobias Gerschner" <tobias.gerschner@gmail.com>
To: elmig@debianpt.org, "ck list" <ck@vds.kolivas.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
Subject: RE: call for more SD versus CFS comparisons (was: Re: [ck] Mainline plans)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> I did run massive_intr.c for 60 secs with increasing nproc (
>> 10,20,30,40,50,60) waiting for effects.
>>
>> Below a small table of the results
>>
>> 2.6.21.1-cfs-v16
>>
>> nproc ,  usability result
>>
>> 10 , serious frame drops , Firefox  hardly recognizes clicked links,
>> but still usable
>> 20 - 30, usability loss ( somehow under cfs firefox never finished
>> user requests like displaying web pages or opening new pages , no
>> feedback anymore, sudden changes on the desktop )
>
>ouch! The expected load-testing result under CFS should be something
>like this:
>
>   http://bhhdoa.org.au/pipermail/ck/2007-June/007817.html
>
>could you send me the output of /proc/sched_debug? (while say a
>"massive_intr 20" is running?)
>
>Roughly what hardware do you have? (could you send me your lspci -v
>output and dmesg output?)
>
>      Ingo
>

Hi,


After some serious but fun testing on my machine over hours, Ingo got
CFS behave on par with SD. It was my understanding that the changes
were mainly adjusting tunables rather than changing code. But that is
not for me to explain.

>From my point of view it was impressive to see the determination INGO
had, to make sure he delivers the best he can :) . And I learned a lot
how to provide usable / readable test results.

So thumbs up for CFS and SD . ALL IMO: The current advantage of SD
over CFS is the lack of need of tuning for SD . So there is certainly
room for improvement for CFS.

Over the weekend I'll prepare some test cases and documentation for
them to test CFS and SD more specific so that a broader public can
provide the same sort of (comparable) data. The test we used only
covered 1 usage case. This is certainly not enough to measure the
performance of such a key component.

I am looking forward to the next version of CFS and I will certainly
test it toroughly.

kind regards to all responsiveness junkees

-- 
Tobias Gerschner
Member of Board of Yoper Linux Ltd. NZ

Knowing is not enough; we must apply. Willing is not enough; we must do.
