Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbZHUKx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbZHUKx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 06:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbZHUKxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 06:53:55 -0400
Received: from relay1.sgi.com ([192.48.179.29]:39985 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752400AbZHUKxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 06:53:54 -0400
Message-ID: <4A8E7CBE.3020209@sgi.com>
Date: Fri, 21 Aug 2009 12:53:50 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Latest Linus tree oopses on Nehalem box
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am seeing this one with the latest Linus' git tree as of this morning
on a Nehalem box. Using the defconfig + megaraid driver.

Not sure if this is already fixed, or if someone already knows whats
wrong? Smells like a yet another BIOS bug - yes the BIOS on this thing
is rubbish.

Cheers,
Jes

Starting Bluetooth services:[  OK  ]scd): [  OK  ]
Starting sshd: [  OK  ]ices:[  OK  ]
[    1.380099] pci 0000:01:01.0: BAR 6: address space collision on of 
device [0xfbbc0000-0xfbbdffff] 

�               Welcome to Fedora 

                 Press 'I' to enter interactive startup. 
          Starting udev: [    6.468279] BUG: unable to handle kernel 
NULL pointer dereference at 0000000000000008 

[    6.491835] IP: [<ffffffff810391e7>] find_busiest_group+0x620/0x6fd 

[    6.499207] usb usb8: uevent 
         [    6.499220] usb usb3: uevent 

[    6.499232] usb usb6: uevent 

[    6.499249] usb usb1: uevent 

[    6.499373] usb usb2: uevent 

[    6.499408] usb usb7: uevent 
         [    6.499602] usb usb4: uevent 

[    6.499949] usb usb5: uevent 

[    6.501821] usb 1-5: uevent 

[    6.588040] PGD 0 

[    6.594124] Oops: 0000 [#1] SMP 

[    6.603870] last sysfs file: /sys/devices/virtual/vc/vcsa1/dev 

[    6.621339] CPU 1 

[    6.627420] Modules linked in: [last unloaded: scsi_wait_scan] 

[    6.644994] Pid: 0, comm: swapper Not tainted 2.6.31-rc6 #15 
AltixXE270
[    6.664800] RIP: 0010:[<ffffffff810391e7>]  [<ffffffff810391e7>] 
find_busiest_group+0x620/0x6fd 

[    6.690897] RSP: 0018:ffffc90000203c50  EFLAGS: 00010216
[    6.706805] RAX: 0000000000000000 RBX: 0000000000000716 RCX: 
ffffc9000000e160
[    6.728173] RDX: 00000000000009c5 RSI: 0000000000000000 RDI: 
0000000000000040
[    6.749540] RBP: ffffc90000203dc0 R08: 0000000000000000 R09: 
00000000000002af
[    6.770908] R10: ffffc90001613980 R11: 0000000000000000 R12: 
ffffc9000080e160
[    6.792274] R13: 0000000000013980 R14: 0000000000000001 R15: 
ffffc90000203e58
[    6.813643] FS:  0000000000000000(0000) GS:ffffc90000200000(0000) 
knlGS:0000000000000000wn NFS mountd: [  OK  ]
[    6.837869] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[    6.855076] CR2: 0000000000000008 CR3: 0000000001001000 CR4: 
00000000000006e0
[    6.876445] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[    6.897812] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[    6.919179] Process swapper (pid: 0, threadinfo ffff88063e458000, 
task ffff88063e452d60)wn sendmail: [  OK  ]
[    6.943404] Stack:  ]
[    6.949436]  0000000000013980 0000000000000000 ffffc90000000000 
ffffc9000000e160pping HAL daemon: [  OK  ]
[    6.971165] <0> 0000000000013990 0000000000013980 ffffc9000020de18 
ffffc90000203e58ng Bluetooth services:[  OK  ]
[    6.994302] <0> 0000000000000010 0000000000013980 0000000000013980 
ffffc90000203e64ng RPC idmapd: [  OK  ]
[    7.017982] Call Trace:emon: M signal...
[    7.025312]  <IRQ>                       Sending all processes the 
KILL signa[    7.031657]  [<ffffffff8103c66b>] rebalance_domains+0x173/0x513
[    7.049388]  [<ffffffff8105e1fa>] ? clocksource_read+0xa/0xc
[    7.066333]  [<ffffffff8103ca8d>] run_rebalance_domains+0x82/0xcc
[    7.084582]  [<ffffffff8101ea54>] ? apic_write+0x11/0x13dware clock 
to system[    7.100491]  [<ffffffff81047c55>] __do_softirq+0xd2/0x19c
[    7.116658]  [<ffffffff8100cb9c>] call_softirq+0x1c/0x28
[    7.132566]  [<ffffffff8100df68>] do_softirq+0x34/0x72
[    7.147954]  [<ffffffff8104799a>] irq_exit+0x3f/0x81g pipe file 
systems:
[    7.162823]  [<ffffffff8101f28b>] smp_apic_timer_interrupt+0x81/0x8f 
      Unm[    7.181852]  [<ffffffff8100c573>] apic_timer_interrupt+0x13/0x20
