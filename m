Return-Path: <linux-kernel-owner+w=401wt.eu-S1759262AbXI0VBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262AbXI0VBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 17:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756572AbXI0VB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 17:01:26 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:49739 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464AbXI0VBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 17:01:25 -0400
Date: Thu, 27 Sep 2007 23:01:23 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
cc: mahamuni ashish <ash_lkp@yahoo.co.in>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Floating Point Issue
In-Reply-To: <Pine.LNX.4.61.0709271645590.5183@chaos.analogic.com>
Message-ID: <Pine.LNX.4.64.0709272300250.25099@fbirervta.pbzchgretzou.qr>
References: <109515.18343.qm@web7805.mail.in.yahoo.com>
 <Pine.LNX.4.61.0709271645590.5183@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 27 2007 16:53, linux-os (Dick Johnson) wrote:
>
>If Windows lets you get away with this, then Windows is broken.
>memset(ch,'\0',strlen(ch) );

No, probably just the chance that the memory to which ch points
had a nul in it or in the near bytes.

Use valgrind, move along.

>On Thu, 27 Sep 2007, mahamuni ashish wrote:
>
>> I have small code....
>>
>> #include <stdio.h>
>> #include <string.h>
>>
>> int main()
>> {
>> float f= 1256.35;
>> char ch[4];
>>
>> printf("\n1. f : %f",f);
>> memset(ch,'\0',strlen(ch) );
>> printf("\n2. f : %f",f);
>> return 0;
>> }
>>
>> Expected output is
>> 1. f : 1256.35
>> 2. f : 1256.35
>>
>> But I am getting the output
>> (on windows)
>> 1. f : 1256.35
>> 2. f : 0.000000
>>
>> (on Linux)
>> 1. f : 1256.35
>> segmentation fault
>>
>> why?
>>
>>
>>      Forgot the famous last words? Access your message archive online at http://in.messenger.yahoo.com/webmessengerpromo.php
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
>Cheers,
>Dick Johnson
>Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
>My book : http://www.AbominableFirebug.com/
>_
>
>
>****************************************************************
>The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.
>
>Thank you.
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>

