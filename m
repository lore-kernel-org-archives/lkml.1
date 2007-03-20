Return-Path: <linux-kernel-owner+w=401wt.eu-S933965AbXCTPns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933965AbXCTPns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 11:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934014AbXCTPns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 11:43:48 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:55360 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933965AbXCTPnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 11:43:47 -0400
Message-ID: <46000121.7070509@oracle.com>
Date: Tue, 20 Mar 2007 08:43:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc3-mm2
References: <20070307201915.4d579113.akpm@linux-foundation.org> <20070319172711.1176b3d4.randy.dunlap@oracle.com> <20070320121432.GC10240@uranus.ravnborg.org>
In-Reply-To: <20070320121432.GC10240@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Mon, Mar 19, 2007 at 05:27:11PM -0700, Randy Dunlap wrote:
>> On Wed, 7 Mar 2007 20:19:15 -0800 Andrew Morton wrote:
>>
>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc3/2.6.21-rc3-mm2/
>>>
>>> - This is the same as 2.6.21-rc3-mm1, except Con's CPU scheduler changes
>>>   were dropped.
>>>
>>>   This is for A/B comparison purposes, and because those changes crashed on
>>>   one test setup.
>> I don't quite see why this error is happening.  Looks like all
>> the nested #includes should handle it...
>>
>> CONFIG_KEXEC=y
>> CONFIG_CRASH_DUMP=y
>> CONFIG_UTRACE=y
>> # PTRACE=n
>> # PROC_FS=n
>>
>> In file included from arch/x86_64/kernel/crash.c:19:
>> include/linux/elfcore.h: In function 'elf_core_copy_regs':
>> include/linux/elfcore.h:103: error: dereferencing pointer to incomplete type
>> include/linux/elfcore.h:103: error: dereferencing pointer to incomplete type
>> make[1]: *** [arch/x86_64/kernel/crash.o] Error 1
>> make: *** [arch/x86_64/kernel] Error 2
> 
> make arch/x86_64/kernel/crash.i
> may tell you a bit more why the includes foes wrong.

That didn't complain or have any errors/warnings, so hopefully
Roland can see something.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
