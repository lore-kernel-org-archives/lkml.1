Return-Path: <linux-kernel-owner+w=401wt.eu-S1758296AbXLOBuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296AbXLOBuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 20:50:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356AbXLOBt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 20:49:56 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:59972 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbXLOBtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 20:49:55 -0500
Date: Fri, 14 Dec 2007 19:49:44 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Strange ATA problems
In-reply-to: <4762A625.4050101@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Message-id: <476332B8.9090802@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <1197591699.3453.38.camel@fermat.scientia.net>
 <47629E40.5020007@gmail.com> <1197647095.3454.3.camel@fermat.scientia.net>
 <4762A625.4050101@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>> Dec 14 01:06:33 fermat kernel: ata1: EH in ADMA mode, notifier 0x0
>> notifier_error 0x0 gen_ctl 0x1501000 status 0x400 next cpb count 0x0
>> next
>>  cpb idx 0x0
>> Dec 14 01:06:33 fermat kernel: ata1: CPB 0: ctl_flags 0x1f, resp_flags
>> 0x2
>> Dec 14 01:06:33 fermat kernel: ata1: CPB 1: ctl_flags 0x1f, resp_flags
>> 0x2
>> Dec 14 01:06:33 fermat kernel: ata1: CPB 2: ctl_flags 0x1f, resp_flags
>> 0x2
>> Dec 14 01:06:33 fermat kernel: ata1: CPB 3: ctl_flags 0x1f, resp_flags
>> 0x2
>> Dec 14 01:06:33 fermat kernel: ata1: CPB 4: ctl_flags 0x1f, resp_flags
>> 0x2
>> Dec 14 01:06:33 fermat kernel: ata1: CPB 5: ctl_flags 0x1f, resp_flags
>> 0x2
>> Dec 14 01:06:33 fermat kernel: ata1: CPB 6: ctl_flags 0x1f, resp_flags
>> 0x2
>> Dec 14 01:06:33 fermat kernel: ata1: CPB 7: ctl_flags 0x1f, resp_flags
>> 0x2
>> Dec 14 01:06:33 fermat kernel: ata1: CPB 8: ctl_flags 0x1f, resp_flags
>> 0x2
>> Dec 14 01:06:33 fermat kernel: ata1: CPB 9: ctl_flags 0x1f, resp_flags
>> 0x2
>> Dec 14 01:06:33 fermat kernel: ata1: CPB 10: ctl_flags 0x1f, resp_flags
>> 0x2

CPB flags stuck at 0x2 indicates that the controller issued the command 
to the drive and is waiting for completion. Usually seems to indicate 
some kind of SATA communication problem.

>>> If your USB cdrom is bus powered and you yanked it, it could have caused
>>> fluctuation in power which in turn can cause disruption on serial ATA
>>> bus leading to transmission error and timeouts.  There are other
>>> possibilities but this kind of thing does happen often with SATA.  Those
>>> highspeed low-voltage serial links are very susceptible to interferences.
>> Well,.. it actually "worked" again when I unplugged it, but the errors
>> from the cdrom above are probably unrelated..
>>
>>
>>> As long as EH recovered it properly, there's nothing to worry about.
>> What does that mean?
> 
> That means unless the problem continues to occur repeatedly, you don't
> have to worry about it.
> 

Yes, if it didn't recur, was likely just a transient glitch.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

