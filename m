Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbXDZQke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbXDZQke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbXDZQke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:40:34 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754834AbXDZQkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:40:33 -0400
Date: Thu, 26 Apr 2007 09:40:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
In-Reply-To: <Pine.LNX.4.61.0704261005100.506@yvahk01.tjqt.qr>
Message-ID: <alpine.LFD.0.98.0704260930010.9964@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
 <Pine.LNX.4.61.0704261005100.506@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Apr 2007, Jan Engelhardt wrote:
>
> I really appreciate the lot of -rcs, especially if there are so many 
> intrusive changes/regressions. Like Andrew, I have a feeling that it 
> gets buggier, but at least, it seems to be made up every ... two 
> releases.

I wouldn't say that, but yes, there is at least *some* tendency to not 
merge scary stuff after a painful release.

For example, I can certainly say that after 2.6.21, I'm likely to be very 
unhappy merging something that isn't "obviously safe". I knew the timer 
changes were potentially painful, I just hadn't realized just *how* 
painful they would be (we had some SATA/IDE changes too, of course, it's 
not all just about the timers, those just ended up being more noticeable 
to me than some of the other things were).

> About 2.6.21 - will see, rc has been to my liking.

I actually hope that 2.6.21 isn't even all that bad, despite all the 
worries about it. And I may be complaining about the problems the timers 
caused, but it was definitely something that was not only worth it, it was 
overdue - and those NO_HZ issues had been brewing literally for years. So 
considering issues like that, I think we're actually doing fairly well.

One of the bigger issues is that I think -mm (and I'm pretty sure Andrew 
will agree with me on this) has really had a rather spotty history. It's 
been unstable enough at times that I suspect people have largely stopped 
testing it, with just the most die-hard testers running -mm.

So -mm is still very useful just because *Andrew* tests it, and finds all 
kinds of issues with it, but I literally suspect that Andrew himself is 
personally a big part of that, which is kind of wasteful - we should be 
able to spread out the pain more. Andrew is also too damn polite when 
something goes wrong ;)

So we should have somebody like Christoph running -mm, and when things 
break, we'll just sic Christoph on whoever broke it, and teach people 
proper fear and respect! As it is, I think people tend to send things to 
-mm a bit *too* eagerly, because there is no downside - Andrew is a "cheap 
date" testing-wise, and always puts out ;)

			Linus
