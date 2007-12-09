Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbXLIWHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbXLIWHU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 17:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXLIWHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 17:07:08 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52528 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751943AbXLIWHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 17:07:06 -0500
Date: Sun, 9 Dec 2007 22:01:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-ID: <20071209220132.53268368@the-village.bc.nu>
In-Reply-To: <alpine.LFD.0.9999.0712091036380.12046@woody.linux-foundation.org>
References: <200712080340.49546.rjw@sisk.pl>
	<20071208015227.3a1c7fae.akpm@linux-foundation.org>
	<475B9270.6070902@gmail.com>
	<20071209134217.7ff02dd2@the-village.bc.nu>
	<alpine.LFD.0.9999.0712091036380.12046@woody.linux-foundation.org>
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

> Btw, Alan, that "math" is total and utter BULLSH*T, and you should know 
> that.

The one off regression is probably not one off, but this is IDE so
actually its quite probable its a single broken firmware. 

The alternative is that you cripple just about every user of various
other standards compliant devices and controllers whose hardware we
finally fixed.

Finally you need to remember that the 'regression' is caused by the fact
we now do the _right_ thing both in terms of 'old IDE' and specs.

Believe it or not I did actually think in quite some detail about this
case, and the relative probabilities, and go back and re-review the old
IDE code (whose behaviour we now follow) and the spec. I spend a
measurable amount of my time reviewing code and weighing risks,
regressions and progress for an enterprise Linux vendor, so its something
I do every day of the week.

To blindly argue regressions are critical is sometimes (as in this case)
to argue that "this freeway is no longer compatible with a horse and
cart" means the freeway should be turned back into a dirt road.

The horse and cart happened to work by chance because the road was quiet
that day. We clearly need to add a horse & cart lane in the long term,
but for 2.6.24 it may well be the right thing to do just to blacklist
that specific drive back to old behaviour until we can tidy it more
nicely.

Alan
