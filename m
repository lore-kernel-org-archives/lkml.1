Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076AbXAYLho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbXAYLho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 06:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbXAYLhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 06:37:43 -0500
Received: from smtp4.netcabo.pt ([212.113.174.31]:30974 "EHLO
	exch01smtp11.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752076AbXAYLhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 06:37:42 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAKIluEVZmGJA/2dsb2JhbAA
Message-ID: <11401.194.65.103.1.1169725008.squirrel@www.rncbc.org>
Date: Thu, 25 Jan 2007 11:36:47 -0000 (WET)
Subject: 2.6.20-rc6-rt1 timekeeping_is_continuous question
From: "Rui Nuno Capela" <rncbc@rncbc.org>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-OriginalArrivalTime: 25 Jan 2007 11:37:38.0696 (UTC) FILETIME=[37542080:01C74075]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm having the following traces on every boot; are they of any concern, or
should I just ignore and carry on?

(machine is an Intel Core2 Duo T7200 2.0Ghz laptop)

Linux version 2.6.20-rc6-rt1.0 (root@zeta) (gcc version 4.1.2 20061115
(prerelease) (SUSE Linux)) #1 SMP PREEMPT Thu Jan 25 10:02:28 WET 2007
[...]
Total of 2 processors activated (7985.17 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
timekeeping_is_continuous(jiffies): 0
 [<c0105068>] dump_trace+0x63/0x1ec
 [<c010520b>] show_trace_log_lvl+0x1a/0x2f
 [<c0105836>] show_trace+0x12/0x14
 [<c01058c9>] dump_stack+0x16/0x18
 [<c012715f>] timekeeping_is_continuous+0x58/0x60
 [<c0135c71>] tick_check_oneshot_change+0x3e/0x111
 [<c013220b>] hrtimer_run_queues+0x40/0x26a
 [<c012680b>] run_timer_softirq+0x785/0x975
 [<c012313a>] ksoftirqd+0xfd/0x1a2
 [<c012f947>] kthread+0xb5/0xde
 [<c0104c33>] kernel_thread_helper+0x7/0x10
 =======================
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
timekeeping_is_continuous(jiffies): 0
 [<c0105068>] dump_trace+0x63/0x1ec
 [<c010520b>] show_trace_log_lvl+0x1a/0x2f
 [<c0105836>] show_trace+0x12/0x14
 [<c01058c9>] dump_stack+0x16/0x18
 [<c012715f>] timekeeping_is_continuous+0x58/0x60
 [<c0135c71>] tick_check_oneshot_change+0x3e/0x111
 [<c013220b>] hrtimer_run_queues+0x40/0x26a
 [<c012680b>] run_timer_softirq+0x785/0x975
 [<c012313a>] ksoftirqd+0xfd/0x1a2
 [<c012f947>] kthread+0xb5/0xde
 [<c0104c33>] kernel_thread_helper+0x7/0x10
 =======================
migration_cost=34
Booting paravirtualized kernel on bare hardware
[...]
Time: tsc clocksource has been installed.
timekeeping_is_continuous(tsc): 0
 [<c0105068>] dump_trace+0x63/0x1ec
 [<c010520b>] show_trace_log_lvl+0x1a/0x2f
 [<c0105836>] show_trace+0x12/0x14
 [<c01058c9>] dump_stack+0x16/0x18
 [<c012715f>] timekeeping_is_continuous+0x58/0x60
 [<c0135c71>] tick_check_oneshot_change+0x3e/0x111
 [<c013220b>] hrtimer_run_queues+0x40/0x26a
 [<c012680b>] run_timer_softirq+0x785/0x975
 [<c012313a>] ksoftirqd+0xfd/0x1a2
 [<c012f947>] kthread+0xb5/0xde
 [<c0104c33>] kernel_thread_helper+0x7/0x10
 =======================
timekeeping_is_continuous(tsc): 0
 [<c0105068>] dump_trace+0x63/0x1ec
 [<c010520b>] show_trace_log_lvl+0x1a/0x2f
 [<c0105836>] show_trace+0x12/0x14
 [<c01058c9>] dump_stack+0x16/0x18
 [<c012715f>] timekeeping_is_continuous+0x58/0x60
 [<c0135c71>] tick_check_oneshot_change+0x3e/0x111
 [<c013220b>] hrtimer_run_queues+0x40/0x26a
 [<c012680b>] run_timer_softirq+0x785/0x975
 [<c012313a>] ksoftirqd+0xfd/0x1a2
 [<c012f947>] kthread+0xb5/0xde
 [<c0104c33>] kernel_thread_helper+0x7/0x10
 =======================
Write protecting the kernel read-only data: 794k
timekeeping_is_continuous(tsc): 1
timekeeping_is_continuous(tsc): 1
 [<c0105068>] dump_trace+0x63/0x1ec
 [<c010520b>] show_trace_log_lvl+0x1a/0x2f
 [<c0105836>] show_trace+0x12/0x14
 [<c01058c9>] dump_stack+0x16/0x18
 [<c012715f>] timekeeping_is_continuous+0x58/0x60
 [<c0135c71>] tick_check_oneshot_change+0x3e/0x111
 [<c013220b>] hrtimer_run_queues+0x40/0x26a
 [<c012680b>] run_timer_softirq+0x785/0x975
 [<c012313a>] ksoftirqd+0xfd/0x1a2
 [<c012f947>] kthread+0xb5/0xde
 [<c0104c33>] kernel_thread_helper+0x7/0x10
 =======================
Switched to high resolution mode on CPU 1
 [<c0105068>] dump_trace+0x63/0x1ec
 [<c010520b>] show_trace_log_lvl+0x1a/0x2f
 [<c0105836>] show_trace+0x12/0x14
 [<c01058c9>] dump_stack+0x16/0x18
 [<c012715f>] timekeeping_is_continuous+0x58/0x60
 [<c0135c71>] tick_check_oneshot_change+0x3e/0x111
 [<c013220b>] hrtimer_run_queues+0x40/0x26a
 [<c012680b>] run_timer_softirq+0x785/0x975
 [<c012313a>] ksoftirqd+0xfd/0x1a2
 [<c012f947>] kthread+0xb5/0xde
 [<c0104c33>] kernel_thread_helper+0x7/0x10
 =======================
Switched to high resolution mode on CPU 0
[...]

Bye.
-- 
rncbc aka Rui Nuno Capela
rncbc@rncbc.org
