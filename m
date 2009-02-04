Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbZBDD2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbZBDD2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 22:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbZBDD2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 22:28:12 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:55563 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbZBDD2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 22:28:12 -0500
Message-ID: <49890B46.8020308@intertwingly.net>
Date: Tue, 03 Feb 2009 22:28:06 -0500
From: Sam Ruby <rubys@intertwingly.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       x86@kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [APIC] Kernel panic, rsync corruption, intel q8200, 2.6.28-rc8
References: <4978767D.4060700@intertwingly.net> <20090130000758.1dff0113.akpm@linux-foundation.org> <498885CC.4060509@intertwingly.net> <20090203114849.b661f1ce.akpm@linux-foundation.org> <alpine.LFD.2.00.0902032152180.22800@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902032152180.22800@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Tue, 3 Feb 2009, Andrew Morton wrote:
>>>>> [    0.296001] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
>>>>> [    0.296001] Kernel panic - not syncing: IO-APIC + timer doesn't work! 
> Sigh.
> 
>> Not sure.  Perhaps platform_i386/platform_x86_64 would be correct.
>> Can the x86 maintainers please advise?
> 
> Yup. That's correct
> 
> @Sam: I just checked, that your machine has a serial port. That's a
> good start :)
> 
> Do you have a second computer around with a serial port ? If yes, then
> please add the following to the kernel command line:
> 
>        earlyprintk=serial,ttyS0,115200 apic=debug
> 
> and connect the serial ports with a null modem cable. Fire up a
> terminal program on the second machine and capture the output.

I do have a second computer, and went out and bought a null modem 
adapter for my serial cable and connected the two machines.  I've tried 
installing minicom and also connecting it to ttyS0 at 115200 baud on the 
second machine, but when I boot the first machine I don't see any output 
on the terminal.

What am I missing?

> Thanks,
> 
> 	tglx

- Sam Ruby

