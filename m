Return-Path: <linux-kernel-owner+w=401wt.eu-S1752255AbXCSTZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbXCSTZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 15:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbXCSTZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 15:25:17 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:43957 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbXCSTZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 15:25:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=PikmZQ3zZZ1bPMbymGWGP88PMUYd3Aw4F+kJR8fkkQa63TQUBUs87OsbMTJjNImd6QBji9cHZ4dVFilTrrwGAMf95BOCbqx1euV7HQAgD19tJ9DQl2mTMIlucPdotytcT0HbddpZJkej5gAUqUX2u5u6hG8PdEY0Ovp3PV3cwNQ=
Message-ID: <45FEE33C.1020706@googlemail.com>
Date: Mon, 19 Mar 2007 20:23:40 +0100
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm snapshot broken-out-2007-03-18-02-44.tar.gz uploaded
References: <200703180946.l2I9kTVc020636@shell0.pdx.osdl.net>
In-Reply-To: <200703180946.l2I9kTVc020636@shell0.pdx.osdl.net>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org napisa³(a):
> The mm snapshot broken-out-2007-03-18-02-44.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-03-18-02-44.tar.gz
> 
> It contains the following patches against 2.6.21-rc4:
> 

------------[ cut here ]------------
kernel BUG at mm/filemap.c:123!
invalid opcode: 0000 [#1]
PREEMPT SMP 
last sysfs file: devices/platform/w83627hf.656/temp2_input
Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nfsd exportfs lockd nfs_acl autofs4 sunrpc af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss evdev snd_mixer_oss snd_pcm intel_agp agpgart snd_timer snd soundcore i2c_i801 snd_page_alloc ide_cd cdrom rtc unix
CPU:    0
EIP:    0060:[<c01615de>]    Not tainted VLI
EFLAGS: 00010002   (2.6.21-rc4-mm1 #13)
EIP is at __remove_from_page_cache+0x42/0x4a
eax: 00000001   ebx: ca263a58   ecx: c043c968   edx: 00000001
esi: c6ad3480   edi: 00000000   ebp: c968dde8   esp: c968dde0
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process bash-shared-map (pid: 12273, ti=c968c000 task=c78bc030 task.ti=c968c000)
Stack: ca263a68 c6ad3480 c968ddf8 c016161b c6ad3480 000000da c968de04 c016824d 
       c6ad3480 c968de88 c0168525 00001000 00000000 00000000 d17dc000 0005a91a 
       00000000 ca263a58 0000005b ffffffff 0000091a 00000110 c54eb5e0 00000004 
Call Trace:
 [<c0105256>] show_trace_log_lvl+0x1a/0x2f
 [<c0105308>] show_stack_log_lvl+0x9d/0xac
 [<c0105504>] show_registers+0x1ed/0x34c
 [<c0105780>] die+0x11d/0x234
 [<c0105921>] do_trap+0x8a/0xa3
 [<c010620a>] do_invalid_op+0x97/0xa1
 [<c033f87c>] error_code+0x7c/0x84
 [<c016161b>] remove_from_page_cache+0x35/0x40
 [<c016824d>] truncate_complete_page+0x38/0x42
 [<c0168525>] truncate_inode_pages_range+0x2ce/0x2fe
 [<c016856f>] truncate_inode_pages+0x1a/0x1c
 [<c016ebcc>] vmtruncate+0x40/0xbb
 [<c0193c61>] inode_setattr+0x5c/0x137
 [<c01c328d>] ext3_setattr+0x19c/0x1f8
 [<c0193e75>] notify_change+0x139/0x2ec
 [<c017f666>] do_truncate+0x53/0x6c
 [<c017facc>] do_sys_ftruncate+0x135/0x150
 [<c017fb02>] sys_ftruncate64+0x1b/0x1d
 [<c0104270>] syscall_call+0x7/0xb
 =======================
Code: 10 00 00 00 00 ff 4b 68 ba 05 00 00 00 89 f0 e8 17 95 00 00 31 d2 83 7e 08 00 0f 99 c2 b8 68 c9 43 c0 e8 1e 26 0b 00 85 c0 74 04 <0f> 0b eb fe 5b 5e 5d c3 55 89 e5 56 53 89 c6 8b 58 10 8b 10 83 
EIP: [<c01615de>] __remove_from_page_cache+0x42/0x4a SS:ESP 0068:c968dde0

0xc01615de is in __remove_from_page_cache (mm/filemap.c:123).
118
119             radix_tree_delete(&mapping->page_tree, page->index);
120             page->mapping = NULL;
121             mapping->nrpages--;
122             __dec_zone_page_state(page, NR_FILE_PAGES);
123             BUG_ON(page_mapped(page));
124     }
125
126     void remove_from_page_cache(struct page *page)
127     {


note: bash-shared-map[12273] exited with preempt_count 1
BUG: sleeping function called from invalid context at kernel/rwsem.c:20
in_atomic():1, irqs_disabled():1
3 locks held by bash-shared-map/12273:
 #0:  (&inode->i_mutex){--..}, at: [<c033d89a>] mutex_lock+0x1c/0x1f
 #1:  (&inode->i_alloc_sem){--..}, at: [<c0193e1b>] notify_change+0xdf/0x2ec
 #2:  (&inode->i_data.tree_lock){++..}, at: [<c0161614>] remove_from_page_cache+0x2e/0x40

l *0xc033d89a
0xc033d89a is in mutex_lock (kernel/mutex.c:92).
87              /*
88               * The locking fastpath is the 1->0 transition from
89               * 'unlocked' into 'locked' state.
90               */
91              __mutex_fastpath_lock(&lock->count, __mutex_lock_slowpath);
92      }
93
94      EXPORT_SYMBOL(mutex_lock);
95
96      static void fastcall noinline __sched

l *0xc0193e1b
0xc0193e1b is in notify_change (fs/attr.c:146).
141                     return 0;
142
143             if (ia_valid & ATTR_SIZE)
144                     down_write(&dentry->d_inode->i_alloc_sem);
145
146             if (inode->i_op && inode->i_op->setattr) {
147                     error = security_inode_setattr(dentry, attr);
148                     if (!error)
149                             error = inode->i_op->setattr(dentry, attr);
150             } else {

l *0xc0161614
0xc0161614 is in remove_from_page_cache (mm/filemap.c:133).
128             struct address_space *mapping = page->mapping;
129
130             BUG_ON(!PageLocked(page));
131
132             write_lock_irq(&mapping->tree_lock);
133             __remove_from_page_cache(page);
134             write_unlock_irq(&mapping->tree_lock);
135     }
136
137     static int sync_page(void *word)


irq event stamp: 1313898
hardirqs last  enabled at (1313897): [<c017bafa>] kmem_cache_free+0xf7/0x100
hardirqs last disabled at (1313898): [<c033f043>] _write_lock_irq+0xf/0x48
softirqs last  enabled at (1313800): [<c0128e58>] __do_softirq+0xe4/0xea
softirqs last disabled at (1313795): [<c0128e97>] do_softirq+0x39/0x55

l *0xc017bafa
0xc017bafa is in kmem_cache_free (include/asm/irqflags.h:33).
28              return flags;
29      }
30
31      static inline void raw_local_irq_restore(unsigned long flags)
32      {
33              __asm__ __volatile__(
34                      "pushl %0 ; popfl"
35                      : /* no output */
36                      :"g" (flags)
37                      :"memory", "cc"

l *0xc033f043
0xc033f043 is in _write_lock_irq (kernel/spinlock.c:167).
162     EXPORT_SYMBOL(_write_lock_irqsave);
163
164     void __lockfunc _write_lock_irq(rwlock_t *lock)
165     {
166             local_irq_disable();
167             preempt_disable();
168             rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
169             _raw_write_lock(lock);
170     }
171     EXPORT_SYMBOL(_write_lock_irq);

l *0xc0128e58
0xc0128e58 is in __do_softirq (kernel/softirq.c:252).
247
248             trace_softirq_exit();
249
250             account_system_vtime(current);
251             _local_bh_enable();
252     }
253
254     #ifndef __ARCH_HAS_DO_SOFTIRQ
255
256     asmlinkage void do_softirq(void)

l *0xc0128e97
0xc0128e97 is in do_softirq (kernel/softirq.c:271).
266             pending = local_softirq_pending();
267
268             if (pending)
269                     __do_softirq();
270
271             local_irq_restore(flags);
272     }
273
274     EXPORT_SYMBOL(do_softirq);


 [<c0105256>] show_trace_log_lvl+0x1a/0x2f
 [<c010597b>] show_trace+0x12/0x14
 [<c0105a3d>] dump_stack+0x16/0x18
 [<c011cd71>] __might_sleep+0xc9/0xcf
 [<c0139b12>] down_read+0x18/0x4c
 [<c014ef71>] acct_collect+0x3b/0x146
 [<c0126fb9>] do_exit+0x254/0x86c
 [<c0105871>] die+0x20e/0x234
 [<c0105921>] do_trap+0x8a/0xa3
 [<c010620a>] do_invalid_op+0x97/0xa1
 [<c033f87c>] error_code+0x7c/0x84
 [<c016161b>] remove_from_page_cache+0x35/0x40
 [<c016824d>] truncate_complete_page+0x38/0x42
 [<c0168525>] truncate_inode_pages_range+0x2ce/0x2fe
 [<c016856f>] truncate_inode_pages+0x1a/0x1c
 [<c016ebcc>] vmtruncate+0x40/0xbb
 [<c0193c61>] inode_setattr+0x5c/0x137
 [<c01c328d>] ext3_setattr+0x19c/0x1f8
 [<c0193e75>] notify_change+0x139/0x2ec
 [<c017f666>] do_truncate+0x53/0x6c
 [<c017facc>] do_sys_ftruncate+0x135/0x150
 [<c017fb02>] sys_ftruncate64+0x1b/0x1d
 [<c0104270>] syscall_call+0x7/0xb
 =======================
