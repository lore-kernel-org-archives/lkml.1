Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbYCKLwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbYCKLwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 07:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbYCKLwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 07:52:14 -0400
Received: from lucidpixels.com ([75.144.35.66]:43516 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbYCKLwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 07:52:14 -0400
Date: Tue, 11 Mar 2008 07:52:13 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, Stable Team <stable@kernel.org>
Subject: Re: 2.6.24.3: WARNING: native_smp_call_function_mask() at boot
 time
In-Reply-To: <alpine.LFD.1.00.0803111104550.3781@apollo.tec.linutronix.de>
Message-ID: <alpine.DEB.1.00.0803110751470.10032@p34.internal.lan>
References: <alpine.DEB.1.00.0803100426320.18620@p34.internal.lan> <alpine.LFD.1.00.0803111104550.3781@apollo.tec.linutronix.de>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 11 Mar 2008, Thomas Gleixner wrote:

> On Mon, 10 Mar 2008, Justin Piszcz wrote:
>> Running kernel 2.6.24.3 on Debian Testing here..
>>
>> [   19.141846] WARNING: at arch/x86/kernel/smp_32.c:561
>> native_smp_call_function_mask()
>> [   19.141896] Pid: 1, comm: swapper Not tainted 2.6.24.3 #1
>> [   19.141937]  [<c010e50b>] native_smp_call_function_mask+0x14b/0x150
>> [   19.142009]  [<c01036c3>] common_interrupt+0x23/0x28
>> [   19.142076]  [<c010f470>] enable_NMI_through_LVT0+0x0/0x30
>> [   19.142144]  [<c010f470>] enable_NMI_through_LVT0+0x0/0x30
>> [   19.142212]  [<c010e8fc>] smp_call_function+0x1c/0x30
>> [   19.142279]  [<c012196c>] on_each_cpu+0x2c/0x60
>> [   19.142346]  [<c0110840>] setup_nmi+0x30/0x50
>
> Can you please try the backported patch below.
>
> Thanks,
> 	tglx
>

Patching now and will have the result shortly.

# patch -p1 < ../patch
patching file arch/x86/kernel/apic_32.c
patching file arch/x86/kernel/apic_64.c
patching file arch/x86/kernel/io_apic_32.c
patching file arch/x86/kernel/io_apic_64.c
patching file arch/x86/kernel/smpboot_32.c
patching file arch/x86/kernel/smpboot_64.c
patching file include/asm-x86/apic_32.h
patching file include/asm-x86/io_apic_64.h
#

