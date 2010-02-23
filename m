Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab0BWWEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 17:04:23 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:59842 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab0BWWEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 17:04:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=vUuEbx0Zz9KHU9GtHsg0PGsl2XO6pgMzTFzFUuwP1NuM8nBkuArYr6xtIHUT8FoFnP
         UYCMTXM8qZsra3w3AR264RpR/u/OX6Omtgh9XWvMKhQ9HZKLophKGvyVSRdZWn04ncVs
         2w58aPYB1JT09X/268JPsNTAB3dCXheRNHOWE=
Date: Tue, 23 Feb 2010 18:58:19 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>,
       John Kacur <jkacur@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [ANNOUNCE] 2.6.33-rc8-rt1
Message-ID: <20100223215819.GE15854@ghostprotocols.net>
References: <alpine.LFD.2.00.0908282326460.19335@localhost.localdomain>
 <alpine.LFD.2.00.0909152257590.8957@localhost.localdomain>
 <alpine.LFD.2.00.0909190027400.2889@localhost.localdomain>
 <alpine.LFD.2.00.0910061210400.2646@localhost.localdomain>
 <alpine.LFD.2.00.0910141115020.9428@localhost.localdomain>
 <alpine.LFD.2.00.0911061743210.12138@localhost.localdomain>
 <alpine.LFD.2.00.0911101326280.2725@localhost.localdomain>
 <alpine.LFD.2.00.1001212102220.2906@localhost.localdomain>
 <alpine.LFD.2.00.1002181748460.2811@localhost.localdomain>
 <alpine.LFD.2.00.1002212322450.2811@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002212322450.2811@localhost.localdomain>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Feb 22, 2010 at 12:24:07AM +0100, Thomas Gleixner escreveu:
> We are pleased to announce the next update to our new preempt-rt
> series.
> 
>     - Forward to 2.6.33-rc8
> 
> Finally I managed to get that beast tamed. 

