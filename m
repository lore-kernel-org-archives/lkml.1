Return-Path: <linux-kernel-owner+w=401wt.eu-S1755062AbXLJKtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbXLJKtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 05:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbXLJKtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 05:49:04 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:47771 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbXLJKtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 05:49:00 -0500
Date: Mon, 10 Dec 2007 11:48:59 +0100
To: linux-kernel@vger.kernel.org
Subject: kernel BUG: Eeek! page_mapcount(page) went negative!
Message-ID: <20071210104859.GI7003@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

(Please Cc)

I was running a kvm installing windows, and eek it crashed happily my
computer, probably because I forgot to give kvm -no-acpi option.

Anyway, it shouldn't (should it?) Eeeek out?


kvm: guest NX capability removed
apic write: bad size=1 fee00030
Ignoring de-assert INIT to vcpu 0
Ignoring de-assert INIT to vcpu 0
kvm: emulating exchange as write
swap_dup: Bad swap file entry 185e8957
VM: killing process cpufreq-applet
Bad pte = 8b2cec83, process = ???, vm_flags = 8000075, vaddr = b7800000
Pid: 5170, comm: cpufreq-applet Not tainted 2.6.24-rc4 #1
 [<c01556db>] vm_normal_page+0x3e/0x53
 [<c0155d58>] unmap_vmas+0x184/0x4ed
 [<c01587d7>] exit_mmap+0x7c/0x106
 [<c0121730>] mmput+0x1c/0x75
 [<c0126115>] do_exit+0x1cf/0x642
 [<c01265f5>] sys_exit_group+0x0/0xd
 [<c011b5ff>] do_page_fault+0x49b/0x51c
 [<c01701e9>] sys_poll+0x3a/0x6b
 [<c011b164>] do_page_fault+0x0/0x51c
 [<c0354daa>] error_code+0x72/0x78
 =======================
swap_free: Bad swap offset entry 00416856
swap_free: Bad swap file entry 40ff006a
Bad pte = 85f08b80, process = ???, vm_flags = 8000075, vaddr = b7806000
Pid: 5170, comm: cpufreq-applet Not tainted 2.6.24-rc4 #1
 [<c01556db>] vm_normal_page+0x3e/0x53
 [<c0155d58>] unmap_vmas+0x184/0x4ed
 [<c01587d7>] exit_mmap+0x7c/0x106
 [<c0121730>] mmput+0x1c/0x75
 [<c0126115>] do_exit+0x1cf/0x642
 [<c01265f5>] sys_exit_group+0x0/0xd
 [<c011b5ff>] do_page_fault+0x49b/0x51c
 [<c01701e9>] sys_poll+0x3a/0x6b
 [<c011b164>] do_page_fault+0x0/0x51c
 [<c0354daa>] error_code+0x72/0x78
 =======================
Bad pte = b80a75f6, process = ???, vm_flags = 8000075, vaddr = b7807000
Pid: 5170, comm: cpufreq-applet Not tainted 2.6.24-rc4 #1
 [<c01556db>] vm_normal_page+0x3e/0x53
 [<c0155d58>] unmap_vmas+0x184/0x4ed
 [<c01587d7>] exit_mmap+0x7c/0x106
 [<c0121730>] mmput+0x1c/0x75
 [<c0126115>] do_exit+0x1cf/0x642
 [<c01265f5>] sys_exit_group+0x0/0xd
 [<c011b5ff>] do_page_fault+0x49b/0x51c
 [<c01701e9>] sys_poll+0x3a/0x6b
 [<c011b164>] do_page_fault+0x0/0x51c
 [<c0354daa>] error_code+0x72/0x78
 =======================
Bad pte = c000009a, process = ???, vm_flags = 8000075, vaddr = b7808000
Pid: 5170, comm: cpufreq-applet Not tainted 2.6.24-rc4 #1
 [<c01556db>] vm_normal_page+0x3e/0x53
 [<c0155d58>] unmap_vmas+0x184/0x4ed
 [<c01587d7>] exit_mmap+0x7c/0x106
 [<c0121730>] mmput+0x1c/0x75
 [<c0126115>] do_exit+0x1cf/0x642
 [<c01265f5>] sys_exit_group+0x0/0xd
 [<c011b5ff>] do_page_fault+0x49b/0x51c
 [<c01701e9>] sys_poll+0x3a/0x6b
 [<c011b164>] do_page_fault+0x0/0x51c
 [<c0354daa>] error_code+0x72/0x78
 =======================
