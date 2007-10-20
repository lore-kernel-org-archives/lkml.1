Return-Path: <linux-kernel-owner+w=401wt.eu-S1765364AbXJTLyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765364AbXJTLyR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 07:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758815AbXJTLyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 07:54:06 -0400
Received: from m-04.th.seeweb.it ([217.64.195.227]:32814 "EHLO
	m-04.th.seeweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757953AbXJTLyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 07:54:05 -0400
Message-ID: <4719EAEB.6060703@users.sourceforge.net>
Date: Sat, 20 Oct 2007 13:47:55 +0200
From: "legolas558@users.sourceforge.net" <legolas558@users.sourceforge.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070908)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: Laptop keyboard unusable when ACPI is active was Re: [2.6.22]
 i8042, ACPI, ipw2100 and issues reported by psmouse.c atkbd.c
References: <47001841.1000107@users.sourceforge.net> <470DD906.9090504@users.sourceforge.net> <20071018195202.GA6962@ucw.cz>
In-Reply-To: <20071018195202.GA6962@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek ha scritto:
> Hi!
>   
Hi! Finally an answer, thank you.

>> legolas558@users.sourceforge.net ha scritto:
>>     
>>> Kernel: 2.6.22-r5
>>> Kernel option: i8042.nomux=1
>>>       
>> I am now using kernel 2.6.22-r8 (Gentoo) and the following kernel options:
>>
>> i8042.nomux=1 acpi=off
>>
>> I have tried kernel 2.6.23-rc9 but the problem is still there.
>>     
>
> Try usb keyboard.
>   
I will get one within 24 hours.

> Are you experiencing unusually high latencies in acpi mode?
>   
Yes.

> Any unusual activity on top?
>   
Xorg with XFCE4 - it even happens opening up a mousepad and typing
something in it. I do not have particular services running, I have
apache, mysql and samba. I have installed it on July, so it's a pretty
new system - the problem didn't happen before the most recent kernels.

> Try disabling lm_sensors.
>   
I will and report here.

> Try disabling acpi embedded controller.
>   
How can I accomplish this? Are you referring to the i8042?

> Is it smp box?
>   
It is a laptop (Maxdata Pro 7000 DX) with an Intel Centrino 1.6 GhZ
(pentium-m), so it is not.

> Try watching keyboard interrupts. Are they lost?
>   
I am pretty sure they are. I think that ACPI pauses interrupts for a
while (100ms?) and so some keyboard interrupts are lost.

See also http://bugzilla.kernel.org/show_bug.cgi?id=9147

I will come up with a test for lm_sensors and the USB keyboard as soon
as possible.

Thank you very much
--
  Daniele

> 							Pavel
>   

