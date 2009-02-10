Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbZBJUeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbZBJUeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 15:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754991AbZBJUe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 15:34:27 -0500
Received: from mailout.artfiles.de ([80.252.97.80]:55598 "EHLO
	mailout.artfiles.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbZBJUe1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 15:34:27 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with 2.6.29-rc3 on IBM x3400
Content-class: urn:content-classes:message
Date: Tue, 10 Feb 2009 21:34:22 +0100
X-MimeOLE: Produced By Microsoft Exchange V6.5
Message-ID: <B4ED8DE8E195E84A872496A085BC07822F22@exchange01.corp.win-professional.com>
In-Reply-To: <86802c440902101052m223792ddi43d27423844b1d5b@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with 2.6.29-rc3 on IBM x3400
Thread-Index: AcmLsLb7JrmYd8T4TkK/RQh4dLRo3wADd1pA
References: <B4ED8DE8E195E84A872496A085BC07822F18@exchange01.corp.win-professional.com> <B4ED8DE8E195E84A872496A085BC07822F1D@exchange01.corp.win-professional.com> <20090209234528.GA862@elte.hu> <4990E90D.30005@kernel.org> <B4ED8DE8E195E84A872496A085BC07822F21@exchange01.corp.win-professional.com> <86802c440902101052m223792ddi43d27423844b1d5b@mail.gmail.com>
From: "Morten P.D. Stevens" <mstevens@win-professional.com>
To: "Yinghai Lu" <yinghai@kernel.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Feb 2009 20:34:23.0603 (UTC) FILETIME=[F5863430:01C98BBE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> the line before this? it should tell why BIOS set the mask wrong.

here are the lines before:

[    0.000000] BIOS EBDA/lowmem at: 0009c400/0009c400
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.28.4-ibm (root@debian) (gcc version
4.3.2 (Debian 4.3.2-1.1) ) #1 SMP Tue Feb 10 16:49:51 CET 2009
[    0.000000] Command line: root=/dev/sda3 ro quiet
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009c400 (usable)
[    0.000000]  BIOS-e820: 000000000009c400 - 00000000000a0000
(reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000
(reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bff60000 (usable)
[    0.000000]  BIOS-e820: 00000000bff60000 - 00000000bff6a000 (ACPI
data)
[    0.000000]  BIOS-e820: 00000000bff6a000 - 00000000bff80000 (ACPI
NVS)
[    0.000000]  BIOS-e820: 00000000bff80000 - 00000000c0000000
(reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000
(reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000
(reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000
(reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000
(reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] DMI present.
[    0.000000] last_pfn = 0x140000 max_arch_pfn = 0x3ffffffff
[    0.000000] mtrr: BIOS set mask_lo: fcffff80 should be ffffff80,
fixing it up


-----Original Message-----
From: yhlu.kernel@gmail.com [mailto:yhlu.kernel@gmail.com] On Behalf Of
Yinghai Lu
Sent: Tuesday, February 10, 2009 7:52 PM
To: Morten P.D. Stevens
Cc: Ingo Molnar; Thomas Gleixner; H. Peter Anvin; Arjan van de Ven;
linux-kernel@vger.kernel.org
Subject: Re: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with
2.6.29-rc3 on IBM x3400

On Tue, Feb 10, 2009 at 8:21 AM, Morten P.D. Stevens
<mstevens@win-professional.com> wrote:
> Hi,
>
>> please try:
>> diff --git a/arch/x86/kernel/cpu/mtrr/generic.c
> b/arch/x86/kernel/cpu/mtrr/generic.c
>> index 0c0a455..7a359ce 100644
>> --- a/arch/x86/kernel/cpu/mtrr/generic.c
>> +++ b/arch/x86/kernel/cpu/mtrr/generic.c
>> @@ -397,7 +397,8 @@ static void generic_get_mtrr(unsigned int reg,
> unsigned long *base,
>>               tmp |= ~((1<<(hi - 1)) - 1);
>>
>>               if (tmp != mask_lo) {
>> -                     WARN_ONCE(1, KERN_INFO "mtrr: your BIOS has set
> up an incorrect mask, fixing it up.\n");
>> +                     printk(KERN_INFO "mtrr: BIOS set mask_lo: %x
> should be %x, fixing it up\n", mask_lo, tmp);
>> +                     WARN_ONCE(1, KERN_INFO "mtrr: your BIOS has set
> up an incorrect mask.\n");
>>                       mask_lo = tmp;
>>               }
>>       }
>
> result:
>
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:405
> generic_get_mtrr+0xd0/0x10a()
> [    0.000000] mtrr: your BIOS has set up an incorrect mask.
> [    0.000000] Modules linked in:
> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.28.4-ibm #1
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff8023acca>] warn_slowpath+0xb4/0xda
> [    0.000000]  [<ffffffff8023b8c6>] vprintk+0x2a4/0x2d1
> [    0.000000]  [<ffffffff80221bea>] default_spin_lock_flags+0x6/0x8
> [    0.000000]  [<ffffffff80451cf9>] printk+0x4e/0x5d
> [    0.000000]  [<ffffffff80453e6a>] _spin_lock_irqsave+0x25/0x2c
> [    0.000000]  [<ffffffff802194c0>] mtrr_wrmsr+0x1b/0x48
> [    0.000000]  [<ffffffff805e5f88>] get_mtrr_state+0x2e5/0x2f1
> [    0.000000]  [<ffffffff8021960e>] generic_get_mtrr+0xd0/0x10a
> [    0.000000]  [<ffffffff805e4e0d>] mtrr_bp_init+0x1f5/0xc39
> [    0.000000]  [<ffffffff805e58e4>]
> mtrr_trim_uncached_memory+0x93/0x374
> [    0.000000]  [<ffffffff805f07c9>] early_iounmap+0x13d/0x19d
> [    0.000000]  [<ffffffff805f07c9>] early_iounmap+0x13d/0x19d
> [    0.000000]  [<ffffffff805da140>] early_idt_handler+0x0/0x71
> [    0.000000]  [<ffffffff805e0d56>] setup_arch+0x407/0x78c
> [    0.000000]  [<ffffffff805f4c81>] cgroup_init_subsys+0x2a/0xd9
> [    0.000000]  [<ffffffff805f4f5e>] cgroup_init_early+0x1a4/0x1b6
> [    0.000000]  [<ffffffff80453f10>] _spin_lock+0x6/0x7
> [    0.000000]  [<ffffffff805da931>] start_kernel+0x7b/0x38b
> [    0.000000]  [<ffffffff805da140>] early_idt_handler+0x0/0x71
> [    0.000000]  [<ffffffff805da3a1>] x86_64_start_kernel+0xe7/0xf4
> [    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
>


the line before this? it should tell why BIOS set the mask wrong.

YH