swap_free: Bad swap offset entry 0014458b
Bad pte = 458b0689, process = ???, vm_flags = 8000075, vaddr = b780b000
Pid: 5170, comm: cpufreq-applet Not tainted 2.6.24-rc4 #1
 [<c01556db>] vm_normal_page+0x3e/0x53
 [<c0155d58>] unmap_vmas+0x184/0x4ed
 [<c01587d7>] exit_mmap+0x7c/0x106
 [<c0121730>] mmput+0x1c/0x75
 [<c0126115>] do_exit+0x1cf/0x642
 [<c01265f5>] sys_exit_group+0x0/0xd
 [<c011b5ff>] do_page_fault+0x49b/0x51c
 [<c01701e9>] sys_poll+0x3a/0x6b
 [<c011b164>] do_page_fault+0x0/0x51c
 [<c0354daa>] error_code+0x72/0x78
 =======================
swap_free: Bad swap file entry 60044689
Bad pte = 530c458b, process = ???, vm_flags = 8000075, vaddr = b780d000
Pid: 5170, comm: cpufreq-applet Not tainted 2.6.24-rc4 #1
 [<c01556db>] vm_normal_page+0x3e/0x53
 [<c0155d58>] unmap_vmas+0x184/0x4ed
 [<c01587d7>] exit_mmap+0x7c/0x106
 [<c0121730>] mmput+0x1c/0x75
 [<c0126115>] do_exit+0x1cf/0x642
 [<c01265f5>] sys_exit_group+0x0/0xd
 [<c011b5ff>] do_page_fault+0x49b/0x51c
 [<c01701e9>] sys_poll+0x3a/0x6b
 [<c011b164>] do_page_fault+0x0/0x51c
 [<c0354daa>] error_code+0x72/0x78
 =======================
Bad pte = 89105d8b, process = ???, vm_flags = 8000075, vaddr = b780e000
Pid: 5170, comm: cpufreq-applet Not tainted 2.6.24-rc4 #1
 [<c01556db>] vm_normal_page+0x3e/0x53
 [<c0155d58>] unmap_vmas+0x184/0x4ed
 [<c01587d7>] exit_mmap+0x7c/0x106
 [<c0121730>] mmput+0x1c/0x75
 [<c0126115>] do_exit+0x1cf/0x642
 [<c01265f5>] sys_exit_group+0x0/0xd
 [<c011b5ff>] do_page_fault+0x49b/0x51c
 [<c01701e9>] sys_poll+0x3a/0x6b
 [<c011b164>] do_page_fault+0x0/0x51c
 [<c0354daa>] error_code+0x72/0x78
 =======================
swap_free: Bad swap file entry 185e8957
swap_free: Bad swap file entry 30481574
swap_free: Bad swap offset entry 00ebc000
Bad pte = 9868562b, process = ???, vm_flags = 8000075, vaddr = b7814000
Pid: 5170, comm: cpufreq-applet Not tainted 2.6.24-rc4 #1
 [<c01556db>] vm_normal_page+0x3e/0x53
 [<c0155d58>] unmap_vmas+0x184/0x4ed
 [<c01587d7>] exit_mmap+0x7c/0x106
 [<c0121730>] mmput+0x1c/0x75
 [<c0126115>] do_exit+0x1cf/0x642
 [<c01265f5>] sys_exit_group+0x0/0xd
 [<c011b5ff>] do_page_fault+0x49b/0x51c
 [<c01701e9>] sys_poll+0x3a/0x6b
 [<c011b164>] do_page_fault+0x0/0x51c
 [<c0354daa>] error_code+0x72/0x78
 =======================
