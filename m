Return-Path: <linux-kernel-owner+w=401wt.eu-S1755822AbZBCTPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbZBCTPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 14:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbZBCTPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 14:15:17 -0500
Received: from mx2.compro.net ([216.54.166.4]:13516 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265AbZBCTPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 14:15:15 -0500
X-IronPort-AV: E=Sophos;i="4.37,373,1231131600"; 
   d="scan'208";a="3348592"
Message-ID: <498897C1.2090802@compro.net>
Date: Tue, 03 Feb 2009 14:15:13 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Mark Hounschell <dmarkh@cfl.rr.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD	Phenom-II
 processor
References: <49798F33.8070906@cfl.rr.com> <20090123130416.GA27616@alberich.amd.com> <497A48D5.9040904@cfl.rr.com> <497E0072.7000500@compro.net> <20090127163843.GA1628@aftab> <497FA725.7020503@cfl.rr.com> <497FA7F2.3060709@cfl.rr.com> <498416CE.4040101@cfl <20090203151137.GB12017@aftab>
In-Reply-To: <20090203151137.GB12017@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> Hi,
> 
> On Tue, Feb 03, 2009 at 04:17:55AM -0500, Mark Hounschell wrote:
>> Borislav Petkov wrote:
>>> On Sat, Jan 31, 2009 at 04:15:58AM -0500, Mark Hounschell wrote:
>>>
>>> [..]
>>>
>>>> So were you able to reproduce this with my .config. Has anyone booted a Hz=1000
>>>> kernel on an AMD Phenom-II? Is there something wrong with my .config? Is there
>>>> anything else I can do?
>>> Hi,
>>>
>>> sorry for the delay - I've been busy last week and couldn't get to your
>>> problem. So, I couldn't reproduce the bug here with a Phenom II and your
>>> kernel config. However, we have a working theory, so can you please send
>>> me the output of
>>>
>>> xxd /sys/firmware/acpi/tables/APIC
>>>
>> markh@harley:~> xxd /sys/firmware/acpi/tables/APIC
>> 0000000: 4150 4943 8400 0000 014c 5258 3738 3020  APIC.....LRX780
>> 0000010: 4157 5244 4143 5049 312e 3042 4157 5244  AWRDACPI1.0BAWRD
>> 0000020: 0000 0000 0000 e0fe 0100 0000 0008 0000  ................
>> 0000030: 0100 0000 0008 0101 0100 0000 0008 0202  ................
>> 0000040: 0100 0000 0008 0303 0100 0000 010c 0400  ................
>> 0000050: 0000 c0fe 0000 0000 020a 0000 0200 0000  ................
>> 0000060: 0000 020a 0009 0900 0000 0f00 0406 0005  ................
>> 0000070: 0001 0406 0105 0001 0406 0205 0001 0406  ................
>> 0000080: 0305 0001
> 
> looks good at a glance...
> 
>>> Also, can you boot a 64-bit, HZ1000 kernel on your machine?
>>>
>> No, a 64 bit kernel @1000Hz doesn't boot either. As with the 32 bit kernel,
>> setting Hz to 250 allows it to boot. The messages are slightly different when it
>> hangs on the 64bit kernel at 1000Hz.
> 
> That's not cool - as I said before, I can't reproduce this behavior here
> which means that the problem might be chipset-related. What you could do
> now is to boot the kernel with "debug initcall_debug log_buf_len=10M"
> and try to capture the whole boot log with a serial console - or if that
> doesn't work - make a screenshot with a camera of some sort. This might
> shed some light on the question where exactly your machine hangs.
> 

It will be easier to capture the process on video then rip it out into a
bunch jpegs than it will be to connect the serial port. It's internal and I
don't have the adapter to bring it out the back of the case. I'll see what
I can do. It might be a couple of days but I'll get back to ya.


Thanks
Mark
