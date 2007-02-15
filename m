Return-Path: <linux-kernel-owner+w=401wt.eu-S932821AbXBOOcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821AbXBOOcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 09:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932828AbXBOOcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 09:32:33 -0500
Received: from odyssey.analogic.com ([204.178.40.5]:1251 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932821AbXBOOcc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 09:32:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 15 Feb 2007 14:32:30.0494 (UTC) FILETIME=[1F9A33E0:01C7510E]
Content-class: urn:content-classes:message
Subject: Re: GPL vs non-GPL device drivers
Date: Thu, 15 Feb 2007 09:32:30 -0500
Message-ID: <Pine.LNX.4.61.0702150913020.1735@chaos.analogic.com>
In-Reply-To: <1a297b360702150451n3dca1140ra6827cfde020eed5@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: GPL vs non-GPL device drivers
Thread-index: AcdRDh+mz0CN495ORkaAuKoCZek4Nw==
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com> <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com> <200702151254.39058.mws@twisted-brains.org> <1a297b360702150451n3dca1140ra6827cfde020eed5@mail.gmail.com>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Manu Abraham" <abraham.manu@gmail.com>
Cc: "Mws" <mws@twisted-brains.org>, "v j" <vj.linux@gmail.com>,
       <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 15 Feb 2007, Manu Abraham wrote:

> On 2/15/07, Mws <mws@twisted-brains.org> wrote:
>> hi vj,
>>
>> On Thursday 15 February 2007, v j wrote:
>>> This is in reference to the following thread:
>>>
>>> http://lkml.org/lkml/2006/12/14/63
>>>
>>> I am not sure if this is ever addressed in LKML, but linux is _very_
>>> popular in the embedded space. We (an embedded vendor) chose Linux 3
>>> years back because of its lack of royalty model, robustness and
>>> availability of infinite number of open-source tools.
>>>
>>> We recently decided to move to Linux 2.6 for our next product, mainly
>>> because Linux has worked so well for us in the past, and we would like
>>> to move up to keep up with the latest and greatest.
>>
>> you choose to move to linux 2.6 for your next product - fine.
>> it has worked for you well in the past - fine.
>> you would like to keep along with the latest and greatest - fine.
>>
>> _but_
>>
>> for all those reasons you have to get along with all rules, licenses and
>> at least all changes that the kernel community decided to perform.
>>
>>> However in moving to  2.6, we noticed a number of alarming things.
>>> Porting drivers over from devfs to udev, though easy raised a number
>>> of alarming issues. Driver's no longer could dynamically allocate
>>> their MAJOR/MINOR numbers. Doing so would mean they would have to use
>>> sysfs. However it seems that sysfs (and the class_ interface) is only
>>> available to GPL modules. This is very concerning. The drivers which
>>> we have written over the last three years are suddenly under threat.
>>> We don't mind statically assigning MAJOR/MINOR numbers to our drivers.
>>> We can do this and modify our user space applications too.
>>>
>>> However we have a worrying trend here. If at some point it becomes
>>> illegal to load our modules into the linux kernel, then it is
>>> unacceptable to us. We would have been better off choosing VxWorks or
>>> OSE 3 years ago when we made an OS choice. The fact that Linux is
>>> becoming more and more closed is very very alarming.
>>
>> the trend is not worrying. we are not responsible for your decisions you made
>> in the past.
>> the only real FACT is that linux is being stated to BE OPEN and what is much more
>> important to STAY OPEN for everybody.
>>
>> you chose it years ago, because of those facts. of course linux is very popular on
>> embedded systems. i am working within some open source projects that also run
>> on embedded hardware designs.
>>
>> your main mistake in understanding linux and our way to have it also more open in
>> future than by now.
>>
>> what actually costs you more in future?
>> opening your drivers, as much it must be, to have your hardware supported under 2.6
>> _or_
>> paying license fees for runtime/development tools for vxworks, ose whatever?
>
>
> marcel,
>
> most of the vendors, who claim IP just cite nonsense. There are really
> hardly a few vendors who are really bound to the IP issue. Just that
> they do not know how to write proper code, they do not want to open up
> their code.
>
> In fact , such vendors do have a think probably like this "if we open
> up our driver if people see the pathetic quality, the customers would
> probably think how bad is the hardware and probably affect our sales"
> . So it would be better if we hide under the shade of the IP umbrella.
>
> Little do that these vendors know that customers wouldn't want to go
> alongwith such narrow minded vendors in the long run. But somehow due
> to a certain void people do the get along, that's it, not for long
> though.
>
> regards,
> manu
> -

There are a lot of device drivers that will never make it into the
mainline kernel because they are for one-of-a-kind devices or boards
that companies embed into their products. Nobody would even want a
copy of the software to interface with something that they would
never even have. When Version 2.6 started, it became necessary to
use special tools and procedures to compile a module that was not
inside the mainline kernel. However, it was still quite easy. Recently,
somebody, apparently with an advanced degree in obfuscation, has made
that more difficult. This is abuse, pure and simple. That, in my
opinion, is one of the major reasons why people who use Linux in
embedded systems end up using very old versions.

There are, however, still ways to work around this obfuscation.
One can write a simple program or script that parses the .config
variables and creates a header file. One can also use the correct
(changing) search paths for the necessary included header files.
This, of course, is a pain in the butt, but it works and provides 
correctly-working modules. The kernel obfuscator's time would be
better spent making kernel use easier, but what do I know.
I don't think of GPL as a religion, only as an experiment
that has run amok.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.61 BogoMips).
New book: http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
