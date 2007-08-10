Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbXHJEuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbXHJEuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 00:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbXHJEum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 00:50:42 -0400
Received: from mail.tmr.com ([64.65.253.246]:60825 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925AbXHJEui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 00:50:38 -0400
Message-ID: <46BBEF90.7000808@tmr.com>
Date: Fri, 10 Aug 2007 00:54:40 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Niels <zorglub_olsen@hotmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Problems with USB disk
References: <f9akh8$ori$1@sea.gmane.org> <20070807211847.GA25391@kroah.com>
In-Reply-To: <20070807211847.GA25391@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Aug 07, 2007 at 10:26:15PM +0200, Niels wrote:
>> Hi,
>>
>> I'm having problems with a new 500 GB USB disk. It works, but sometimes I
>> get these in dmesg:
>>
>>
>> usb 1-3: reset high speed USB device using ehci_hcd and address 2
>> usb 5-1: USB disconnect, address 2
>> drivers/usb/class/usblp.c: usblp0: removed
>> sd 0:0:0:0: Device not ready: <6>: Sense Key : 0x2 [current]
>> : ASC=0x4 ASCQ=0x2
>> end_request: I/O error, dev sda, sector 254148215
>> sd 0:0:0:0: Device not ready: <6>: Sense Key : 0x2 [current]
>> : ASC=0x4 ASCQ=0x2
>> end_request: I/O error, dev sda, sector 252434023
>> EXT3-fs error (device sda1): ext3_find_entry: reading directory #15761836
>> offset 0
>>
>>
>> There's also a printer connected. This is on a pci/usb2 card. When the above
>> happens, I get I/O errors. When I mount the drive next, there are errors
>> and often missing files. Quite annoying!
>>
>> Kernel is 2.6.21
>>
>> What's going on?
> 
> You have a low voltage issue, or a bad cable.  The device is
> electronically disconnecting itself.  Try using a externally-powered
> hub, or a new cable.
> 
I see the external drive becoming read-only, although I haven't checked 
the dmesg for the events, since other things in my system generate a 
bunch of output I have to wade through.

New cable, separate power, doesn't do it under 2.6.20-* Fedora or 
2.6.21.x kernel.org kernels.

I'll check the dmesg next time it happens, but I doubt a kernel version 
change would heal the hardware issues you mention.


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
