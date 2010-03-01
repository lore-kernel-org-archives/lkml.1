Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750854Ab0CAI3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 03:29:05 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:59651 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab0CAI3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 03:29:01 -0500
Message-ID: <4B8B7AC7.1070201@in.ibm.com>
Date: Mon, 01 Mar 2010 13:58:55 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Xiaotian Feng <xtfeng@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: Re: 2.6.33-git6 boot failure[x86_64] (WARN: at arch/x86/mm/ioremap.c:111)
References: <4B8B43E9.1010506@in.ibm.com> <7b6bb4a51002282218u22c8f4c4wb2a345fcb7a82257@mail.gmail.com>
In-Reply-To: <7b6bb4a51002282218u22c8f4c4wb2a345fcb7a82257@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiaotian Feng wrote:
> On Mon, Mar 1, 2010 at 12:34 PM, Sachin Sant <sachinp@in.ibm.com> wrote:
>   
>> Latest 2.6.33 git(30ff056..) failed to boot on a x86_64 box
>> with errors during mptsas/mptbase initialization. I also
>> noticed a warning during ACPI initialization.
>>     
>
> does revert of 13ca0f and 1b5576 makes your system alive?
>   
Yes.. after reverting 13ca0f and 1b5576, the machine boots fine.


>> Performance Events: AMD PMU driver.
>> ... version:                0
>> ... bit width:              48
>> ... generic registers:      4
>> ... value mask:             0000ffffffffffff
>> ... max period:             00007fffffffffff
>> ... fixed-purpose events:   0
>> ... event mask:             000000000000000f
>> ACPI: Core revision 20091214
>> ------------[ cut here ]------------
>> WARNING: at arch/x86/mm/ioremap.c:111 __ioremap_caller+0x169/0x2f1()
>> Hardware name: BladeCenter LS21 -[79716AA]-
>> Modules linked in:
>> Pid: 0, comm: swapper Not tainted 2.6.33-git6-autotest #1
>> Call Trace:
>> [<ffffffff81047cff>] ? __ioremap_caller+0x169/0x2f1
>> [<ffffffff81063b7d>] warn_slowpath_common+0x77/0xa4
>> [<ffffffff81063bb9>] warn_slowpath_null+0xf/0x11
>> [<ffffffff81047cff>] __ioremap_caller+0x169/0x2f1
>> [<ffffffff813747a3>] ? acpi_os_map_memory+0x12/0x1b
>> [<ffffffff81047f10>] ioremap_nocache+0x12/0x14
>> [<ffffffff813747a3>] acpi_os_map_memory+0x12/0x1b
>> [<ffffffff81282fa0>] acpi_tb_verify_table+0x29/0x5b
>> [<ffffffff812827f0>] acpi_load_tables+0x39/0x15a
>> [<ffffffff8191c8f8>] acpi_early_init+0x60/0xf5
>> [<ffffffff818f2cad>] start_kernel+0x397/0x3a7
>> [<ffffffff818f2295>] x86_64_start_reservations+0xa5/0xa9
>> [<ffffffff818f237a>] x86_64_start_kernel+0xe1/0xe8
>> ---[ end trace 4eaa2a86a8e2da22 ]---
>> ioremap reserve_memtype failed -22
>> ACPI Exception: AE_NO_ACPI_TABLES, While loading namespace from ACPI tables
>> (20091214/tbxface-604)
>> ACPI: Unable to load the System Description Tables
>>
>> I observed similar failure with x86_32 as well.
>>
>> 2.6.33-git5 (847f9c6...) worked fine.
>>     

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

