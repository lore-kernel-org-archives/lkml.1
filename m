Return-Path: <linux-kernel-owner+w=401wt.eu-S964781AbXAWM2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964781AbXAWM2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 07:28:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964798AbXAWM2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 07:28:10 -0500
Received: from smtp7-g19.free.fr ([212.27.42.64]:48144 "EHLO smtp7-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964806AbXAWM2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 07:28:08 -0500
X-Greylist: delayed 12510 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jan 2007 07:28:08 EST
Subject: Re: 2.6.19.2 sky2/acpi crashes
From: Lionel Landwerlin <landwer@free.fr>
To: Luming Yu <luming.yu@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <3877989d0701230122r426eb5b0h446c897780923d7a@mail.gmail.com>
References: <1169542768.5537.11.camel@cocoduo>
	 <3877989d0701230122r426eb5b0h446c897780923d7a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 23 Jan 2007 13:27:18 +0100
Message-Id: <1169555238.5747.3.camel@cocoduo>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 23 janvier 2007 à 17:22 +0800, Luming Yu a écrit :
> Please try to remove processor module.

Ok, that's done. Same problem.

Just to show you I did not forget to remove processor.ko from initrd
image, I tried to load speedstep_centrino :

Jan 23 13:09:58 cocoduo kernel: [  105.697279] speedstep_centrino:
Unknown symbol acpi_processor_notify_smm
Jan 23 13:09:58 cocoduo kernel: [  105.697324] speedstep_centrino:
Unknown symbol acpi_processor_unregister_performance
Jan 23 13:09:58 cocoduo kernel: [  105.697411] speedstep_centrino:
Unknown symbol acpi_processor_preregister_performance
Jan 23 13:09:58 cocoduo kernel: [  105.697464] speedstep_centrino:
Unknown symbol acpi_processor_register_performance
Jan 23 13:15:51 cocoduo kernel: [  458.267151] NETDEV WATCHDOG: eth0:
transmit timed out
Jan 23 13:15:51 cocoduo kernel: [  458.267157] sky2 eth0: tx timeout
Jan 23 13:15:51 cocoduo kernel: [  458.267164] sky2 eth0: transmit ring
421 .. 398 report=422 done=422
Jan 23 13:15:51 cocoduo kernel: [  458.267166] sky2 status report lost?
Jan 23 13:16:00 cocoduo kernel: [  466.730622] BUG: soft lockup detected
on CPU#0!
Jan 23 13:16:00 cocoduo kernel: [  466.730644]  [softlockup_tick
+155/208] softlockup_tick+0x9b/0xd0
Jan 23 13:16:00 cocoduo kernel: [  466.730656]  [update_process_times
+49/128] update_process_times+0x31/0x80
Jan 23 13:16:00 cocoduo kernel: [  466.730666]
[smp_apic_timer_interrupt+145/176] smp_apic_timer_interrupt+0x91/0xb0
Jan 23 13:16:00 cocoduo kernel: [  466.730674]  [apic_timer_interrupt
+31/36] apic_timer_interrupt+0x1f/0x24
Jan 23 13:16:00 cocoduo kernel: [  466.730684]  [_spin_lock_bh+18/32]
_spin_lock_bh+0x12/0x20
Jan 23 13:16:00 cocoduo kernel: [  466.730693]  [pg0
+945944213/1068803072] sky2_tx_timeout+0xf5/0x1d0 [sky2]
Jan 23 13:16:00 cocoduo kernel: [  466.730707]  [dev_watchdog+0/208]
dev_watchdog+0x0/0xd0
Jan 23 13:16:00 cocoduo kernel: [  466.730712]  [dev_watchdog+192/208]
dev_watchdog+0xc0/0xd0
Jan 23 13:16:00 cocoduo kernel: [  466.730718]  [run_timer_softirq
+273/400] run_timer_softirq+0x111/0x190
Jan 23 13:16:00 cocoduo kernel: [  466.730728]  [__do_softirq+116/240]
__do_softirq+0x74/0xf0
Jan 23 13:16:00 cocoduo kernel: [  466.730734]  [do_softirq+59/80]
do_softirq+0x3b/0x50
Jan 23 13:16:00 cocoduo kernel: [  466.730739]
[smp_apic_timer_interrupt+150/176] smp_apic_timer_interrupt+0x96/0xb0
Jan 23 13:16:00 cocoduo kernel: [  466.730746]  [apic_timer_interrupt
+31/36] apic_timer_interrupt+0x1f/0x24
Jan 23 13:16:00 cocoduo kernel: [  466.730756]  [mwait_idle_with_hints
+70/96] mwait_idle_with_hints+0x46/0x60
Jan 23 13:16:00 cocoduo kernel: [  466.730762]  [mwait_idle+12/32]
mwait_idle+0xc/0x20
Jan 23 13:16:00 cocoduo kernel: [  466.730766]  [cpu_idle+116/208]
cpu_idle+0x74/0xd0
Jan 23 13:16:00 cocoduo kernel: [  466.730773]  [start_kernel+872/1072]
start_kernel+0x368/0x430
Jan 23 13:16:00 cocoduo kernel: [  466.730780]  [unknown_bootoption
+0/624] unknown_bootoption+0x0/0x270
Jan 23 13:16:00 cocoduo kernel: [  466.730790]  =======================


