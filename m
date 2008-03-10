Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbYCJNU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbYCJNU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 09:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbYCJNUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 09:20:47 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:59810 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753939AbYCJNUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 09:20:46 -0400
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Anders Eriksson <aeriksson@fastmail.fm>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.25-rc4 
In-reply-to: <200803101336.56159.bzolnier@gmail.com> 
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <20080308210559.0C7A193C070@tippex.mynet.homeunix.org> <20080310085539.6815693C900@tippex.mynet.homeunix.org> <200803101336.56159.bzolnier@gmail.com>
Comments: In-reply-to Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
   message dated "Mon, 10 Mar 2008 13:36:55 +0100."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Mon, 10 Mar 2008 14:19:00 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080310131901.0154B93C900@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-Scan-Result: No virus found in message 1JYhvN-0000e2-5W.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1JYhvN-0000e2-5W 34f5f335028bf4ac165beb9b4e7571ab
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


bzolnier@gmail.com said:
>> The bisect came up with this:
>> 
>> 18a056feccabdfa9764016a615121b194828bc72 is first bad commit
>> commit 18a056feccabdfa9764016a615121b194828bc72

> Hmm, this is the first commit _after_ the previous "guilty" commit
> 852738f39258deafb3d89c187cb1a4050820d555 so it just can't be the "real bad"
> one... 

I share the same worry. Towards the end of the bisect run (something like the
4-th last reboot), I was asked to try "2.6.24". Now, I _thought_ 2.6.24 was way
before 852738f39258deafb3d89c187cb1a4050820d555, and hence it should be called
2.X.Y-foobaz something as the others were. Is this the way it should be, or did
I fscked up the bisect?

This was a bisect run between 852738f39.. and 2.5.25-rc1. I got a string of 
"bad"s but TWO goods, actually. Those goods sustained a number of reruns of 
smartd (I can share the BISECT_LOG if wanted).

And how we can end up with good_start+1 as the guilty one, and STILL have two 
good ones during the bisect run..... That's beyond me. lets just say that my 
faith in myself and/or bisect starts to decline...

Now I'm considering a 2.6.24 .. 8527 run.
/A


/A



