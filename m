Return-Path: <linux-kernel-owner+w=401wt.eu-S1752195AbYDMFAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbYDMFAe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 01:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbYDMFAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 01:00:21 -0400
Received: from static-151-204-187-166.pskn.east.verizon.net ([151.204.187.166]:55316
	"EHLO wesmo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbYDMFAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 01:00:20 -0400
Message-ID: <480189DB.9050900@wesmo.com>
Date: Sun, 13 Apr 2008 00:19:39 -0400
From: Rich West <Rich.West@wesmo.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>,
       Wander Winkelhorst <w.winkelhorst@gmail.com>,
       linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: sata_via
References: <47F694C8.8020507@wesmo.com> <47F6A5E8.1030602@garzik.org>	 <47F6BD55.3090708@wesmo.com> <5699f8f00804050015kb1ebb1cpf3ab8b587580fffd@mail.gmail.com> <47F7982E.5080701@wesmo.com> <47F7F463.2060402@garzik.org> <480173CB.5070805@gmail.com>
In-Reply-To: <480173CB.5070805@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (wesmo.com [127.0.0.1]); Sun, 13 Apr 2008 01:00:18 -0400 (EDT)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (wesmo.com [192.168.56.10]); Sun, 13 Apr 2008 00:19:44 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Jeff Garzik wrote:
>> Rich West wrote:
>>> I was only curious as to what turning off power management support 
>>> would buy with regard to the sata timeout issue.
>>
>>
>> ACPI is not only power management.  It is all the information your 
>> hardware conveys to your OS, about the setup and workings of your 
>> hardware.
>>
>> Without ACPI, non-PM things like SMP, laptop dock/undock, and many 
>> other gadgets fail to function (or are configured sub-optimally).
>>
>> ACPI sets up interrupt routing, and Linux history is _loaded_ with 
>> _years_ of problem reports that appear as timeouts, only to be 
>> resolved as ACPI interrupt bugs (aka BIOS bugs, since ACPI tables 
>> come from BIOS).
>
> Also, please give a shot at the sacred "irqpoll".

I've had bad luck in the past (with other machiens) when adding 
"irqpoll" in that it had locked up the entire machine (not this one, but 
others) after a very short period of time.  My only attempt at using it, 
though, was to try to address an X server related issue, but this is a 
non-user machine, so X isn't necessary, and, hence, it's at runlevel 3 
all of the time.

So far, noapic and acpi=off seem to be working.. The system has been up 
8 days without any problems.. previously, a problem with the SATA drive 
(details of which were part of the first few messages in this thread) 
would surface anywhere between 15 minutes and 5-7 days after a reboot.

However, since I started this email, I tried firing up X (with noapci 
and acpi=off both set), the machine locks up entirely.

-Rich
