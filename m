Return-Path: <linux-kernel-owner+w=401wt.eu-S1758084AbYDYGDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbYDYGDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 02:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757792AbYDYGCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 02:02:21 -0400
Received: from [83.228.35.12] ([83.228.35.12]:38920 "EHLO fs.ru.acad.bg"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757517AbYDYGCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 02:02:18 -0400
Message-ID: <481173E7.3050903@fs.ru.acad.bg>
Date: Fri, 25 Apr 2008 09:02:15 +0300
From: Plamen Petrov <plamen.petrov@fs.ru.acad.bg>
Organization: Filial - Silistra
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: latest git (linux-2.6.25-git6) compile error
References: <200804250028.24913.pvp@fs.ru.acad.bg> <200804250107.40778.IvDoorn@gmail.com>
In-Reply-To: <200804250107.40778.IvDoorn@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivo van Doorn wrote:
> On Thursday 24 April 2008, Plamen Petrov wrote:
>   
>> Hi, folks!
>>
>> Just "git pulled" 2.6.25-git6, did the
>> "zcat /proc/config.gz > .config && make oldconfig" stuff,
>> and when I was asked for leds support (RT61PCI_LEDS) 
>> in the RT61 driver I happen to use, got this:
>>
>> [***************** SNIP *********************]
>>   LD      net/built-in.o
>>   LD      vmlinux.o
>>   MODPOST vmlinux.o
>> WARNING: modpost: Found 16 section mismatch(es).
>> To see full details build your kernel with:
>> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>>   GEN     .version
>>   CHK     include/linux/compile.h
>>   UPD     include/linux/compile.h
>>   CC      init/version.o
>>   LD      init/built-in.o
>>   LD      .tmp_vmlinux1
>> drivers/built-in.o: In function `rt2x00leds_resume':
>> /tmp/compile/linux-2.6/drivers/net/wireless/rt2x00/rt2x00leds.c:216: undefined 
>> reference to `led_classdev_resume'
>>     
>
> Can you confirm that this error goes away when enabling CONFIG_NEW_LEDS ?
>
> Ivo
>   
Will try and report later - now I'm at work, away from the machine.

Thanks,

-- 
Plamen Petrov, network & system administrator
Filial - Silistra
RU "Angel Kantchev"
http://fs.ru.acad.bg/
--------------------------------
this message is UTF8 encoded

