Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbXLJBc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbXLJBc4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 20:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbXLJBcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 20:32:48 -0500
Received: from qmta08.westchester.pa.mail.comcast.net ([76.96.62.80]:47196
	"EHLO QMTA08.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955AbXLJBcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 20:32:48 -0500
X-Authority-Analysis: v=1.0 c=1 a=ZbwHDR6R-BkA:10 a=6u5ayftARPOD6I5J3h8A:9 a=WBVpmcZpqd8BZLaVOSQdF33TU7kA:4 a=-4xtSMBTtIIA:10 a=0dRpvnS4h04A:10
Message-ID: <475C9739.4030306@comcast.net>
Date: Sun, 09 Dec 2007 20:32:41 -0500
From: Ed Sweetman <safemode2@comcast.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Mike Houston <mikeserv@bmts.com>
CC: Jean Delvare <khali@linux-fr.org>, Elvis Pranskevichus <el@prans.net>,
       Adrian Bunk <bunk@stusta.de>, mhoffman@lightlink.com,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Adam Belay <ambx1@neo.rr.com>
Subject: Re: [lm-sensors] 2.6.24-rc4 hwmon it87 probe fails
References: <20071204215154.7f26285e.mikeserv@bmts.com>	<20071209000554.GF20441@stusta.de>	<20071208212234.e00b74cd.mikeserv@bmts.com>	<20071209105028.06ed52a6@hyperion.delvare>	<E1J1TRp-0000ZF-6J@asgard.prans.org>	<20071209234215.748ed407@hyperion.delvare> <20071209191959.eba5a41f.mikeserv@bmts.com>
In-Reply-To: <20071209191959.eba5a41f.mikeserv@bmts.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Houston wrote:
> On Sun, 9 Dec 2007 23:42:15 +0100
> Jean Delvare <khali@linux-fr.org> wrote:
>
>   
>> On Sun, 09 Dec 2007 16:12:25 -0500, Elvis Pranskevichus wrote:
>>     
>
>   
>>> This indeed looks like a broken ACPI BIOS since the
>>> aforementioned commit touches only the PNP ACPI driver. I'm not
>>> sure how to work around this, though. Ideas?
>>>       
>> Complaining to Gigabyte seems to be the best approach.
>>     
>
> I just happen to have a Windows Vista installation on this box as
> well, and I just thought to check. Sorry, I wish I'd have thought of
> it sooner but I don't go there often. You folks might be interested
> to know that Windows appears to have the same silly problem with the
> i/o resources (from Device Manager):
>
> [000000290 - 000000294]  Motherboard resources
> [000000290 - 00000029F]  Motherboard resources
>
> I don't have anything that reads sensors in Windows though, so I
> couldn't tell you if it could access that it87 chip or not.
>
> So this pretty much confirms that it's a motherboard/bios issue.
>
> Mike Houston
>
>   

I'm seeing this exact problem on an Asus Nforce4 based board. Prior to 
moving to 2.6.24-rc4 it worked just fine.  No additional acpi options 
were selected in kernel config.  

So add Asus A8N-E to the list of broken pnpacpi

