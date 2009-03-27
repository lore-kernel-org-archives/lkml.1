Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbZC0Ofk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbZC0Ofk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 10:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758800AbZC0Oe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 10:34:26 -0400
Received: from main.gmane.org ([80.91.229.2]:46778 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758773AbZC0OeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 10:34:22 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Philippe Reynes <philippe.reynes@isismpp.fr>
Subject: Re: [Announce] 2.6.29-rt1
Date: Fri, 27 Mar 2009 14:34:08 +0000 (UTC)
Message-ID: <gqio50$c27$3@ger.gmane.org>
References: <49b7c2350903260354p6eaf50ebo87985dcfb8d48ba0@mail.gmail.com>
	<gqi6oc$1s3$1@ger.gmane.org> <gqic7t$c27$1@ger.gmane.org>
	<alpine.LFD.2.00.0903271236270.3397@localhost.localdomain>
	<gqilj9$c27$2@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: extranet.isismpp.fr
User-Agent: Pan/0.133 (House of Butterflies)
Cc: linux-rt-users@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

may be this trace is better ....


    sirq-timer/0-4     [000]    97.737264: finish_task_switch <-__schedule
    sirq-timer/0-4     [000]    97.737267: run_timer_softirq <-ksoftirqd
    sirq-timer/0-4     [000]    97.737269: printk_tick <-run_timer_softirq
    sirq-timer/0-4     [000]    97.737271: hrtimer_run_pending <-
run_timer_softirq
    sirq-timer/0-4     [000]    97.737273: rt_spin_lock <-
run_timer_softirq
    sirq-timer/0-4     [000]    97.737275: __wake_up <-run_timer_softirq
    sirq-timer/0-4     [000]    97.737277: rt_spin_lock <-__wake_up
         hwclock-1740  [000]   121.298710: free_page_and_swap_cache <-
unmap_vmas
         hwclock-1740  [000]   121.298712: put_page <-
free_page_and_swap_cache
         hwclock-1740  [000]   121.298713: vm_normal_page <-unmap_vmas
         hwclock-1740  [000]   121.298715: page_remove_rmap <-unmap_vmas
         hwclock-1740  [000]   121.298716: free_page_and_swap_cache <-
unmap_vmas
         hwclock-1740  [000]   121.298718: put_page <-
free_page_and_swap_cache
         hwclock-1740  [000]   121.298719: vm_normal_page <-unmap_vmas
         hwclock-1740  [000]   121.298721: page_remove_rmap <-unmap_vmas
         hwclock-1740  [000]   121.298722: free_page_and_swap_cache <-
unmap_vmas
         hwclock-1740  [000]   121.298724: put_page <-
free_page_and_swap_cache
         hwclock-1740  [000]   121.298726: vm_normal_page <-unmap_vmas
         hwclock-1740  [000]   121.298727: page_remove_rmap <-unmap_vmas
         hwclock-1740  [000]   121.298729: free_page_and_swap_cache <-
unmap_vmas
         hwclock-1740  [000]   121.298730: put_page <-
free_page_and_swap_cache
         hwclock-1740  [000]   121.298732: vm_normal_page <-unmap_vmas
         hwclock-1740  [000]   121.298733: page_remove_rmap <-unmap_vmas
         hwclock-1740  [000]   121.298735: free_page_and_swap_cache <-
unmap_vmas
         hwclock-1740  [000]   121.298736: put_page <-
free_page_and_swap_cache
         hwclock-1740  [000]   121.298738: vm_normal_page <-unmap_vmas
         hwclock-1740  [000]   121.298739: page_remove_rmap <-unmap_vmas
         hwclock-1740  [000]   121.298741: free_page_and_swap_cache <-
unmap_vmas
         hwclock-1740  [000]   121.298742: put_page <-
free_page_and_swap_cache
         hwclock-1740  [000]   121.298744: vm_normal_page <-unmap_vmas
         hwclock-1740  [000]   121.298746: page_remove_rmap <-unmap_vmas
         hwclock-1740  [000]   121.298747: free_page_and_swap_cache <-
unmap_vmas
         hwclock-1740  [000]   121.298749: put_page <-
free_page_and_swap_cache
         hwclock-1740  [000]   121.298750: vm_normal_page <-unmap_vmas
         hwclock-1740  [000]   121.298752: page_remove_rmap <-unmap_vmas
         hwclock-1740  [000]   121.298753: free_page_and_swap_cache <-
unmap_vmas
         hwclock-1740  [000]   121.298755: put_page <-
free_page_and_swap_cache
         hwclock-1740  [000]   121.298756: vm_normal_page <-unmap_vmas
         hwclock-1740  [000]   121.298758: page_remove_rmap <-unmap_vmas
         hwclock-1740  [000]   121.298759: free_page_and_swap_cache <-
unmap_vmas
         hwclock-1740  [000]   121.298761: put_page <-
free_page_and_swap_cache
         hwclock-1740  [000]   121.298762: vm_normal_page <-unmap_vmas
         hwclock-1740  [000]   121.298764: page_remove_rmap <-unmap_vmas
         hwclock-1740  [000]   121.298766: free_page_and_swap_cache <-
unmap_vmas
         hwclock-1740  [000]   121.298767: put_page <-
free_page_and_swap_cache
         hwclock-1740  [000]   121.298769: vm_normal_page <-unmap_vmas
         hwclock-1740  [000]   121.298770: page_remove_rmap <-unmap_vmas
         hwclock-1740  [000]   121.298772: free_page_and_swap_cache <-
unmap_vmas
         hwclock-1740  [000]   121.298773: put_page <-
free_page_and_swap_cache
         hwclock-1740  [000]   121.298775: vm_normal_page <-unmap_vmas
         hwclock-1740  [000]   121.298776: page_remove_rmap <-unmap_vmas
         hwclock-1740  [000]   121.298778: free_page_and_swap_cache <-
unmap_vmas
         hwclock-1740  [000]   121.298779: put_page <-
free_page_and_swap_cache
         hwclock-1740  [000]   12PHY: 0:0a - Link is Up1.298781: 
vm_normal_page <-unmap_vmas
         hwclock-1740  [000]   121.298782: page_remove_rm - 1000/Fullap <-
unmap_vmas

         hwclock-1740  [000]   121.298784: free_page_and_swap_cache <-
unmap_vmas
         hwclock-1740  [000]   121.298785: put_page <-
free_page_and_swap_cache
         hwclock-1740  [000]   121.298787: vm_normal_page <-unmap_vmas
         hwclock-1740  [000]   121.298789: page_remove_rmap <-unmap_vmas
         hwclock-1740  [000]   121.298790: free_page_and_swap_cache <-
unmap_vmas
         hwclock-1740  [000]   121.298792: put_page <-
free_page_and_swap_cache
         hwclock-1740  [000]   121.298793: vm_normal_page <-unmap_vmas
         hwclock-1740  [000]   121.298795: page_remove_rmap <-unmap_vmas
         hwclock-1740  [000]   121.2987Oops: Exception in kernel mode, 
sig: 5 [#1]
PREEMPT MPC837x RR605
Modules linked in:
NIP: c0095550 LR: c00956f0 CTR: c00954d8
REGS: df89fe00 TRAP: 0700   Not tainted  (2.6.29-rt1)
MSR: 00029032 <EE,ME,CE,IR,DR>  CR: 24044028  XER: 20000000
TASK = df89da00[15] 'events/0' THREAD: df89e000
GPR00: 00000001 df89feb0 df89da00 df80ae00 c0b821a0 00000000 00000000 
df89fee8 
GPR08: 00000000 003821a0 dc10d918 c0800000 777db820 00000000 1ffcd000 
00000000 
GPR16: 1ffc300e 1ffc6f20 00000000 1ffc8600 c0471623 c047165a c0560000 
00000002 
GPR24: df89fee8 df80ae00 00100100 00200200 00000000 df816828 df80ae00 
df89feb0 
NIP [c0095550] free_block+0x84/0x160
LR [c00956f0] drain_array+0xc4/0x194
Call Trace:
[df89feb0] [c0013d88] ftrace_call+0x4/0x48 (unreliable)
[df89fee0] [c00956f0] drain_array+0xc4/0x194
[df89ff20] [c0097374] cache_reap+0x68/0x148
[df89ff50] [c003aa8c] run_workqueue+0x14c/0x1b8
[df89ff90] [c003b51c] worker_thread+0xfc/0x10c
[df89ffd0] [c003fd00] kthread+0x5c/0x8c
[df89fff0] [c00131c0] kernel_thread+0x4c/0x68
Instruction dump:
815d0000 8176b248 3d2a4000 5529c9f4 7c09582e 7c895a14 70054000 41a20008 
8084000c 80040000 68000080 5400cffe <0f000000> 8084001c 80f9004c 81640004 
---[ end trace 8fa1185748d94493 ]---
------------[ cut here ]------------
kernel BUG at kernel/rtmutex.c:806!
Oops: Exception in kernel mode, sig: 5 [#2]
PREEMPT MPC837x RR605
Modules linked in:
NIP: c03f3b64 LR: c03f409c CTR: c03f3af4
REGS: df89fab0 TRAP: 0700   Tainted: G      D     (2.6.29-rt1)
MSR: 00021032 <ME,CE,IR,DR>  CR: 84044048  XER: 20000000
TASK = df89da00[15] 'events/0' THREAD: df89e000
GPR00: 00000001 df89fb60 df89da00 c052bb7c df87b580 00001032 00017fff 
c051cc6c 
GPR08: df89da00 00000001 df89da00 df89e000 7e6ec050 00000000 1ffcd000 
00000000 
GPR16: 1ffc300e 1ffc6f20 00000000 1ffc8600 c0471623 c0028780 c055e748 
c0520000 
GPR24: c0560000 00200200 c0023edc df87b580 c052bb7c df89fc08 df85a240 
df89fb60 
NIP [c03f3b64] rt_spin_lock_slowlock+0x7c/0x284
LR [c03f409c] rt_spin_lock+0x7c/0x84
Call Trace:
[df89fb60] [00001032] 0x1032 (unreliable)
[df89fbd0] [c03f409c] rt_spin_lock+0x7c/0x84
[df89fbe0] [c0094e40] _slab_irq_disable+0x34/0x44
[df89fc00] [c009531c] kmem_cache_free+0x38/0x15c
[df89fc30] [c0023edc] __cleanup_sighand+0x4c/0x54
[df89fc40] [c0029114] release_task+0x2d0/0x3a8
[df89fc80] [c002a7f8] do_exit+0x65c/0x710
[df89fcc0] [c0010e18] kernel_bad_stack+0x0/0x54
[df89fce0] [c0011010] _exception+0x68/0x174
[df89fdd0] [c0011838] program_check_exception+0x520/0x530
[df89fdf0] [c00139e8] ret_from_except_full+0x0/0x4c
--- Exception: 700 at free_block+0x84/0x160
    LR = drain_array+0xc4/0x194
[df89feb0] [c0013d88] ftrace_call+0x4/0x48 (unreliable)
[df89fee0] [c00956f0] drain_array+0xc4/0x194
[df89ff20] [c0097374] cache_reap+0x68/0x148
[df89ff50] [c003aa8c] run_workqueue+0x14c/0x1b8
[df89ff90] [c003b51c] worker_thread+0xfc/0x10c
[df89ffd0] [c003fd00] kthread+0x5c/0x8c
[df89fff0] [c00131c0] kernel_thread+0x4c/0x68
Instruction dump:
2f800000 40be0018 39230008 907c0004 907c0000 91290004 91230008 801c0010 
5400003a 7c001278 7c000034 5400d97e <0f000000> 81420000 69490002 3129ffff 
---[ end trace 8fa1185748d94494 ]---
Fixing recursive fault but reboot is needed!
96: free_page_and_swap_cache <-unmap_vmas
         hwclock-1740  [000]   121.298798: put_page <-
free_page_and_swap_cache
         hwclock-1740  [000]   121.298799: vm_normal_page <-unmap_vmas
         hwclock-1740  [000]   121.298801: page_remove_rmap <-unmap_vmas
         hwclock-1740  [000]   121.298802: free_page_and_swap_cache <-
unmap_vmas
         hwclock-1740  [000]   121.298804: put_page <-
free_page_and_swap_cache
         hwclock-1740  [000]   121.298805: vm_normal_page <-unmap_vmas
         hwclock-1740  [000]   121.298807: page_remove_rmap <-unmap_vmas
         hwclock-1740  [000]   121.298809: free_page_and_swap_cache <-
unmap_vmas
         hwclock-1740  [000]   121.298810: put_page <-
free_page_and_swap_cache
         hwclock-1740  [000]   121.298812: vm_normal_page <-unmap_vmas
         hwclock-1740  [000]   121.298813: page_remove_rmap <-unmap_vmas
         hwclock-1740  [000]   121.298815: free_page_and_swap_cache <-
unmap_vmas
         hwclock-1740  [000]   121.298816: put_page <-
free_page_and_swap_cache
         hwclock-1740  [000]   121.298818: vm_normal_page <-unmap_vmas
         hwclock-1740  [000]   121.298819: page_remove_rmap <-unmap_vmas
         hwclock-1740  [000]   121.298821: free_page_and_swap_cache <-
unmap_vmas
         hwclock-1740  [000]   121.298822: put_page <-
free_page_and_swap_cache
         hwclock-1740  [000]   121.298824: vm_normal_page <-unmap_vmas
         hwclock-1740  [000]   121.298825: page_remove_rmap <-unmap_vmas
         hwclock-1740  [000]   121.298827: free_page_and_swap_cache <-
unmap_vmas
         hwclock-1740  [000]   121.298828: put_page <-
free_page_and_swap_cache
         hwclock-1740  [000]   121.298830: vm_normal_page <-unmap_vmas
         hwclock-1740  [000]   121.298832: page_remove_rmap <-unmap_vmas
         hwclock-1740  [000]   121.298833: free_page_and_swap_cache <-
unmap_vmas
         hwclock-1740  [000]   121.298835: put_page <-
free_page_and_swap_cache
         hwclock-1740  [000]   121.298836: vm_normal_page <-unmap_vmas
         hwclock-1740  [000]   121.298838: page_remove_rmap <-unmap_vmas
         hwclock-1740  [000]   121.298839: free_page_and_swap_cache <-
unmap_vmas
         hwclock-1740  [000]   121.298841: put_page <-
free_page_and_swap_cache
         hwclock-1740  [000]   121.298842: vm_normal_page <-unmap_vmas
         hwclock-1740  [000]   121.298844: page_remove_rmap <-unmap_vmas
         hwclock-1740  [000]   121.298845: free_page_and_swap_cache <-
unmap_vmas
         hwclock-1740  [000]   121.298847: put_page <-
free_page_and_swap_cache
         hwclock-1740  [000]   121.298849: vm_normal_page <-unmap_vmas
         hwclock-1740  [000]   121.298850: page_remove_rmap <-unmap_vmas
         hwclock-1740  [000]   121.298852: free_page_and_swap_cache <-
unmap_vmas
         hwclock-1740  [000]   121.298853: put_page <-
free_page_and_swap_cache
         hwclock-1740  [000]   121.298855: vm_normal_page <-unmap_vmas
         hwclock-1740  [000]   121.298856: page_remove_rmap <-unmap_vmas
         hwclock-1740  [000]   121.298858: free_page_and_swap_cache <-
unmap_vmas

