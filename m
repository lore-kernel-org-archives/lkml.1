Return-Path: <linux-kernel-owner+w=401wt.eu-S1031474AbXDZT6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031474AbXDZT6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031480AbXDZT6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:58:49 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:41900 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031474AbXDZT6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:58:47 -0400
Date: Thu, 26 Apr 2007 21:57:58 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
In-Reply-To: <alpine.LFD.0.98.0704260930010.9964@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0704262146470.506@yvahk01.tjqt.qr>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
 <Pine.LNX.4.61.0704261005100.506@yvahk01.tjqt.qr>
 <alpine.LFD.0.98.0704260930010.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 26 2007 09:40, Linus Torvalds wrote:
>On Thu, 26 Apr 2007, Jan Engelhardt wrote:
>>
>For example, I can certainly say that after 2.6.21, I'm likely to be very 
>unhappy merging something that isn't "obviously safe". I knew the timer 
>changes were potentially painful, I just hadn't realized just *how* 
>painful they would be (we had some SATA/IDE changes too, of course, it's 
>not all just about the timers, those just ended up being more noticeable 
>to me than some of the other things were).

Perhaps do one at a time [ at the cost of queueing other stuff, yeah :( ]
Like: 2.6.21 - only NO_HZ & hrtimers, and the SATA code in .22. Probably does
not work out in reality, so perhaps just live with long rc cycles.
(Let rc8 come.)

>So we should have somebody like Christoph running -mm, and when things 
>break, we'll just sic Christoph on whoever broke it, and teach people 
>proper fear and respect! As it is, I think people tend to send things to 
>-mm a bit *too* eagerly, because there is no downside - Andrew is a "cheap 
>date" testing-wise, and always puts out ;)

Yes, perhaps we need a weakchanges-mm ("weak" is inteded, not to be confused
with week) that can carry stuff like doc updates, Kconfig updates, etc. -
patches that are a little more than -trivial.


Jan
-- 