BUG: scheduling while atomic: bash-shared-map/0x10000001/12273
3 locks held by bash-shared-map/12273:
 #0:  (&inode->i_mutex){--..}, at: [<c033d89a>] mutex_lock+0x1c/0x1f
 #1:  (&inode->i_alloc_sem){--..}, at: [<c0193e1b>] notify_change+0xdf/0x2ec
 #2:  (&inode->i_data.tree_lock){++..}, at: [<c0161614>] remove_from_page_cache+0x2e/0x40
 [<c0105256>] show_trace_log_lvl+0x1a/0x2f
 [<c010597b>] show_trace+0x12/0x14
 [<c0105a3d>] dump_stack+0x16/0x18
 [<c033ba9a>] __sched_text_start+0x92/0xb25
 [<c011eed7>] __cond_resched+0x21/0x4b
 [<c033c85d>] cond_resched+0x3c/0x47
 [<c016cf02>] unmap_vmas+0x471/0x560
 [<c016fc38>] exit_mmap+0x7e/0x12a
 [<c0121db7>] mmput+0x49/0xaf
 [<c0125a69>] exit_mm+0xe5/0xeb
 [<c012700c>] do_exit+0x2a7/0x86c
 [<c0105871>] die+0x20e/0x234
 [<c0105921>] do_trap+0x8a/0xa3
 [<c010620a>] do_invalid_op+0x97/0xa1
 [<c033f87c>] error_code+0x7c/0x84
 [<c016161b>] remove_from_page_cache+0x35/0x40
 [<c016824d>] truncate_complete_page+0x38/0x42
 [<c0168525>] truncate_inode_pages_range+0x2ce/0x2fe
 [<c016856f>] truncate_inode_pages+0x1a/0x1c
 [<c016ebcc>] vmtruncate+0x40/0xbb
 [<c0193c61>] inode_setattr+0x5c/0x137
 [<c01c328d>] ext3_setattr+0x19c/0x1f8
 [<c0193e75>] notify_change+0x139/0x2ec
 [<c017f666>] do_truncate+0x53/0x6c
 [<c017facc>] do_sys_ftruncate+0x135/0x150
 [<c017fb02>] sys_ftruncate64+0x1b/0x1d
 [<c0104270>] syscall_call+0x7/0xb
 =======================