[    7.199837]  <EOI>  Please stand by while rebooting the system...
[    7.206185]  [<ffffffff81226c7b>] ? acpi_idle_do_entry+0x3f/0x60 �
[    7.224169]  [<ffffffff81226cf7>] ? acpi_idle_enter_c1+0x5b/0xa4
[    7.242157]  [<ffffffff81226e11>] ? acpi_idle_enter_bm+0xd1/0x285
[    7.260408]  [<ffffffff8138afec>] ? cpuidle_idle_call+0x88/0xc0
[    7.278133]  [<ffffffff8100abc4>] ? cpu_idle+0x52/0x95
[    7.293522]  [<ffffffff815040c9>] ? start_secondary+0x179/0x17d
[    7.311248] Code: 09 49 c7 07 00 00 00 00 eb 51 48 8b b5 18 ff ff ff 
48 89 ca 49 89 c1 48 29 c8 48 8b 8d 10 ff ff ff 48 2b 95 38 ff ff ff 49 
29 d9 <8b> 76 08 8b 49 08 48 0f af d6 49 39 c1 49 0f 46 c1 48 0f af c1
[    7.370696] RIP  [<ffffffff810391e7>] find_busiest_group+0x620/0x6fd
[    7.389776]  RSP <ffffc90000203c50>
[    7.400226] CR2: 0000000000000008
[    7.410160] BUG: unable to handle kernel
[    7.410163] ---[ end trace ceb5be95b4c33d3f ]---
[    7.410166] Kernel panic - not syncing: Fatal exception in interrupt
[    7.410169] Pid: 0, comm: swapper Tainted: G      D    2.6.31-rc6 #15
[    7.410169] Call Trace:
[    7.410170]  <IRQ>  [<ffffffff81507b67>] panic+0x75/0x11c
[    7.410176]  [<ffffffff8150a81c>] oops_end+0xa9/0xb9
[    7.410180]  [<ffffffff8102b250>] no_context+0x1f1/0x200
[    7.410182]  [<ffffffff8102b3f7>] __bad_area_nosemaphore+0x198/0x1be
[    7.410185]  [<ffffffff8105b8a8>] ? sched_clock_cpu+0x18/0x151
[    7.410187]  [<ffffffff8102b42b>] bad_area_nosemaphore+0xe/0x10
[    7.410189]  [<ffffffff8150bbdb>] do_page_fault+0x135/0x273
[    7.410191]  [<ffffffff81509d7f>] page_fault+0x1f/0x30
[    7.410193]  [<ffffffff810391e7>] ? find_busiest_group+0x620/0x6fd
[    7.410196]  [<ffffffff8103c66b>] rebalance_domains+0x173/0x513
[    7.410198]  [<ffffffff8105e1fa>] ? clocksource_read+0xa/0xc
[    7.410200]  [<ffffffff8103ca8d>] run_rebalance_domains+0x82/0xcc
[    7.410202]  [<ffffffff8101ea54>] ? apic_write+0x11/0x13
[    7.410204]  [<ffffffff81047c55>] __do_softirq+0xd2/0x19c
[    7.410206]  [<ffffffff8100cb9c>] call_softirq+0x1c/0x28
[    7.410208]  [<ffffffff8100df68>] do_softirq+0x34/0x72
[    7.410209]  [<ffffffff8104799a>] irq_exit+0x3f/0x81
[    7.410211]  [<ffffffff8101f28b>] smp_apic_timer_interrupt+0x81/0x8f
[    7.410213]  [<ffffffff8100c573>] apic_timer_interrupt+0x13/0x20
[    7.410214]  <EOI>  [<ffffffff81226c7b>] ? acpi_idle_do_entry+0x3f/0x60
[    7.410218]  [<ffffffff81226cf7>] ? acpi_idle_enter_c1+0x5b/0xa4
[    7.410220]  [<ffffffff81226e11>] ? acpi_idle_enter_bm+0xd1/0x285
[    7.410222]  [<ffffffff8138afec>] ? cpuidle_idle_call+0x88/0xc0
[    7.410224]  [<ffffffff8100abc4>] ? cpu_idle+0x52/0x95
[    7.410226]  [<ffffffff815040c9>] ? start_secondary+0x179/0x17d
[    7.908334] NULL pointer dereference at 0000000000000008
[    7.924293] IP: [<ffffffff810391e7>] find_busiest_group+0x620/0x6fd
[    7.943115] PGD 0
[    7.949197] Oops: 0000 [#2] SMP
[    7.958945] last sysfs file: /sys/devices/virtual/vc/vcsa1/dev
[    7.976414] CPU 6
[    7.982496] Modules linked in: [last unloaded: scsi_wait_scan]
[    8.000043] Pid: 0, comm: swapper Tainted: G      D    2.6.31-rc6 #15 
AltixXE270
[    8.022189] RIP: 0010:[<ffffffff810391e7>]  [<ffffffff810391e7>] 
find_busiest_group+0x620/0x6fd
[    8.048288] RSP: 0018:ffffc90000c03c50  EFLAGS: 00010216
[    8.064195] RAX: 00000000000007fc RBX: 00000000000007fb RCX: 
ffffc9000080e160
[    8.085563] RDX: 00000000000007fb RSI: 0000000000000000 RDI: 
0000000000000040
[    8.106930] RBP: ffffc90000c03dc0 R08: 0000000000000000 R09: 
00000000000007fc
[    8.128296] R10: ffffc90001613980 R11: 0000000000000000 R12: 
ffffc9000080e160
[    8.149664] R13: 0000000000013980 R14: 0000000000000001 R15: 
ffffc90000c03e58
[    8.171031] FS:  0000000000000000(0000) GS:ffffc90000c00000(0000) 
knlGS:0000000000000000
[    8.195259] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[    8.212466] CR2: 0000000000000008 CR3: 0000000001001000 CR4: 
00000000000006e0
[    8.233833] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[    8.255200] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[    8.276568] Process swapper (pid: 0, threadinfo ffff88063e46e000, 
task ffff88033e49a5d0)
[    8.300794] Stack:
[    8.306824]  0000000000013980 ffffc90000000000 ffffffff00000000 
ffffc9000000e160
[    8.328608] <0> 0000000000013990 0000000000013980 ffffc90000c0de18 
ffffc90000c03e58
[    8.351794] <0> 0000000000000010 0000000000013980 0000000000013980 
ffffc90000c03e64
[    8.375553] Call Trace:
[    8.382883]  <IRQ>
[    8.389229]  [<ffffffff8103c66b>] rebalance_domains+0x173/0x513
[    8.406957]  [<ffffffff8105e1fa>] ? clocksource_read+0xa/0xc
[    8.423904]  [<ffffffff8103ca4f>] run_rebalance_domains+0x44/0xcc
[    8.442152]  [<ffffffff8101ea54>] ? apic_write+0x11/0x13
[    8.458063]  [<ffffffff81047c55>] __do_softirq+0xd2/0x19c
[    8.474229]  [<ffffffff8100cb9c>] call_softirq+0x1c/0x28
[    8.490137]  [<ffffffff8100df68>] do_softirq+0x34/0x72
[    8.505525]  [<ffffffff8104799a>] irq_exit+0x3f/0x81
[    8.520394]  [<ffffffff8101f28b>] smp_apic_timer_interrupt+0x81/0x8f
[    8.539422]  [<ffffffff8100c573>] apic_timer_interrupt+0x13/0x20
[    8.557409]  <EOI>
[    8.563755]  [<ffffffff81226f9a>] ? acpi_idle_enter_bm+0x25a/0x285
[    8.582259]  [<ffffffff81226f90>] ? acpi_idle_enter_bm+0x250/0x285
[    8.600770]  [<ffffffff8138afec>] ? cpuidle_idle_call+0x88/0xc0
[    8.618495]  [<ffffffff8100abc4>] ? cpu_idle+0x52/0x95
[    8.633885]  [<ffffffff815040c9>] ? start_secondary+0x179/0x17d
[    8.651612] Code: 09 49 c7 07 00 00 00 00 eb 51 48 8b b5 18 ff ff ff 
48 89 ca 49 89 c1 48 29 c8 48 8b 8d 10 ff ff ff 48 2b 95 38 ff ff ff 49 
29 d9 <8b> 76 08 8b 49 08 48 0f af d6 49 39 c1 49 0f 46 c1 48 0f af c1
[    8.711320] RIP  [<ffffffff810391e7>] find_busiest_group+0x620/0x6fd
[    8.730400]  RSP <ffffc90000c03c50>
[    8.740848] CR2: 0000000000000008
[    8.750780] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000008
[    8.774301] IP: [<ffffffff810391e7>] find_busiest_group+0x620/0x6fd
[    8.793096] PGD 0
 

