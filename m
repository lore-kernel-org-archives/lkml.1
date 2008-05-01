Return-Path: <linux-kernel-owner+w=401wt.eu-S1761006AbYEANzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761006AbYEANzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 09:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbYEANzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 09:55:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:32332 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbYEANzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 09:55:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=OuliBcknkx0lAUtRBLt1Cd0UbLgRmDJAc+y9Om8xxSULE09xZKVU+Zx9LrpuGFyUZ485Yy9+XRe9h64I1Ilm0JMYKWKqeAfU49wGZ9RwZhkgCexwyUHogeUc7b4yx5ufo9Yzwn6UuBpGHCBKsgSDXzOXiA1hXS1DU7sBU19vkto=
Message-ID: <4819CBB0.8010208@gmail.com>
Date: Thu, 01 May 2008 15:54:56 +0200
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080109)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re:Re: kernel BUG at mm/rmap.c:669 (during localegen)
References: <48199F05.507@gmail.com> <Pine.LNX.4.64.0805011325290.22839@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0805011325290.22839@blonde.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
From: =?UTF-8?B?UGF3ZcWC?= <anilatx@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem is reproducible, as I wrote, also while booting through 
init=/bin/bash parameter(and in init 1, but with hang instead of reboot) 
so before loading any modules or nvidia drivers(but this case leaves no 
logs becouse logging is down too)
I mentioned first and last line as commented, just to ensure that it's 
everything about this symptome(timestamps suggest that)

Hugh Dickins wrote:
> On Thu, 1 May 2008, Paweł wrote:
>   
>> Every time I try to generate locales computer reboots or hangs. To ensure
>> that's not matter of graphDrivers I checked also in runlevel 1 and
>> "init=/bin/bash".
>>
>> Linux debby 2.6.25 #1 PREEMPT Mon Apr 28 15:18:31 CEST 2008 x86_64 GNU/Linux
>> gcc (GCC) 4.2.3 (Debian 4.2.3-3)
>>
>> [kern.log:]
>> //May  1 11:20:09 debby kernel: NVRM: bad caching on address
>> 0xffff81003a910000: actual 0x173 != expected 0x17b
>>
>> May  1 11:25:44 debby kernel: Eeek! page_mapcount(page) went negative! (-1)
>> May  1 11:25:44 debby kernel:   page pfn = 257d2
>> May  1 11:25:44 debby kernel:   page->flags = 2200000000001c
>> May  1 11:25:44 debby kernel:   page->count = 0
>> May  1 11:25:44 debby kernel:   page->mapping = 0000000000000000
>> May  1 11:25:44 debby kernel:   vma->vm_ops = 0x0
>> May  1 11:25:44 debby kernel: ------------[ cut here ]------------
>> May  1 11:25:44 debby kernel: kernel BUG at mm/rmap.c:669!
>> May  1 11:25:44 debby kernel: invalid opcode: 0000 [1] PREEMPT
>> May  1 11:25:44 debby kernel: CPU 0
>> May  1 11:25:44 debby kernel: Modules linked in: nvidia(P) ...
>> May  1 11:25:44 debby kernel: Pid: 3007, comm: localedef Tainted: P
>> 2.6.25 #1
>> May  1 11:25:44 debby kernel: RIP: 0010:[<ffffffff80270c74>]
>> [<ffffffff80270c74>] page_remove_rmap+0x164/0x180
>>     
>
> Sorry, you'll have to ask Nvidia to help you with this: we don't
> know what their driver is up to, and don't have any "NVRM" errors in
> 2.6.25 source; they should be grateful for your reproducible test case.
>
> Hugh
