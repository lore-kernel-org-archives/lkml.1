Return-Path: <linux-kernel-owner+w=401wt.eu-S933532AbXGQP23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532AbXGQP23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbXGQP2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:28:21 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:23918 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbXGQP2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:28:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VCEZr9HjDvHUi1AmlVBNMQU52FpOFUSTdPS2QAjJxlcaB7++lc8hGpwm1N2m30ybVN6Z3k/fzZFLwDrgELHxVyxGW29PnE6NweVKznKOl98ASQYCtUjc3Ih3xexTZeaq4Um+mMcHUvtDd8w368l7AsoUY8Z1WVYdbTpC3CsjZVQ=
Message-ID: <c4e36d110707170828s15a2e43ai9e3df37fb419aed6@mail.gmail.com>
Date: Tue, 17 Jul 2007 17:28:13 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: oops with 2.6.22.1 - bad magic number for tty struct
In-Reply-To: <c4e36d110707170814y682cefa6t58ab08f1cad6c6ac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110707170814y682cefa6t58ab08f1cad6c6ac@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I get kernel oopses when I run powertop on my old BP6 SMP dual Celeron board.

In case more details are needed - send me a replay.

The machine with problem is -
2xCPU400MHz Celerons running at 450MHz (stable - compiles kernel
without any problems, thought it takes more than hour nowadays :(...)
512MB RAM
120&30GB Hard drivers (all should be visible in the boot log that
follows oops trace)
In Bp6 bios - PnP enabled, Serial&Parallel ports disabled.
Atheros WiFi driver is used - but this shall hopefully not influence
this problem.

bye

Zdenek


Jul 16 21:16:35 bad magic number for tty struct (136:3) in tty_poll
Jul 16 21:20:56 BUG: unable to handle kernel NULL pointer dereference
at virtual address 0000007c
Jul 16 21:20:56  printing eip:
Jul 16 21:20:56 c0260c23
Jul 16 21:20:56 *pde = 00000000
Jul 16 21:20:56 Oops: 0000 [#1]
Jul 16 21:20:56 PREEMPT SMP
Jul 16 21:20:56 Modules linked in: cpufreq_stats freq_table mga drm
binfmt_misc autofs4 nfsd exportfs lockd sunrpc thermal fan button
processor ac battery ipv6 iptable_filter ip_tables x_tables fuse
dm_snapshot dm_mirror dm_mod w83781d hwmon_vid hwmon tuner tvaudio
snd_emu10k1 wlan_scan_sta snd_rawmidi ath_rate_sample snd_ac97_codec
ac97_bus bttv video_buf firmware_class snd_bt87x ir_common snd_pcm_oss
snd_mixer_oss compat_ioctl32 i2c_algo_bit snd_pcm btcx_risc
snd_util_mem tveeprom videodev snd_hwdep 8139too snd_timer uhci_hcd
v4l2_common v4l1_compat mii floppy emu10k1_gp snd_page_alloc ath_pci
wlan ath_hal(P) pata_hpt366 libata i2c_piix4 snd intel_agp soundcore
rtc usbcore gameport i2c_core scsi_mod agpgart evdev
Jul 16 21:20:56 CPU:    0
Jul 16 21:20:56 EIP:    0060:[<c0260c23>]    Tainted: P       VLI
Jul 16 21:20:56 EFLAGS: 00010046   (2.6.22.1 #1)
Jul 16 21:20:56 EIP is at tty_devnum+0x3/0x20
Jul 16 21:20:56 eax: d7b3f800   ebx: d7b0c030   ecx: 00000000   edx: 00000000
Jul 16 21:20:56 esi: cf9ac000   edi: df1aa7c0   ebp: d7b0c030   esp: c94a3db8
Jul 16 21:20:56 ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Jul 16 21:20:56 Process top (pid: 6260, ti=c94a2000 task=c9a5ba90
task.ti=c94a2000)
Jul 16 21:20:56 Stack: c01adca0 c0186934 df00ce0c c94a3e08 c017e42d
c7c0200b 00000101 01c5a71f
Jul 16 21:20:56        c94a3e44 dffcbf20 c01f5340 dffce6b8 c94a3e38
c0186934 c66b7b8c c94a3e38
Jul 16 21:20:56        c017e42d c7c02006 00000001 00000000 01c5a71f
00000004 c7c0200b dffcbf20
Jul 16 21:20:56 Call Trace:
Jul 16 21:20:56  [<c01adca0>] do_task_stat+0x120/0x9a0
Jul 16 21:20:56  [<c0186934>] dput+0x94/0x130
Jul 16 21:20:56  [<c017e42d>] __link_path_walk+0xacd/0xc80
Jul 16 21:20:56  [<c01f5340>] ext3_permission+0x0/0x10
Jul 16 21:20:56  [<c0186934>] dput+0x94/0x130
Jul 16 21:20:56  [<c017e42d>] __link_path_walk+0xacd/0xc80
Jul 16 21:20:56  [<c018aef3>] mntput_no_expire+0x13/0x60
Jul 16 21:20:56  [<c017e645>] link_path_walk+0x65/0xc0
Jul 16 21:20:56  [<c032a005>] _spin_unlock+0x5/0x20
Jul 16 21:20:56  [<c0173253>] get_unused_fd+0xa3/0xc0
Jul 16 21:20:56  [<c017e888>] do_path_lookup+0x78/0x1c0
Jul 16 21:20:56  [<c0175c5c>] file_move+0x1c/0x60
Jul 16 21:20:56  [<c0158cbf>] __alloc_pages+0x4f/0x300
Jul 16 21:20:56  [<c0173525>] nameidata_to_filp+0x35/0x40
Jul 16 21:20:56  [<c01abd87>] proc_info_read+0x87/0xc0
Jul 16 21:20:56  [<c0175401>] vfs_read+0xa1/0x130
Jul 16 21:20:56  [<c01abd00>] proc_info_read+0x0/0xc0
Jul 16 21:20:56  [<c0175931>] sys_read+0x41/0x70
Jul 16 21:20:56  [<c010436a>] syscall_call+0x7/0xb
Jul 16 21:20:56  =======================
Jul 16 21:20:56 Code: 2c 01 00 00 8b 4a 54 89 88 30 01 00 00 8b 4a 58
89 88 34 01 00 00 8b 52 5c 89 90 38 01 00 00 c3 90 8d b4 26 00 00 00
00 8b 48 04 <8b> 51 7c c1 e2 14 0b 91 80 00 00 00 8b 48 08 01 ca 89 d0
c3 89
Jul 16 21:20:56 EIP: [<c0260c23>] tty_devnum+0x3/0x20 SS:ESP 0068:c94a3db8
Jul 16 21:20:56 note: top[6260] exited with preempt_count 2
Jul 16 21:20:56 BUG: sleeping function called from invalid context at
kernel/rwsem.c:20
Jul 16 21:20:56 in_atomic():1, irqs_disabled():0
Jul 16 21:20:56  [<c0140902>] down_read+0x12/0x20
Jul 16 21:20:56  [<c012aba5>] exit_mm+0x25/0xf0
Jul 16 21:20:56  [<c012c276>] do_exit+0xf6/0x7c0
Jul 16 21:20:56  [<c01213a8>] __wake_up+0x38/0x50
Jul 16 21:20:56  [<c0105a70>] do_trap+0x0/0x100
Jul 16 21:20:56  [<c011fa54>] do_page_fault+0x314/0x680
Jul 16 21:20:56  [<c021b5ab>] vsnprintf+0x2db/0x590
Jul 16 21:20:56  [<c011f740>] do_page_fault+0x0/0x680
Jul 16 21:20:56  [<c032a2ca>] error_code+0x72/0x78
Jul 16 21:20:56  [<c0260c23>] tty_devnum+0x3/0x20
Jul 16 21:20:56  [<c01adca0>] do_task_stat+0x120/0x9a0
Jul 16 21:20:56  [<c0186934>] dput+0x94/0x130
Jul 16 21:20:56  [<c017e42d>] __link_path_walk+0xacd/0xc80
Jul 16 21:20:56  [<c01f5340>] ext3_permission+0x0/0x10
Jul 16 21:20:56  [<c0186934>] dput+0x94/0x130
Jul 16 21:20:56  [<c017e42d>] __link_path_walk+0xacd/0xc80
Jul 16 21:20:56  [<c018aef3>] mntput_no_expire+0x13/0x60
Jul 16 21:20:56  [<c017e645>] link_path_walk+0x65/0xc0
Jul 16 21:20:56  [<c032a005>] _spin_unlock+0x5/0x20
Jul 16 21:20:56  [<c0173253>] get_unused_fd+0xa3/0xc0
Jul 16 21:20:56  [<c017e888>] do_path_lookup+0x78/0x1c0
Jul 16 21:20:56  [<c0175c5c>] file_move+0x1c/0x60
Jul 16 21:20:56  [<c0158cbf>] __alloc_pages+0x4f/0x300
Jul 16 21:20:56  [<c0173525>] nameidata_to_filp+0x35/0x40
Jul 16 21:20:56  [<c01abd87>] proc_info_read+0x87/0xc0
Jul 16 21:20:56  [<c0175401>] vfs_read+0xa1/0x130
Jul 16 21:20:56  [<c01abd00>] proc_info_read+0x0/0xc0
Jul 16 21:20:56  [<c0175931>] sys_read+0x41/0x70
Jul 16 21:20:56  [<c010436a>] syscall_call+0x7/0xb
Jul 16 21:20:56  =======================
Jul 16 21:20:56 BUG: scheduling while atomic: top/0x10000002/6260
Jul 16 21:20:56  [<c03276c3>] __sched_text_start+0x4e3/0x890
Jul 16 21:20:56  [<c0129341>] release_console_sem+0x1d1/0x1f0
Jul 16 21:20:56  [<c026ecc0>] vt_console_print+0x0/0x2c0
Jul 16 21:20:56  [<c0128f5e>] __call_console_drivers+0x5e/0x70
Jul 16 21:20:56  [<c0129341>] release_console_sem+0x1d1/0x1f0
Jul 16 21:20:56  [<c0123fe5>] __cond_resched+0x25/0x40
Jul 16 21:20:56  [<c03281ca>] cond_resched+0x2a/0x40
Jul 16 21:20:56  [<c0160d52>] unmap_vmas+0x5c2/0x610
Jul 16 21:20:56  [<c01052ea>] print_trace_address+0x1a/0x30
Jul 16 21:20:56  [<c01646be>] exit_mmap+0x7e/0x120
Jul 16 21:20:56  [<c0126db2>] mmput+0x42/0xc0
Jul 16 21:20:56  [<c012c276>] do_exit+0xf6/0x7c0
Jul 16 21:20:56  [<c01213a8>] __wake_up+0x38/0x50
Jul 16 21:20:56  [<c0105a70>] do_trap+0x0/0x100
Jul 16 21:20:56  [<c011fa54>] do_page_fault+0x314/0x680
Jul 16 21:20:56  [<c021b5ab>] vsnprintf+0x2db/0x590
Jul 16 21:20:56  [<c011f740>] do_page_fault+0x0/0x680
Jul 16 21:20:56  [<c032a2ca>] error_code+0x72/0x78
Jul 16 21:20:56  [<c0260c23>] tty_devnum+0x3/0x20
Jul 16 21:20:56  [<c01adca0>] do_task_stat+0x120/0x9a0
Jul 16 21:20:56  [<c0186934>] dput+0x94/0x130
Jul 16 21:20:56  [<c017e42d>] __link_path_walk+0xacd/0xc80
Jul 16 21:20:56  [<c01f5340>] ext3_permission+0x0/0x10
Jul 16 21:20:56  [<c0186934>] dput+0x94/0x130
Jul 16 21:20:56  [<c017e42d>] __link_path_walk+0xacd/0xc80
Jul 16 21:20:56  [<c018aef3>] mntput_no_expire+0x13/0x60
Jul 16 21:20:56  [<c017e645>] link_path_walk+0x65/0xc0
Jul 16 21:20:56  [<c032a005>] _spin_unlock+0x5/0x20
Jul 16 21:20:56  [<c0173253>] get_unused_fd+0xa3/0xc0
Jul 16 21:20:56  [<c017e888>] do_path_lookup+0x78/0x1c0
Jul 16 21:20:56  [<c0175c5c>] file_move+0x1c/0x60
Jul 16 21:20:56  [<c0158cbf>] __alloc_pages+0x4f/0x300
Jul 16 21:20:56  [<c0173525>] nameidata_to_filp+0x35/0x40
Jul 16 21:20:56  [<c01abd87>] proc_info_read+0x87/0xc0
Jul 16 21:20:56  [<c0175401>] vfs_read+0xa1/0x130
Jul 16 21:20:56  [<c01abd00>] proc_info_read+0x0/0xc0
Jul 16 21:20:56  [<c0175931>] sys_read+0x41/0x70
Jul 16 21:20:56  [<c010436a>] syscall_call+0x7/0xb
Jul 16 21:20:56  =======================
Jul 16 21:27:50 klogd 1.4.1#21, log source = /proc/kmsg started.
Jul 16 21:27:50 Linux version 2.6.22.1 (root@kabi) (gcc version 4.1.3
20070629 (prerelease) (Debian 4.1.2-13)) #1 SMP PREEMPT Sun Jul 15
17:35:15 CEST 2007
Jul 16 21:27:50 BIOS-provided physical RAM map:
Jul 16 21:27:50  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Jul 16 21:27:50  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Jul 16 21:27:50  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
Jul 16 21:27:50  BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
Jul 16 21:27:50  BIOS-e820: 000000001fff0000 - 000000001fff3000 (ACPI NVS)
Jul 16 21:27:50  BIOS-e820: 000000001fff3000 - 0000000020000000 (ACPI data)
Jul 16 21:27:50  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
Jul 16 21:27:50  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Jul 16 21:27:50  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
Jul 16 21:27:50 0MB HIGHMEM available.
Jul 16 21:27:50 511MB LOWMEM available.
Jul 16 21:27:50 found SMP MP-table at 000f5ae0
Jul 16 21:27:50 Entering add_active_range(0, 0, 131056) 0 entries of 256 used
Jul 16 21:27:50 Zone PFN ranges:
Jul 16 21:27:50   DMA             0 ->     4096
Jul 16 21:27:50   Normal       4096 ->   131056
Jul 16 21:27:50   HighMem    131056 ->   131056
Jul 16 21:27:50 early_node_map[1] active PFN ranges
 Jul 16 21:27:50     0:        0 ->   131056
Jul 16 21:27:50 On node 0 totalpages: 131056
Jul 16 21:27:50   DMA zone: 44 pages used for memmap
Jul 16 21:27:50   DMA zone: 0 pages reserved
Jul 16 21:27:50   DMA zone: 4052 pages, LIFO batch:0
Jul 16 21:27:50   Normal zone: 1363 pages used for memmap
Jul 16 21:27:50   Normal zone: 125597 pages, LIFO batch:31
Jul 16 21:27:50   HighMem zone: 0 pages used for memmap
Jul 16 21:27:50 DMI 2.2 present.
 Jul 16 21:27:50 ACPI: RSDP 000F7370, 0014 (r0 ABIT  )
Jul 16 21:27:50 ACPI: RSDT 1FFF3000, 002C (r1 ABIT   AWRDACPI 42302E31
AWRD        0)
Jul 16 21:27:50 ACPI: FACP 1FFF3040, 0074 (r1 ABIT   AWRDACPI 42302E31
AWRD        0)
Jul 16 21:27:50 ACPI: DSDT 1FFF30C0, 21B2 (r1 ABIT   AWRDACPI     1000
INTL 20031203)
Jul 16 21:27:50 ACPI: FACS 1FFF0000, 0040
Jul 16 21:27:50 ACPI: APIC 1FFF5280, 005C (r1 ABIT                   0
            0)
Jul 16 21:27:50 ACPI: PM-Timer IO Port: 0x4008
Jul 16 21:27:50 ACPI: Local APIC address 0xfee00000
Jul 16 21:27:50 ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Jul 16 21:27:50 Processor #0 6:6 APIC version 17
Jul 16 21:27:50 ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Jul 16 21:27:50 Processor #1 6:6 APIC version 17
Jul 16 21:27:50 ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
Jul 16 21:27:50 IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
Jul 16 21:27:50 ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl edge)
Jul 16 21:27:50 ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 dfl dfl)
Jul 16 21:27:50 ACPI: IRQ0 used by override.
Jul 16 21:27:50 ACPI: IRQ2 used by override.
Jul 16 21:27:50 ACPI: IRQ9 used by override.
Jul 16 21:27:50 Enabling APIC mode:  Flat.  Using 1 I/O APICs
Jul 16 21:27:50 Using ACPI (MADT) for SMP configuration information
Jul 16 21:27:50 Allocating PCI resources starting at 30000000 (gap:
20000000:dec00000)
Jul 16 21:27:50 Built 1 zonelists.  Total pages: 129649
Jul 16 21:27:50 Kernel command line: root=/dev/hdb1 vga=0x305 4
Jul 16 21:27:50 mapped APIC to ffffd000 (fee00000)
Jul 16 21:27:50 mapped IOAPIC to ffffc000 (fec00000)
Jul 16 21:27:50 Enabling fast FPU save and restore... done.
Jul 16 21:27:50 Initializing CPU#0
Jul 16 21:27:50 PID hash table entries: 2048 (order: 11, 8192 bytes)
Jul 16 21:27:50 Detected 450.011 MHz processor.
Jul 16 21:27:50 Console: colour dummy device 80x25
Jul 16 21:27:50 Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Jul 16 21:27:50 Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
 Jul 16 21:27:50 Memory: 513884k/524224k available (2220k kernel code,
9872k reserved, 929k data, 248k init, 0k highmem)
Jul 16 21:27:50 virtual kernel memory layout:
Jul 16 21:27:50     fixmap  : 0xfff4e000 - 0xfffff000   ( 708 kB)
Jul 16 21:27:50     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
Jul 16 21:27:50     vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)
Jul 16 21:27:50     lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
Jul 16 21:27:50       .init : 0xc041a000 - 0xc0458000   ( 248 kB)
Jul 16 21:27:50       .data : 0xc032b0a7 - 0xc0413804   ( 929 kB)
Jul 16 21:27:50       .text : 0xc0100000 - 0xc032b0a7   (2220 kB)
Jul 16 21:27:50 Checking if this processor honours the WP bit even in
supervisor mode... Ok.
Jul 16 21:27:50 Calibrating delay using timer specific routine..
901.30 BogoMIPS (lpj=1501282)
Jul 16 21:27:50 Mount-cache hash table entries: 512
Jul 16 21:27:50 CPU: After generic identify, caps: 0183fbff 00000000
00000000 00000000 00000000 00000000 00000000
Jul 16 21:27:50 CPU: L1 I cache: 16K, L1 D cache: 16K
Jul 16 21:27:50 CPU: L2 cache: 128K
Jul 16 21:27:50 CPU: After all inits, caps: 0183fbff 00000000 00000000
00000040 00000000 00000000 00000000
Jul 16 21:27:50 Intel machine check architecture supported.
Jul 16 21:27:50 Intel machine check reporting enabled on CPU#0.
Jul 16 21:27:50 Compat vDSO mapped to ffffe000.
Jul 16 21:27:50 Checking 'hlt' instruction... OK.
Jul 16 21:27:50 SMP alternatives: switching to UP code
Jul 16 21:27:50 ACPI: Core revision 20070126
Jul 16 21:27:50 CPU0: Intel Celeron (Mendocino) stepping 05
Jul 16 21:27:50 SMP alternatives: switching to SMP code
Jul 16 21:27:50 Booting processor 1/1 eip 3000
 Jul 16 21:27:50 Initializing CPU#1
