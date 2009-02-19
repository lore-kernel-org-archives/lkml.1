Return-Path: <linux-kernel-owner+w=401wt.eu-S1758921AbZBSTFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921AbZBSTFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 14:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbZBSTFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 14:05:36 -0500
Received: from adsl134-239.ath.forthnet.gr ([79.103.101.239]:34579 "EHLO
	vergina.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504AbZBSTFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 14:05:35 -0500
Message-ID: <499DAD7C.4060404@asyr.hopto.org>
Date: Thu, 19 Feb 2009 21:05:32 +0200
From: Thanasis <thanasis@asyr.hopto.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090112)
MIME-Version: 1.0
To: gentoo-amd64@lists.gentoo.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [gentoo-amd64] Is /proc/cpuinfo showing the actual frequency
 ?
References: <499D0D0E.9020608@asyr.hopto.org> <499D8783.2080704@j-schmitz.net>	 <499D8CFA.9080406@asyr.hopto.org> <499D8F02.3010905@j-schmitz.net> <58965d8a0902190946k3f0be02nd3f4eef4827cc08a@mail.gmail.com>
In-Reply-To: <58965d8a0902190946k3f0be02nd3f4eef4827cc08a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 02/19/2009 07:46 PM Paul Hartman wrote the following:
> On Thu, Feb 19, 2009 at 10:55 AM, Justin <justin@j-schmitz.net> wrote:
>> Thanasis schrieb:
>>> on 02/19/2009 06:23 PM Justin wrote the following:
>>>> Thanasis schrieb:
>>>>
>>>>> # uname -a
>>>>> Linux wolfdale 2.6.28-gentoo-r2 #1 SMP PREEMPT Wed Feb 18 13:53:22 EET
>>>>> 2009 x86_64 Intel(R) Core(TM)2 Duo CPU E8400 @ 3.00GHz GenuineIntel
>>>>> GNU/Linux
>>>>>
>>>>> Overclocked the core 2 duo (E8400) from 3 to 4GHz using motherboard
>>>>> BIOS settings. In mswindblows I can see the overclocked frequency
>>>>> (when cpu is under load), in linux /proc/cpuinfo never shows beyond the
>>>>> stock 3GHz value.
>>>>>
>>>>> Q: Is /proc/cpuinfo showing the actual frequency?
>>>>>
>>>>>
>>>> Do you have frequency scaling active?
>>> Yes, but the /proc/cpuinfo I showed, was with the max frequency ever
>>> displayed (under load).
>>>
>> AFAIK the scaling will interfere with OC. Try to disable it and check
>> again.
>
> I just did some googling and it seems that frequency scaling in linux
> only works with the stock speed steps, not the OC'ed speed.

I bet if I disable frequency scaling from BIOS, it will show 4GHz, because the 
funny thing is that inside a fully VM (guest) it shows the "real" frequency  ;-) 

# cat cpuinfo
processor    : 0
vendor_id    : GenuineIntel
cpu family    : 6
model        : 23
model name    : Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz
stepping    : 10
cpu MHz        : 4050.236
cache size    : 6144 KB
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat 
clflush dts mmx fxsr sse sse2 ss syscall nx lm pni ds_cpl cx16 xtpr lahf_lm
bogomips    : 8111.05
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 1
vendor_id    : GenuineIntel
cpu family    : 6
model        : 23
model name    : Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz
stepping    : 10
cpu MHz        : 4050.236
cache size    : 6144 KB
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat 
clflush dts mmx fxsr sse sse2 ss syscall nx lm pni ds_cpl cx16 xtpr lahf_lm
bogomips    : 8101.80
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

