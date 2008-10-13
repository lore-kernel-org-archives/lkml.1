Return-Path: <linux-kernel-owner+w=401wt.eu-S1757094AbYJMI32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094AbYJMI32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 04:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755392AbYJMI3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 04:29:18 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:42403 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbYJMI3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 04:29:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lEA6ZdwVQJdl5wKEPJN9/EHEp82kh7tutFWT5UtZOZNO79CznSI+Eb6R+42JpsEdL5
         RhaPiwxx3gsWdzRgJlub1I5KGLX69hQKpNHHsv4R9oT+9GWgNHSUG949MXUueIXrDmK6
         ysmXksOLVMM4Nq5YzkVUnbWZEkL1ackl6XH0Y=
Message-ID: <264b990a0810130129m434ce4d1s93ecb63c4d032d2b@mail.gmail.com>
Date: Mon, 13 Oct 2008 15:29:14 +0700
From: "Yudha Harimantoro T" <yudha.ht@gmail.com>
To: "Bill Davidsen" <davidsen@tmr.com>
Subject: Re:
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <264b990a0810122318p477f7d19ye5e17414c4f5e8f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <264b990a0810110030r307829afmc8c2e1dfe6713faa@mail.gmail.com>
	 <48F0C24E.9030205@tmr.com>
	 <264b990a0810122318p477f7d19ye5e17414c4f5e8f3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you explain to me what the error means?
I got the kernel panic with the
http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.27.tar.bz2

<b>....
Kernel panic - not syncing: No init found. Try passing init= option to
kernel</b>

I still got the error.

Best regards,
Yudha_HT

2008/10/13, Yudha Harimantoro T <yudha.ht@gmail.com>:
> This morning I run `make mrproper` in the kernel tree and rebuild. But
> it make the kernel panic at 9 s, with the same error.
>
> Maybe I'll get the 2.6.27 from the kernel.org now.
>
> Thx,
>
> Yudha_HT
>
> 2008/10/11, Bill Davidsen <davidsen@tmr.com>:
>> Yudha Harimantoro T wrote:
>>> Date:	Fri, 10 Oct 2008 16:41:36 -0400
>>> From:	Bill Davidsen
>>>
>>>
>>>
>>>> Yudha Harimantoro T wrote:
>>>>
>>>>> Hi all,
>>>>> Yesterday I build kernel 2.6.26.6 and it's run well. Today I got
>>>>> 2.6.27 patch and try to build it.
>>>>>
>>>>> I build with `make oldconfig` and answer any question with default
>>>>> answer, I just press [enter].
>>>>> I build with `make`. No error and all compiled.
>>>>> Then I install with `make modules_install` and `make install`.
>>>>>
>>>>>
>>>
>>>
>>>> I realize that this is a low-probability thought, but did you:
>>>> - apply the patch against 2.6.26 NOT 2.6.26.6
>>>>
>>> Yup, I've did it.
>>>
>>>> - run make clean before applying the patch
>>>>
>>> I still need this for a pure 2.6.26? I'll try this.
>>>
>>>
>>>>> After reboot the system I got 'kernel panic'.
>>>>> This is the error picture :
>>>>> http://www.ryht.co.cc/wordpress/wp-content/uploads/2008/10/pa101358.jpg
>>>>> Is it a bugs?
>>>>>
>>>>> http://www.ryht.co.cc/wordpress/wp-content/uploads/2008/10/pa101353.jpg
>>>>> [2.6.26.6 run well]
>>>>>
>>>
>>>
>>>> I keep configs in a separate place. I would first copy a 2.6.26 tree to
>>>> a
>>>> new directory (cp -rl linux-2.6.26 linux2.6.27) then be sure I had a
>>>> clean copy with "make distclean" (or "make mrproper") and then apply the
>>>> 2.6.27 patch. Then I would copy the 2.6.26 (or maybe 2.6.26.6) config to
>>>> .config, and make the oldconfig.
>>>> None of that is magic, it just keeps me from making common mistakes,
>>>> lets
>>>> me start with a clean 2.6.27, etc, etc.
>>>> You mentioned oldconfig, but not starting back with a clean 2.6.26,
>>>> which
>>>> made me think of this.
>>>>
>>> Hm, I `cp /boot/config .config` in new kernel tree [2.6.27] for the
>>> config. Do I make mistakes?
>>>
>>
>> No, I was just noting that I try to start oldconfig with a known working
>> config, to reduce the number of choices and possible errors. I wasn't
>> sure if you did that, so I mentioned it.
>>
>> --
>> Bill Davidsen <davidsen@tmr.com>
>>   "Woe unto the statesman who makes war without a reason that will still
>>   be valid when the war is over..." Otto von Bismark
>>
>>
>>
>
