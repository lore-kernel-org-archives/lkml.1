Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbXLJDoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbXLJDoU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 22:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbXLJDoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 22:44:10 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42626 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752276AbXLJDoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 22:44:08 -0500
Date: Mon, 10 Dec 2007 03:38:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-ID: <20071210033832.3eefbc52@the-village.bc.nu>
In-Reply-To: <alpine.LFD.0.9999.0712091736450.12046@woody.linux-foundation.org>
References: <200712080340.49546.rjw@sisk.pl>
	<20071208015227.3a1c7fae.akpm@linux-foundation.org>
	<475B9270.6070902@gmail.com>
	<20071209134217.7ff02dd2@the-village.bc.nu>
	<alpine.LFD.0.9999.0712091036380.12046@woody.linux-foundation.org>
	<20071209220132.53268368@the-village.bc.nu>
	<alpine.LFD.0.9999.0712091736450.12046@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Have you even *read* the thread?

In detail, as it unfolds and while testing variants of Tejun's code on
the hardware I have access to - none of which has this bug making it
rather trickier to help.

> In other words, the stuff you call so critically important (yet we've been 
> able to live without it until now!) is apparently simply NOT YET READY. 
> It's breaking things.

And as I keep pointing out but you keep ignoring - not doing it breaks
even more things, by a factor of quite a lot.

> .. and what the hell does that matter? If the code doesn't work, it 
> doesn't work, and you might as well point to some random scribblings done 
> by a three-year-old on toilet paper rather than any "specs".

The code without the changes doesn't work either. So pick your toilet
paper.. by your argument both are toilet paper.

> causes regressions should be reverted, so that 2.6.24 is at least no worse 
> than 2.6.23 (and all earlier kernels) in this respect.

Which as the distro bug lists for ATAPI will tell you - aint good. Still
distro vendors can ship patches.

> We used to allow regressions. It was really painful. It's hard to debug 
> things when things sometimes break. It's much better to have a nice 
> constant monotonic improvement.

Linus, the kernel regresses all over the place every release. If it
didn't do that you'd never get any changes in. Your kernel would
fossilize like RHEL or SLES and you'd be spending weeks analysing each
changeset for possible side effects, or - as happens by neccessity -
adding code paths so a fix vital to one driver ceases to share core code
with another driver - to reduce regression risk. Been there, done that
and its not the way progress happens.

> It's better for users, but it's much better also for developers, even if 
> you may be frustrated right now because some new code effectively gets 
> shut down until it works for everybody.

Have fun. I trust you'll be fixing the other 11 I think it was listed
regressions before 2.6.24  - or backing out every changeset that could be
responsible ?

No I thought not - because that wouldn't be sensible either.

Alan
