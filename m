Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbZDVGsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbZDVGsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 02:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbZDVGsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 02:48:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49216 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbZDVGsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 02:48:12 -0400
Date: Wed, 22 Apr 2009 02:48:09 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing: various bug fixes
In-Reply-To: <20090421094616.GA14561@elte.hu>
Message-ID: <alpine.DEB.2.00.0904220237330.9714@gandalf.stny.rr.com>
References: <20090420222257.267399830@goodmis.org> <20090421082354.GC12512@elte.hu> <20090421094616.GA14561@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 21 Apr 2009, Ingo Molnar wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Pulled, thanks guys! I've reactivated the self-tests in tip:master 
> > - lets see how it goes today.
> 
> i'm still getting a ring-buffer warning - see below. Config 
> attached.
> 
> 	Ingo
> 
> [    7.671145] calling  clear_boot_tracer+0x0/0x52 @ 1
> [    7.672145] initcall clear_boot_tracer+0x0/0x52 returned 0 after 0 usecs
> [    7.673145] calling  event_trace_self_tests_init+0x0/0x5f @ 1
> [    7.674206] Running tests on trace events:
> [    7.675143] Testing event kfree_skb: OK
> [    7.680145] Testing event kmalloc: OK
> [    7.683819] Testing event kmem_cache_alloc: OK
> [    7.686755] Testing event kmalloc_node: OK
> [    7.689744] Testing event kmem_cache_alloc_node: OK
> [    7.692711] Testing event kfree: OK
> [    7.695712] Testing event kmem_cache_free: OK
> [    7.698744] Testing event irq_handler_exit: OK
> [    7.701724] Testing event irq_handler_entry: OK
> [    7.704710] Testing event softirq_entry: OK
> [    7.707743] Testing event softirq_exit: OK
> [    7.710768] Testing event lock_acquired: OK
> [    7.713738] Testing event lock_acquire: OK
> [    7.716782] Testing event lock_release: OK
> [    7.719771] Testing event lock_contended: OK
> [    7.722740] Testing event sched_kthread_stop: OK
> [    7.726741] Testing event sched_kthread_stop_ret: OK
> [    7.729710] Testing event sched_wait_task: OK
> [    7.732706] Testing event sched_wakeup: OK
> [    7.735713] Testing event sched_wakeup_new: OK
> [    7.738727] Testing event sched_switch: OK
> [    7.741724] Testing event sched_migrate_task: OK
> [    7.745711] Testing event sched_process_free: OK
> [    7.749704] Testing event sched_process_exit: OK
> [    7.753699] Testing event sched_process_wait: OK
> [    7.757692] Testing event sched_process_fork: OK
> [    7.761711] Testing event sched_signal_send: OK
> [    7.764709] Running tests on trace event systems:
> [    7.765144] Testing event system skb: OK
> [    7.768776] Testing event system kmem: OK
> [    7.771817] Testing event system irq: OK
> [    7.774778] Testing event system lockdep: OK
> [    7.777921] Testing event system sched: OK
> [    7.780902] Running tests on all trace events:
> [    7.781148] Testing all events: OK
> [    7.787765] Running tests again, along with the function tracer
> [    7.788156] Running tests on trace events:
> [    7.789154] Testing event kfree_skb: OK
> [    7.792858] Testing event kmalloc: OK
> [    7.795853] Testing event kmem_cache_alloc: OK
> [    7.799848] Testing event kmalloc_node: OK
> [    7.802966] Testing event kmem_cache_alloc_node: OK
> [    7.805970] Testing event kfree: OK
> [    7.808942] Testing event kmem_cache_free: OK
> [    7.812935] Testing event irq_handler_exit: OK
> [    7.815850] Testing event irq_handler_entry: OK
> [    7.818877] Testing event softirq_entry: OK
> [    7.822846] Testing event softirq_exit: OK
> [    7.825895] Testing event lock_acquired: OK
> [    7.830045] Testing event lock_acquire: OK
> [    7.834025] Testing event lock_release: OK
> [    7.837920] Testing event lock_contended: OK
> [    7.841854] Testing event sched_kthread_stop: OK
> [    7.844883] Testing event sched_kthread_stop_ret: OK
> [    7.847850] Testing event sched_wait_task: OK
> [    7.851938] Testing event sched_wakeup: OK
> [    7.855960] Testing event sched_wakeup_new: OK
> [    7.858884] Testing event sched_switch: OK
> [    7.861941] Testing event sched_migrate_task: OK
> [    7.864972] Testing event sched_process_free: OK
> [    7.867853] Testing event sched_process_exit: OK
> [    7.870890] Testing event sched_process_wait: OK
> [    7.873856] Testing event sched_process_fork: OK
> [    7.876930] Testing event sched_signal_send: OK
> [    7.879853] Running tests on trace event systems:
> [    7.880154] Testing event system skb: OK
> [    7.883940] Testing event system kmem: OK
> [    7.888105] Testing event system irq: OK
> [    7.892085] Testing event system lockdep: OK
> [    7.896154] Testing event system sched: OK
> [    7.901156] Running tests on all trace events:
> [    7.903170] Testing all events: <4>------------[ cut here ]------------
> [    7.909137] WARNING: at kernel/trace/ring_buffer.c:1245 __rb_reserve_next+0x130/0x40c()
> [    7.909137] Modules linked in:
> [    7.909137] Pid: 0, comm: swapper Not tainted 2.6.30-rc2-tip #38087
> [    7.909137] Call Trace:
> [    7.909137]  <IRQ>  [<ffffffff8025a273>] warn_slowpath+0xca/0x115
> [    7.909137]  [<ffffffff802bf4fe>] ? __rb_reserve_next+0x2a5/0x40c
> [    7.909137]  [<ffffffff8021ab74>] ? native_sched_clock+0x4f/0x6a
> [    7.909137]  [<ffffffff8021ab74>] ? native_sched_clock+0x4f/0x6a
> [    7.909137]  [<ffffffff8021ab74>] ? native_sched_clock+0x4f/0x6a
> [    7.909137]  [<ffffffff802bf2c6>] ? __rb_reserve_next+0x6d/0x40c
> [    7.909137]  [<ffffffff802cb54e>] ? time_hardirqs_off+0x31/0x47
> [    7.909137]  [<ffffffff802bf389>] __rb_reserve_next+0x130/0x40c
> [    7.909137]  [<ffffffff802c00ad>] rb_reserve_next_event+0x1d3/0x31a
> [    7.909137]  [<ffffffff802c04c9>] ring_buffer_lock_reserve+0x16b/0x1cb
> [    7.909137]  [<ffffffff802c4f4b>] trace_buffer_lock_reserve+0x34/0x7e
> [    7.909137]  [<ffffffff802c542c>] trace_vbprintk+0x136/0x275
> [    7.909137]  [<ffffffff8028534f>] ? trace_hardirqs_on_caller+0x132/0x18e
> [    7.909137]  [<ffffffff80286cfb>] ? lock_acquire+0x74/0x15b
> [    7.909137]  [<ffffffff802ca54b>] __trace_bprintk+0x80/0x9d
> [    7.909137]  [<ffffffff802661bc>] ? run_timer_softirq+0x16f/0x281
> [    7.909137]  [<ffffffff802ca54b>] ? __trace_bprintk+0x80/0x9d
> [    7.909137]  [<ffffffff80283871>] ? put_lock_stats+0x44/0x5a
> [    7.909137]  [<ffffffff802c5d68>] ? tracing_record_cmdline+0x3d/0x141
> [    7.909137]  [<ffffffff802661bc>] ? run_timer_softirq+0x16f/0x281
> [    7.909137]  [<ffffffff8028259c>] ftrace_event_lock_acquire+0x6a/0x89
> [    7.909137]  [<ffffffff80266273>] ? run_timer_softirq+0x226/0x281
> [    7.909137]  [<ffffffff80286cfb>] lock_acquire+0x74/0x15b
> [    7.909137]  [<ffffffff80266273>] ? run_timer_softirq+0x226/0x281
> [    7.909137]  [<ffffffff802668c1>] ? process_timeout+0x0/0x37
> [    7.909137]  [<ffffffff80a246af>] _spin_lock_irq+0x5c/0xa5
> [    7.909137]  [<ffffffff80266273>] ? run_timer_softirq+0x226/0x281
> [    7.909137]  [<ffffffff80266273>] run_timer_softirq+0x226/0x281
> [    7.909137]  [<ffffffff802661bc>] ? run_timer_softirq+0x16f/0x281
> [    7.909137]  [<ffffffff802133d6>] ? ftrace_call+0x5/0x2b
> [    7.909137]  [<ffffffff80260bd3>] __do_softirq+0xff/0x22c
> [    7.909137]  [<ffffffff802149bc>] call_softirq+0x1c/0x30
> [    7.909137]  [<ffffffff802163df>] do_softirq+0x5f/0xdb
> [    7.909137]  [<ffffffff802601ac>] irq_exit+0x5d/0x7d
> [    7.909137]  [<ffffffff80a2a076>] do_IRQ+0xbe/0xeb
> [    7.909137]  [<ffffffff80214153>] ret_from_intr+0x0/0x16
> [    7.909137]  <EOI>  [<ffffffff802bf2a9>] ? __rb_reserve_next+0x50/0x40c
> [    7.909137]  [<ffffffff802c00ad>] ? rb_reserve_next_event+0x1d3/0x31a
> [    7.909137]  [<ffffffff802c00ad>] ? rb_reserve_next_event+0x1d3/0x31a
> [    7.909137]  [<ffffffff802c04c9>] ? ring_buffer_lock_reserve+0x16b/0x1cb
> [    7.909137]  [<ffffffff802c4f4b>] ? trace_buffer_lock_reserve+0x34/0x7e
> [    7.909137]  [<ffffffff8021b722>] ? test_ti_thread_flag+0x8/0x38
> [    7.909137]  [<ffffffff802c5d15>] ? trace_current_buffer_lock_reserve+0x36/0x4c
> [    7.909137]  [<ffffffff802d3227>] ? function_test_events_call+0x8f/0x12e
> [    7.909137]  [<ffffffff8021b841>] ? need_resched+0x36/0x54
> [    7.909137]  [<ffffffff802d3251>] ? function_test_events_call+0xb9/0x12e
> [    7.909137]  [<ffffffff802133d6>] ? ftrace_call+0x5/0x2b
> [    7.909137]  [<ffffffff8021b727>] ? test_ti_thread_flag+0xd/0x38
> [    7.909137]  [<ffffffff8021b841>] ? need_resched+0x36/0x54
> [    7.909137]  [<ffffffff8021b945>] ? poll_idle+0x41/0x64
> [    7.909137]  [<ffffffff802cb871>] ? stop_critical_timings+0x3d/0x54
> [    7.909137]  [<ffffffff802127b2>] ? cpu_idle+0xb1/0x112
> [    7.909137]  [<ffffffff809e6369>] ? rest_init+0x8d/0xa3
> [    7.909137]  [<ffffffff8108709a>] ? start_kernel+0x49c/0x4bd
> [    7.909137]  [<ffffffff81086140>] ? early_idt_handler+0x0/0x71
> [    7.909137]  [<ffffffff810862ce>] ? x86_64_start_reservations+0xb9/0xd4
> [    7.909137]  [<ffffffff81086000>] ? _sinittext+0x0/0x140
> [    7.909137]  [<ffffffff81086441>] ? x86_64_start_kernel+0x158/0x17b
> [    7.909137] ---[ end trace 3b85485e39bcb7cf ]---
> [    7.912099] OK
> [    7.913421] initcall event_trace_self_tests_init+0x0/0x5f returned 0 after 233398 usecs
> [    7.914172] calling  random32_reseed+0x0/0xce @ 1
> [    7.915159] initcall random32_reseed+0x0/0xce returned 0 after 0 usecs
> [    7.916145] calling  pci_resource_alignment_sysfs_init+0x0/0x40 @ 1
> 

I spent the entire day (and half the night) debugging this. I was fighting 
a case where the hardirqs_enabled flag in the task struct (lockdep flag) 
was mysteriously being set and cleared. I stepped through the entire 
kernel thread fork process (that was an exercise) and could not find 
anything wrong.

Sometimes it would go away with printk's sometimes it would not. This was 
driving me crazy, until I noticed that paravirt was enabled.

Turning off paravirtualization here (so far) makes everything run 
smoothly.

Thus my theory is that there's something fishy with the modifying of the 
irq enable/disable code when the system detects that it is running on bare 
hardware.

I'm too tired to look at this more. Ingo supplied a config to play with. 
You can disable VSMP too and it will still trigger the crash.

-- Steve