Jul 16 21:27:50 Calibrating delay using timer specific routine..
900.46 BogoMIPS (lpj=1499950)
Jul 16 21:27:50 CPU: After generic identify, caps: 0183fbff 00000000
00000000 00000000 00000000 00000000 00000000
Jul 16 21:27:50 CPU: L1 I cache: 16K, L1 D cache: 16K
Jul 16 21:27:50 CPU: L2 cache: 128K
Jul 16 21:27:50 CPU: After all inits, caps: 0183fbff 00000000 00000000
00000040 00000000 00000000 00000000
Jul 16 21:27:50 Intel machine check architecture supported.
Jul 16 21:27:50 Intel machine check reporting enabled on CPU#1.
Jul 16 21:27:50 CPU1: Intel Celeron (Mendocino) stepping 05
Jul 16 21:27:50 Total of 2 processors activated (1801.77 BogoMIPS).
Jul 16 21:27:50 ENABLING IO-APIC IRQs
Jul 16 21:27:50 ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
Jul 16 21:27:50 checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Jul 16 21:27:50 Brought up 2 CPUs
Jul 16 21:27:50 migration_cost=1507
Jul 16 21:27:50 Booting paravirtualized kernel on bare hardware
Jul 16 21:27:50 NET: Registered protocol family 16
Jul 16 21:27:50 ACPI: bus type pci registered
Jul 16 21:27:50 PCI: PCI BIOS revision 2.10 entry at 0xfb5c0, last bus=1
Jul 16 21:27:50 PCI: Using configuration type 1
Jul 16 21:27:50 Setting up standard PCI resources
Jul 16 21:27:50 mtrr: your CPUs had inconsistent fixed MTRR settings
Jul 16 21:27:50 mtrr: probably your BIOS does not setup all CPUs.
Jul 16 21:27:50 mtrr: corrected configuration.
Jul 16 21:27:50 ACPI: Interpreter enabled
Jul 16 21:27:50 ACPI: (supports S0 S1 S4 S5)
Jul 16 21:27:50 ACPI: Using IOAPIC for interrupt routing
Jul 16 21:27:50 ACPI: PCI Root Bridge [PCI0] (0000:00)
Jul 16 21:27:50 PCI: Probing PCI hardware (bus 00)
Jul 16 21:27:50 * Found PM-Timer Bug on the chipset. Due to
workarounds for a bug,
Jul 16 21:27:50 * this clock source is slow. Consider trying other
clock sources
Jul 16 21:27:50 PCI quirk: region 4000-403f claimed by PIIX4 ACPI
Jul 16 21:27:50 PCI quirk: region 5000-500f claimed by PIIX4 SMB
Jul 16 21:27:50 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Jul 16 21:27:50 ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11
12 14 15)
Jul 16 21:27:50 ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
Jul 16 21:27:50 ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11 12 14 15)
Jul 16 21:27:50 ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 10 11
12 14 15)
Jul 16 21:27:50 Linux Plug and Play Support v0.97 (c) Adam Belay
Jul 16 21:27:50 pnp: PnP ACPI init
Jul 16 21:27:50 ACPI: bus type pnp registered
Jul 16 21:27:50 pnp: PnP ACPI: found 10 devices
Jul 16 21:27:50 ACPI: ACPI bus type pnp unregistered
Jul 16 21:27:50 PnPBIOS: Disabled by ACPI PNP
Jul 16 21:27:50 PCI: Using ACPI for IRQ routing
Jul 16 21:27:50 PCI: If a device doesn't work, try "pci=routeirq".  If
it helps, post a report
Jul 16 21:27:50 ACPI: RTC can wake from S4
Jul 16 21:27:50 Time: tsc clocksource has been installed.
Jul 16 21:27:50 pnp: 00:00: iomem range 0xf0000-0xf3fff could not be reserved
Jul 16 21:27:50 pnp: 00:00: iomem range 0xf4000-0xf7fff could not be reserved
Jul 16 21:27:50 pnp: 00:00: iomem range 0xf8000-0xfbfff could not be reserved
Jul 16 21:27:50 pnp: 00:00: iomem range 0xfc000-0xfffff could not be reserved
Jul 16 21:27:50 PCI: Bridge: 0000:00:01.0
Jul 16 21:27:50   IO window: disabled.
Jul 16 21:27:50   MEM window: d4000000-d7ffffff
Jul 16 21:27:50   PREFETCH window: d8000000-d9ffffff
Jul 16 21:27:50 NET: Registered protocol family 2
Jul 16 21:27:50 IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
Jul 16 21:27:50 TCP established hash table entries: 16384 (order: 6,
458752 bytes)
Jul 16 21:27:50 TCP bind hash table entries: 16384 (order: 6, 393216 bytes)
Jul 16 21:27:50 TCP: Hash tables configured (established 16384 bind 16384)
Jul 16 21:27:50 TCP reno registered
Jul 16 21:27:50 Machine check exception polling timer started.
Jul 16 21:27:50 VFS: Disk quotas dquot_6.5.1
Jul 16 21:27:50 Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Jul 16 21:27:50 io scheduler noop registered (default)
Jul 16 21:27:50 Limiting direct PCI/PCI transfers.
Jul 16 21:27:50 pci 0000:00:07.2: uhci_check_and_reset_hc: legsup = 0x2000
Jul 16 21:27:50 pci 0000:00: 07.2: Performing full reset
Jul 16 21:27:50 Boot video device is 0000:01:00.0
Jul 16 21:27:50 vesafb: framebuffer at 0xd8000000, mapped to
0xe0880000, using 1536k, total 32768k
Jul 16 21:27:50 vesafb: mode is 1024x768x8, linelength=1024, pages=18
Jul 16 21:27:50 vesafb: protected mode interface info at c000:7d60
Jul 16 21:27:50 vesafb: pmi: set display start = c00c7df2, set palette
= c00c7e5e
Jul 16 21:27:50 vesafb: pmi: ports = 3de 3df
Jul 16 21:27:50 vesafb: scrolling: redraw
Jul 16 21:27:50 vesafb: Pseudocolor: size=8:8:8:8, shift=0:0:0:0
Jul 16 21:27:50 Console: switching to colour frame buffer device 128x48
Jul 16 21:27:50 fb0: VESA VGA frame buffer device
Jul 16 21:27:50 isapnp: Scanning for PnP cards...
Jul 16 21:27:50 isapnp: No Plug & Play device found
Jul 16 21:27:50 Switched to high resolution mode on CPU 1
Jul 16 21:27:50 Switched to high resolution mode on CPU 0
Jul 16 21:27:50 Uniform Multi-Platform E-IDE driver Revision:  7.00alpha2
Jul 16 21:27:50 ide: Assuming 33MHz system bus speed for PIO modes;
override with idebus=xx
Jul 16 21:27:50 PIIX4: IDE controller at PCI slot 0000:00:07.1
Jul 16 21:27:50 PIIX4: chipset revision 1
Jul 16 21:27:50 PIIX4: not 100%% native mode: will probe irqs later
Jul 16 21:27:50     ide0: BM-DMA at 0xf000-0xf007, BIOS settings:
hda:DMA, hdb:DMA
Jul 16 21:27:50     ide1: BM-DMA at 0xf008-0xf00f, BIOS settings:
hdc:pio, hdd:pio
Jul 16 21:27:50 Probing IDE interface ide0...
Jul 16 21:27:50 hda: ST3120026A, ATA DISK drive
Jul 16 21:27:50 hdb: IBM-DTLA-307030, ATA DISK drive
Jul 16 21:27:50 hda: selected mode 0x42
Jul 16 21:27:50 hdb: selected mode 0x42
Jul 16 21:27:50 ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Jul 16 21:27:50 Probing IDE interface ide1...
Jul 16 21:27:50 HPT366: onboard version of chipset, pin1=1 pin2=2
Jul 16 21:27:50 HPT366: IDE controller at PCI slot 0000:00:13.0
Jul 16 21:27:50 ACPI: PCI Interrupt 0000:00: 13.0[A] -> GSI 18 (level,
low) -> IRQ 16
Jul 16 21:27:50 HPT366: chipset revision 1
Jul 16 21:27:50 HPT366: using 33 MHz PCI clock
Jul 16 21:27:50 HPT366: 100%% native mode on irq 16
Jul 16 21:27:50     ide2: BM-DMA at 0xd800-0xd807, BIOS settings:
hde:pio, hdf:pio
Jul 16 21:27:50 ACPI: PCI Interrupt 0000:00:13.1[B] -> GSI 18 (level,
low) -> IRQ 16
Jul 16 21:27:50 HPT366: using 33 MHz PCI clock
Jul 16 21:27:50     ide3: BM-DMA at 0xe400-0xe407, BIOS settings:
hdg:pio, hdh:pio
Jul 16 21:27:50 Probing IDE interface ide2...
Jul 16 21:27:51 Probing IDE interface ide3...
Jul 16 21:27:51 Probing IDE interface ide1...
Jul 16 21:27:51 Probing IDE interface ide2...
Jul 16 21:27:51 Probing IDE interface ide3...
Jul 16 21:27:51 hda: max request size: 512KiB
Jul 16 21:27:51 hda: 234441648 sectors (120034 MB) w/8192KiB Cache,
CHS=16383/255/63, UDMA(33)
Jul 16 21:27:51 hda: cache flushes supported
Jul 16 21:27:51  hda: hda1 hda2 hda3 < hda5 hda6 hda7 hda8 >
Jul 16 21:27:51 hdb: max request size: 128KiB
Jul 16 21:27:51 hdb: 60036480 sectors (30738 MB) w/1916KiB Cache,
CHS=59560/16/63, UDMA(33)
Jul 16 21:27:51 hdb: cache flushes not supported
Jul 16 21:27:51  hdb: hdb1 hdb2 < hdb5 hdb6 hdb7 hdb8 hdb9 >
Jul 16 21:27:51 PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at
0x60,0x64 irq 1,12
Jul 16 21:27:51 serio: i8042 KBD port at 0x60,0x64 irq 1
Jul 16 21:27:51 serio: i8042 AUX port at 0x60,0x64 irq 12
Jul 16 21:27:51 mice: PS/2 mouse device common for all mice
Jul 16 21:27:51 input: AT Translated Set 2 keyboard as /class/input/input0
Jul 16 21:27:51 input: ImPS/2 Generic Wheel Mouse as /class/input/input1
Jul 16 21:27:51 md: raid1 personality registered for level 1
 Jul 16 21:27:51 TCP cubic registered
