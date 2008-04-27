Return-Path: <linux-kernel-owner+w=401wt.eu-S1759390AbYD0Ggw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759390AbYD0Ggw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 02:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbYD0Ggp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 02:36:45 -0400
Received: from colobus.isomerica.net ([216.93.242.10]:40540 "EHLO
	colobus.isomerica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbYD0Ggn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 02:36:43 -0400
Message-ID: <48141EFA.6080700@isomerica.net>
Date: Sun, 27 Apr 2008 02:36:42 -0400
From: Dan Noe <dpn@isomerica.net>
Reply-To: dpn@isomerica.net
Organization: isomerica.net
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: NULL dereference OOPS on SysRq-w
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've experienced the following on a build done today from Linus's 
linux-2.6 tree.  After a fresh boot I do "echo "w" > 
/proc/sysrq_trigger" and I get the OOPS, every time.  I looked at the 
sched_debug code but I admit I was lost.  Not sure why sched.c includes 
sched_debug.c.

Cheers,
Dan

Via netconsole:

SysRq : Show Blocked State
   task                        PC stack   pid father
Sched Debug Version: v0.07, 2.6.25 #12
now at 275558.648467 msecs
   .sysctl_sched_latency                    : 40.000000
   .sysctl_sched_min_granularity            : 8.000000
   .sysctl_sched_wakeup_granularity         : 20.000000
   .sysctl_sched_child_runs_first           : 0.000001
   .sysctl_sched_features                   : 895

cpu#0, 2194.491 MHz
   .nr_running                    : 3
   .load                          : 3145728
   .nr_switches                   : 13171
   .nr_load_updates               : 6476
   .nr_uninterruptible            : -94
   .jiffies                       : 4294961186
   .next_balance                  : 4294.961046
   .curr->pid                     : 3078
   .clock                         : 101239.537371
   .idle_clock                    : 0.000000
   .prev_clock_raw                : 296931.974646
   .clock_warps                   : 0
   .clock_overflows               : 12189
   .clock_underflows              : 4657
   .clock_deep_idle_events        : 4
   .clock_max_delta               : 499.306905
   .cpu_load[0]                   : 0
   .cpu_load[1]                   : 96
   .cpu_load[2]                   : 14028
   .cpu_load[3]                   : 62524
   .cpu_load[4]                   : 91704

cfs_rq[0]:
   .exec_clock                    : 400.314576
   .MIN_vruntime                  : 17300.019734
   .min_vruntime                  : 2099676.053218
   .max_vruntime                  : 17300.019734
   .spread                        : 0.000000
   .spread0                       : 0.000000
   .nr_running                    : 1
   .load                          : 1024
   .bkl_count                     : 353
   .nr_spread_over                : 44
   .shares                        : 1024

cfs_rq[0]:
   .exec_clock                    : 1.281845
   .MIN_vruntime                  : 0.000001
   .min_vruntime                  : 2099676.053218
   .max_vruntime                  : 0.000001
   .spread                        : 0.000000
   .spread0                       : 0.000000
   .nr_running                    : 0
   .load                          : 0
   .bkl_count                     : 353
   .nr_spread_over                : 2
   .shares                        : 0

cfs_rq[0]:
   .exec_clock                    : 13.306219
   .MIN_vruntime                  : 0.000001
   .min_vruntime                  : 2099676.053218
   .max_vruntime                  : 0.000001
   .spread                        : 0.000000
   .spread0                       : 0.000000
   .nr_running                    : 0
   .load                          : 0
   .bkl_count                     : 353
   .nr_spread_over                : 3
   .shares                        : 0

cfs_rq[0]:
   .exec_clock                    : 0.380305
   .MIN_vruntime                  : 0.000001
   .min_vruntime                  : 2099676.053218
   .max_vruntime                  : 0.000001
   .spread                        : 0.000000
   .spread0                       : 0.000000
   .nr_running                    : 0
   .load                          : 0
   .bkl_count                     : 353
   .nr_spread_over                : 1
   .shares                        : 0

cfs_rq[0]:
   .exec_clock                    : 6.341858
   .MIN_vruntime                  : 0.000001
   .min_vruntime                  : 2099676.053218
   .max_vruntime                  : 0.000001
   .spread                        : 0.000000
   .spread0                       : 0.000000
   .nr_running                    : 0
   .load                          : 0
   .bkl_count                     : 353
   .nr_spread_over                : 1
   .shares                        : 0

cfs_rq[0]:
   .exec_clock                    : 6.341858
   .MIN_vruntime                  : 0.000001
   .min_vruntime                  : 2099676.053218
   .max_vruntime                  : 0.000001
   .spread                        : 0.000000
   .spread0                       : 0.000000
   .nr_running                    : 0
   .load                          : 0
   .bkl_count                     : 353
   .nr_spread_over                : 16
   .shares                        : 1024

cfs_rq[0]:
   .exec_clock                    : 12850.277817
   .MIN_vruntime                  : 69710.961030
   .min_vruntime                  : 2099676.053218
   .max_vruntime                  : 69751.539537
   .spread                        : 40.578507
   .spread0                       : 0.000000
   .nr_running                    : 3
   .load                          : 5169  .bkl_count 
  : 353  .nr_spread_over                : 2038  .shares 
        : 2048BUG: unable to handle kernel NULL pointer dereference at 
0000000000000018IP: [<ffffffff802b9ab6>] seq_printf+0x2e/0xa7
PGD 7dd05067 PUD 7e0fb067 PMD 0 Oops: 0000 [1] PREEMPT SMP 
DEBUG_PAGEALLOCCPU 0
Modules linked in: netconsole nfsd lockd nfs_acl auth_rpcgss sunrpc 
exportfs ac battery ipv6 dm_snapshot dm_mirror dm_log dm_mod eeprom 
coretemp loop parport_pc parport snd_hda_intel rtc iTCO_wdt 
iTCO_vendor_support i2c_i801 i2c_core snd_pc
m snd_timer snd soundcore snd_page_alloc button intel_agp evdev ext3 jbd 
mbcache sd_mod ata_generic ata_piix pata_acpi libata scsi_mod dock 
ehci_hcd uhci_hcd ide_pci_generic piix ide_core r8169 usbcore thermal 
processor fan
Pid: 3078, comm: zsh Not tainted 2.6.25 #12
RIP: 0010:[<ffffffff802b9ab6>]  [<ffffffff802b9ab6>] seq_printf+0x2e/0xa7
RSP: 0018:ffff81007e387c68  EFLAGS: 00010092
RAX: ffffffff804eec79 RBX: 0000000000000000 RCX: ffffee71806668f8
RDX: ffff810001091f80 RSI: ffffffff804eec79 RDI: 0000000000000000
RBP: ffff81007e387d48 R08: 0000000000000002 R09: ffffffff8024fb76
R10: 00000000d59bb5d6 R11: ffff81007e387968 R12: 0000000000000000
R13: 0000000000000000 R14: ffff810001091740 R15: 0000000000000007
FS:  00007f7dce0896e0(0000) GS:ffffffff8057a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000018 CR3: 000000007e3ed000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process zsh (pid: 3078, threadinfo ffff81007e386000, task ffff81007e090000)
Stack:  0000000000000002 ffffffff8024fb76 ffff81007e090090 ffff81007e090000
  ffffffff8022dc31 0000000000000046 ffff810001091f80 ffffee71806668f8
  0000000000000002 ffffffff8024fb76 0000000000000096 0000000000000000
Call Trace:
  [<ffffffff8024fb76>] ? up+0xf/0x39
  [<ffffffff8022dc31>] ? print_cfs_rq+0x130/0x465
  [<ffffffff8024fb76>] ? up+0xf/0x39
  [<ffffffff8041dfa5>] ? _spin_unlock_irqrestore+0x66/0x74
  [<ffffffff8022df57>] ? print_cfs_rq+0x456/0x465
  [<ffffffff8022e920>] sched_debug_show+0x9ba/0xd28
  [<ffffffff8022f978>] ? cpu_clock+0xf0/0xff
  [<ffffffff802745fe>] ? get_timestamp+0x9/0xf
  [<ffffffff80274628>] ? touch_softlockup_watchdog+0x24/0x2d
  [<ffffffff802319ec>] show_state_filter+0x8b/0xaa
  [<ffffffff80375848>] sysrq_handle_showstate_blocked+0xe/0x10
  [<ffffffff803757a3>] __handle_sysrq+0x9e/0x135
  [<ffffffff802e2544>] ? write_sysrq_trigger+0x0/0x3a
  [<ffffffff802e2574>] write_sysrq_trigger+0x30/0x3a
  [<ffffffff802dc6b2>] proc_reg_write+0x8a/0xa7
  [<ffffffff802a0118>] vfs_write+0xa7/0xe1
  [<ffffffff802a020c>] sys_write+0x47/0x6d
  [<ffffffff8020c3ab>] system_call_after_swapgs+0x7b/0x80
Code: f0 48 89 e5 53 48 89 fb 48 81 ec d8 00 00 00 48 89 95 50 ff ff ff 
48 89 8d 58 ff ff ff 4c 89 85 60 ff ff ff 4c 89 8d 68 ff ff ff <48> 8b 
7f 18 48 3b 7b 08 73 5a 48 8b 73 08 48 8d 55 10 48 8d 8d
RIP  [<ffffffff802b9ab6>] seq_printf+0x2e/0xa7
  RSP <ffff81007e387c68>
CR2: 0000000000000018
---[ end trace ffd04a8c8a72749a ]---
note: zsh[3078] exited with preempt_count 2
BUG: sleeping function called from invalid context at kernel/rwsem.c:21
in_atomic():1, irqs_disabled():1
INFO: lockdep is turned off.
irq event stamp: 136430
hardirqs last  enabled at (136429): [<ffffffff8041d4c0>] 
trace_hardirqs_on_thunk+0x35/0x3a
hardirqs last disabled at (136430): [<ffffffff8041de72>] 
_spin_lock_irqsave+0x19/0x73
softirqs last  enabled at (131948): [<ffffffff8023dcec>] 
__do_softirq+0x9e/0xa7
softirqs last disabled at (131911): [<ffffffff8020d68c>] 
call_softirq+0x1c/0x28
Pid: 3078, comm: zsh Tainted: G      D  2.6.25 #12
Call Trace:
  [<ffffffff80255f3d>] ? print_irqtrace_events+0x110/0x114
  [<ffffffff8022f7fc>] __might_sleep+0xda/0xdc
  [<ffffffff8041c7f6>] down_read+0x20/0x68
  [<ffffffff802681eb>] acct_collect+0x42/0x1a7
  [<ffffffff8023ba57>] do_exit+0x205/0x713
  [<ffffffff803723e2>] ? do_unblank_screen+0x29/0x125
  [<ffffffff8020d90d>] oops_begin+0x0/0x8f
  [<ffffffff80223c64>] do_page_fault+0x69f/0x757
  [<ffffffff8041e2ed>] error_exit+0x0/0xa9
  [<ffffffff8024fb76>] ? up+0xf/0x39
  [<ffffffff802b9ab6>] ? seq_printf+0x2e/0xa7
  [<ffffffff8024fb76>] ? up+0xf/0x39
  [<ffffffff8022dc31>] ? print_cfs_rq+0x130/0x465
  [<ffffffff8024fb76>] ? up+0xf/0x39
  [<ffffffff8041dfa5>] ? _spin_unlock_irqrestore+0x66/0x74
  [<ffffffff8022df57>] ? print_cfs_rq+0x456/0x465
  [<ffffffff8022e920>] ? sched_debug_show+0x9ba/0xd28
  [<ffffffff8022f978>] ? cpu_clock+0xf0/0xff
  [<ffffffff802745fe>] ? get_timestamp+0x9/0xf
  [<ffffffff80274628>] ? touch_softlockup_watchdog+0x24/0x2d
  [<ffffffff802319ec>] ? show_state_filter+0x8b/0xaa
  [<ffffffff80375848>] ? sysrq_handle_showstate_blocked+0xe/0x10
  [<ffffffff803757a3>] ? __handle_sysrq+0x9e/0x135
  [<ffffffff802e2544>] ? write_sysrq_trigger+0x0/0x3a
  [<ffffffff802e2574>] ? write_sysrq_trigger+0x30/0x3a
  [<ffffffff802dc6b2>] ? proc_reg_write+0x8a/0xa7
  [<ffffffff802a0118>] ? vfs_write+0xa7/0xe1
  [<ffffffff802a020c>] ? sys_write+0x47/0x6d
  [<ffffffff8020c3ab>] ? system_call_after_swapgs+0x7b/0x80



-- 
                     /--------------- - -  -  -   -   -
                     |  Dan Noe
                     |  http://isomerica.net/~dpn/
