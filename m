Return-Path: <linux-kernel-owner+w=401wt.eu-S1763380AbYEASTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763380AbYEASTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 14:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbYEASTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 14:19:11 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:45304 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbYEASTK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 14:19:10 -0400
Date: Thu, 01 May 2008 20:19:08 +0200
Message-Id: <261769053@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: anilatx@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re:Re: kernel BUG at mm/rmap.c:669 (during localegen)
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX19WjtivLYAtSwdZdgMXepPwE3d6WqXie3+6Q1Nx99Fn9Ci1H
 gTS4+xn3RN3W4YvScYoBjFOQJSEM5lSKIMCqytS/s0G0A6jZyc=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so, you are absolutely sure that this happens without nvidia driver?

if not, rename the nvidia kernel module and try again.....

>(but this case leaves no logs becouse logging is down too)

kernel logging should still be there (dmesg), but it may not go to /var/log/messages.
you may start syslogd/klogd manually in that runlevel






List:       linux-kernel
Subject:    Re:Re: kernel BUG at mm/rmap.c:669 (during localegen)
From:       Paweł <anilatx () gmail ! com>
Date:       2008-05-01 13:54:56
Message-ID: 4819CBB0.8010208 () gmail ! com
[Download message RAW]

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



_______________________________________________________________________
Jetzt neu! Sch�tzen Sie Ihren PC mit McAfee und WEB.DE. 30 Tage
kostenlos testen. http://www.pc-sicherheit.web.de/startseite/?mc=022220

