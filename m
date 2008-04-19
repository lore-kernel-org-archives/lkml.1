Return-Path: <linux-kernel-owner+w=401wt.eu-S1762812AbYDSVeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762812AbYDSVeV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 17:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbYDSVeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 17:34:13 -0400
Received: from colobus.isomerica.net ([216.93.242.10]:48099 "EHLO
	colobus.isomerica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbYDSVeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 17:34:12 -0400
Message-ID: <480A6553.7080502@isomerica.net>
Date: Sat, 19 Apr 2008 17:34:11 -0400
From: Dan Noe <dpn@isomerica.net>
Reply-To: dpn@isomerica.net
Organization: isomerica.net
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-$SHA1: WARNING: at arch/x86/kernel/genapic_64.c:86 read_apic_id+0x78/0x80()
References: <20080418223945.GA4801@martell.zuzino.mipt.ru> <20080419232543.6f0dc3ab.diegocg@gmail.com>
In-Reply-To: <20080419232543.6f0dc3ab.diegocg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Diego Calleja wrote:
> El Sat, 19 Apr 2008 02:39:45 +0400, Alexey Dobriyan <adobriyan@gmail.com> escribió:
> 
>> ------------[ cut here ]------------
>> WARNING: at arch/x86/kernel/genapic_64.c:86 read_apic_id+0x78/0x80()
>> Modules linked in:
>> Pid: 1, comm: swapper Not tainted 2.6.25-2cca775baecbfede2fec20c99add709232311fe7 #3
>>
>> Call Trace:
>>  [<ffffffff8023150f>] warn_on_slowpath+0x5f/0x80
>>  [<ffffffff80299e9e>] ? open_namei+0x4e/0x6b0
>>  [<ffffffff804594e5>] ? _spin_unlock_irqrestore+0x65/0x80
>>  [<ffffffff80254105>] ? trace_hardirqs_on+0xd5/0x160
>>  [<ffffffff804594c2>] ? _spin_unlock_irqrestore+0x42/0x80
>>  [<ffffffff8021ed28>] read_apic_id+0x78/0x80
>>  [<ffffffff805e7332>] verify_local_APIC+0xb2/0x1a0
>>  [<ffffffff805e6193>] native_smp_prepare_cpus+0x1a3/0x390
>>  [<ffffffff805e0713>] kernel_init+0x53/0x340
>>  [<ffffffff80459536>] ? _spin_unlock_irq+0x36/0x60
>>  [<ffffffff80458a92>] ? trace_hardirqs_on_thunk+0x35/0x3a
>>  [<ffffffff80254105>] ? trace_hardirqs_on+0xd5/0x160
>>  [<ffffffff8020c4b8>] child_rip+0xa/0x12
>>  [<ffffffff8020bba3>] ? restore_args+0x0/0x30
>>  [<ffffffff805e06c0>] ? kernel_init+0x0/0x340
>>  [<ffffffff8020c4ae>] ? child_rip+0x0/0x12
> 
> I'm getting exactly the same backtrace (it's also a Intel Core 2 machine)

I am also experiencing this with Core 2 Duo.  Same backtrace.

dmesg: http://isomerica.net/~dpn/WARN_ON_preemptible

config: http://isomerica.net/~dpn/WARN_ON_preemptible_config

Cheers,
Dan

-- 
                     /--------------- - -  -  -   -   -
                     |  Dan Noe
                     |  http://isomerica.net/~dpn/

