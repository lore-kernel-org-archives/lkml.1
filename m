Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbYAODpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbYAODpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 22:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbYAODpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 22:45:04 -0500
Received: from mail.gmx.net ([213.165.64.20]:58519 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753229AbYAODpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 22:45:00 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/spU4w4QTsxTUCiYfqtSakXni4MpNsIvi/XU6B8/
	Zr3Qee6SxiMwDj
Subject: Re: 2.6.24-rc7-rt2: WARNING: at include/linux/rcupreempt.h:110
	rcu_enter_nohz()
From: Mike Galbraith <efault@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1200336080.318.8.camel@localhost.localdomain>
References: <1200336080.318.8.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 04:44:56 +0100
Message-Id: <1200368696.4061.5.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

I receive $subject upon every resume.

[  115.223202] CPU1 is down
[    3.725918] Intel machine check architecture supported.
[    3.725925] Intel machine check reporting enabled on CPU#0.
[    3.725927] CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
[    3.725930] CPU0: Thermal monitoring enabled
[    3.725936] Back to C!
[    3.726468] Force enabled HPET at resume
[    3.726532] Enabling non-boot CPUs ...
[    3.726796] CPU0 attaching NULL sched-domain.
[    3.726912] SMP alternatives: switching to SMP code
[    3.727602] Booting processor 1/1 eip 3000
[    3.727605] CPU 1 irqstacks, hard=b042d000 soft=b042b000
[    3.737950] Initializing CPU#1
[    3.798694] Calibrating delay using timer specific routine.. 5986.21 BogoMIPS (lpj=2993108)
[    3.798703] CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000 00000000
[    3.798714] CPU: Trace cache: 12K uops, L1 D cache: 8K
[    3.798717] CPU: L2 cache: 512K
[    3.798719] CPU: Physical Processor ID: 0
[    3.798721] CPU: After all inits, caps: bfebfbff 00000000 00000000 0000b080 00004400 00000000 00000000 00000000
[    3.798729] Intel machine check architecture supported.
[    3.798734] Intel machine check reporting enabled on CPU#1.
[    3.798738] CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
[    3.798741] CPU1: Thermal monitoring enabled
[    3.798893] CPU1: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 09
[    3.798916] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    3.818995] CPU0 attaching sched-domain:
[    3.819000]  domain 0: span 3
[    3.819002]   groups: 1 2
[    3.819006]   domain 1: span 3
[    3.819009]    groups: 3
[    3.819013] CPU1 attaching sched-domain:
[    3.819016]  domain 0: span 3
[    3.819018]   groups: 2 1
[    3.819020]   domain 1: span 3
[    3.819021]    groups: 3
[    3.819615] CPU1 is up
[    3.820379] ACPI: Unable to turn cooling device [ef83ab80] 'off'
[    3.820424] PM: Writing back config space on device 0000:00:01.0 at offset 7 (was 22a0a0a0, writing 2a0a0a0)
[    3.820444] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 17
[    3.820450] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    3.820481] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 18
[    3.820487] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    3.820517] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 16
[    3.820523] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    3.820553] ACPI: PCI Interrupt 0000:00:1d.3[A] -> GSI 16 (level, low) -> IRQ 17
[    3.820558] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[    3.820614] BUG: bad accounting of dynamic ticks
[    3.820616]    will try to fix, but it is best to reboot
[    3.820618] WARNING: at include/linux/rcupreempt.h:110 rcu_enter_nohz()
[    3.820621] Pid: 0, comm: swapper Not tainted 2.6.24-rt2-smp #64
[    3.820624]  [<b010522a>] show_trace_log_lvl+0x1a/0x30
[    3.820631]  [<b0105ccd>] show_trace+0x12/0x14
[    3.820634]  [<b010641f>] dump_stack+0x6c/0x72
[    3.820637]  [<b0148f10>] tick_nohz_stop_sched_tick+0x2fa/0x30c
[    3.820641]  [<b010256d>] cpu_idle+0x27/0xd2
[    3.820644]  [<b0116f01>] start_secondary+0x19f/0x1a5
[    3.820648]  [<00000000>] 0x0
[    3.820661]  =======================


