Return-Path: <linux-kernel-owner+w=401wt.eu-S1030718AbXAZOzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030718AbXAZOzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 09:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030705AbXAZOzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 09:55:52 -0500
Received: from ironport-out.pppoe.ca ([206.248.154.186]:43057 "EHLO
	ironport-out.pppoe.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030681AbXAZOzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 09:55:51 -0500
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jan 2007 09:55:51 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoXALqiuUVBJ8TuX2dsb2JhbACOOhUPKQ
X-IronPort-AV: i="4.13,243,1167627600"; 
   d="scan'208"; a="69720371:sNHT17472544"
Date: Fri, 26 Jan 2007 09:46:01 -0500
From: <yavuz@teksavvy.com>
Reply-To: <yavuz@teksavvy.com>
To: linux-kernel@vger.kernel.org
Cc: yavuz@teksavvy.com
Subject: 2.6.19.2: bad reads/writes from/to CMOS clock
Message-ID: <9e18e56a85195bf4a507163df8e2f62e@teksavvy.com>
X-Mailer: IceWarp Web Mail 5.6.6
X-Originating-IP: 47.248.0.45
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi everyone,

I am running 2.6.19.2 kernel from kernel.org.

This is my first SMP kernel. 

The problem I describe below has not happend with non-SMP kernels ever...

I have installed my new AMD64 x2 4800 CPU just a few days ago. My mobo is Asus A8N SLI
(Nvidia chipset).

My problem with this new setup is that my CMOS clock is thrown off by varying 
amounts of time. I have seen system times as long as ten months into future, and as
long as 25 days in the past. At the moment my system clock has correct 
hh:mm:ss, but it shows the date Jan 1st, instead of correct 25th.

In last few days have systematically checked CMOS clock after shutdown and before
boot-up.

I have observed CMOS clock set to a wrong value, immediately after shutdown. 
I also ended up with a wrong system time following a boot after verifying 
correctness of the CMOS clock.

Problem does not happen 100% of the time. But 6-7 times in a week is bad 
enough. 

I searched mailing list archives, and found some NMI-RTC race condition discussion, 
and some other discussions about timers not running, clock ticks being missed
etc. But they were all at least one year old. The fixes to those should have found
their way into 2.6.19 kernels.

I would appreciate any ideas on how to follow-up on this problem. 

I am eager to try things, collect data as needed. Just tell me what to do.

Thanks in advance.




Yavuz Onder
