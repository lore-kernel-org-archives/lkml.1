Return-Path: <linux-kernel-owner+w=401wt.eu-S1760234AbXLUNMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234AbXLUNMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 08:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792AbXLUNMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 08:12:14 -0500
Received: from odyssey.analogic.com ([204.178.40.5]:3938 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616AbXLUNMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 08:12:13 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 21 Dec 2007 13:11:35.0505 (UTC) FILETIME=[03726C10:01C843D3]
Content-class: urn:content-classes:message
Subject: Re: Trying to convert old modules to newer kernels
Date: Fri, 21 Dec 2007 08:11:34 -0500
Message-ID: <Pine.LNX.4.61.0712210810450.13248@chaos.analogic.com>
in-reply-to: <E1J5VYf-0004go-9q@be1.7eggert.dyndns.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Trying to convert old modules to newer kernels
thread-index: AchD0wN8quQLJmwDS3GGrqddowiGhg==
References: <9CdyE-1A6-7@gated-at.bofh.it> <9CdIw-1Op-29@gated-at.bofh.it> <9Cebz-2sz-29@gated-at.bofh.it> <9Cvcw-5mu-15@gated-at.bofh.it> <9CwhY-76J-11@gated-at.bofh.it> <9Cyk3-1Zc-29@gated-at.bofh.it> <9CB8a-6zV-13@gated-at.bofh.it> <E1J5VYf-0004go-9q@be1.7eggert.dyndns.org>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Bodo Eggert" <7eggert@gmx.de>
Cc: "Sam Ravnborg" <sam@ravnborg.org>,
       "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 20 Dec 2007, Bodo Eggert wrote:

> linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
>> On Thu, 20 Dec 2007, Sam Ravnborg wrote:
>
>>>> It never gets to the printk(). You were right about the
>>>> compilation. Somebody changed the kernel to compile with
>>>> parameter passing in REGISTERS! This means that EVERYTHING
>>>> needs to be compiled the same way, 'C' calling conventions
>>>> were not good enough!
>>>
>>> How did you build the module. It reads like you failed to use
>>> kbuild to build your module which is why you did not pass
>>> correct options to gcc - correct?
>>>
>>> If you did not use kbuild - why not?
>>> Is there anything missing you need?
>
>> I need to get rid of -mregparm=3 on gcc's command line. It
>> is completely incompatible with the standard calling conventions
>> used in all our assembly-language files in our drivers. We make
>> very high-speed number-crunching drivers that munge high-speed
>> data into images. We need to do that in assembly as we have
>> always done.
>
> According to my quick googling, "__attribute__((regparm,0))" is what you need.
>

Yes, thanks! I don't need to change anything except the
declarations of the assembly-language stuff.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