Jul 16 21:27:51 NET: Registered protocol family 1
Jul 16 21:27:51 NET: Registered protocol family 17
Jul 16 21:27:51 Using IPI No-Shortcut mode
Jul 16 21:27:51 md: Autodetecting RAID arrays.
Jul 16 21:27:51 md: autorun ...
Jul 16 21:27:51 md: ... autorun DONE.
Jul 16 21:27:51 EXT3-fs: INFO: recovery required on readonly filesystem.
Jul 16 21:27:51 EXT3-fs: write access will be enabled during recovery.
Jul 16 21:27:51 kjournald starting.  Commit interval 5 seconds
Jul 16 21:27:51 EXT3-fs: recovery complete.
Jul 16 21:27:51 EXT3-fs: mounted filesystem with ordered data mode.
Jul 16 21:27:51 VFS: Mounted root (ext3 filesystem) readonly.
Jul 16 21:27:51 Freeing unused kernel memory: 248k freed
Jul 16 21:27:51 Write protecting the kernel read-only data: 763k
Jul 16 21:27:51 Linux agpgart interface v0.102 (c) Dave Jones
Jul 16 21:27:51 agpgart: Detected an Intel 440BX Chipset.
Jul 16 21:27:51 agpgart: AGP aperture is 64M @ 0xd0000000
Jul 16 21:27:51 ath_hal: module license 'Proprietary' taints kernel.
Jul 16 21:27:51 ath_hal: 0.9.30.13 (AR5210, AR5211, AR5212, AR5416,
RF5111, RF5112, RF2413, RF5413, RF2133)
Jul 16 21:27:51 wlan: 0.8.4.2 (svn r2523)
Jul 16 21:27:51 usbcore: registered new interface driver usbfs
Jul 16 21:27:51 usbcore: registered new interface driver hub
Jul 16 21:27:51 usbcore: registered new device driver usb
Jul 16 21:27:51 SCSI subsystem initialized
Jul 16 21:27:51 gameport: EMU10K1 is pci0000:00:0b.1/gameport0, io
0xc800, speed 1217kHz
Jul 16 21:27:51 ath_pci: 0.9.4.5 (svn r2523)
Jul 16 21:27:51 ACPI: PCI Interrupt 0000:00: 09.0[A] -> GSI 19 (level,
low) -> IRQ 17
Jul 16 21:27:51 8139too Fast Ethernet driver 0.9.28
Jul 16 21:27:51 Real Time Clock Driver v1.12ac
Jul 16 21:27:51 Linux video capture interface: v2.00
Jul 16 21:27:51 USB Universal Host Controller Interface driver  v3.0
Jul 16 21:27:51 Floppy drive(s): fd0 is 1.44M
Jul 16 21:27:51 FDC 0 is a post-1991 82077
Jul 16 21:27:51 HAL returned 27 channels.
Jul 16 21:27:51 Channel 1 (2412 MHz) Max Tx Power 16 dBm (hw limited)
[16 hw 20 reg] Flags CF_CCK CF_2GHZ
Jul 16 21:27:51 Channel 1 (2412 MHz) Max Tx Power 16 dBm (hw limited)
[16 hw 20 reg] Flags CF_OFDM CF_2GHZ
Jul 16 21:27:51 Channel 2 (2417 MHz) Max Tx Power 16 dBm (hw limited)
[16 hw 20 reg] Flags CF_CCK CF_2GHZ
 Jul 16 21:27:51 Channel 2 (2417 MHz) Max Tx Power 16 dBm (hw limited)
