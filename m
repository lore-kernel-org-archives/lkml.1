Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714Ab0BYOWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 09:22:24 -0500
Received: from lucidpixels.com ([75.144.35.66]:43552 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932680Ab0BYOWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 09:22:22 -0500
Date: Thu, 25 Feb 2010 09:22:19 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Thomas Backlund <tmb@mandriva.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.33: Problem continues: WARNING: at arch/x86/kernel/hpet.c:404
 hpet_next_event+0x70/0x80
In-Reply-To: <4B86832F.70706@mandriva.org>
Message-ID: <alpine.DEB.2.00.1002250921530.7133@p34.internal.lan>
References: <alpine.DEB.2.00.1002241835120.4716@p34.internal.lan> <4B86832F.70706@mandriva.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Feb 2010, Thomas Backlund wrote:

> Justin Piszcz skrev 25.2.2010 01:37:
>> Hello,
>> 
>> Again, on the Intel DP55KG board:
>> 
>> # uname -a
>> Linux host 2.6.33 #1 SMP Wed Feb 24 18:31:00 EST 2010 x86_64 GNU/Linux
>> 
>> [ 1.237600] ------------[ cut here ]------------
>> [ 1.237890] WARNING: at arch/x86/kernel/hpet.c:404
>> hpet_next_event+0x70/0x80()
>> [ 1.238221] Hardware name:
>> [ 1.238504] hpet: compare register read back failed.
>> [ 1.238793] Modules linked in:
>> [ 1.239315] Pid: 0, comm: swapper Not tainted 2.6.33 #1
>> [ 1.239605] Call Trace:
>> [ 1.239886] <IRQ> [<ffffffff81056c13>] ? warn_slowpath_common+0x73/0xb0
>> [ 1.240409] [<ffffffff81079608>] ? tick_dev_program_event+0x38/0xc0
>> [ 1.240699] [<ffffffff81056cb0>] ? warn_slowpath_fmt+0x40/0x50
>> [ 1.240992] [<ffffffff81079608>] ? tick_dev_program_event+0x38/0xc0
>> [ 1.241281] [<ffffffff81041ad0>] ? hpet_next_event+0x70/0x80
>> [ 1.241573] [<ffffffff81079608>] ? tick_dev_program_event+0x38/0xc0
>> [ 1.241859] [<ffffffff81078e32>] ? tick_handle_oneshot_broadcast+0xe2/0x100
>> [ 1.246533] [<ffffffff8102a67a>] ? timer_interrupt+0x1a/0x30
>> [ 1.246826] [<ffffffff81085499>] ? handle_IRQ_event+0x39/0xd0
>> [ 1.247118] [<ffffffff81087368>] ? handle_edge_irq+0xb8/0x160
>> [ 1.247407] [<ffffffff81029f55>] ? handle_irq+0x15/0x20
>> [ 1.247689] [<ffffffff810294a2>] ? do_IRQ+0x62/0xe0
>> [ 1.247976] [<ffffffff8146be53>] ? ret_from_intr+0x0/0xa
>> [ 1.248262] <EOI> [<ffffffff8102f277>] ? mwait_idle+0x57/0x80
>> [ 1.248796] [<ffffffff8102645c>] ? cpu_idle+0x5c/0xb0
>> [ 1.249080] ---[ end trace db7f668fb6fef4e1 ]---
>> 
>> Is this something Intel has to fix or is it a bug in the kernel?
>> 
>
> Here is a suggested fix:
>
> http://marc.info/?l=linux-kernel&m=126531123524059&w=2
>
> --
> Thomas
>

Hi,

This looks like what I want, will it be included in 2.6.33.1 or 2.6.34?

Justin.
