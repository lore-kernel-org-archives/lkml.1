Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbXIWMix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbXIWMix (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 08:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbXIWMir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 08:38:47 -0400
Received: from echo.digadd.de ([195.47.195.234]:45195 "EHLO mx2.digadd.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751935AbXIWMiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 08:38:46 -0400
Message-ID: <46F65E56.8090701@digadd.de>
Date: Sun, 23 Sep 2007 15:38:46 +0300
From: "Christian P. Schmidt" <charlie@digadd.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>
Subject: Re: Memory allocation problem with 2.6.22 after suspend/resume cycle
References: <46F53793.3020102@digadd.de> <200709230000.09722.rjw@sisk.pl>
In-Reply-To: <200709230000.09722.rjw@sisk.pl>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Saturday, 22 September 2007 17:41, Christian P. Schmidt wrote:
>> Hi all,
>>
>> I'm having a strange problem, of course not reproducible. Sometimes
>> after a suspend (to ram) and resume cycle, the kernel will try to free
>> all memory. This means, all running applications are flushed to swap (as
>> long as it is available), caches and buffers stay at around 15MB each.
>>
>> The following video (traded quality for bandwidth) shows what happens on
>> the way from no swap to "swapon -a" (that's the unreadable thing in the
>> small shell): http://digadd.de/swapping.avi
>>
>> The system:
>> Linux dnnote 2.6.22.5 #1 SMP PREEMPT Sat Aug 25 18:39:21 AST 2007 x86_64
>> Intel(R) Core(TM)2 CPU T7400 @ 2.16GHz GenuineIntel GNU/Linux
> 
> Are you using an ATI binary graphics driver?

Yes. I do not (yet) have a choice... can't wait for the open source drivers.


>> A 32bit Kernel is unable to suspend/resume at all. No idea why. dmesg
>> shows nothing, logs show nothing. Any ideas for debugging are welcome.
> 
> Well, that's interesting.
> 
> Can you try in the minimal configuration (ie. boot with init=/bin/bash,
> mount /sys, mount /proc and run "echo mem > /sys/power/disk)?

Which? the 32bit or the 64bit?

Regards,
Chris

> Greetings,
> Rafael

