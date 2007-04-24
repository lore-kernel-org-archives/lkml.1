Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557AbXDXBvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbXDXBvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 21:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbXDXBvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 21:51:38 -0400
Received: from wx-out-0506.google.com ([66.249.82.226]:53716 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbXDXBvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 21:51:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=baxewsMTDYUeGRQQJtnF4QvgPcqhy6nWV+LPfVEXr86GnjDtswj9wsR2wtXIQazwGu3r/1KmxxMTEXxesipd0PKl9+b+CvZmsEuH1EYRZICxFC07taeAYVG+0ZvoaG/Vls9ggYKGbwBApXv8rFZez5RKXCKq5gt7PsLSYQVJoRA=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Niel Lambrechts <unix@telkomsa.net>
Subject: Re: [report] renicing X, cfs-v5 vs sd-0.46
Date: Mon, 23 Apr 2007 21:51:34 -0400
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <8c1Z0-5Lw-29@gated-at.bofh.it> <8dawR-4zw-21@gated-at.bofh.it> <462D0085.6070806@telkomsa.net>
In-Reply-To: <462D0085.6070806@telkomsa.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704232151.34616.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 April 2007, Niel Lambrechts wrote:
>Gene Heskett wrote:
>> This message prompted me to do some checking in re context switches
>> myself, and I've come to the conclusion that there could be a bug in
>> vmstat itself.
>
>Perhaps. perhaps not. :)
>
>> Run singly the context switching is reasonable even for a -19 niceness of
>> x, its only showing about 200 or so on the first loop of vmstat.  But
>> throw in the -n 1 arguments and it goes crazy on the second and subsequent
>> loops.
>
>man vmstat:
>"The first report produced gives averages since the last reboot.
>Additional reports  give information on a sampling period of length delay."

I missed that, concentrating on finding the method of telling it the delay I 
guess.

So then the next question is, over what period is that obviously lower figure 
being averaged over?  Certainly not over a 1 second period else it would then 
be much higher, as seen by the figures after the initial delay.  The time 
slice spec'd in /proc/sys/kernel/sched_granularity_ns, which here is 
currently 5000000 or 5 milliseconds?  If that was the case, the first answer 
would be in the area of 15, not 200.

So educate me, off list if you would like and have the time.

Thanks Niel.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Sweet sixteen is beautiful Bess,
And her voice is changing -- from "No" to "Yes".
