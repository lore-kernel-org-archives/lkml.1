Return-Path: <linux-kernel-owner+w=401wt.eu-S1759946AbXKTXUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759946AbXKTXUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:20:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbXKTXUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:20:01 -0500
Received: from dizzy.i200.net ([74.86.142.210]:37031 "EHLO dizzy.i200.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbXKTXUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:20:00 -0500
Message-ID: <47436BA0.5050809@quo.to>
Date: Tue, 20 Nov 2007 17:20:00 -0600
From: Jordan Russell <jr-list-2007@quo.to>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>
Subject: Re: 2.6.23.1: Random hangs during boot with "tsc" clocksource
References: <472B59E8.3080709@quo.to> <20071106221548.c8d7b41b.akpm@linux-foundation.org>
In-Reply-To: <20071106221548.c8d7b41b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Fri, 02 Nov 2007 12:10:00 -0500 Jordan Russell <jr-list-2007@quo.to> wrote:
>> Hi,
>>
>> With 2.6.23.1 (stock and Fedora), roughly 50% of the time my system
>> hangs indefinitely during the kernel boot process. The hangs occur in
>> places where normally a brief delay is seen, such as when detecting
>> serial ports, ATA devices, and USB hubs. SysRq+W, when it works, shows
>> tasks stuck inside schedule_timeout and lock_timer_base.
>>
>> I've found, however, that if I override the default "tsc" clocksource
>> with "acpi_pm" by adding "clocksource=acpi_pm" to the kernel command
>> line, the system comes up fine every time. (Zero hangs in ~50 tries.)
>>
>> I never had to do this with stock kernels based on 2.6.22.10 and
>> earlier, which also defaulted to "tsc" on my system.
>>
>> I came across this thread:
>>   http://lkml.org/lkml/2007/10/16/339
>> but I'm not sure if it's the same issue. I've never seen a "Clocksource
>> tsc unstable" message, and the kernel doesn't appear to unwedge itself
>> after 5 minutes (I waited 20 minutes once).

[... snip cpuinfo, dmesg, config ...]

Same problem with 2.6.23.8.

Are there any specific (TSC related?) patches I should try reverting?

Would it help if I captured the dmesg/SysRq output from one of the
hanging boots?

Any other information that might be useful in getting to the bottom of this?

Thanks.
Jordan Russell