BUG: soft lockup detected on CPU#0!
 [<c0105256>] show_trace_log_lvl+0x1a/0x2f
 [<c010597b>] show_trace+0x12/0x14
 [<c0105a3d>] dump_stack+0x16/0x18
 [<c015698d>] softlockup_tick+0xca/0xdc
 [<c012c7b5>] run_local_timers+0x12/0x14
 [<c012cbc3>] update_process_times+0x3e/0x63
 [<c013d29f>] tick_sched_timer+0x5d/0xa1
 [<c01397dd>] hrtimer_interrupt+0x11e/0x1b9
 [<c0115daa>] smp_apic_timer_interrupt+0x72/0x84
 [<c0104d33>] apic_timer_interrupt+0x33/0x38
 [<c0113d26>] flush_tlb_page+0x86/0xb8
 [<c0172644>] page_referenced_one+0x90/0xd1
 [<c017317d>] page_referenced+0x64/0xd0
 [<c0168b3d>] shrink_active_list+0x169/0x426
 [<c01698f6>] shrink_zone+0xb9/0xf8
 [<c016a33e>] try_to_free_pages+0x155/0x223
 [<c016498c>] __alloc_pages+0x1cd/0x324
 [<c016c570>] do_wp_page+0x263/0x4a6
 [<c016db99>] __handle_mm_fault+0x6db/0x72c
 [<c011a694>] do_page_fault+0x22b/0x55b
 [<c033f87c>] error_code+0x7c/0x84
 =======================
