Return-Path: <linux-kernel-owner+w=401wt.eu-S933713AbZJNUKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933713AbZJNUKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 16:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933662AbZJNUKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 16:10:38 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:45523 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933653AbZJNUKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 16:10:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rbDxoEzUAW364EH22+h9Kpu7AGvnMJ34Gl/QbViNSGZzB4MC//ptCsi1VTQV/T9AdK
         20ySbhR0gLLT3DBZcpCzRTNyxadRmn299R4wbZIzI97TOwUpLHLHIk3oFma811sLd0hx
         IsIF1X4ZlJSnnQPfrqFE37pwEMkEqCLz+hd4A=
MIME-Version: 1.0
In-Reply-To: <200910122320.10059.rjw@sisk.pl>
References: <37b436160910101054t7765c253ta98b983f226b57c3@mail.gmail.com>
	 <200910102334.42399.rjw@sisk.pl>
	 <37b436160910120849o6aae596w50e450b4838ed233@mail.gmail.com>
	 <200910122320.10059.rjw@sisk.pl>
Date: Wed, 14 Oct 2009 22:10:00 +0200
Message-ID: <37b436160910141310yc13f9ewa1def04c2e8e3101@mail.gmail.com>
Subject: Re: Suspend to RAM on MSI PR200YA - do not recover, system 
	immediately turns down
From: Ondrej Hujnak <hujnak.ondrej@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, mschmidt@redhat.com,
       pm list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 12.10.2009 23:20, Rafael J. Wysocki napsal(a):
> On Monday 12 October 2009, Ondrej Hujnak wrote:
>
>> 2009/10/10 Rafael J. Wysocki<rjw@sisk.pl>:
>>
>>> On Saturday 10 October 2009, Ondrej Hujnak wrote:
>>>
>>>> Hello,
>>>>
>>>> I am trying to make work "Suspend to RAM".
>>>> My laptop is MSI PR200YA, linux
>>>> kernel 2.6.30.8-64.fc11.i586 (fedora 11, 32bit),
>>>> the same is with 2.6.31.1-56.fc12.i686.
>>>> Motherboard - MSI 1221, graphics:
>>>> Mobile GM965/GL960 Integrated Graphics Controller
>>>>
>>>> When I do suspend to RAM it seem to work ok, it sleeps.
>>>> But when I want to wake it, it only switches off (the power
>>>> LED stops blinking).  If I'm having my notebook connected
>>>> to electricity, after start it don't  start screen and keyboard.
>>>> Notebook is running, but there is no HDD activity according
>>>> to the LED indicator. When it is on battery, it normally starts,
>>>> as if I had switched it normally off. Every time after trying to
>>>> suspend it to RAM, on the next start I have
>>>> "last write to superblock in future".
>>>>
>>>> I tried:
>>>>   - suspend from "single" mode
>>>>   - suspend from "single" mode with as many modules as possible rmmod'ed
>>>>   - using "nomodeset"
>>>>   - early suspend-to-RAM at boot test with "test_suspend=mem"
>>>> All with the same result.
>>>>
>>>> I also tried using pm_trace, but this gave no useful results in dmesg
>>>> in the next boot. The clock was not changed by it (the documentation
>>>> said it would be).
>>>>
>>>> I have attached printout of "lspci -vv" and "dmesg" after switching
>>>> pm_trace on.
>>>>
>>>> I'd welcome any ideas how to debug this further.
>>>> I'm looking forward to your reply.
>>>>
>>> Does the pm_test 'core' test work (please see
>>> Documentation/power/basic-pm-debugging.txt)?
>>>
>>> Rafael
>>>
>>>
>> Ok, i tried all kinds of pm_test including core several times
>> and everything seemed ok. I got no error, failure..
>>
>> And i tried all possibilities of /sys/power/disk under
>>   "init=/bin/bash" and same result as above.
>>
> That seems to indicate some kind of a BIOS issue.  However, several suspend
> bugs are going to be fixes in 2.6.32, so perhaps you can try -rc6 or later,
> when they are out.
>
> Thanks,
> Rafael
>
I tried to flash BIOS, so I have it up to date now. And it didn't help at all.
Being too eager to wait for -rc6 i tried v2.6.32-rc4-94-g80f5069, and it didn't
help as well.

Ondrej
