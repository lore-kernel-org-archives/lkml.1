Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbYEDRh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbYEDRh5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 13:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbYEDRht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 13:37:49 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:50042 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbYEDRht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 13:37:49 -0400
Date: Sun, 04 May 2008 11:36:56 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Suspend to memory is freezing my machine
In-reply-to: <fa.plXIUcQIe19WMbpH4aKYo6JX1RQ@ifi.uio.no>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <481DF438.30307@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.4esVkXHbwOL+Pzatd+lYSGawfns@ifi.uio.no>
 <fa.zsdi5UBi6URzBaRSfFXIc6F7kHk@ifi.uio.no>
 <fa.plXIUcQIe19WMbpH4aKYo6JX1RQ@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jacek Luczak wrote:
> Rafael J. Wysocki pisze:
>> On Sunday, 4 of May 2008, Zdenek Kabelac wrote:
>>> Hello
>> Hi,
>>
>>> With recent 2.6.25 & 2.6.26-rc1 git (around 1 week) I get occasionally
>>> complete freeze of my T61 during suspend. (dual core, 2GB).
>> How reproducible is this?
>>
>>> I'm running kernel with no_console_suspend - but all I can see is
>>> blinking cursor on an empty screen - thus even when I run kernel with
>>> most debug options turned on, I can't pass more details so far.  I run
>>> suspend with with SD card in - so maybe some update in the MMC driver
>>> might be responsible for this ?
>>>
>>> Also - I think that option no_console_suspend doens't work correctly -
>>> as many times with suspend I do not see any log message on my console
>>> screen. However sometimes the log is shown.
>> It would be helpful if you could verify if:
>>
>> (1) The problem occurs without no_console_suspend.
>> (2) The problem occurs without the SD card.
>>
> 
> Hi Rafael,
> 
> same problem here, although I was able to resume system (it's basically Intel
> machine) , but it was unusable - I was able to switch between terminals and see
> output from kernel. So there was:
> 	- Disabling irq #19;
> 	- some kind of lock spinning on disk:
> IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) Serial ATA Storage
> Controller IDE (rev 02)
> 	but I can't provide more output of that lock now - no sign in logs.
> 
> I've made some successful suspend/resume all without sound card active without
> problem. Those appear with sound card active, but I must take closer look - will
> send info later.

Can you post your dmesg and /proc/interrupts output from normal bootup ?
