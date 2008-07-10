Return-Path: <linux-kernel-owner+w=401wt.eu-S1761540AbYGJTDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761540AbYGJTDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 15:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757365AbYGJTCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 15:02:51 -0400
Received: from gw.goop.org ([64.81.55.164]:53865 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbYGJTCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 15:02:50 -0400
Message-ID: <48765CCD.4070308@goop.org>
Date: Thu, 10 Jul 2008 12:02:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: next-0710: CONFIG_PARAVIRT broken on x86_64?
References: <s5htzexryqy.wl%tiwai@suse.de>	<487621BC.4040001@goop.org> <s5hmykprv2q.wl%tiwai@suse.de>
In-Reply-To: <s5hmykprv2q.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> At Thu, 10 Jul 2008 07:50:36 -0700,
> Jeremy Fitzhardinge wrote:
>   
>> Takashi Iwai wrote:
>>     
>>> Hi,
>>>
>>> does paravirt work on x86_64 with the recent linux-next kernels?
>>> I have a boot problem, a segfault of init at the very beginning.
>>>
>>>   Freeing memory ...
>>>   init[1]: segfault ... in libc-2.8.so
>>>
>>> The backtrace is like below:
>>>   ? do_coredump
>>>   ? blocking_notifier_call_chain
>>>   do_exit
>>>   do_group_exit
>>>   get_signal_to_deliver
>>>   do_notify_resume
>>>   ? do_wait
>>>   ? default_wake_function
>>>   retint_signal
>>>
>>> The kconfig is below.  When I set CONFIG_PARAVIRT=n, it works fine.
>>>
>>> The problem exists at least since 20080703 until today, maybe in the
>>> earlier versions, too.  The similar config works on i386.
>>>   
>>>       
>> Is your userspace 32 or 64 bit?
>>     
>
> 64bit.
>   

Booting native or under kvm?

    J
