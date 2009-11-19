Return-Path: <linux-kernel-owner+w=401wt.eu-S1758023AbZKSKTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbZKSKTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 05:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbZKSKTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 05:19:51 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:50350 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087AbZKSKTu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 05:19:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Qouvwr7oX+nw3C6ab5Pox5Q+XdzFIJm9j9B++Y9YhyqkY7m3wTqKNGYdPZTuML2kAR
         IT5znq/onQDkpHZJbyCvMWlkOQ/DOD78l+IjZKA1Hw7NTwN1vEYSwvNcPOce6Xuz/lWY
         DWXt3hwBBcTw/T3inLWUFAdA8Hk2aZ6Yg/u8U=
MIME-Version: 1.0
In-Reply-To: <4B05187F.6030809@einfochips.com>
References: <cb9ecdfa0911190150w4edbacdfp24a7069c618193f4@mail.gmail.com>
	 <4B05187F.6030809@einfochips.com>
Date: Thu, 19 Nov 2009 18:19:55 +0800
Message-ID: <cb9ecdfa0911190219r11fa165v331a590889edcfd0@mail.gmail.com>
Subject: Re: How to move two valuables to x86 CPU register ebx, ecx by using 
	AT&A inline asm.
From: Johnny Hung <johnny.hacking@gmail.com>
To: Viral Mehta <viral.mehta@einfochips.com>
Cc: kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't works. :(

2009/11/19 Viral Mehta <viral.mehta@einfochips.com>:
> How about putting \n at the end ?
>
> Just try out,
>
> __asm__ volatile ("movl %0, %%ebx\n"
>         "movl %1, %%ecx\n"
>
>
>
>
> Thanks,
> Viral Mehta,
> Embedded Software Engineer,
> Tel. No. 91 79 26563705, Ext. 423
> www.einfochips.com <http://www.einfochips.com>
> Prepare and Prevent rather than Repair and Repent
>
>
> Johnny Hung wrote:
>>
>> Hi All:
>>    I want to move two local valuables to x86 arch CPU ebx, ecx
>> register and do outb cpu instruction by using AT&A inline asm in
>> kernel driver.  The following code was I wrote but gcc report syntax
>> error:
>> ==
>>    unsigned int val = 10;
>>    unsigned int tmp = 5;
>>    ....
>>    __asm__ volatile ("movl %0, %%ebx"
>>          "movl %1, %%ecx"
>>          "outb $0x27, $0xb2"
>>          :
>>          :"r"(val), "r"(tmp)
>>          :"%ebx", "%ecx"
>>   );
>>
>> Does anyone can point me out. Any reply is appreciated.
>>
>> BRs, H. Johnny
>>
>> --
>> To unsubscribe from this list: send an email with
>> "unsubscribe kernelnewbies" to ecartis@nl.linux.org
>> Please read the FAQ at http://kernelnewbies.org/FAQ
>>
>>
>>
>> Email Scanned for Virus & Dangerous Content by : www.CleanMailGateway.com
>>
>>
>>
>
> --
> _____________________________________________________________________
> Disclaimer: This e-mail message and all attachments transmitted with it
> are intended solely for the use of the addressee and may contain legally
> privileged and confidential information. If the reader of this message
> is not the intended recipient, or an employee or agent responsible for
> delivering this message to the intended recipient, you are hereby
> notified that any dissemination, distribution, copying, or other use of
> this message or its attachments is strictly prohibited. If you have
> received this message in error, please notify the sender immediately by
> replying to this message and please delete it from your computer. Any
> views expressed in this message are those of the individual sender
> unless otherwise stated.Company has taken enough precautions to prevent
> the spread of viruses. However the company accepts no liability for any
> damage caused by any virus transmitted by this email.
> _____________________________________________________________________
>
>
