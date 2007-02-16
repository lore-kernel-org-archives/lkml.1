Return-Path: <linux-kernel-owner+w=401wt.eu-S964934AbXBPN4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934AbXBPN4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 08:56:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964960AbXBPN4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 08:56:09 -0500
Received: from webmail19.mail.yandex.net ([213.180.200.53]:34988 "EHLO
	webmail19.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964934AbXBPN4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 08:56:07 -0500
Date: Fri, 16 Feb 2007 16:55:51 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45D5B7E7.000004.26865@webmail19.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: linux-os@analogic.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: cat, cp operations for tty driver (like for char one)
X-MsgDayCount: 4
X-BornDate: 1134853200
In-Reply-To: <Pine.LNX.4.61.0702151146400.2062@chaos.analogic.com>
Reply-To: Mockern@yandex.ru
References: <45D47779.000006.08064@webmail16.yandex.ru> <Pine.LNX.4.61.0702151146400.2062@chaos.analogic.com>
X-Source-Ip: 84.185.222.204
Content-Type: text/plain;
  charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanx for your respond.

Does it mean I have to change nothing in my tty driver (based on serial_core.c) to use: cat and cp? No "nonstandard " special functions to implement? 

 

>
>On Thu, 15 Feb 2007, Mockern wrote:
>
>> I have a question about linux tty driver
>>
>> how to support cp, cat operations in tty driver (like tiny_tty)?
>> (e.g. echo "hello tty" > /dev/ttyS3, cat < ttyS10 etc)
>>
>> There a lot of examples with char drivers, but I could not find it for tty Linux driver.
>>
>
>It works out of the box. Just keep hardware flow-control turned off
>if there are no receivers connected to the output port. Also, you need
>to set up the port's baud-rate and (usually) to make it transparent to
>control characters (man tc-get/set-attr).
>
>Cheers,
>Dick Johnson
>Penguin : Linux version 2.6.16.24 on an i686 machine (5592.61 BogoMips).
>New book: http://www.AbominableFirebug.com/
>_
>
>
>****************************************************************
>The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.
>
>Thank you.

