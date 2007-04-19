Return-Path: <linux-kernel-owner+w=401wt.eu-S1766932AbXDSSVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766932AbXDSSVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 14:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766931AbXDSSVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 14:21:10 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:46566 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766934AbXDSSVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 14:21:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=eM4rmTg+dwAppiNuHT4SrlEqWXcZzq6T4lZfPTAZwT3eTrqUP2TPkN1iDDK+OWubBoBpMEmuRrTFanxysaLL1NzRZRWxTJ0gX4rFJHl2h6FrHxwfO7cRRzGCWD+/cm/6jMhazUc/RCMzJYxtEQR9DD0tvN9vVYFwTnB4M8ReCcQ=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Mark Lord <lkml@rtr.ca>
Subject: Re: Renice X for cpu schedulers
Date: Thu, 19 Apr 2007 14:21:03 -0400
User-Agent: KMail/1.9.6
Cc: Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070417062621.GL2986@holomorphy.com> <200704200110.47974.kernel@kolivas.org> <46279585.4010409@rtr.ca>
In-Reply-To: <46279585.4010409@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704191421.04367.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 April 2007, Mark Lord wrote:
>Con Kolivas wrote:
>> On Thursday 19 April 2007 23:17, Mark Lord wrote:
>>> Con Kolivas wrote:
>>> s go ahead and think up great ideas for other ways of metering out cpu
>>>
>>>> bandwidth for different purposes, but for X, given the absurd simplicity
>>>> of renicing, why keep fighting it? Again I reiterate that most users of
>>>> SD have not found the need to renice X anyway except if they stick to
>>>> old habits of make -j4 on uniprocessor and the like, and I expect that
>>>> those on CFS and Nicksched would also have similar experiences.
>>>
>>> Just plain "make" (no -j2 or -j9999) is enough to kill interactivity
>>> on my 2GHz P-M single-core non-HT machine with SD.
>>>
>>> But with the very first posted version of CFS by Ingo,
>>> I can do "make -j2" no problem and still have a nicely interactive
>>> destop.
>>
>> Cool. Then there's clearly a bug with SD that manifests on your machine as
>> it should not have that effect at all (and doesn't on other people's
>> machines). I suggest trying the latest version which fixes some bugs.
>
>SD just doesn't do nearly as good as the stock scheduler, or CFS, here.

I found the early SD's much friendlier here, but I also think that at that 
point I was comparing SD to stock 2.6.21-rc5 and 6, and to say that it sucked 
would be a slight understatement.

>I'm quite likely one of the few single-CPU/non-HT testers of this stuff.
>If it should ever get more widely used I think we'd hear a lot more
> complaints.

I'm in that row of seats too Mark.  Someday I have to build a new box, that's 
all there is to it...

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Lots of folks confuse bad management with destiny.
		-- Frank Hubbard