BUG: soft lockup detected on CPU#0!
 [<c0105256>] show_trace_log_lvl+0x1a/0x2f
 [<c010597b>] show_trace+0x12/0x14
 [<c0105a3d>] dump_stack+0x16/0x18
 [<c015698d>] softlockup_tick+0xca/0xdc
 [<c012c7b5>] run_local_timers+0x12/0x14
 [<c012cbc3>] update_process_times+0x3e/0x63
 [<c013d29f>] tick_sched_timer+0x5d/0xa1
 [<c01397dd>] hrtimer_interrupt+0x11e/0x1b9
 [<c0115daa>] smp_apic_timer_interrupt+0x72/0x84
 [<c0104d33>] apic_timer_interrupt+0x33/0x38
 [<c0113d26>] flush_tlb_page+0x86/0xb8
 [<c0172644>] page_referenced_one+0x90/0xd1
 [<c017317d>] page_referenced+0x64/0xd0
 [<c0168b3d>] shrink_active_list+0x169/0x426
 [<c01698f6>] shrink_zone+0xb9/0xf8
 [<c016a33e>] try_to_free_pages+0x155/0x223
 [<c016498c>] __alloc_pages+0x1cd/0x324
 [<c016c570>] do_wp_page+0x263/0x4a6
 [<c016db99>] __handle_mm_fault+0x6db/0x72c
 [<c011a694>] do_page_fault+0x22b/0x55b
 [<c033f87c>] error_code+0x7c/0x84
 =======================
BUG: soft lockup detected on CPU#0!
 [<c0105256>] show_trace_log_lvl+0x1a/0x2f
 [<c010597b>] show_trace+0x12/0x14
 [<c0105a3d>] dump_stack+0x16/0x18
 [<c015698d>] softlockup_tick+0xca/0xdc
 [<c012c7b5>] run_local_timers+0x12/0x14
 [<c012cbc3>] update_process_times+0x3e/0x63
 [<c013d29f>] tick_sched_timer+0x5d/0xa1
 [<c01397dd>] hrtimer_interrupt+0x11e/0x1b9
 [<c0115daa>] smp_apic_timer_interrupt+0x72/0x84
 [<c0104d33>] apic_timer_interrupt+0x33/0x38
 [<c0113d26>] flush_tlb_page+0x86/0xb8
 [<c0172644>] page_referenced_one+0x90/0xd1
 [<c017317d>] page_referenced+0x64/0xd0
 [<c0168b3d>] shrink_active_list+0x169/0x426
 [<c01698f6>] shrink_zone+0xb9/0xf8
 [<c016a33e>] try_to_free_pages+0x155/0x223
 [<c016498c>] __alloc_pages+0x1cd/0x324
 [<c016c570>] do_wp_page+0x263/0x4a6
 [<c016db99>] __handle_mm_fault+0x6db/0x72c
 [<c011a694>] do_page_fault+0x22b/0x55b
 [<c033f87c>] error_code+0x7c/0x84
 =======================