Bad pte = 53801981, process = ???, vm_flags = 8000075, vaddr = b7815000
Pid: 5170, comm: cpufreq-applet Not tainted 2.6.24-rc4 #1
 [<c01556db>] vm_normal_page+0x3e/0x53
 [<c0155d58>] unmap_vmas+0x184/0x4ed
 [<c01587d7>] exit_mmap+0x7c/0x106
 [<c0121730>] mmput+0x1c/0x75
 [<c0126115>] do_exit+0x1cf/0x642
 [<c01265f5>] sys_exit_group+0x0/0xd
 [<c011b5ff>] do_page_fault+0x49b/0x51c
 [<c01701e9>] sys_poll+0x3a/0x6b
 [<c011b164>] do_page_fault+0x0/0x51c
 [<c0354daa>] error_code+0x72/0x78
 =======================
Bad pte = 6a538019, process = ???, vm_flags = 8000075, vaddr = b7818000
Pid: 5170, comm: cpufreq-applet Not tainted 2.6.24-rc4 #1
 [<c01556db>] vm_normal_page+0x3e/0x53
 [<c0155d58>] unmap_vmas+0x184/0x4ed
 [<c01587d7>] exit_mmap+0x7c/0x106
 [<c0121730>] mmput+0x1c/0x75
 [<c0126115>] do_exit+0x1cf/0x642
 [<c01265f5>] sys_exit_group+0x0/0xd
 [<c011b5ff>] do_page_fault+0x49b/0x51c
 [<c01701e9>] sys_poll+0x3a/0x6b
 [<c011b164>] do_page_fault+0x0/0x51c
 [<c0354daa>] error_code+0x72/0x78
 =======================
swap_free: Bad swap file entry 18c7ace8
Bad pte = f88bfffe, process = ???, vm_flags = 8000075, vaddr = b781a000
Pid: 5170, comm: cpufreq-applet Not tainted 2.6.24-rc4 #1
 [<c01556db>] vm_normal_page+0x3e/0x53
 [<c0155d58>] unmap_vmas+0x184/0x4ed
 [<c01587d7>] exit_mmap+0x7c/0x106
 [<c0121730>] mmput+0x1c/0x75
 [<c0126115>] do_exit+0x1cf/0x642
 [<c01265f5>] sys_exit_group+0x0/0xd
 [<c011b5ff>] do_page_fault+0x49b/0x51c
 [<c01701e9>] sys_poll+0x3a/0x6b
 [<c011b164>] do_page_fault+0x0/0x51c
 [<c0354daa>] error_code+0x72/0x78
 =======================
Bad pte = 8510c483, process = ???, vm_flags = 8000075, vaddr = b781b000
Pid: 5170, comm: cpufreq-applet Not tainted 2.6.24-rc4 #1
 [<c01556db>] vm_normal_page+0x3e/0x53
 [<c0155d58>] unmap_vmas+0x184/0x4ed
 [<c01587d7>] exit_mmap+0x7c/0x106
 [<c0121730>] mmput+0x1c/0x75
 [<c0126115>] do_exit+0x1cf/0x642
 [<c01265f5>] sys_exit_group+0x0/0xd
 [<c011b5ff>] do_page_fault+0x49b/0x51c
 [<c01701e9>] sys_poll+0x3a/0x6b
 [<c011b164>] do_page_fault+0x0/0x51c
 [<c0354daa>] error_code+0x72/0x78
 =======================
Bad pte = bf1674ff, process = ???, vm_flags = 8000075, vaddr = b781c000
Pid: 5170, comm: cpufreq-applet Not tainted 2.6.24-rc4 #1
 [<c01556db>] vm_normal_page+0x3e/0x53
 [<c0155d58>] unmap_vmas+0x184/0x4ed
 [<c01587d7>] exit_mmap+0x7c/0x106
 [<c0121730>] mmput+0x1c/0x75
 [<c0126115>] do_exit+0x1cf/0x642
 [<c01265f5>] sys_exit_group+0x0/0xd
 [<c011b5ff>] do_page_fault+0x49b/0x51c
 [<c01701e9>] sys_poll+0x3a/0x6b
 [<c011b164>] do_page_fault+0x0/0x51c
 [<c0354daa>] error_code+0x72/0x78
 =======================