[16 hw 20 reg] Flags CF_OFDM CF_2GHZ
Jul 16 21:27:51 Channel 3 (2422 MHz) Max Tx Power 16 dBm (hw limited)
[16 hw 20 reg] Flags CF_CCK CF_2GHZ
Jul 16 21:27:51 Channel 3 (2422 MHz) Max Tx Power 16 dBm (hw limited)
[16 hw 20 reg] Flags CF_OFDM CF_2GHZ
Jul 16 21:27:51 Channel 4 (2427 MHz) Max Tx Power 16 dBm (hw limited)
[16 hw 20 reg] Flags CF_CCK CF_2GHZ
Jul 16 21:27:51 Channel 4 (2427 MHz) Max Tx Power 16 dBm (hw limited)
[16 hw 20 reg] Flags CF_OFDM CF_2GHZ
 Jul 16 21:27:51 Channel 5 (2432 MHz) Max Tx Power 16 dBm (hw limited)
[16 hw 20 reg] Flags CF_CCK CF_2GHZ
Jul 16 21:27:51 Channel 5 (2432 MHz) Max Tx Power 16 dBm (hw limited)
[16 hw 20 reg] Flags CF_OFDM CF_2GHZ
Jul 16 21:27:51 Channel 6 (2437 MHz) Max Tx Power 16 dBm (hw limited)
[16 hw 20 reg] Flags CF_CCK CF_2GHZ
Jul 16 21:27:51 Channel 6 (2437 MHz) Max Tx Power 16 dBm (hw limited)
[16 hw 20 reg] Flags CF_OFDM CF_2GHZ
Jul 16 21:27:51 Channel 7 (2442 MHz) Max Tx Power 16 dBm (hw limited)
[16 hw 20 reg] Flags CF_CCK CF_2GHZ
 Jul 16 21:27:51 Channel 7 (2442 MHz) Max Tx Power 16 dBm (hw limited)
