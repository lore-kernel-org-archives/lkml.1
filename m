Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbYJaVl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbYJaVl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 17:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbYJaVlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 17:41:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:51729 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbYJaVlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 17:41:51 -0400
Message-ID: <490B7B6F.2080800@kernel.org>
Date: Fri, 31 Oct 2008 14:41:03 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Aristeu Rozanski <aris@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: nmi - document lapic and ioapic parameters
References: <20081031192358.GC20803@localhost> <86802c440810311422w79d0e697k246cb5ca76bf91b5@mail.gmail.com> <490B7AFE.2030505@zytor.com>
In-Reply-To: <490B7AFE.2030505@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Yinghai Lu wrote:
>> On Fri, Oct 31, 2008 at 12:23 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>>> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
>>> ---
>>>
>>> On top of -tip dda51106620c328b50007c259b9ef8cea2b7c3d2
>>>
>>> Index: linux-2.6.git/Documentation/kernel-parameters.txt
>>> ===================================================================
>>> --- linux-2.6.git.orig/Documentation/kernel-parameters.txt      2008-10-27 21:35:08.000000000 +0300
>>> +++ linux-2.6.git/Documentation/kernel-parameters.txt   2008-10-31 22:21:59.000000000 +0300
>>> @@ -1404,6 +1404,14 @@ and is between 256 and 4096 characters.
>>>                        Format: [state][,regs][,debounce][,die]
>>>
>>>        nmi_watchdog=   [KNL,BUGS=X86-32] Debugging features for SMP kernels
>>> +                       Format: [panic,][num]
>>> +                       Valid num: 0,1,2
>>> +                       0 - turn nmi_watchdog off
>>> +                       1 - use IO-APIC
>>> +                       2 - use local APIC
>>> +                       Instead of 1 and 2 it is possible to use the following
>>> +                       symbolic names: lapic and ioapic
>>> +                       Example: nmi_watchdog=2 or nmi_watchdog=panic,lapic
>>>
>>>        no387           [BUGS=X86-32] Tells the kernel to use the 387 maths
>>>                        emulation library even if a 387 maths coprocessor
>>> --
>> please update
>>
>> Documentation/x86/x86_64/boot-options.txt
>>
> 
> If it's in x86-64, it's not =X86-32, so something is fishy.  The
> x86_64/boot-options.txt file really should be merged into
> kernel-parameters.txt.

should have all command line etc in source code .c, and use some tools to extract them to keep them consistent.

YH