mica.ghostprotocols.net login: BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<(null)>] (null)
PGD 37ea1067 PUD bae52067 PMD 0 
Oops: 0010 [#1] PREEMPT SMP 
last sysfs file: /sys/class/misc/autofs/dev
CPU 0 
Pid: 7341, comm: perf Not tainted 2.6.33-rc8-rt #1 0KN122/PowerEdge 1900
RIP: 0010:[<0000000000000000>]  [<(null)>] (null)
RSP: 0018:ffff8800bae01990  EFLAGS: 00010046
RAX: ffffffff8140a060 RBX: ffff88012f0206c0 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffff88012f0206c0 RDI: ffff8800282d0300
RBP: ffff8800bae019b8 R08: ffff8800282c3e68 R09: ffff8800bac16238
R10: ffffffff81600000 R11: ffff8800bae01b38 R12: 0000000000000001
R13: ffff8800282d0300 R14: ffff8800282d0300 R15: 0000000000000001
FS:  00007f862804b6e0(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 00000000baf13000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process perf (pid: 7341, threadinfo ffff8800bae00000, task ffff880037f580c0)
Stack:
 ffffffff8102caee ffff8800282d0300 ffff88012f0206c0 ffff8800282d0300
<0> ffff8800282d0300 ffff8800bae019d8 ffffffff8102cb29 ffff8800bac16238
<0> 0000000000000003 ffff8800bae01a38 ffffffff8103aeb3 ffff8800bae019f8
Call Trace:
 [<ffffffff8102caee>] ? enqueue_task+0x45/0x55
 [<ffffffff8102cb29>] activate_task+0x2b/0x33
 [<ffffffff8103aeb3>] try_to_wake_up+0x1cc/0x33c
 [<ffffffff81330d37>] ? preempt_schedule_irq+0x6a/0x76
 [<ffffffff8103b072>] wake_up_process_mutex+0x15/0x17
 [<ffffffff8106ac2e>] wakeup_next_waiter+0x85/0x15e
 [<ffffffff813319e5>] rt_spin_lock_slowunlock+0x3e/0x5c
 [<ffffffff8106a302>] rt_spin_lock_fastunlock+0x35/0x37
 [<ffffffff81331f67>] rt_spin_unlock+0x10/0x12
 [<ffffffff8105a5a7>] remove_wait_queue+0x49/0x4e
 [<ffffffff810f0927>] free_poll_entry+0x19/0x25
 [<ffffffff810f095d>] poll_freewait+0x2a/0x6b
 [<ffffffff810f0c81>] do_sys_poll+0x2e3/0x3a3
 [<ffffffff810f1678>] ? __pollwait+0x0/0xd7
 [<ffffffff810f174f>] ? pollwake+0x0/0x5b
 [<ffffffff810f174f>] ? pollwake+0x0/0x5b
 [<ffffffff810f174f>] ? pollwake+0x0/0x5b
 [<ffffffff810f174f>] ? pollwake+0x0/0x5b
 [<ffffffff810308c7>] ? rcu_read_unlock+0x9/0xb
 [<ffffffff8103091f>] ? cpuacct_charge+0x56/0x5f
 [<ffffffff81001d1e>] ? __switch_to+0xc2/0x1ca
 [<ffffffff81332239>] ? _raw_spin_unlock+0x23/0x2e
 [<ffffffff810351c3>] ? finish_task_switch+0x53/0xb8
 [<ffffffff81330caa>] ? __schedule+0x7bb/0x7de
 [<ffffffff810308c7>] ? rcu_read_unlock+0x9/0xb
 [<ffffffff810308c7>] ? rcu_read_unlock+0x9/0xb
 [<ffffffff8103091f>] ? cpuacct_charge+0x56/0x5f
 [<ffffffff81001d1e>] ? __switch_to+0xc2/0x1ca
 [<ffffffff81031201>] ? __dequeue_entity+0x2c/0x35
 [<ffffffff810445bd>] ? timespec_add_safe+0x37/0x64
 [<ffffffff810f0888>] ? poll_select_set_timeout+0x5c/0x7f
 [<ffffffff810f0d93>] sys_poll+0x52/0xb1
 [<ffffffff81002b2b>] system_call_fastpath+0x16/0x1b
Code:  Bad RIP value.
RIP  [<(null)>] (null)
 RSP <ffff8800bae01990>
CR2: 0000000000000000
---[ end trace 55781d66e9d64e79 ]---


Workload (screens were frozen at that time):

make -j128 allyesconfig

[root@mica rt-tests]# perf record -a -f ./cyclictest -a -t -n -p99 -i100 -d50
policy: fifo: loadavg: 0.58 0.19 0.09 1/238 7343          

T: 0 ( 5502) P:99 I:100 C:1305514 Min:      2 Act:    4 Avg:    3 Max:  27
T: 1 ( 5503) P:98 I:150 C: 870343 Min:      3 Act:    3 Avg:    4 Max:  25
T: 2 ( 5504) P:97 I:200 C: 652757 Min:      3 Act:    4 Avg:    3 Max:  27
T: 3 ( 5505) P:96 I:250 C: 522206 Min:      3 Act:    5 Avg:    4 Max:  25


[root@mica rt-tests]# perf top
--------------------------------------------------------------------------
   PerfTop:    2799 irqs/sec  kernel:99.4% [1000Hz cycles],  (all, 4 CPUs)
--------------------------------------------------------------------------

samples  pcnt function                    DSO
_______ _____ ___________________________ ________________________________________

9924.00 50.6% need_resched                /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
8276.00 42.2% test_ti_thread_flag         /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
 116.00  0.6% _raw_spin_lock_irqsave      /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
 102.00  0.5% cpupri_set                  /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
  90.00  0.5% sha1_block_data_order       /lib64/libcrypto.so.0.9.8b                                             
  77.00  0.4% __schedule                  /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
  63.00  0.3% read_tsc                    /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
  58.00  0.3% get_next_timer_interrupt    /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
  57.00  0.3% apic_timer_interrupt        /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
  45.00  0.2% native_sched_clock          /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
  44.00  0.2% _raw_spin_lock              /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
  42.00  0.2% __unlazy_fpu                /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
  40.00  0.2% system_call                 /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
  37.00  0.2% sched_clock_local           /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
  30.00  0.2% __switch_to                 /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
  27.00  0.1% rt_spin_lock_fastlock       /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
  26.00  0.1% rt_spin_lock_fastunlock     /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
  24.00  0.1% _raw_spin_unlock_irqrestore /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
  22.00  0.1% dequeue_rt_stack            /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
  22.00  0.1% timekeeping_get_ns          /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
  20.00  0.1% rcu_sched_qs                /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
  20.00  0.1% switch_mm                   /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
  19.00  0.1% mmdrop_delayed              /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
  19.00  0.1% sched_clock_cpu             /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
  17.00  0.1% __cycles_2_ns               /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
  16.00  0.1% tick_nohz_stop_sched_tick   /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
  13.00  0.1% try_to_wake_up              /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
  13.00  0.1% __math_state_restore        /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
  13.00  0.1% __GI_clock_gettime          /lib64/librt-2.5.so                                                    
  11.00  0.1% _raw_spin_lock_irq          /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
  10.00  0.1% timerthread                 /home/acme/git/rt-tests/cyclictest                                     
   9.00  0.0% cpumask_clear_cpu           /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
   9.00  0.0% __GI_vfprintf               /lib64/libc-2.5.so                                                     
   8.00  0.0% finish_task_switch          /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
   8.00  0.0% hrtimer_interrupt           /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
   8.00  0.0% ktime_get                   /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
   8.00  0.0% rb_erase                    /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
   8.00  0.0% test_ti_thread_flag         /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
   7.00  0.0% pick_next_task              /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
   7.00  0.0% clock_nanosleep             /lib64/librt-2.5.so                                                    
   6.00  0.0% __remove_hrtimer            /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
   6.00  0.0% cpumask_set_cpu             /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
   6.00  0.0% __rcu_read_unlock           /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
   5.00  0.0% megasas_clear_intr_xscale   /lib/modules/2.6.33-rc8-rt/kernel/drivers/scsi/megaraid/megaraid_sas.ko
   5.00  0.0% native_apic_mem_write       /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
   5.00  0.0% __hrtimer_start_range_ns    /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
   5.00  0.0% rb_insert_color             /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
   5.00  0.0% update_curr_rt              /lib/modules/2.6.33-rc8-rt/build/vmlinux                               
   5.00  0.0% hrtimer_nanosleep           /lib/modules/2.6.33-rc8-rt/build/vmlinux                               

- Arnaldo