[16 hw 20 reg] Flags CF_OFDM CF_2GHZ
Jul 16 21:27:51 Channel 8 (2447 MHz) Max Tx Power 16 dBm (hw limited)
[16 hw 20 reg] Flags CF_CCK CF_2GHZ
Jul 16 21:27:51 libata version  2.21 loaded.
Jul 16 21:27:51 Channel 8 (2447 MHz) Max Tx Power 16 dBm (hw limited)
[16 hw 20 reg] Flags CF_OFDM CF_2GHZ
Jul 16 21:27:51 Channel 9 (2452 MHz) Max Tx Power 16 dBm (hw limited)
[16 hw 20 reg] Flags CF_CCK CF_2GHZ
Jul 16 21:27:51 Channel 9 (2452 MHz) Max Tx Power 16 dBm (hw limited)
[16 hw 20 reg] Flags CF_OFDM CF_2GHZ
Jul 16 21:27:51 Channel 10 (2457 MHz) Max Tx Power 16 dBm (hw limited)
[16 hw 20 reg] Flags CF_CCK CF_2GHZ
 Jul 16 21:27:51 Channel 10 (2457 MHz) Max Tx Power 16 dBm (hw
limited) [16 hw 20 reg] Flags CF_OFDM CF_2GHZ
Jul 16 21:27:51 Channel 11 (2462 MHz) Max Tx Power 16 dBm (hw limited)
[16 hw 20 reg] Flags CF_CCK CF_2GHZ
 Jul 16 21:27:51 Channel 11 (2462 MHz) Max Tx Power 16 dBm (hw
limited) [16 hw 20 reg] Flags CF_OFDM CF_2GHZ
Jul 16 21:27:51 Channel 12 (2467 MHz) Max Tx Power 15 dBm (hw limited)
[15 hw 20 reg] Flags CF_CCK CF_2GHZ
 Jul 16 21:27:51 Channel 12 (2467 MHz) Max Tx Power 15 dBm (hw
limited) [15 hw 20 reg] Flags CF_OFDM CF_2GHZ
Jul 16 21:27:51 Channel 13 (2472 MHz) Max Tx Power 9 dBm (hw limited)
[9 hw 20 reg] Flags CF_CCK CF_2GHZ
Jul 16 21:27:51 Channel 13 (2472 MHz) Max Tx Power 9 dBm (hw limited)
[9 hw 20 reg] Flags CF_OFDM CF_2GHZ
Jul 16 21:27:51 Channel 14 (2484 MHz) Max Tx Power 17 dBm (hw limited)
[17 hw 20 reg] Flags CF_CCK CF_2GHZ
Jul 16 21:27:51 ath_pci: switching rfkill capability off
Jul 16 21:27:51 ath_pci: ath_pci: switching per-packet transmit power
control off
Jul 16 21:27:51 bttv: driver version 0.9.17 loaded
Jul 16 21:27:51 bttv: using 8 buffers with 2080k (520 pages) each for capture
Jul 16 21:27:51 bttv: Host bridge needs ETBF enabled.
Jul 16 21:27:51 ath_rate_sample:  1.2 (svn r2523)
Jul 16 21:27:51 wifi0: 11b rates: 1Mbps 2Mbps 5.5Mbps 11Mbps
Jul 16 21:27:51 wifi0: 11g rates: 1Mbps 2Mbps 5.5Mbps 11Mbps 6Mbps
9Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
Jul 16 21:27:51 wifi0: H/W encryption support: WEP AES AES_CCM TKIP
Jul 16 21:27:51 wifi0: mac 7.8 phy 4.5 radio 5.6
Jul 16 21:27:51 wifi0: Use hw queue 1 for WME_AC_BE traffic
Jul 16 21:27:51 wifi0: Use hw queue 0 for WME_AC_BK traffic
Jul 16 21:27:51 wifi0: Use hw queue 2 for WME_AC_VI traffic
Jul 16 21:27:51 wifi0: Use hw queue 3 for WME_AC_VO traffic
Jul 16 21:27:51 wifi0: Use hw queue 8 for CAB traffic
Jul 16 21:27:51 wifi0: Use hw queue 9 for beacons
Jul 16 21:27:51 wifi0: Atheros 5212: mem=0xdb000000, irq=17
Jul 16 21:27:51 ACPI: PCI Interrupt 0000:00:0d.0[A] -> GSI 17 (level,
low) -> IRQ 18
Jul 16 21:27:51 eth0: RealTek RTL8139 at 0xe0bc2000, 00:50:fc:fb:58:27, IRQ 18
Jul 16 21:27:51 eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
Jul 16 21:27:51 ACPI: PCI Interrupt 0000:00:07.2[D] -> GSI 19 (level,
low) -> IRQ 17
Jul 16 21:27:51 uhci_hcd 0000:00:07.2: UHCI Host Controller
Jul 16 21:27:51 drivers/usb/core/inode.c: creating file 'devices'
Jul 16 21:27:51 drivers/usb/core/inode.c: creating file '001'
Jul 16 21:27:51 uhci_hcd 0000:00:07.2: new USB bus registered,
assigned bus number 1
Jul 16 21:27:51 uhci_hcd 0000:00:07.2: detected 2 ports
 Jul 16 21:27:51 uhci_hcd 0000:00:07.2: uhci_check_and_reset_hc: cmd = 0x0000
