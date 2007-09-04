Return-Path: <linux-kernel-owner+w=401wt.eu-S1756013AbXIDWn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbXIDWn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 18:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbXIDWnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 18:43:51 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:4459 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbXIDWnu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 18:43:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 04 Sep 2007 22:43:24.0460 (UTC) FILETIME=[00907EC0:01C7EF45]
Content-class: urn:content-classes:message
Subject: Re: ramdisk
Date: Tue, 4 Sep 2007 18:43:48 -0400
Message-ID: <Pine.LNX.4.61.0709041841440.8678@chaos.analogic.com>
In-Reply-To: <ab40e9c0709041437m13b12b47r1461d3b9bba68a99@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: ramdisk
Thread-Index: AcfvRQCXnBp81afQSKisMDpiKPSVxQ==
References: <ab40e9c0709030604u5fecf34dr945ece01b95e622d@mail.gmail.com> <Pine.LNX.4.61.0709041101290.7968@chaos.analogic.com> <ab40e9c0709041437m13b12b47r1461d3b9bba68a99@mail.gmail.com>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Xu Yang" <risingsunxy@googlemail.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 4 Sep 2007, Xu Yang wrote:

> Hi Dick,
> Thanks for the reply.
>
> then how to create these device nodes in /dev? from the information i
> got from the cosole(unknown block(1,0) ), it seems that I didn't
> create the device? I thought the kernel should do this work right? if
> not how to create it?
>
> thanks,
>
> regards,
>

mkknod /dev/ram0 b 1 0
mkknod /dev/ram1 b 1 1
mkknod /dev/ram2 b 1 2

Do this in the file-system you create for the RAM Disk.



>
> 2007/9/4, linux-os (Dick Johnson) <linux-os@analogic.com>:
>>
>> On Mon, 3 Sep 2007, Xu Yang wrote:
>>
>>> Hi everyone,
>>>
>>> I want to use ramdisk to boot my filesystem, as I can't use NFS and harddisk.
>>>
>>> I have load the ramdisk into the ram memory (start address :0x4000000)
>>>
>>> and in the boot options I specified : root =dev/ram0 initrd=0x4000000
>>
>> Since you don't know what the default directory is, perhaps
>> root should be /dev/ram0. Also, make sure you actually create
>> those device nodes in /dev
>>
>> [Snipped...]
>>
>>> but the kernel said it can not find any file system on it.
>>>
>>> regards,
>>>
>>> Yang
>>>
>>
>> Cheers,
>> Dick Johnson
>> Penguin : Linux version 2.6.22.1 on an i686 machine (5588.30 BogoMips).
>> My book : http://www.AbominableFirebug.com/
>> _
>>
>>
>> ****************************************************************
>> The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.
>>
>> Thank you.
>>
>

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.30 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