Bad pte = c0000001, process = ???, vm_flags = 8000075, vaddr = b781d000
Pid: 5170, comm: cpufreq-applet Not tainted 2.6.24-rc4 #1
 [<c01556db>] vm_normal_page+0x3e/0x53
 [<c0155d58>] unmap_vmas+0x184/0x4ed
 [<c01587d7>] exit_mmap+0x7c/0x106
 [<c0121730>] mmput+0x1c/0x75
 [<c0126115>] do_exit+0x1cf/0x642
 [<c01265f5>] sys_exit_group+0x0/0xd
 [<c011b5ff>] do_page_fault+0x49b/0x51c
 [<c01701e9>] sys_poll+0x3a/0x6b
 [<c011b164>] do_page_fault+0x0/0x51c
 [<c0354daa>] error_code+0x72/0x78
 =======================
Eeek! page_mapcount(page) went negative! (-1)
  page pfn = 199a8
  page->flags = 40000000
  page->count = 1
  page->mapping = 00000000
  vma->vm_ops = 0xc0412a48
  vma->vm_ops->nopage = _stext+0x3feff000/0x14
  vma->vm_ops->fault = filemap_fault+0x0/0x39d
  vma->vm_file->f_op->mmap = generic_file_mmap+0x0/0x3e
------------[ cut here ]------------
kernel BUG at mm/rmap.c:631!
invalid opcode: 0000 [#1] PREEMPT SMP 
Modules linked in: usb_storage kvm_intel kvm binfmt_misc fuse dm_crypt dm_snapshot dm_mod coretemp hwmon nsc_ircc tifm_7xx1 iwl3945 tifm_core joydev 8250_pnp 8250 serial_core irda mac80211 crc_ccitt firewire_ohci firewire_core crc_itu_t

Pid: 5170, comm: cpufreq-applet Not tainted (2.6.24-rc4 #1)
EIP: 0060:[<c015b0db>] EFLAGS: 00210292 CPU: 0
EIP is at page_remove_rmap+0xe5/0x104
EAX: 0000003b EBX: c1333500 ECX: c04a5893 EDX: 00200002
ESI: e6f8280c EDI: b7820000 EBP: e6fef080 ESP: e6dd3e8c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process cpufreq-applet (pid: 5170, ti=e6dd2000 task=e6c24000 task.ti=e6dd2000)
Stack: c03bf622 00000000 c1333500 00000000 c0155e35 c04940e0 c17f80f0 b788afff 
       00000000 e6f8280c e6dd3f0c 00000001 00000000 b788b000 f77a2b78 f77a2b78 
       f7492040 c17f80e0 00000000 fffffffe 00004000 b788b000 00000000 e6dd3f0c 
Call Trace:
 [<c0155e35>] unmap_vmas+0x261/0x4ed
 [<c01587d7>] exit_mmap+0x7c/0x106
 [<c0121730>] mmput+0x1c/0x75
 [<c0126115>] do_exit+0x1cf/0x642
 [<c01265f5>] sys_exit_group+0x0/0xd
 [<c011b5ff>] do_page_fault+0x49b/0x51c
 [<c01701e9>] sys_poll+0x3a/0x6b
 [<c011b164>] do_page_fault+0x0/0x51c
 [<c0354daa>] error_code+0x72/0x78
 =======================
Code: 8b 46 40 8b 50 08 b8 71 f6 3b c0 e8 a2 76 fe ff 8b 46 48 85 c0 74 14 8b 40 10 85 c0 74 0d 8b 50 2c b8 8f f6 3b c0 e8 87 76 fe ff <0f> 0b eb fe 8b 53 10 89 d8 59 5b 5b 83 e2 01 5e f7 da 83 c2 04 
EIP: [<c015b0db>] page_remove_rmap+0xe5/0x104 SS:ESP 0068:e6dd3e8c
Fixing recursive fault but reboot is needed!
BUG: scheduling while atomic: cpufreq-applet/5170/0x00000003
Pid: 5170, comm: cpufreq-applet Tainted: G      D 2.6.24-rc4 #1
 [<c035336d>] schedule+0x93/0x5a8
 [<c01cf25d>] free_as_io_context+0x7/0x79
 [<c0126009>] do_exit+0xc3/0x642
 [<c021adfc>] do_unblank_screen+0xd/0x103
 [<c0105328>] die+0x1d6/0x1de
 [<c010560c>] do_invalid_op+0x0/0x8a
 [<c010568d>] do_invalid_op+0x81/0x8a
 [<c015b0db>] page_remove_rmap+0xe5/0x104
 [<c0123519>] __call_console_drivers+0x4f/0x5b
 [<c01238d0>] release_console_sem+0x17f/0x198
 [<c0123d15>] printk+0x1b/0x1f
 [<c0354daa>] error_code+0x72/0x78
 [<c015b0db>] page_remove_rmap+0xe5/0x104
 [<c0155e35>] unmap_vmas+0x261/0x4ed
 [<c01587d7>] exit_mmap+0x7c/0x106
 [<c0121730>] mmput+0x1c/0x75
 [<c0126115>] do_exit+0x1cf/0x642
 [<c01265f5>] sys_exit_group+0x0/0xd
 [<c011b5ff>] do_page_fault+0x49b/0x51c
 [<c01701e9>] sys_poll+0x3a/0x6b
 [<c011b164>] do_page_fault+0x0/0x51c
 [<c0354daa>] error_code+0x72/0x78
 =======================
apic write: bad size=1 fee00030
Ignoring de-assert INIT to vcpu 0
Ignoring de-assert INIT to vcpu 0
Eeek! page_mapcount(page) went negative! (-2)
  page pfn = 199a8
  page->flags = 40000004
  page->count = 1
  page->mapping = 00000000
  vma->vm_ops = kvm_vm_vm_ops+0x0/0xffffae2f [kvm]
  vma->vm_ops->nopage = kvm_vm_nopage+0x0/0x42 [kvm]
  vma->vm_ops->fault = _stext+0x3feff000/0x14
  vma->vm_file->f_op->mmap = kvm_vm_mmap+0x0/0xa [kvm]
------------[ cut here ]------------
kernel BUG at mm/rmap.c:631!
invalid opcode: 0000 [#2] PREEMPT SMP 
Modules linked in: usb_storage kvm_intel kvm binfmt_misc fuse dm_crypt dm_snapshot dm_mod coretemp hwmon nsc_ircc tifm_7xx1 iwl3945 tifm_core joydev 8250_pnp 8250 serial_core irda mac80211 crc_ccitt firewire_ohci firewire_core crc_itu_t

Pid: 20473, comm: kvm Tainted: G      D (2.6.24-rc4 #1)
EIP: 0060:[<c015b0db>] EFLAGS: 00010286 CPU: 0
EIP is at page_remove_rmap+0xe5/0x104
EAX: 0000003a EBX: c1333500 ECX: c04a5892 EDX: 00000002
ESI: e6e8eba8 EDI: a74b9000 EBP: d82c52e4 ESP: df4cfdd8
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kvm (pid: 20473, ti=df4ce000 task=df61c550 task.ti=df4ce000)
Stack: c03bf622 00000000 c1333500 00000020 c0155e35 c04940e0 c17f80f0 b7a25fff 
       00000000 e6e8eba8 df4cfe58 00000001 00000000 a7800000 e9c4ea74 e9c4ea74 
       e6e8a040 c17f80e0 00000000 fffffffd 00005000 b7a26000 00000000 df4cfe58 
Call Trace:
 [<c0155e35>] unmap_vmas+0x261/0x4ed
 [<c01587d7>] exit_mmap+0x7c/0x106
 [<c0121730>] mmput+0x1c/0x75
 [<c0126115>] do_exit+0x1cf/0x642
 [<c012bb68>] __dequeue_signal+0x10/0x14c
 [<c012be35>] recalc_sigpending+0xb/0x30
 [<c01265f5>] sys_exit_group+0x0/0xd
 [<c012d7af>] get_signal_to_deliver+0x3f8/0x41d
 [<c0103609>] do_notify_resume+0x84/0x612
 [<c012d078>] dequeue_signal+0x95/0x111
 [<c013b2a6>] tick_program_event+0x33/0x52
 [<c01384bd>] getnstimeofday+0x2b/0xac
 [<c013654a>] hrtimer_start+0xf1/0xfd
 [<f8a6b006>] kvm_vcpu_ioctl+0x0/0xc60 [kvm]
 [<c016ee67>] do_ioctl+0x1f/0x62
 [<c016f0ca>] vfs_ioctl+0x220/0x232
 [<c016f11f>] sys_ioctl+0x43/0x4c
 [<c010404a>] work_notifysig+0x13/0x19
 =======================
Code: 8b 46 40 8b 50 08 b8 71 f6 3b c0 e8 a2 76 fe ff 8b 46 48 85 c0 74 14 8b 40 10 85 c0 74 0d 8b 50 2c b8 8f f6 3b c0 e8 87 76 fe ff <0f> 0b eb fe 8b 53 10 89 d8 59 5b 5b 83 e2 01 5e f7 da 83 c2 04 
EIP: [<c015b0db>] page_remove_rmap+0xe5/0x104 SS:ESP 0068:df4cfdd8
Fixing recursive fault but reboot is needed!
BUG: scheduling while atomic: kvm/20473/0x00000003
Pid: 20473, comm: kvm Tainted: G      D 2.6.24-rc4 #1
 [<c035336d>] schedule+0x93/0x5a8
 [<c01cf25d>] free_as_io_context+0x7/0x79
 [<c0126009>] do_exit+0xc3/0x642
 [<c021adfc>] do_unblank_screen+0xd/0x103
 [<c0105328>] die+0x1d6/0x1de
 [<c010560c>] do_invalid_op+0x0/0x8a
 [<c010568d>] do_invalid_op+0x81/0x8a
 [<c015b0db>] page_remove_rmap+0xe5/0x104
 [<c0123519>] __call_console_drivers+0x4f/0x5b
 [<c01238d0>] release_console_sem+0x17f/0x198
 [<c0147b6e>] handle_IRQ_event+0x1a/0x3f
 [<c010678c>] do_IRQ+0x5c/0x70
 [<c0127b26>] irq_exit+0x53/0x75
 [<c010678c>] do_IRQ+0x5c/0x70
 [<c0354daa>] error_code+0x72/0x78
 [<c015b0db>] page_remove_rmap+0xe5/0x104
 [<c0155e35>] unmap_vmas+0x261/0x4ed
 [<c01587d7>] exit_mmap+0x7c/0x106
 [<c0121730>] mmput+0x1c/0x75
 [<c0126115>] do_exit+0x1cf/0x642
 [<c012bb68>] __dequeue_signal+0x10/0x14c
 [<c012be35>] recalc_sigpending+0xb/0x30
 [<c01265f5>] sys_exit_group+0x0/0xd
 [<c012d7af>] get_signal_to_deliver+0x3f8/0x41d
 [<c0103609>] do_notify_resume+0x84/0x612
 [<c012d078>] dequeue_signal+0x95/0x111
 [<c013b2a6>] tick_program_event+0x33/0x52
 [<c01384bd>] getnstimeofday+0x2b/0xac
 [<c013654a>] hrtimer_start+0xf1/0xfd
 [<f8a6b006>] kvm_vcpu_ioctl+0x0/0xc60 [kvm]
 [<c016ee67>] do_ioctl+0x1f/0x62
 [<c016f0ca>] vfs_ioctl+0x220/0x232
 [<c016f11f>] sys_ioctl+0x43/0x4c
 [<c010404a>] work_notifysig+0x13/0x19
 =======================

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
PEN-TRE-TAFARN-Y-FEDW (n.)
Welsh word which literally translates as
'leaking-biro-by-the-glass-hole-of-the-clerk-of-the-bank-has-been-
-taken-to-another-place-leaving-only-the-special-inkwell-and-three-
-inches-of-tin-chain'.
			--- Douglas Adams, The Meaning of Liff
