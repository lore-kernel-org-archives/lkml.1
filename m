Return-Path: <linux-kernel-owner+w=401wt.eu-S1762259AbXEQXv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762259AbXEQXv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 19:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759657AbXEQXvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 19:51:16 -0400
Received: from mail.tmr.com ([64.65.253.246]:40393 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760182AbXEQXvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 19:51:15 -0400
Message-ID: <464CEA70.1080908@tmr.com>
Date: Thu, 17 May 2007 19:51:12 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: 7eggert@gmx.de, "H. Peter Anvin" <hpa@zytor.com>,
       Jonathan Corbet <corbet@lwn.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Johannes Stezenbach <js@linuxtv.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Heikki Orsila <shdl@zakalwe.fi>,
       jimmy bahuleyan <knight.camelot@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] "volatile considered harmful", take 3
References: <8jHg3-1T2-5@gated-at.bofh.it> <8jQt5-7As-3@gated-at.bofh.it>	 <8jSuQ-28J-21@gated-at.bofh.it> <8jT7y-39x-9@gated-at.bofh.it>	 <E1Hn1VO-0001Gp-Ka@be1.lrz> <a781481a0705132037v2229e675p1f51a9f18222b46b@mail.gmail.com>
In-Reply-To: <a781481a0705132037v2229e675p1f51a9f18222b46b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:

> *Unfortunately* (the trouble with C itself, is that a *committee* has made
> it into ... something ... that it should not have made it into) -- anyway,
> unfortunately C took it upon itself to solve a problem that it did not
> have (and does not even bring about) in the first place: and the
> half-hearted (or vague, call it what you will) attempt _then_ ends up
> being a problem -- by making people _feel_ as if they are doing things
> right, when that is probably not the case.
> 
> [ And we've not even touched the issue of whether the _same_ compiler's
> implementation of volatile across archs/platforms is consistent. ]
> 
Pardon, I was GE's representative to the original X3J11 committee, and 
'volatile' was added to "codify existing practice" which is one of the 
goals of a standard. The extension existed, in at least two forms, to 
allow handling of memory mapped hardware. So the committee did not take 
it upon itself, it was a part of the defined duty of the committee.

The intents was simple, clear, and limited, to tell the compiler that 
every read of a variable in source code should result in a read, at that 
point in the logic, and similar for writes. In other words, the code 
should not be moved and should generate a real memory access every time. 
People have tried to do many things with that limited concept since, 
some with "clarification" and some with assuming the compiler knows when 
to ignore volatile.

As someone noted about a committee, a committee is a poor way to get 
innovation, and a good way to have a bunch of know legible people shoot 
down bad ideas.

It was a fun experience, where I first learned the modern equivalent of 
Occam's Razor, Plauger's "Law of least astonishment," which compiler 
writers regularly violate :-(

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