BUG: soft lockup detected on CPU#0!
 [<c0105256>] show_trace_log_lvl+0x1a/0x2f
 [<c010597b>] show_trace+0x12/0x14
 [<c0105a3d>] dump_stack+0x16/0x18
 [<c015698d>] softlockup_tick+0xca/0xdc
 [<c012c7b5>] run_local_timers+0x12/0x14
 [<c012cbc3>] update_process_times+0x3e/0x63
 [<c013d29f>] tick_sched_timer+0x5d/0xa1
 [<c01397dd>] hrtimer_interrupt+0x11e/0x1b9
 [<c0115daa>] smp_apic_timer_interrupt+0x72/0x84
 [<c0104d33>] apic_timer_interrupt+0x33/0x38
 [<c0113d26>] flush_tlb_page+0x86/0xb8
 [<c0172644>] page_referenced_one+0x90/0xd1
 [<c017317d>] page_referenced+0x64/0xd0
 [<c0168b3d>] shrink_active_list+0x169/0x426
 [<c01698f6>] shrink_zone+0xb9/0xf8
 [<c016a33e>] try_to_free_pages+0x155/0x223
 [<c016498c>] __alloc_pages+0x1cd/0x324
 [<c016c570>] do_wp_page+0x263/0x4a6
 [<c016db99>] __handle_mm_fault+0x6db/0x72c
 [<c011a694>] do_page_fault+0x22b/0x55b
 [<c033f87c>] error_code+0x7c/0x84
 =======================
BUG: soft lockup detected on CPU#0!
 [<c0105256>] show_trace_log_lvl+0x1a/0x2f
 [<c010597b>] show_trace+0x12/0x14
 [<c0105a3d>] dump_stack+0x16/0x18
 [<c015698d>] softlockup_tick+0xca/0xdc
 [<c012c7b5>] run_local_timers+0x12/0x14
 [<c012cbc3>] update_process_times+0x3e/0x63
 [<c013d29f>] tick_sched_timer+0x5d/0xa1
 [<c01397dd>] hrtimer_interrupt+0x11e/0x1b9
 [<c0115daa>] smp_apic_timer_interrupt+0x72/0x84
 [<c0104d33>] apic_timer_interrupt+0x33/0x38
 [<c0113d26>] flush_tlb_page+0x86/0xb8
 [<c0172644>] page_referenced_one+0x90/0xd1
 [<c017317d>] page_referenced+0x64/0xd0
 [<c0168b3d>] shrink_active_list+0x169/0x426
 [<c01698f6>] shrink_zone+0xb9/0xf8
 [<c016a33e>] try_to_free_pages+0x155/0x223
 [<c016498c>] __alloc_pages+0x1cd/0x324
 [<c016c570>] do_wp_page+0x263/0x4a6
 [<c016db99>] __handle_mm_fault+0x6db/0x72c
 [<c011a694>] do_page_fault+0x22b/0x55b
 [<c033f87c>] error_code+0x7c/0x84
 =======================
BUG: soft lockup detected on CPU#0!
 [<c0105256>] show_trace_log_lvl+0x1a/0x2f
 [<c010597b>] show_trace+0x12/0x14
 [<c0105a3d>] dump_stack+0x16/0x18
 [<c015698d>] softlockup_tick+0xca/0xdc
 [<c012c7b5>] run_local_timers+0x12/0x14
 [<c012cbc3>] update_process_times+0x3e/0x63
 [<c013d29f>] tick_sched_timer+0x5d/0xa1
 [<c01397dd>] hrtimer_interrupt+0x11e/0x1b9
 [<c0115daa>] smp_apic_timer_interrupt+0x72/0x84
 [<c0104d33>] apic_timer_interrupt+0x33/0x38
 [<c0113d26>] flush_tlb_page+0x86/0xb8
 [<c0172644>] page_referenced_one+0x90/0xd1
 [<c017317d>] page_referenced+0x64/0xd0
 [<c0168b3d>] shrink_active_list+0x169/0x426
 [<c01698f6>] shrink_zone+0xb9/0xf8
 [<c016a33e>] try_to_free_pages+0x155/0x223
 [<c016498c>] __alloc_pages+0x1cd/0x324
 [<c016c570>] do_wp_page+0x263/0x4a6
 [<c016db99>] __handle_mm_fault+0x6db/0x72c
 [<c011a694>] do_page_fault+0x22b/0x55b
 [<c033f87c>] error_code+0x7c/0x84
 =======================

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-03-18-02-44/mm-config

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