Jul 16 21:27:51 uhci_hcd 0000:00:07.2: Performing full reset
Jul 16 21:27:51 uhci_hcd 0000:00:07.2: irq 17, io base 0x0000c000
Jul 16 21:27:51 usb usb1: default language 0x0409
Jul 16 21:27:51 usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
Jul 16 21:27:51 usb usb1: Product: UHCI Host Controller
Jul 16 21:27:51 usb usb1: Manufacturer: Linux 2.6.22.1  uhci_hcd
Jul 16 21:27:51 usb usb1: SerialNumber: 0000:00:07.2
Jul 16 21:27:51 usb usb1: uevent
Jul 16 21:27:51 usb usb1: usb_probe_device
Jul 16 21:27:51 usb usb1: configuration #1 chosen from 1 choice
 Jul 16 21:27:51 usb usb1: adding 1-0:1.0 (config #1, interface 0)
Jul 16 21:27:51 usb 1-0:1.0: uevent
Jul 16 21:27:51 usb 1-0:1.0: uevent
Jul 16 21:27:51 hub 1-0:1.0: usb_probe_interface
Jul 16 21:27:51 hub 1-0: 1.0: usb_probe_interface - got id
Jul 16 21:27:51 hub 1-0:1.0: USB hub found
Jul 16 21:27:51 hub 1-0:1.0: 2 ports detected
Jul 16 21:27:51 hub 1-0:1.0: standalone hub
Jul 16 21:27:51 hub 1-0:1.0: no power switching (usb  1.0)
Jul 16 21:27:51 hub 1-0:1.0: individual port over-current protection
Jul 16 21:27:51 hub 1-0:1.0: power on to power good time: 2ms
Jul 16 21:27:51 hub 1-0:1.0: local power source is good
Jul 16 21:27:51 hub 1-0: 1.0: trying to enable port power on non-switchable hub
Jul 16 21:27:51 hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
Jul 16 21:27:51 drivers/usb/core/inode.c: creating file '001'
Jul 16 21:27:51 piix4_smbus 0000:00: 07.3: Found 0000:00:07.3 device
Jul 16 21:27:51 bttv: Bt8xx card found (0).
Jul 16 21:27:51 ACPI: PCI Interrupt 0000:00:0f.0[A] -> GSI 16 (level,
low) -> IRQ 19
Jul 16 21:27:51 bttv0: Bt878 (rev 17) at 0000:00: 0f.0, irq: 19,
latency: 32, mmio: 0xdb011000
Jul 16 21:27:51 bttv0: detected: AVerMedia TVPhone98 [card=41], PCI
subsystem ID is 1461:0003
Jul 16 21:27:51 bttv0: using: AVerMedia TVPhone 98 [card=41,autodetected]
 Jul 16 21:27:51 bttv0: enabling ETBF (430FX/VP3 compatibilty)
Jul 16 21:27:51 bttv0: gpio: en=00000000, out=00000000 in=000477c3 [init]
Jul 16 21:27:51 bttv0: Avermedia eeprom[0x0aff]: tuner=Unknown type
radio:yes remote control:yes
Jul 16 21:27:51 bttv0: using tuner=5
Jul 16 21:27:51 bttv0: i2c: checking for MSP34xx @ 0x80... not found
Jul 16 21:27:51 bttv0: i2c: checking for TDA9875 @ 0xb0... not found
Jul 16 21:27:51 bttv0: i2c: checking for TDA7432 @ 0x8a... not found
Jul 16 21:27:51 tvaudio 1-0042: tda9840 found @ 0x84 (bt878 #0 [sw])
Jul 16 21:27:51 bttv0: i2c: checking for TDA9887 @ 0x86... not found
Jul 16 21:27:51 tuner 1-0061: chip found @ 0xc2 (bt878 #0 [sw])
Jul 16 21:27:51 tuner 1-0061: type set to 5 (Philips PAL_BG (FI1216
and compatibles))
Jul 16 21:27:51 tuner 1-0061: type set to 5 (Philips PAL_BG (FI1216
and compatibles))
Jul 16 21:27:51 bttv0: registered device video0
Jul 16 21:27:51 bttv0: registered device vbi0
Jul 16 21:27:51 bttv0: registered device radio0
Jul 16 21:27:51 bttv0: PLL: 28636363 => 35468950 .. ok
Jul 16 21:27:51 input: bttv IR (card=41) as /class/input/input2
Jul 16 21:27:51 ACPI: PCI Interrupt 0000:00:0f.1[A] -> GSI 16 (level,
low) -> IRQ 19
Jul 16 21:27:51 PCI: Unable to reserve I/O region #5:100@e400 for
device 0000:00:13.1
Jul 16 21:27:51 pata_hpt366 0000:00:13.1: failed to request/iomap BAR4
Jul 16 21:27:51 scsi0 : pata_hpt366
Jul 16 21:27:51 scsi1 : pata_hpt366
Jul 16 21:27:51 ata1: PATA max UDMA/66 cmd 0x0001dc00 ctl 0x0001e002
bmdma 0x00000000 irq 16
Jul 16 21:27:51 ata2: DUMMY
Jul 16 21:27:51 ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 18 (level,
low) -> IRQ 16
Jul 16 21:27:51 usb usb1: suspend_rh (auto-stop)
Jul 16 21:27:51 Adding 781188k swap on /dev/hdb7.  Priority:-1
extents:1 across:781188k
Jul 16 21:27:51 EXT3 FS on hdb1, internal journal
Jul 16 21:27:51 hub 1-0: 1.0: hub_suspend
Jul 16 21:27:51 usb usb1: suspend_rh
Jul 16 21:27:51 usb usb1: usb auto-suspend
Jul 16 21:27:51 w83781d: Found a W83782D chip at 0x290
Jul 16 21:27:51 device-mapper: ioctl: 4.11.0-ioctl (2006-10-12)
initialised:  dm-devel@redhat.com
Jul 16 21:27:51 md: md0 stopped.
Jul 16 21:27:51 fuse init (API version 7.8)
Jul 16 21:27:51 ReiserFS: hdb5: found reiserfs format "3.6" with
standard journal
Jul 16 21:27:51 ReiserFS: hdb5: using ordered data mode
Jul 16 21:27:51 ReiserFS: hdb5: journal params: device hdb5, size
8192, journal first block 18, max trans len 1024, max batch 900, max
commit age 30, max trans age 30
Jul 16 21:27:51 ReiserFS: hdb5: checking transaction log (hdb5)
Jul 16 21:27:51 ReiserFS: hdb5: replayed 591 transactions in 45 seconds
Jul 16 21:27:51 ReiserFS: hdb5: Using r5 hash to sort names
Jul 16 21:27:51 ip_tables: (C) 2000-2006 Netfilter Core Team
Jul 16 21:27:51 NET: Registered protocol family 10
Jul 16 21:27:51 input: Power Button (FF) as /class/input/input3
Jul 16 21:27:51 ACPI: Power Button (FF) [PWRF]
Jul 16 21:27:51 input: Power Button (CM) as /class/input/input4
Jul 16 21:27:51 ACPI: Power Button (CM) [PWRB]
Jul 16 21:27:51 ACPI: Fan [FAN] (on)
Jul 16 21:27:51 ACPI: Thermal Zone [THRM] (48 C)
Jul 16 21:27:53 ath0: no IPv6 routers present
Jul 16 21:27:59 Installing knfsd (copyright (C) 1996  okir@monad.swb.de).
Jul 16 21:27:59 NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state
recovery directory
Jul 16 21:27:59 NFSD: starting 90-second grace period
Jul 16 21:28:52 APIC error on CPU1: 00(08)
Jul 16 21:30:02 [drm] Initialized drm 1.1.0 20060810
Jul 16 21:30:02 ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level,
low) -> IRQ 19
Jul 16 21:30:02 [drm] Initialized mga 3.2.1 20051102 on minor 0
 Jul 16 21:30:02 agpgart: Found an AGP 1.0 compliant device at 0000:00:00.0.
Jul 16 21:30:02 agpgart: Putting AGP V2 device at 0000:00:00.0 into 2x mode
Jul 16 21:30:02 agpgart: Putting AGP V2 device at 0000:01:00.0 into 2x mode
Jul 16 21:30:02 [drm] Initialized card for AGP DMA.


CONFIG_X86_32=y
CONFIG_GENERIC_TIME=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_X86=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=15
CONFIG_SYSFS_DEPRECATED=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_SYSCTL=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLAB=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=m
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=m
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_SMP=y
CONFIG_X86_PC=y
CONFIG_PARAVIRT=y
CONFIG_VMI=y
CONFIG_MPENTIUMIII=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_XADD=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_MODEL=4
CONFIG_HPET_TIMER=y
CONFIG_NR_CPUS=8
CONFIG_SCHED_MC=y
CONFIG_PREEMPT=y
CONFIG_PREEMPT_BKL=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
CONFIG_X86_MCE_P4THERMAL=y
CONFIG_VM86=y
CONFIG_MICROCODE=m
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_EDD=m
CONFIG_HIGHMEM4G=y
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ZONE_DMA_FLAG=1
CONFIG_NR_QUICK=1
CONFIG_MTRR=y
CONFIG_SECCOMP=y
CONFIG_HZ_300=y
CONFIG_HZ=300
CONFIG_KEXEC=y
CONFIG_PHYSICAL_START=0x100000
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_HOTPLUG_CPU=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_PM=y
CONFIG_PM_LEGACY=y
CONFIG_SUSPEND_SMP=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_SLEEP_PROC_FS=y
CONFIG_ACPI_PROCFS=y
 CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=m
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=m
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_SPEEDSTEP_CENTRINO=m
CONFIG_X86_SPEEDSTEP_CENTRINO_ACPI=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=m
CONFIG_X86_SPEEDSTEP_SMI=m
CONFIG_X86_P4_CLOCKMOD=m
CONFIG_X86_CPUFREQ_NFORCE2=m
CONFIG_X86_ACPI_CPUFREQ_PROC_INTF=y
CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_PCI=y
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_K8_NB=y
CONFIG_PCCARD=m
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y
CONFIG_PCMCIA_PROBE=y
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_AOUT=m
CONFIG_BINFMT_MISC=m
CONFIG_NET=y
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
CONFIG_SYN_COOKIES=y
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_IP_VS=m
CONFIG_IP_VS_TAB_BITS=12
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_FTP=m
CONFIG_IPV6=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_TUNNEL=m
CONFIG_NETFILTER=y
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK_ENABLED=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_IPRANGE=m
CONFIG_IP_NF_MATCH_TOS=m
CONFIG_IP_NF_MATCH_RECENT=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_MATCH_OWNER=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_SAME=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_TOS=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m
CONFIG_NET_SCHED=y
CONFIG_NET_SCH_FIFO=y
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_ESTIMATOR=y
CONFIG_NET_PKTGEN=m
CONFIG_IRDA=m
CONFIG_IRLAN=m
CONFIG_IRNET=m
CONFIG_IRCOMM=m
CONFIG_IRDA_ULTRA=y
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
CONFIG_IRTTY_SIR=m
CONFIG_USB_IRDA=m
CONFIG_NSC_FIR=m
CONFIG_SMC_IRCC_FIR=m
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m
CONFIG_BT_HCIUSB=m
CONFIG_FIB_RULES=y
CONFIG_CFG80211=m
CONFIG_WIRELESS_EXT=y
CONFIG_IEEE80211=m
CONFIG_IEEE80211_CRYPT_WEP=m
CONFIG_IEEE80211_CRYPT_CCMP=m
CONFIG_IEEE80211_CRYPT_TKIP=m
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=m
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
CONFIG_ISAPNP=y
CONFIG_PNPBIOS=y
CONFIG_PNPBIOS_PROC_FS=y
CONFIG_PNPACPI=y
CONFIG_BLK_DEV_FD=m
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
CONFIG_IDE=y
CONFIG_BLK_DEV_IDE=y
CONFIG_BLK_DEV_IDEDISK=y
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDEFLOPPY=m
CONFIG_BLK_DEV_IDESCSI=m
CONFIG_BLK_DEV_IDEACPI=y
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_CMD640=y
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_SHARE_IRQ=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
CONFIG_BLK_DEV_GENERIC=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AMD74XX=y
CONFIG_BLK_DEV_CMD64X=y
CONFIG_BLK_DEV_HPT366=y
CONFIG_BLK_DEV_PIIX=y
CONFIG_BLK_DEV_PDC202XX_OLD=y
CONFIG_PDC202XX_BURST=y
CONFIG_BLK_DEV_PDC202XX_NEW=y
CONFIG_BLK_DEV_VIA82CXXX=y
CONFIG_BLK_DEV_IDEDMA=y
CONFIG_SCSI=m
CONFIG_SCSI_PROC_FS=y
CONFIG_BLK_DEV_SD=m
CONFIG_BLK_DEV_SR=m
CONFIG_CHR_DEV_SG=m
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
 CONFIG_SCSI_WAIT_SCAN=m
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_ATA=m
CONFIG_ATA_ACPI=y
CONFIG_PATA_HPT366=m
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=y
CONFIG_MD_RAID456=m
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_MD_MULTIPATH=m
CONFIG_BLK_DEV_DM=m
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_EMC=m
CONFIG_DM_DELAY=m
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
CONFIG_FUSION_MAX_SGE=128
CONFIG_I2O=m
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_CONFIG=m
CONFIG_I2O_BUS=m
 CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=m
CONFIG_I2O_PROC=m
CONFIG_NETDEVICES=y
CONFIG_DUMMY=m
CONFIG_TUN=m
CONFIG_NET_ETHERNET=y
CONFIG_MII=m
CONFIG_NET_VENDOR_3COM=y
CONFIG_EL3=m
CONFIG_VORTEX=m
CONFIG_HP100=m
CONFIG_NET_PCI=y
CONFIG_EEPRO100=m
CONFIG_E100=m
CONFIG_NE2K_PCI=m
CONFIG_8139TOO=m
CONFIG_NETDEV_1000=y
CONFIG_E1000=m
CONFIG_TIGON3=m
CONFIG_BNX2=m
CONFIG_NETDEV_10000=y
 CONFIG_WLAN_80211=y
CONFIG_IPW2100=m
CONFIG_IPW2100_MONITOR=y
CONFIG_IPW2200=m
CONFIG_IPW2200_MONITOR=y
CONFIG_IPW2200_RADIOTAP=y
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
CONFIG_SLHC=m
CONFIG_SHAPER=m
CONFIG_INPUT=y
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1400
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=1050
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_SERIAL=y
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_LIBPS2=y
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_CYCLADES=m
CONFIG_SERIAL_8250=m
CONFIG_SERIAL_8250_PCI=m
CONFIG_SERIAL_8250_PNP=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_CORE=m
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_PRINTER=m
CONFIG_PPDEV=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
 CONFIG_NVRAM=m
CONFIG_RTC=m
CONFIG_GEN_RTC=m
CONFIG_GEN_RTC_X=y
CONFIG_AGP=m
CONFIG_AGP_ATI=m
CONFIG_AGP_AMD=m
CONFIG_AGP_AMD64=m
CONFIG_AGP_INTEL=m
CONFIG_AGP_NVIDIA=m
CONFIG_AGP_VIA=m
CONFIG_DRM=m
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=m
CONFIG_DRM_I810=m
CONFIG_DRM_I830=m
CONFIG_DRM_I915=m
CONFIG_DRM_MGA=m
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_I810=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_ISA=m
CONFIG_I2C_PARPORT=m
CONFIG_I2C_VIAPRO=m
CONFIG_SENSORS_PCF8574=m
CONFIG_SENSORS_PCF8591=m
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83627HF=m
 CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9875=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_CX25840=m
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m
CONFIG_VIDEO_VIVI=m
CONFIG_VIDEO_BT848=m
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_SAA7134_DVB=m
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_IVTV=m
CONFIG_V4L_USB_DRIVERS=y
CONFIG_RADIO_ADAPTERS=y
CONFIG_DVB_CORE=m
CONFIG_DVB_CAPTURE_DRIVERS=y
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_MT352=m
CONFIG_DVB_NXT200X=m
CONFIG_DVB_PLL=m
CONFIG_DVB_TDA826X=m
 CONFIG_DVB_TDA827X=m
CONFIG_DVB_ISL6421=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_BUF=m
CONFIG_VIDEO_BUF_DVB=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_DAB=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_DISPLAY_SUPPORT=m
CONFIG_VGASTATE=m
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=m
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
 CONFIG_FB_TILEBLITTING=y
CONFIG_FB_VGA16=m
CONFIG_FB_VESA=y
CONFIG_FB_I810=m
CONFIG_FB_I810_GTF=y
CONFIG_FB_I810_I2C=y
CONFIG_FB_INTEL=m
CONFIG_FB_INTEL_I2C=y
CONFIG_FB_MATROX=m
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=m
CONFIG_FB_MATROX_MAVEN=m
CONFIG_FB_MATROX_MULTIHEAD=y
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
 CONFIG_FB_VIRTUAL=m
CONFIG_VGA_CONSOLE=y
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FONTS=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_RTCTIMER=m
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DUMMY=m
CONFIG_SND_MPU401=m
CONFIG_SND_BT87X=m
CONFIG_SND_BT87X_OVERCLOCK=y
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ES1968=m
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_VIA82XX=m
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SOUND_PRIME=m
CONFIG_AC97_BUS=m
CONFIG_HID=y
CONFIG_USB_HID=m
CONFIG_HID_FF=y
CONFIG_USB_HIDDEV=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=m
CONFIG_USB_DEBUG=y
CONFIG_USB_DEVICEFS=y
CONFIG_USB_SUSPEND=y
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_SPLIT_ISO=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_OHCI_HCD=m
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_STORAGE=m
CONFIG_USB_MON=y
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_EZUSB=y
CONFIG_USB_TEST=m
CONFIG_USB_GADGET=m
CONFIG_USB_GADGET_SELECTED=y
CONFIG_USB_GADGET_NET2280=y
CONFIG_USB_NET2280=m
CONFIG_USB_GADGET_DUALSPEED=y
CONFIG_USB_G_SERIAL=m
CONFIG_MMC=m
CONFIG_MMC_BLOCK=m
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_DRV_CMOS=m
CONFIG_DMA_ENGINE=y
CONFIG_NET_DMA=y
CONFIG_INTEL_IOATDMA=m
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XIP=y
CONFIG_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_JBD=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_PROC_INFO=y
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=m
CONFIG_XFS_POSIX_ACL=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_DNOTIFY=y
CONFIG_AUTOFS_FS=m
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=852
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-2"
CONFIG_NTFS_FS=m
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_RAMFS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V4=y
CONFIG_NFS_DIRECTIO=y
CONFIG_NFSD=m
CONFIG_NFSD_V3=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_TCP=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_SMB_FS=m
CONFIG_SMB_NLS_DEFAULT=y
CONFIG_SMB_NLS_REMOTE="cp852"
CONFIG_CIFS=m
CONFIG_PARTITION_ADVANCED=y
CONFIG_AMIGA_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-2"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_UTF8=m
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_FORCED_INLINING=y
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_RODATA=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_HASH=m
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_DEV_GEODE=m
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=m
CONFIG_CRC32=y
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y
