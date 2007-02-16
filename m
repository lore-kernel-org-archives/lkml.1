Return-Path: <linux-kernel-owner+w=401wt.eu-S1945928AbXBPP3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945928AbXBPP3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 10:29:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945927AbXBPP3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 10:29:01 -0500
Received: from webmail15.mail.yandex.net ([213.180.200.30]:35037 "EHLO
	webmail15.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945928AbXBPP3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 10:29:00 -0500
Date: Fri, 16 Feb 2007 18:28:53 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45D5CDB5.000001.19383@webmail15.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: linux-os@analogic.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: cat, cp operations for tty driver (like for char one)
X-MsgDayCount: 5
X-BornDate: 1134853200
In-Reply-To: <Pine.LNX.4.61.0702161011080.4199@chaos.analogic.com>
Reply-To: Mockern@yandex.ru
References: <45D47779.000006.08064@webmail16.yandex.ru> <Pine.LNX.4.61.0702151146400.2062@chaos.analogic.com> <45D5B7E7.000004.26865@webmail19.yandex.ru> <Pine.LNX.4.61.0702161011080.4199@chaos.analogic.com>
X-Source-Ip: 84.185.222.204
Content-Type: text/plain;
  charset="KOI8-R"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you very much


>On Fri, 16 Feb 2007, Mockern wrote:
>
>> Thanx for your respond.
>>
>> Does it mean I have to change nothing in my tty driver
>> (based on serial_core.c) to use: cat and cp? No "nonstandard " special 
>> functions to implement?
>>
>
>Change nothing. It you are making your own, make sure your iocl() function
>returns the same kinds of errors as the in-kernel one.
>
>You can check out the existing in-kernel driver as:
>
>strace cp filename /dev/ttyS0
>
>
>
>>
>>
>>>
>>> On Thu, 15 Feb 2007, Mockern wrote:
>>>
>>>> I have a question about linux tty driver
>>>>
>>>> how to support cp, cat operations in tty driver (like tiny_tty)?
>>>> (e.g. echo "hello tty" > /dev/ttyS3, cat < ttyS10 etc)
>>>>
>>>> There a lot of examples with char drivers, but I could not find it for tty Linux driver.
>>>>
>>>
>>> It works out of the box. Just keep hardware flow-control turned off
>>> if there are no receivers connected to the output port. Also, you need
>>> to set up the port's baud-rate and (usually) to make it transparent to
>>> control characters (man tc-get/set-attr).
>>>
>>> Cheers,
>>> Dick Johnson
>>> Penguin : Linux version 2.6.16.24 on an i686 machine (5592.61 BogoMips).
>>> New book: http://www.AbominableFirebug.com/
>>> _
>>> 
>>>
>>> ****************************************************************
>>> The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.
>>>
>>> Thank you.
>>
>>
>
>Cheers,
>Dick Johnson
>Penguin : Linux version 2.6.16.24 on an i686 machine (5594.84 BogoMips).
>New book: http://www.AbominableFirebug.com/
>_
>
>
>****************************************************************
>The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.
>
>Thank you.


-- 
Сегодня удачный день, чтобы завести почту на Яндексе http://mail.yandex.ru
