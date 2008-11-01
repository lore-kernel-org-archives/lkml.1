Return-Path: <linux-kernel-owner+w=401wt.eu-S1751998AbYKAF4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbYKAF4W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 01:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbYKAF4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 01:56:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:55175 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbYKAF4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 01:56:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UaW2v1uwkijBs9MMphiyOGwm59y3ukfN++II0KWyY5Q2hOYyLIWvhBBdrmvgBvs00r
         tgelyIoCmTrZ5vvVD9GJQdAbBd7JuUfZd0BXn1GvbV61yVG36BAiWN6Z8w0grhobMdz2
         QcZ/kNOEtZJX+tJGJb8D8oT3Lqqq+q17BPc6c=
Message-ID: <aa79d98a0810312256j490baac3o93b61c8704314dee@mail.gmail.com>
Date: Sat, 1 Nov 2008 08:56:11 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Yinghai Lu" <yinghai@kernel.org>
Subject: Re: [PATCH] x86: nmi - document lapic and ioapic parameters
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       "Aristeu Rozanski" <aris@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <490B7B6F.2080800@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081031192358.GC20803@localhost>
	 <86802c440810311422w79d0e697k246cb5ca76bf91b5@mail.gmail.com>
	 <490B7AFE.2030505@zytor.com> <490B7B6F.2080800@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 1, 2008 at 12:41 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> H. Peter Anvin wrote:
>> Yinghai Lu wrote:
>>> On Fri, Oct 31, 2008 at 12:23 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>>>> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
>>>> ---
>>>>
>>>> On top of -tip dda51106620c328b50007c259b9ef8cea2b7c3d2
>>>>
>>>> Index: linux-2.6.git/Documentation/kernel-parameters.txt
>>>> ===================================================================
>>>> --- linux-2.6.git.orig/Documentation/kernel-parameters.txt      2008-10-27 21:35:08.000000000 +0300
>>>> +++ linux-2.6.git/Documentation/kernel-parameters.txt   2008-10-31 22:21:59.000000000 +0300
>>>> @@ -1404,6 +1404,14 @@ and is between 256 and 4096 characters.
>>>>                        Format: [state][,regs][,debounce][,die]
>>>>
>>>>        nmi_watchdog=   [KNL,BUGS=X86-32] Debugging features for SMP kernels
>>>> +                       Format: [panic,][num]
>>>> +                       Valid num: 0,1,2
>>>> +                       0 - turn nmi_watchdog off
>>>> +                       1 - use IO-APIC
>>>> +                       2 - use local APIC
>>>> +                       Instead of 1 and 2 it is possible to use the following
>>>> +                       symbolic names: lapic and ioapic
>>>> +                       Example: nmi_watchdog=2 or nmi_watchdog=panic,lapic
>>>>
>>>>        no387           [BUGS=X86-32] Tells the kernel to use the 387 maths
>>>>                        emulation library even if a 387 maths coprocessor
>>>> --
>>> please update
>>>
>>> Documentation/x86/x86_64/boot-options.txt
>>>
>>
>> If it's in x86-64, it's not =X86-32, so something is fishy.  The
>> x86_64/boot-options.txt file really should be merged into
>> kernel-parameters.txt.
>
> should have all command line etc in source code .c, and use some tools to extract them to keep them consistent.
>
> YH
>
>

Will update boot-options.txt by a separate patch later. Thanks!
