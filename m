Return-Path: <linux-kernel-owner+w=401wt.eu-S2992885AbXEBILh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992885AbXEBILh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 04:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992895AbXEBILh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 04:11:37 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:45932 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992885AbXEBILd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 04:11:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=uS8CJfO+u0gfKeC/twtV7nZPH1HFBdapUcjIv8CrwQlZzrRXnAmWpFgaPAn3qJdN8gT+Rd9jAzCmtnoIXtniq48YpLKCiHSWGQI7+52qMOVuME2BNvI1Qs7GvpeMzbwYXW3YLeWrfYGt1kKHqRyyvbWj8UruTKMAqzEKTBnLX7U=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [patch] CFS scheduler, -v8
Date: Wed, 2 May 2007 04:11:27 -0400
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>,
       Balbir Singh <balbir@in.ibm.com>
References: <20070501212223.GA29867@elte.hu> <1178092794.8926.43.camel@Homer.simpson.net>
In-Reply-To: <1178092794.8926.43.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705020411.28457.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 May 2007, Mike Galbraith wrote:
>On Tue, 2007-05-01 at 23:22 +0200, Ingo Molnar wrote:
>>  - interactivity: precise load calculation and load smoothing
>
>This seems to help quite a bit.
>
>(5 second top sample)
>
> 2636 root      15  -5 19148  15m 5324 R   73  1.5   1:42.29 0
> amarok_libvisua 5440 root      20   0  320m  36m 8388 S   18  3.6   3:28.55
> 1 Xorg 4621 root      20   0 22776  18m 4168 R   12  1.8   0:00.63 1 cc1
> 4616 root      20   0 19456  13m 2200 R    9  1.3   0:00.43 0 cc1
>
>I no longer have to renice both X and Gforce to achieve a perfect
>display when they are sharing my box with a make -j2.  X is displaying
>everything it's being fed beautifully with no help.  I have to renice
>Gforce (amarok_libvisual), but given it's very heavy CPU usage, that
>seems perfectly fine.
>
>No regressions noticed so far.  Box is _very_ responsive under load,
>seemingly even more so than with previous releases.  That is purely
>subjective, but the first impression was very distinct.
>
>	-Mike

And I have a make -j4 running to apply your patch Mike, and can't tell it from 
here, no lag.

This is another keeper folks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
It takes less time to do a thing right than it does to explain why you
did it wrong.
		-- H.W. Longfellow
