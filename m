Return-Path: <linux-kernel-owner+w=401wt.eu-S1752518AbXCQMGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbXCQMGN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 08:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbXCQMGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 08:06:13 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:56601 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbXCQMGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 08:06:12 -0400
Date: Sat, 17 Mar 2007 08:05:59 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: RSDL v0.31
In-reply-to: <1174128564.7996.9.camel@Homer.simpson.net>
To: linux-kernel@vger.kernel.org
Cc: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, Al Boldi <a1426z@gawab.com>,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <200703170805.59619.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703042335.26785.a1426z@gawab.com>
 <1174125534.7734.2.camel@Homer.simpson.net>
 <1174128564.7996.9.camel@Homer.simpson.net>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 March 2007, Mike Galbraith wrote:
>Rocks and clubs at work (down boy <whack>, down i say!;).
>
>This is .30 with some targeted unfairness. I seem to be making progress

Try -0.31, its better yet.

>toward beating it to a bloody but cooperative pulp.  It might be
>possible to have my cake and eat it too.  Likely too ugly to live
>though.
>
>top - 11:35:50 up 57 min, 12 users,  load average: 5.20, 4.30, 2.57
>
>  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
> 6599 root      26   0  174m  30m 8028 R   51  3.1   7:08.70 0 Xorg
> 7991 root      29   0 18196  14m 5188 R   47  1.4   0:55.70 0
> amarok_libvisua 7995 root      37   5  3720 2444  976 R   44  0.2  
> 0:27.53 1 lame 7993 root      37   5  3720 2448  976 R   40  0.2  
> 0:46.60 1 lame

What X driver are you using Mike?  Are you on a builtin video chipset 
using mobo shared memory?  I'm running the nvidia 9755 driver here with a 
jaton nvidia 6200-256 card here, and YES I KNOW that taints the kernel, 
but x is using on average, 1.3% of the cpu.  Its sitting at a -1 nice and 
it continues to give usable results here in the face of a make -j8 
running in another shell.

With figures (over 50% cpu to X)  like that, its no wonder you're 
squawking about it.

An old phrase comes to mind "Physician, Heal thyself".  Your X is broken 
and you are trying to blame everything but X.  Fix your hardware and 
drivers.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Two can Live as Cheaply as One for Half as Long.
		-- Howard Kandel
