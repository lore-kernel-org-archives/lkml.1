Return-Path: <linux-kernel-owner+w=401wt.eu-S1764456AbXGQUMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764456AbXGQUMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbXGQUMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:12:07 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:42647 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329AbXGQUMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:12:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18077.8844.37996.592932@stoffel.org>
Date: Tue, 17 Jul 2007 16:11:56 -0400
From: "John Stoffel" <john@stoffel.org>
To: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: oops with 2.6.22.1 - bad magic number for tty struct
In-Reply-To: <c4e36d110707170828s15a2e43ai9e3df37fb419aed6@mail.gmail.com>
References: <c4e36d110707170814y682cefa6t58ab08f1cad6c6ac@mail.gmail.com>
	<c4e36d110707170828s15a2e43ai9e3df37fb419aed6@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Zdenek> I get kernel oopses when I run powertop on my old BP6 SMP dual
Zdenek> Celeron board.

Zdenek> In case more details are needed - send me a replay.

Since it's tainted with a proprietary module, we can't do anything
here.  Please re-create the oops without that module and we'll be able
to help.

John


Zdenek> The machine with problem is -
Zdenek> 2xCPU400MHz Celerons running at 450MHz (stable - compiles kernel
Zdenek> without any problems, thought it takes more than hour nowadays :(...)
Zdenek> 512MB RAM
Zdenek> 120&30GB Hard drivers (all should be visible in the boot log that
Zdenek> follows oops trace)
Zdenek> In Bp6 bios - PnP enabled, Serial&Parallel ports disabled.
Zdenek> Atheros WiFi driver is used - but this shall hopefully not influence
Zdenek> this problem.

Zdenek> bye

Zdenek> Zdenek


Zdenek> Jul 16 21:16:35 bad magic number for tty struct (136:3) in tty_poll
Zdenek> Jul 16 21:20:56 BUG: unable to handle kernel NULL pointer dereference
Zdenek> at virtual address 0000007c
Zdenek> Jul 16 21:20:56  printing eip:
Zdenek> Jul 16 21:20:56 c0260c23
Zdenek> Jul 16 21:20:56 *pde = 00000000
Zdenek> Jul 16 21:20:56 Oops: 0000 [#1]
Zdenek> Jul 16 21:20:56 PREEMPT SMP
Zdenek> Jul 16 21:20:56 Modules linked in: cpufreq_stats freq_table mga drm
Zdenek> binfmt_misc autofs4 nfsd exportfs lockd sunrpc thermal fan button
Zdenek> processor ac battery ipv6 iptable_filter ip_tables x_tables fuse
Zdenek> dm_snapshot dm_mirror dm_mod w83781d hwmon_vid hwmon tuner tvaudio
Zdenek> snd_emu10k1 wlan_scan_sta snd_rawmidi ath_rate_sample snd_ac97_codec
Zdenek> ac97_bus bttv video_buf firmware_class snd_bt87x ir_common snd_pcm_oss
Zdenek> snd_mixer_oss compat_ioctl32 i2c_algo_bit snd_pcm btcx_risc
Zdenek> snd_util_mem tveeprom videodev snd_hwdep 8139too snd_timer uhci_hcd
Zdenek> v4l2_common v4l1_compat mii floppy emu10k1_gp snd_page_alloc ath_pci
Zdenek> wlan ath_hal(P) pata_hpt366 libata i2c_piix4 snd intel_agp soundcore
Zdenek> rtc usbcore gameport i2c_core scsi_mod agpgart evdev
Zdenek> Jul 16 21:20:56 CPU:    0
Zdenek> Jul 16 21:20:56 EIP:    0060:[<c0260c23>]    Tainted: P       VLI
Zdenek> Jul 16 21:20:56 EFLAGS: 00010046   (2.6.22.1 #1)
Zdenek> Jul 16 21:20:56 EIP is at tty_devnum+0x3/0x20
Zdenek> Jul 16 21:20:56 eax: d7b3f800   ebx: d7b0c030   ecx: 00000000   edx: 00000000
Zdenek> Jul 16 21:20:56 esi: cf9ac000   edi: df1aa7c0   ebp: d7b0c030   esp: c94a3db8
Zdenek> Jul 16 21:20:56 ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Zdenek> Jul 16 21:20:56 Process top (pid: 6260, ti=c94a2000 task=c9a5ba90
Zdenek> task.ti=c94a2000)
Zdenek> Jul 16 21:20:56 Stack: c01adca0 c0186934 df00ce0c c94a3e08 c017e42d
Zdenek> c7c0200b 00000101 01c5a71f
Zdenek> Jul 16 21:20:56        c94a3e44 dffcbf20 c01f5340 dffce6b8 c94a3e38
Zdenek> c0186934 c66b7b8c c94a3e38
Zdenek> Jul 16 21:20:56        c017e42d c7c02006 00000001 00000000 01c5a71f
Zdenek> 00000004 c7c0200b dffcbf20
Zdenek> Jul 16 21:20:56 Call Trace:
Zdenek> Jul 16 21:20:56  [<c01adca0>] do_task_stat+0x120/0x9a0
Zdenek> Jul 16 21:20:56  [<c0186934>] dput+0x94/0x130
Zdenek> Jul 16 21:20:56  [<c017e42d>] __link_path_walk+0xacd/0xc80
Zdenek> Jul 16 21:20:56  [<c01f5340>] ext3_permission+0x0/0x10
Zdenek> Jul 16 21:20:56  [<c0186934>] dput+0x94/0x130
Zdenek> Jul 16 21:20:56  [<c017e42d>] __link_path_walk+0xacd/0xc80
Zdenek> Jul 16 21:20:56  [<c018aef3>] mntput_no_expire+0x13/0x60
Zdenek> Jul 16 21:20:56  [<c017e645>] link_path_walk+0x65/0xc0
Zdenek> Jul 16 21:20:56  [<c032a005>] _spin_unlock+0x5/0x20
Zdenek> Jul 16 21:20:56  [<c0173253>] get_unused_fd+0xa3/0xc0
Zdenek> Jul 16 21:20:56  [<c017e888>] do_path_lookup+0x78/0x1c0
Zdenek> Jul 16 21:20:56  [<c0175c5c>] file_move+0x1c/0x60
Zdenek> Jul 16 21:20:56  [<c0158cbf>] __alloc_pages+0x4f/0x300
Zdenek> Jul 16 21:20:56  [<c0173525>] nameidata_to_filp+0x35/0x40
Zdenek> Jul 16 21:20:56  [<c01abd87>] proc_info_read+0x87/0xc0
Zdenek> Jul 16 21:20:56  [<c0175401>] vfs_read+0xa1/0x130
Zdenek> Jul 16 21:20:56  [<c01abd00>] proc_info_read+0x0/0xc0
Zdenek> Jul 16 21:20:56  [<c0175931>] sys_read+0x41/0x70
Zdenek> Jul 16 21:20:56  [<c010436a>] syscall_call+0x7/0xb
Zdenek> Jul 16 21:20:56  =======================
Zdenek> Jul 16 21:20:56 Code: 2c 01 00 00 8b 4a 54 89 88 30 01 00 00 8b 4a 58
Zdenek> 89 88 34 01 00 00 8b 52 5c 89 90 38 01 00 00 c3 90 8d b4 26 00 00 00
Zdenek> 00 8b 48 04 <8b> 51 7c c1 e2 14 0b 91 80 00 00 00 8b 48 08 01 ca 89 d0
Zdenek> c3 89
Zdenek> Jul 16 21:20:56 EIP: [<c0260c23>] tty_devnum+0x3/0x20 SS:ESP 0068:c94a3db8
Zdenek> Jul 16 21:20:56 note: top[6260] exited with preempt_count 2
Zdenek> Jul 16 21:20:56 BUG: sleeping function called from invalid context at
Zdenek> kernel/rwsem.c:20
Zdenek> Jul 16 21:20:56 in_atomic():1, irqs_disabled():0
Zdenek> Jul 16 21:20:56  [<c0140902>] down_read+0x12/0x20
Zdenek> Jul 16 21:20:56  [<c012aba5>] exit_mm+0x25/0xf0
Zdenek> Jul 16 21:20:56  [<c012c276>] do_exit+0xf6/0x7c0
Zdenek> Jul 16 21:20:56  [<c01213a8>] __wake_up+0x38/0x50
Zdenek> Jul 16 21:20:56  [<c0105a70>] do_trap+0x0/0x100
Zdenek> Jul 16 21:20:56  [<c011fa54>] do_page_fault+0x314/0x680
Zdenek> Jul 16 21:20:56  [<c021b5ab>] vsnprintf+0x2db/0x590
Zdenek> Jul 16 21:20:56  [<c011f740>] do_page_fault+0x0/0x680
Zdenek> Jul 16 21:20:56  [<c032a2ca>] error_code+0x72/0x78
Zdenek> Jul 16 21:20:56  [<c0260c23>] tty_devnum+0x3/0x20
Zdenek> Jul 16 21:20:56  [<c01adca0>] do_task_stat+0x120/0x9a0
Zdenek> Jul 16 21:20:56  [<c0186934>] dput+0x94/0x130
Zdenek> Jul 16 21:20:56  [<c017e42d>] __link_path_walk+0xacd/0xc80
Zdenek> Jul 16 21:20:56  [<c01f5340>] ext3_permission+0x0/0x10
Zdenek> Jul 16 21:20:56  [<c0186934>] dput+0x94/0x130
Zdenek> Jul 16 21:20:56  [<c017e42d>] __link_path_walk+0xacd/0xc80
Zdenek> Jul 16 21:20:56  [<c018aef3>] mntput_no_expire+0x13/0x60
Zdenek> Jul 16 21:20:56  [<c017e645>] link_path_walk+0x65/0xc0
Zdenek> Jul 16 21:20:56  [<c032a005>] _spin_unlock+0x5/0x20
Zdenek> Jul 16 21:20:56  [<c0173253>] get_unused_fd+0xa3/0xc0
Zdenek> Jul 16 21:20:56  [<c017e888>] do_path_lookup+0x78/0x1c0
Zdenek> Jul 16 21:20:56  [<c0175c5c>] file_move+0x1c/0x60
Zdenek> Jul 16 21:20:56  [<c0158cbf>] __alloc_pages+0x4f/0x300
Zdenek> Jul 16 21:20:56  [<c0173525>] nameidata_to_filp+0x35/0x40
Zdenek> Jul 16 21:20:56  [<c01abd87>] proc_info_read+0x87/0xc0
Zdenek> Jul 16 21:20:56  [<c0175401>] vfs_read+0xa1/0x130
Zdenek> Jul 16 21:20:56  [<c01abd00>] proc_info_read+0x0/0xc0
Zdenek> Jul 16 21:20:56  [<c0175931>] sys_read+0x41/0x70
Zdenek> Jul 16 21:20:56  [<c010436a>] syscall_call+0x7/0xb
Zdenek> Jul 16 21:20:56  =======================
Zdenek> Jul 16 21:20:56 BUG: scheduling while atomic: top/0x10000002/6260
Zdenek> Jul 16 21:20:56  [<c03276c3>] __sched_text_start+0x4e3/0x890
Zdenek> Jul 16 21:20:56  [<c0129341>] release_console_sem+0x1d1/0x1f0
Zdenek> Jul 16 21:20:56  [<c026ecc0>] vt_console_print+0x0/0x2c0
Zdenek> Jul 16 21:20:56  [<c0128f5e>] __call_console_drivers+0x5e/0x70
Zdenek> Jul 16 21:20:56  [<c0129341>] release_console_sem+0x1d1/0x1f0
Zdenek> Jul 16 21:20:56  [<c0123fe5>] __cond_resched+0x25/0x40
Zdenek> Jul 16 21:20:56  [<c03281ca>] cond_resched+0x2a/0x40
Zdenek> Jul 16 21:20:56  [<c0160d52>] unmap_vmas+0x5c2/0x610
Zdenek> Jul 16 21:20:56  [<c01052ea>] print_trace_address+0x1a/0x30
Zdenek> Jul 16 21:20:56  [<c01646be>] exit_mmap+0x7e/0x120
Zdenek> Jul 16 21:20:56  [<c0126db2>] mmput+0x42/0xc0
Zdenek> Jul 16 21:20:56  [<c012c276>] do_exit+0xf6/0x7c0
Zdenek> Jul 16 21:20:56  [<c01213a8>] __wake_up+0x38/0x50
Zdenek> Jul 16 21:20:56  [<c0105a70>] do_trap+0x0/0x100
Zdenek> Jul 16 21:20:56  [<c011fa54>] do_page_fault+0x314/0x680
Zdenek> Jul 16 21:20:56  [<c021b5ab>] vsnprintf+0x2db/0x590
Zdenek> Jul 16 21:20:56  [<c011f740>] do_page_fault+0x0/0x680
Zdenek> Jul 16 21:20:56  [<c032a2ca>] error_code+0x72/0x78
Zdenek> Jul 16 21:20:56  [<c0260c23>] tty_devnum+0x3/0x20
Zdenek> Jul 16 21:20:56  [<c01adca0>] do_task_stat+0x120/0x9a0
Zdenek> Jul 16 21:20:56  [<c0186934>] dput+0x94/0x130
Zdenek> Jul 16 21:20:56  [<c017e42d>] __link_path_walk+0xacd/0xc80
Zdenek> Jul 16 21:20:56  [<c01f5340>] ext3_permission+0x0/0x10
Zdenek> Jul 16 21:20:56  [<c0186934>] dput+0x94/0x130
Zdenek> Jul 16 21:20:56  [<c017e42d>] __link_path_walk+0xacd/0xc80
Zdenek> Jul 16 21:20:56  [<c018aef3>] mntput_no_expire+0x13/0x60
Zdenek> Jul 16 21:20:56  [<c017e645>] link_path_walk+0x65/0xc0
Zdenek> Jul 16 21:20:56  [<c032a005>] _spin_unlock+0x5/0x20
Zdenek> Jul 16 21:20:56  [<c0173253>] get_unused_fd+0xa3/0xc0
Zdenek> Jul 16 21:20:56  [<c017e888>] do_path_lookup+0x78/0x1c0
Zdenek> Jul 16 21:20:56  [<c0175c5c>] file_move+0x1c/0x60
Zdenek> Jul 16 21:20:56  [<c0158cbf>] __alloc_pages+0x4f/0x300
Zdenek> Jul 16 21:20:56  [<c0173525>] nameidata_to_filp+0x35/0x40
Zdenek> Jul 16 21:20:56  [<c01abd87>] proc_info_read+0x87/0xc0
Zdenek> Jul 16 21:20:56  [<c0175401>] vfs_read+0xa1/0x130
Zdenek> Jul 16 21:20:56  [<c01abd00>] proc_info_read+0x0/0xc0
Zdenek> Jul 16 21:20:56  [<c0175931>] sys_read+0x41/0x70
Zdenek> Jul 16 21:20:56  [<c010436a>] syscall_call+0x7/0xb
Zdenek> Jul 16 21:20:56  =======================
Zdenek> Jul 16 21:27:50 klogd 1.4.1#21, log source = /proc/kmsg started.
Zdenek> Jul 16 21:27:50 Linux version 2.6.22.1 (root@kabi) (gcc version 4.1.3
Zdenek> 20070629 (prerelease) (Debian 4.1.2-13)) #1 SMP PREEMPT Sun Jul 15
Zdenek> 17:35:15 CEST 2007
Zdenek> Jul 16 21:27:50 BIOS-provided physical RAM map:
Zdenek> Jul 16 21:27:50  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Zdenek> Jul 16 21:27:50  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Zdenek> Jul 16 21:27:50  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
Zdenek> Jul 16 21:27:50  BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
Zdenek> Jul 16 21:27:50  BIOS-e820: 000000001fff0000 - 000000001fff3000 (ACPI NVS)
Zdenek> Jul 16 21:27:50  BIOS-e820: 000000001fff3000 - 0000000020000000 (ACPI data)
Zdenek> Jul 16 21:27:50  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
Zdenek> Jul 16 21:27:50  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Zdenek> Jul 16 21:27:50  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
Zdenek> Jul 16 21:27:50 0MB HIGHMEM available.
Zdenek> Jul 16 21:27:50 511MB LOWMEM available.
Zdenek> Jul 16 21:27:50 found SMP MP-table at 000f5ae0
Zdenek> Jul 16 21:27:50 Entering add_active_range(0, 0, 131056) 0 entries of 256 used
Zdenek> Jul 16 21:27:50 Zone PFN ranges:
Zdenek> Jul 16 21:27:50   DMA             0 ->     4096
Zdenek> Jul 16 21:27:50   Normal       4096 ->   131056
Zdenek> Jul 16 21:27:50   HighMem    131056 ->   131056
Zdenek> Jul 16 21:27:50 early_node_map[1] active PFN ranges
Zdenek>  Jul 16 21:27:50     0:        0 ->   131056
Zdenek> Jul 16 21:27:50 On node 0 totalpages: 131056
Zdenek> Jul 16 21:27:50   DMA zone: 44 pages used for memmap
Zdenek> Jul 16 21:27:50   DMA zone: 0 pages reserved
Zdenek> Jul 16 21:27:50   DMA zone: 4052 pages, LIFO batch:0
Zdenek> Jul 16 21:27:50   Normal zone: 1363 pages used for memmap
Zdenek> Jul 16 21:27:50   Normal zone: 125597 pages, LIFO batch:31
Zdenek> Jul 16 21:27:50   HighMem zone: 0 pages used for memmap
Zdenek> Jul 16 21:27:50 DMI 2.2 present.
Zdenek>  Jul 16 21:27:50 ACPI: RSDP 000F7370, 0014 (r0 ABIT  )
Zdenek> Jul 16 21:27:50 ACPI: RSDT 1FFF3000, 002C (r1 ABIT   AWRDACPI 42302E31
Zdenek> AWRD        0)
Zdenek> Jul 16 21:27:50 ACPI: FACP 1FFF3040, 0074 (r1 ABIT   AWRDACPI 42302E31
Zdenek> AWRD        0)
Zdenek> Jul 16 21:27:50 ACPI: DSDT 1FFF30C0, 21B2 (r1 ABIT   AWRDACPI     1000
Zdenek> INTL 20031203)
Zdenek> Jul 16 21:27:50 ACPI: FACS 1FFF0000, 0040
Zdenek> Jul 16 21:27:50 ACPI: APIC 1FFF5280, 005C (r1 ABIT                   0
Zdenek>             0)
Zdenek> Jul 16 21:27:50 ACPI: PM-Timer IO Port: 0x4008
Zdenek> Jul 16 21:27:50 ACPI: Local APIC address 0xfee00000
Zdenek> Jul 16 21:27:50 ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Zdenek> Jul 16 21:27:50 Processor #0 6:6 APIC version 17
Zdenek> Jul 16 21:27:50 ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Zdenek> Jul 16 21:27:50 Processor #1 6:6 APIC version 17
Zdenek> Jul 16 21:27:50 ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
Zdenek> Jul 16 21:27:50 IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
Zdenek> Jul 16 21:27:50 ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl edge)
Zdenek> Jul 16 21:27:50 ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 dfl dfl)
Zdenek> Jul 16 21:27:50 ACPI: IRQ0 used by override.
Zdenek> Jul 16 21:27:50 ACPI: IRQ2 used by override.
Zdenek> Jul 16 21:27:50 ACPI: IRQ9 used by override.
Zdenek> Jul 16 21:27:50 Enabling APIC mode:  Flat.  Using 1 I/O APICs
Zdenek> Jul 16 21:27:50 Using ACPI (MADT) for SMP configuration information
Zdenek> Jul 16 21:27:50 Allocating PCI resources starting at 30000000 (gap:
Zdenek> 20000000:dec00000)
Zdenek> Jul 16 21:27:50 Built 1 zonelists.  Total pages: 129649
Zdenek> Jul 16 21:27:50 Kernel command line: root=/dev/hdb1 vga=0x305 4
Zdenek> Jul 16 21:27:50 mapped APIC to ffffd000 (fee00000)
Zdenek> Jul 16 21:27:50 mapped IOAPIC to ffffc000 (fec00000)
Zdenek> Jul 16 21:27:50 Enabling fast FPU save and restore... done.
Zdenek> Jul 16 21:27:50 Initializing CPU#0
Zdenek> Jul 16 21:27:50 PID hash table entries: 2048 (order: 11, 8192 bytes)
Zdenek> Jul 16 21:27:50 Detected 450.011 MHz processor.
Zdenek> Jul 16 21:27:50 Console: colour dummy device 80x25
Zdenek> Jul 16 21:27:50 Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Zdenek> Jul 16 21:27:50 Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Zdenek>  Jul 16 21:27:50 Memory: 513884k/524224k available (2220k kernel code,
Zdenek> 9872k reserved, 929k data, 248k init, 0k highmem)
Zdenek> Jul 16 21:27:50 virtual kernel memory layout:
Zdenek> Jul 16 21:27:50     fixmap  : 0xfff4e000 - 0xfffff000   ( 708 kB)
Zdenek> Jul 16 21:27:50     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
Zdenek> Jul 16 21:27:50     vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)
Zdenek> Jul 16 21:27:50     lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
Zdenek> Jul 16 21:27:50       .init : 0xc041a000 - 0xc0458000   ( 248 kB)
Zdenek> Jul 16 21:27:50       .data : 0xc032b0a7 - 0xc0413804   ( 929 kB)
Zdenek> Jul 16 21:27:50       .text : 0xc0100000 - 0xc032b0a7   (2220 kB)
Zdenek> Jul 16 21:27:50 Checking if this processor honours the WP bit even in
Zdenek> supervisor mode... Ok.
Zdenek> Jul 16 21:27:50 Calibrating delay using timer specific routine..
Zdenek> 901.30 BogoMIPS (lpj=1501282)
Zdenek> Jul 16 21:27:50 Mount-cache hash table entries: 512
Zdenek> Jul 16 21:27:50 CPU: After generic identify, caps: 0183fbff 00000000
Zdenek> 00000000 00000000 00000000 00000000 00000000
Zdenek> Jul 16 21:27:50 CPU: L1 I cache: 16K, L1 D cache: 16K
Zdenek> Jul 16 21:27:50 CPU: L2 cache: 128K
Zdenek> Jul 16 21:27:50 CPU: After all inits, caps: 0183fbff 00000000 00000000
Zdenek> 00000040 00000000 00000000 00000000
Zdenek> Jul 16 21:27:50 Intel machine check architecture supported.
Zdenek> Jul 16 21:27:50 Intel machine check reporting enabled on CPU#0.
Zdenek> Jul 16 21:27:50 Compat vDSO mapped to ffffe000.
Zdenek> Jul 16 21:27:50 Checking 'hlt' instruction... OK.
Zdenek> Jul 16 21:27:50 SMP alternatives: switching to UP code
Zdenek> Jul 16 21:27:50 ACPI: Core revision 20070126
Zdenek> Jul 16 21:27:50 CPU0: Intel Celeron (Mendocino) stepping 05
Zdenek> Jul 16 21:27:50 SMP alternatives: switching to SMP code
Zdenek> Jul 16 21:27:50 Booting processor 1/1 eip 3000
Zdenek>  Jul 16 21:27:50 Initializing CPU#1
Zdenek> Jul 16 21:27:50 Calibrating delay using timer specific routine..
Zdenek> 900.46 BogoMIPS (lpj=1499950)
Zdenek> Jul 16 21:27:50 CPU: After generic identify, caps: 0183fbff 00000000
Zdenek> 00000000 00000000 00000000 00000000 00000000
Zdenek> Jul 16 21:27:50 CPU: L1 I cache: 16K, L1 D cache: 16K
Zdenek> Jul 16 21:27:50 CPU: L2 cache: 128K
Zdenek> Jul 16 21:27:50 CPU: After all inits, caps: 0183fbff 00000000 00000000
Zdenek> 00000040 00000000 00000000 00000000
Zdenek> Jul 16 21:27:50 Intel machine check architecture supported.
Zdenek> Jul 16 21:27:50 Intel machine check reporting enabled on CPU#1.
Zdenek> Jul 16 21:27:50 CPU1: Intel Celeron (Mendocino) stepping 05
Zdenek> Jul 16 21:27:50 Total of 2 processors activated (1801.77 BogoMIPS).
Zdenek> Jul 16 21:27:50 ENABLING IO-APIC IRQs
Zdenek> Jul 16 21:27:50 ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
Zdenek> Jul 16 21:27:50 checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Zdenek> Jul 16 21:27:50 Brought up 2 CPUs
Zdenek> Jul 16 21:27:50 migration_cost=1507
Zdenek> Jul 16 21:27:50 Booting paravirtualized kernel on bare hardware
Zdenek> Jul 16 21:27:50 NET: Registered protocol family 16
Zdenek> Jul 16 21:27:50 ACPI: bus type pci registered
Zdenek> Jul 16 21:27:50 PCI: PCI BIOS revision 2.10 entry at 0xfb5c0, last bus=1
Zdenek> Jul 16 21:27:50 PCI: Using configuration type 1
Zdenek> Jul 16 21:27:50 Setting up standard PCI resources
Zdenek> Jul 16 21:27:50 mtrr: your CPUs had inconsistent fixed MTRR settings
Zdenek> Jul 16 21:27:50 mtrr: probably your BIOS does not setup all CPUs.
Zdenek> Jul 16 21:27:50 mtrr: corrected configuration.
Zdenek> Jul 16 21:27:50 ACPI: Interpreter enabled
Zdenek> Jul 16 21:27:50 ACPI: (supports S0 S1 S4 S5)
Zdenek> Jul 16 21:27:50 ACPI: Using IOAPIC for interrupt routing
Zdenek> Jul 16 21:27:50 ACPI: PCI Root Bridge [PCI0] (0000:00)
Zdenek> Jul 16 21:27:50 PCI: Probing PCI hardware (bus 00)
Zdenek> Jul 16 21:27:50 * Found PM-Timer Bug on the chipset. Due to
Zdenek> workarounds for a bug,
Zdenek> Jul 16 21:27:50 * this clock source is slow. Consider trying other
Zdenek> clock sources
Zdenek> Jul 16 21:27:50 PCI quirk: region 4000-403f claimed by PIIX4 ACPI
Zdenek> Jul 16 21:27:50 PCI quirk: region 5000-500f claimed by PIIX4 SMB
Zdenek> Jul 16 21:27:50 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Zdenek> Jul 16 21:27:50 ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11
Zdenek> 12 14 15)
Zdenek> Jul 16 21:27:50 ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
Zdenek> Jul 16 21:27:50 ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11 12 14 15)
Zdenek> Jul 16 21:27:50 ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 10 11
Zdenek> 12 14 15)
Zdenek> Jul 16 21:27:50 Linux Plug and Play Support v0.97 (c) Adam Belay
Zdenek> Jul 16 21:27:50 pnp: PnP ACPI init
Zdenek> Jul 16 21:27:50 ACPI: bus type pnp registered
Zdenek> Jul 16 21:27:50 pnp: PnP ACPI: found 10 devices
Zdenek> Jul 16 21:27:50 ACPI: ACPI bus type pnp unregistered
Zdenek> Jul 16 21:27:50 PnPBIOS: Disabled by ACPI PNP
Zdenek> Jul 16 21:27:50 PCI: Using ACPI for IRQ routing
Zdenek> Jul 16 21:27:50 PCI: If a device doesn't work, try "pci=routeirq".  If
Zdenek> it helps, post a report
Zdenek> Jul 16 21:27:50 ACPI: RTC can wake from S4
Zdenek> Jul 16 21:27:50 Time: tsc clocksource has been installed.
Zdenek> Jul 16 21:27:50 pnp: 00:00: iomem range 0xf0000-0xf3fff could not be reserved
Zdenek> Jul 16 21:27:50 pnp: 00:00: iomem range 0xf4000-0xf7fff could not be reserved
Zdenek> Jul 16 21:27:50 pnp: 00:00: iomem range 0xf8000-0xfbfff could not be reserved
Zdenek> Jul 16 21:27:50 pnp: 00:00: iomem range 0xfc000-0xfffff could not be reserved
Zdenek> Jul 16 21:27:50 PCI: Bridge: 0000:00:01.0
Zdenek> Jul 16 21:27:50   IO window: disabled.
Zdenek> Jul 16 21:27:50   MEM window: d4000000-d7ffffff
Zdenek> Jul 16 21:27:50   PREFETCH window: d8000000-d9ffffff
Zdenek> Jul 16 21:27:50 NET: Registered protocol family 2
Zdenek> Jul 16 21:27:50 IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
Zdenek> Jul 16 21:27:50 TCP established hash table entries: 16384 (order: 6,
Zdenek> 458752 bytes)
Zdenek> Jul 16 21:27:50 TCP bind hash table entries: 16384 (order: 6, 393216 bytes)
Zdenek> Jul 16 21:27:50 TCP: Hash tables configured (established 16384 bind 16384)
Zdenek> Jul 16 21:27:50 TCP reno registered
Zdenek> Jul 16 21:27:50 Machine check exception polling timer started.
Zdenek> Jul 16 21:27:50 VFS: Disk quotas dquot_6.5.1
Zdenek> Jul 16 21:27:50 Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Zdenek> Jul 16 21:27:50 io scheduler noop registered (default)
Zdenek> Jul 16 21:27:50 Limiting direct PCI/PCI transfers.
Zdenek> Jul 16 21:27:50 pci 0000:00:07.2: uhci_check_and_reset_hc: legsup = 0x2000
Zdenek> Jul 16 21:27:50 pci 0000:00: 07.2: Performing full reset
Zdenek> Jul 16 21:27:50 Boot video device is 0000:01:00.0
Zdenek> Jul 16 21:27:50 vesafb: framebuffer at 0xd8000000, mapped to
Zdenek> 0xe0880000, using 1536k, total 32768k
Zdenek> Jul 16 21:27:50 vesafb: mode is 1024x768x8, linelength=1024, pages=18
Zdenek> Jul 16 21:27:50 vesafb: protected mode interface info at c000:7d60
Zdenek> Jul 16 21:27:50 vesafb: pmi: set display start = c00c7df2, set palette
Zdenek> = c00c7e5e
Zdenek> Jul 16 21:27:50 vesafb: pmi: ports = 3de 3df
Zdenek> Jul 16 21:27:50 vesafb: scrolling: redraw
Zdenek> Jul 16 21:27:50 vesafb: Pseudocolor: size=8:8:8:8, shift=0:0:0:0
Zdenek> Jul 16 21:27:50 Console: switching to colour frame buffer device 128x48
Zdenek> Jul 16 21:27:50 fb0: VESA VGA frame buffer device
Zdenek> Jul 16 21:27:50 isapnp: Scanning for PnP cards...
Zdenek> Jul 16 21:27:50 isapnp: No Plug & Play device found
Zdenek> Jul 16 21:27:50 Switched to high resolution mode on CPU 1
Zdenek> Jul 16 21:27:50 Switched to high resolution mode on CPU 0
Zdenek> Jul 16 21:27:50 Uniform Multi-Platform E-IDE driver Revision:  7.00alpha2
Zdenek> Jul 16 21:27:50 ide: Assuming 33MHz system bus speed for PIO modes;
Zdenek> override with idebus=xx
Zdenek> Jul 16 21:27:50 PIIX4: IDE controller at PCI slot 0000:00:07.1
Zdenek> Jul 16 21:27:50 PIIX4: chipset revision 1
Zdenek> Jul 16 21:27:50 PIIX4: not 100%% native mode: will probe irqs later
Zdenek> Jul 16 21:27:50     ide0: BM-DMA at 0xf000-0xf007, BIOS settings:
Zdenek> hda:DMA, hdb:DMA
Zdenek> Jul 16 21:27:50     ide1: BM-DMA at 0xf008-0xf00f, BIOS settings:
Zdenek> hdc:pio, hdd:pio
Zdenek> Jul 16 21:27:50 Probing IDE interface ide0...
Zdenek> Jul 16 21:27:50 hda: ST3120026A, ATA DISK drive
Zdenek> Jul 16 21:27:50 hdb: IBM-DTLA-307030, ATA DISK drive
Zdenek> Jul 16 21:27:50 hda: selected mode 0x42
Zdenek> Jul 16 21:27:50 hdb: selected mode 0x42
Zdenek> Jul 16 21:27:50 ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Zdenek> Jul 16 21:27:50 Probing IDE interface ide1...
Zdenek> Jul 16 21:27:50 HPT366: onboard version of chipset, pin1=1 pin2=2
Zdenek> Jul 16 21:27:50 HPT366: IDE controller at PCI slot 0000:00:13.0
Zdenek> Jul 16 21:27:50 ACPI: PCI Interrupt 0000:00: 13.0[A] -> GSI 18 (level,
Zdenek> low) -> IRQ 16
Zdenek> Jul 16 21:27:50 HPT366: chipset revision 1
Zdenek> Jul 16 21:27:50 HPT366: using 33 MHz PCI clock
Zdenek> Jul 16 21:27:50 HPT366: 100%% native mode on irq 16
Zdenek> Jul 16 21:27:50     ide2: BM-DMA at 0xd800-0xd807, BIOS settings:
Zdenek> hde:pio, hdf:pio
Zdenek> Jul 16 21:27:50 ACPI: PCI Interrupt 0000:00:13.1[B] -> GSI 18 (level,
Zdenek> low) -> IRQ 16
Zdenek> Jul 16 21:27:50 HPT366: using 33 MHz PCI clock
Zdenek> Jul 16 21:27:50     ide3: BM-DMA at 0xe400-0xe407, BIOS settings:
Zdenek> hdg:pio, hdh:pio
Zdenek> Jul 16 21:27:50 Probing IDE interface ide2...
Zdenek> Jul 16 21:27:51 Probing IDE interface ide3...
Zdenek> Jul 16 21:27:51 Probing IDE interface ide1...
Zdenek> Jul 16 21:27:51 Probing IDE interface ide2...
Zdenek> Jul 16 21:27:51 Probing IDE interface ide3...
Zdenek> Jul 16 21:27:51 hda: max request size: 512KiB
Zdenek> Jul 16 21:27:51 hda: 234441648 sectors (120034 MB) w/8192KiB Cache,
Zdenek> CHS=16383/255/63, UDMA(33)
Zdenek> Jul 16 21:27:51 hda: cache flushes supported
Zdenek> Jul 16 21:27:51  hda: hda1 hda2 hda3 < hda5 hda6 hda7 hda8 >
Zdenek> Jul 16 21:27:51 hdb: max request size: 128KiB
Zdenek> Jul 16 21:27:51 hdb: 60036480 sectors (30738 MB) w/1916KiB Cache,
Zdenek> CHS=59560/16/63, UDMA(33)
Zdenek> Jul 16 21:27:51 hdb: cache flushes not supported
Zdenek> Jul 16 21:27:51  hdb: hdb1 hdb2 < hdb5 hdb6 hdb7 hdb8 hdb9 >
Zdenek> Jul 16 21:27:51 PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at
Zdenek> 0x60,0x64 irq 1,12
Zdenek> Jul 16 21:27:51 serio: i8042 KBD port at 0x60,0x64 irq 1
Zdenek> Jul 16 21:27:51 serio: i8042 AUX port at 0x60,0x64 irq 12
Zdenek> Jul 16 21:27:51 mice: PS/2 mouse device common for all mice
Zdenek> Jul 16 21:27:51 input: AT Translated Set 2 keyboard as /class/input/input0
Zdenek> Jul 16 21:27:51 input: ImPS/2 Generic Wheel Mouse as /class/input/input1
Zdenek> Jul 16 21:27:51 md: raid1 personality registered for level 1
Zdenek>  Jul 16 21:27:51 TCP cubic registered
Zdenek> Jul 16 21:27:51 NET: Registered protocol family 1
Zdenek> Jul 16 21:27:51 NET: Registered protocol family 17
Zdenek> Jul 16 21:27:51 Using IPI No-Shortcut mode
Zdenek> Jul 16 21:27:51 md: Autodetecting RAID arrays.
Zdenek> Jul 16 21:27:51 md: autorun ...
Zdenek> Jul 16 21:27:51 md: ... autorun DONE.
Zdenek> Jul 16 21:27:51 EXT3-fs: INFO: recovery required on readonly filesystem.
Zdenek> Jul 16 21:27:51 EXT3-fs: write access will be enabled during recovery.
Zdenek> Jul 16 21:27:51 kjournald starting.  Commit interval 5 seconds
Zdenek> Jul 16 21:27:51 EXT3-fs: recovery complete.
Zdenek> Jul 16 21:27:51 EXT3-fs: mounted filesystem with ordered data mode.
Zdenek> Jul 16 21:27:51 VFS: Mounted root (ext3 filesystem) readonly.
Zdenek> Jul 16 21:27:51 Freeing unused kernel memory: 248k freed
Zdenek> Jul 16 21:27:51 Write protecting the kernel read-only data: 763k
Zdenek> Jul 16 21:27:51 Linux agpgart interface v0.102 (c) Dave Jones
Zdenek> Jul 16 21:27:51 agpgart: Detected an Intel 440BX Chipset.
Zdenek> Jul 16 21:27:51 agpgart: AGP aperture is 64M @ 0xd0000000
Zdenek> Jul 16 21:27:51 ath_hal: module license 'Proprietary' taints kernel.
Zdenek> Jul 16 21:27:51 ath_hal: 0.9.30.13 (AR5210, AR5211, AR5212, AR5416,
Zdenek> RF5111, RF5112, RF2413, RF5413, RF2133)
Zdenek> Jul 16 21:27:51 wlan: 0.8.4.2 (svn r2523)
Zdenek> Jul 16 21:27:51 usbcore: registered new interface driver usbfs
Zdenek> Jul 16 21:27:51 usbcore: registered new interface driver hub
Zdenek> Jul 16 21:27:51 usbcore: registered new device driver usb
Zdenek> Jul 16 21:27:51 SCSI subsystem initialized
Zdenek> Jul 16 21:27:51 gameport: EMU10K1 is pci0000:00:0b.1/gameport0, io
Zdenek> 0xc800, speed 1217kHz
Zdenek> Jul 16 21:27:51 ath_pci: 0.9.4.5 (svn r2523)
Zdenek> Jul 16 21:27:51 ACPI: PCI Interrupt 0000:00: 09.0[A] -> GSI 19 (level,
Zdenek> low) -> IRQ 17
Zdenek> Jul 16 21:27:51 8139too Fast Ethernet driver 0.9.28
Zdenek> Jul 16 21:27:51 Real Time Clock Driver v1.12ac
Zdenek> Jul 16 21:27:51 Linux video capture interface: v2.00
Zdenek> Jul 16 21:27:51 USB Universal Host Controller Interface driver  v3.0
Zdenek> Jul 16 21:27:51 Floppy drive(s): fd0 is 1.44M
Zdenek> Jul 16 21:27:51 FDC 0 is a post-1991 82077
Zdenek> Jul 16 21:27:51 HAL returned 27 channels.
Zdenek> Jul 16 21:27:51 Channel 1 (2412 MHz) Max Tx Power 16 dBm (hw limited)
Zdenek> [16 hw 20 reg] Flags CF_CCK CF_2GHZ
Zdenek> Jul 16 21:27:51 Channel 1 (2412 MHz) Max Tx Power 16 dBm (hw limited)
Zdenek> [16 hw 20 reg] Flags CF_OFDM CF_2GHZ
Zdenek> Jul 16 21:27:51 Channel 2 (2417 MHz) Max Tx Power 16 dBm (hw limited)
Zdenek> [16 hw 20 reg] Flags CF_CCK CF_2GHZ
Zdenek>  Jul 16 21:27:51 Channel 2 (2417 MHz) Max Tx Power 16 dBm (hw limited)
Zdenek> [16 hw 20 reg] Flags CF_OFDM CF_2GHZ
Zdenek> Jul 16 21:27:51 Channel 3 (2422 MHz) Max Tx Power 16 dBm (hw limited)
Zdenek> [16 hw 20 reg] Flags CF_CCK CF_2GHZ
Zdenek> Jul 16 21:27:51 Channel 3 (2422 MHz) Max Tx Power 16 dBm (hw limited)
Zdenek> [16 hw 20 reg] Flags CF_OFDM CF_2GHZ
Zdenek> Jul 16 21:27:51 Channel 4 (2427 MHz) Max Tx Power 16 dBm (hw limited)
Zdenek> [16 hw 20 reg] Flags CF_CCK CF_2GHZ
Zdenek> Jul 16 21:27:51 Channel 4 (2427 MHz) Max Tx Power 16 dBm (hw limited)
Zdenek> [16 hw 20 reg] Flags CF_OFDM CF_2GHZ
Zdenek>  Jul 16 21:27:51 Channel 5 (2432 MHz) Max Tx Power 16 dBm (hw limited)
Zdenek> [16 hw 20 reg] Flags CF_CCK CF_2GHZ
Zdenek> Jul 16 21:27:51 Channel 5 (2432 MHz) Max Tx Power 16 dBm (hw limited)
Zdenek> [16 hw 20 reg] Flags CF_OFDM CF_2GHZ
Zdenek> Jul 16 21:27:51 Channel 6 (2437 MHz) Max Tx Power 16 dBm (hw limited)
Zdenek> [16 hw 20 reg] Flags CF_CCK CF_2GHZ
Zdenek> Jul 16 21:27:51 Channel 6 (2437 MHz) Max Tx Power 16 dBm (hw limited)
Zdenek> [16 hw 20 reg] Flags CF_OFDM CF_2GHZ
Zdenek> Jul 16 21:27:51 Channel 7 (2442 MHz) Max Tx Power 16 dBm (hw limited)
Zdenek> [16 hw 20 reg] Flags CF_CCK CF_2GHZ
Zdenek>  Jul 16 21:27:51 Channel 7 (2442 MHz) Max Tx Power 16 dBm (hw limited)
Zdenek> [16 hw 20 reg] Flags CF_OFDM CF_2GHZ
Zdenek> Jul 16 21:27:51 Channel 8 (2447 MHz) Max Tx Power 16 dBm (hw limited)
Zdenek> [16 hw 20 reg] Flags CF_CCK CF_2GHZ
Zdenek> Jul 16 21:27:51 libata version  2.21 loaded.
Zdenek> Jul 16 21:27:51 Channel 8 (2447 MHz) Max Tx Power 16 dBm (hw limited)
Zdenek> [16 hw 20 reg] Flags CF_OFDM CF_2GHZ
Zdenek> Jul 16 21:27:51 Channel 9 (2452 MHz) Max Tx Power 16 dBm (hw limited)
Zdenek> [16 hw 20 reg] Flags CF_CCK CF_2GHZ
Zdenek> Jul 16 21:27:51 Channel 9 (2452 MHz) Max Tx Power 16 dBm (hw limited)
Zdenek> [16 hw 20 reg] Flags CF_OFDM CF_2GHZ
Zdenek> Jul 16 21:27:51 Channel 10 (2457 MHz) Max Tx Power 16 dBm (hw limited)
Zdenek> [16 hw 20 reg] Flags CF_CCK CF_2GHZ
Zdenek>  Jul 16 21:27:51 Channel 10 (2457 MHz) Max Tx Power 16 dBm (hw
Zdenek> limited) [16 hw 20 reg] Flags CF_OFDM CF_2GHZ
Zdenek> Jul 16 21:27:51 Channel 11 (2462 MHz) Max Tx Power 16 dBm (hw limited)
Zdenek> [16 hw 20 reg] Flags CF_CCK CF_2GHZ
Zdenek>  Jul 16 21:27:51 Channel 11 (2462 MHz) Max Tx Power 16 dBm (hw
Zdenek> limited) [16 hw 20 reg] Flags CF_OFDM CF_2GHZ
Zdenek> Jul 16 21:27:51 Channel 12 (2467 MHz) Max Tx Power 15 dBm (hw limited)
Zdenek> [15 hw 20 reg] Flags CF_CCK CF_2GHZ
Zdenek>  Jul 16 21:27:51 Channel 12 (2467 MHz) Max Tx Power 15 dBm (hw
Zdenek> limited) [15 hw 20 reg] Flags CF_OFDM CF_2GHZ
Zdenek> Jul 16 21:27:51 Channel 13 (2472 MHz) Max Tx Power 9 dBm (hw limited)
Zdenek> [9 hw 20 reg] Flags CF_CCK CF_2GHZ
Zdenek> Jul 16 21:27:51 Channel 13 (2472 MHz) Max Tx Power 9 dBm (hw limited)
Zdenek> [9 hw 20 reg] Flags CF_OFDM CF_2GHZ
Zdenek> Jul 16 21:27:51 Channel 14 (2484 MHz) Max Tx Power 17 dBm (hw limited)
Zdenek> [17 hw 20 reg] Flags CF_CCK CF_2GHZ
Zdenek> Jul 16 21:27:51 ath_pci: switching rfkill capability off
Zdenek> Jul 16 21:27:51 ath_pci: ath_pci: switching per-packet transmit power
Zdenek> control off
Zdenek> Jul 16 21:27:51 bttv: driver version 0.9.17 loaded
Zdenek> Jul 16 21:27:51 bttv: using 8 buffers with 2080k (520 pages) each for capture
Zdenek> Jul 16 21:27:51 bttv: Host bridge needs ETBF enabled.
Zdenek> Jul 16 21:27:51 ath_rate_sample:  1.2 (svn r2523)
Zdenek> Jul 16 21:27:51 wifi0: 11b rates: 1Mbps 2Mbps 5.5Mbps 11Mbps
Zdenek> Jul 16 21:27:51 wifi0: 11g rates: 1Mbps 2Mbps 5.5Mbps 11Mbps 6Mbps
Zdenek> 9Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
Zdenek> Jul 16 21:27:51 wifi0: H/W encryption support: WEP AES AES_CCM TKIP
Zdenek> Jul 16 21:27:51 wifi0: mac 7.8 phy 4.5 radio 5.6
Zdenek> Jul 16 21:27:51 wifi0: Use hw queue 1 for WME_AC_BE traffic
Zdenek> Jul 16 21:27:51 wifi0: Use hw queue 0 for WME_AC_BK traffic
Zdenek> Jul 16 21:27:51 wifi0: Use hw queue 2 for WME_AC_VI traffic
Zdenek> Jul 16 21:27:51 wifi0: Use hw queue 3 for WME_AC_VO traffic
Zdenek> Jul 16 21:27:51 wifi0: Use hw queue 8 for CAB traffic
Zdenek> Jul 16 21:27:51 wifi0: Use hw queue 9 for beacons
Zdenek> Jul 16 21:27:51 wifi0: Atheros 5212: mem=0xdb000000, irq=17
Zdenek> Jul 16 21:27:51 ACPI: PCI Interrupt 0000:00:0d.0[A] -> GSI 17 (level,
Zdenek> low) -> IRQ 18
Zdenek> Jul 16 21:27:51 eth0: RealTek RTL8139 at 0xe0bc2000, 00:50:fc:fb:58:27, IRQ 18
Zdenek> Jul 16 21:27:51 eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
Zdenek> Jul 16 21:27:51 ACPI: PCI Interrupt 0000:00:07.2[D] -> GSI 19 (level,
Zdenek> low) -> IRQ 17
Zdenek> Jul 16 21:27:51 uhci_hcd 0000:00:07.2: UHCI Host Controller
Zdenek> Jul 16 21:27:51 drivers/usb/core/inode.c: creating file 'devices'
Zdenek> Jul 16 21:27:51 drivers/usb/core/inode.c: creating file '001'
Zdenek> Jul 16 21:27:51 uhci_hcd 0000:00:07.2: new USB bus registered,
Zdenek> assigned bus number 1
Zdenek> Jul 16 21:27:51 uhci_hcd 0000:00:07.2: detected 2 ports
Zdenek>  Jul 16 21:27:51 uhci_hcd 0000:00:07.2: uhci_check_and_reset_hc: cmd = 0x0000
Zdenek> Jul 16 21:27:51 uhci_hcd 0000:00:07.2: Performing full reset
Zdenek> Jul 16 21:27:51 uhci_hcd 0000:00:07.2: irq 17, io base 0x0000c000
Zdenek> Jul 16 21:27:51 usb usb1: default language 0x0409
Zdenek> Jul 16 21:27:51 usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
Zdenek> Jul 16 21:27:51 usb usb1: Product: UHCI Host Controller
Zdenek> Jul 16 21:27:51 usb usb1: Manufacturer: Linux 2.6.22.1  uhci_hcd
Zdenek> Jul 16 21:27:51 usb usb1: SerialNumber: 0000:00:07.2
Zdenek> Jul 16 21:27:51 usb usb1: uevent
Zdenek> Jul 16 21:27:51 usb usb1: usb_probe_device
Zdenek> Jul 16 21:27:51 usb usb1: configuration #1 chosen from 1 choice
Zdenek>  Jul 16 21:27:51 usb usb1: adding 1-0:1.0 (config #1, interface 0)
Zdenek> Jul 16 21:27:51 usb 1-0:1.0: uevent
Zdenek> Jul 16 21:27:51 usb 1-0:1.0: uevent
Zdenek> Jul 16 21:27:51 hub 1-0:1.0: usb_probe_interface
Zdenek> Jul 16 21:27:51 hub 1-0: 1.0: usb_probe_interface - got id
Zdenek> Jul 16 21:27:51 hub 1-0:1.0: USB hub found
Zdenek> Jul 16 21:27:51 hub 1-0:1.0: 2 ports detected
Zdenek> Jul 16 21:27:51 hub 1-0:1.0: standalone hub
Zdenek> Jul 16 21:27:51 hub 1-0:1.0: no power switching (usb  1.0)
Zdenek> Jul 16 21:27:51 hub 1-0:1.0: individual port over-current protection
Zdenek> Jul 16 21:27:51 hub 1-0:1.0: power on to power good time: 2ms
Zdenek> Jul 16 21:27:51 hub 1-0:1.0: local power source is good
Zdenek> Jul 16 21:27:51 hub 1-0: 1.0: trying to enable port power on non-switchable hub
Zdenek> Jul 16 21:27:51 hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
Zdenek> Jul 16 21:27:51 drivers/usb/core/inode.c: creating file '001'
Zdenek> Jul 16 21:27:51 piix4_smbus 0000:00: 07.3: Found 0000:00:07.3 device
Zdenek> Jul 16 21:27:51 bttv: Bt8xx card found (0).
Zdenek> Jul 16 21:27:51 ACPI: PCI Interrupt 0000:00:0f.0[A] -> GSI 16 (level,
Zdenek> low) -> IRQ 19
Zdenek> Jul 16 21:27:51 bttv0: Bt878 (rev 17) at 0000:00: 0f.0, irq: 19,
Zdenek> latency: 32, mmio: 0xdb011000
Zdenek> Jul 16 21:27:51 bttv0: detected: AVerMedia TVPhone98 [card=41], PCI
Zdenek> subsystem ID is 1461:0003
Zdenek> Jul 16 21:27:51 bttv0: using: AVerMedia TVPhone 98 [card=41,autodetected]
Zdenek>  Jul 16 21:27:51 bttv0: enabling ETBF (430FX/VP3 compatibilty)
Zdenek> Jul 16 21:27:51 bttv0: gpio: en=00000000, out=00000000 in=000477c3 [init]
Zdenek> Jul 16 21:27:51 bttv0: Avermedia eeprom[0x0aff]: tuner=Unknown type
Zdenek> radio:yes remote control:yes
Zdenek> Jul 16 21:27:51 bttv0: using tuner=5
Zdenek> Jul 16 21:27:51 bttv0: i2c: checking for MSP34xx @ 0x80... not found
Zdenek> Jul 16 21:27:51 bttv0: i2c: checking for TDA9875 @ 0xb0... not found
Zdenek> Jul 16 21:27:51 bttv0: i2c: checking for TDA7432 @ 0x8a... not found
Zdenek> Jul 16 21:27:51 tvaudio 1-0042: tda9840 found @ 0x84 (bt878 #0 [sw])
Zdenek> Jul 16 21:27:51 bttv0: i2c: checking for TDA9887 @ 0x86... not found
Zdenek> Jul 16 21:27:51 tuner 1-0061: chip found @ 0xc2 (bt878 #0 [sw])
Zdenek> Jul 16 21:27:51 tuner 1-0061: type set to 5 (Philips PAL_BG (FI1216
Zdenek> and compatibles))
Zdenek> Jul 16 21:27:51 tuner 1-0061: type set to 5 (Philips PAL_BG (FI1216
Zdenek> and compatibles))
Zdenek> Jul 16 21:27:51 bttv0: registered device video0
Zdenek> Jul 16 21:27:51 bttv0: registered device vbi0
Zdenek> Jul 16 21:27:51 bttv0: registered device radio0
Zdenek> Jul 16 21:27:51 bttv0: PLL: 28636363 => 35468950 .. ok
Zdenek> Jul 16 21:27:51 input: bttv IR (card=41) as /class/input/input2
Zdenek> Jul 16 21:27:51 ACPI: PCI Interrupt 0000:00:0f.1[A] -> GSI 16 (level,
Zdenek> low) -> IRQ 19
Zdenek> Jul 16 21:27:51 PCI: Unable to reserve I/O region #5:100@e400 for
Zdenek> device 0000:00:13.1
Zdenek> Jul 16 21:27:51 pata_hpt366 0000:00:13.1: failed to request/iomap BAR4
Zdenek> Jul 16 21:27:51 scsi0 : pata_hpt366
Zdenek> Jul 16 21:27:51 scsi1 : pata_hpt366
Zdenek> Jul 16 21:27:51 ata1: PATA max UDMA/66 cmd 0x0001dc00 ctl 0x0001e002
Zdenek> bmdma 0x00000000 irq 16
Zdenek> Jul 16 21:27:51 ata2: DUMMY
Zdenek> Jul 16 21:27:51 ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 18 (level,
Zdenek> low) -> IRQ 16
Zdenek> Jul 16 21:27:51 usb usb1: suspend_rh (auto-stop)
Zdenek> Jul 16 21:27:51 Adding 781188k swap on /dev/hdb7.  Priority:-1
Zdenek> extents:1 across:781188k
Zdenek> Jul 16 21:27:51 EXT3 FS on hdb1, internal journal
Zdenek> Jul 16 21:27:51 hub 1-0: 1.0: hub_suspend
Zdenek> Jul 16 21:27:51 usb usb1: suspend_rh
Zdenek> Jul 16 21:27:51 usb usb1: usb auto-suspend
Zdenek> Jul 16 21:27:51 w83781d: Found a W83782D chip at 0x290
Zdenek> Jul 16 21:27:51 device-mapper: ioctl: 4.11.0-ioctl (2006-10-12)
Zdenek> initialised:  dm-devel@redhat.com
Zdenek> Jul 16 21:27:51 md: md0 stopped.
Zdenek> Jul 16 21:27:51 fuse init (API version 7.8)
Zdenek> Jul 16 21:27:51 ReiserFS: hdb5: found reiserfs format "3.6" with
Zdenek> standard journal
Zdenek> Jul 16 21:27:51 ReiserFS: hdb5: using ordered data mode
Zdenek> Jul 16 21:27:51 ReiserFS: hdb5: journal params: device hdb5, size
Zdenek> 8192, journal first block 18, max trans len 1024, max batch 900, max
Zdenek> commit age 30, max trans age 30
Zdenek> Jul 16 21:27:51 ReiserFS: hdb5: checking transaction log (hdb5)
Zdenek> Jul 16 21:27:51 ReiserFS: hdb5: replayed 591 transactions in 45 seconds
Zdenek> Jul 16 21:27:51 ReiserFS: hdb5: Using r5 hash to sort names
Zdenek> Jul 16 21:27:51 ip_tables: (C) 2000-2006 Netfilter Core Team
Zdenek> Jul 16 21:27:51 NET: Registered protocol family 10
Zdenek> Jul 16 21:27:51 input: Power Button (FF) as /class/input/input3
Zdenek> Jul 16 21:27:51 ACPI: Power Button (FF) [PWRF]
Zdenek> Jul 16 21:27:51 input: Power Button (CM) as /class/input/input4
Zdenek> Jul 16 21:27:51 ACPI: Power Button (CM) [PWRB]
Zdenek> Jul 16 21:27:51 ACPI: Fan [FAN] (on)
Zdenek> Jul 16 21:27:51 ACPI: Thermal Zone [THRM] (48 C)
Zdenek> Jul 16 21:27:53 ath0: no IPv6 routers present
Zdenek> Jul 16 21:27:59 Installing knfsd (copyright (C) 1996  okir@monad.swb.de).
Zdenek> Jul 16 21:27:59 NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state
Zdenek> recovery directory
Zdenek> Jul 16 21:27:59 NFSD: starting 90-second grace period
Zdenek> Jul 16 21:28:52 APIC error on CPU1: 00(08)
Zdenek> Jul 16 21:30:02 [drm] Initialized drm 1.1.0 20060810
Zdenek> Jul 16 21:30:02 ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level,
Zdenek> low) -> IRQ 19
Zdenek> Jul 16 21:30:02 [drm] Initialized mga 3.2.1 20051102 on minor 0
Zdenek>  Jul 16 21:30:02 agpgart: Found an AGP 1.0 compliant device at 0000:00:00.0.
Zdenek> Jul 16 21:30:02 agpgart: Putting AGP V2 device at 0000:00:00.0 into 2x mode
Zdenek> Jul 16 21:30:02 agpgart: Putting AGP V2 device at 0000:01:00.0 into 2x mode
Zdenek> Jul 16 21:30:02 [drm] Initialized card for AGP DMA.


Zdenek> CONFIG_X86_32=y
Zdenek> CONFIG_GENERIC_TIME=y
Zdenek> CONFIG_CLOCKSOURCE_WATCHDOG=y
Zdenek> CONFIG_GENERIC_CLOCKEVENTS=y
Zdenek> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
Zdenek> CONFIG_LOCKDEP_SUPPORT=y
Zdenek> CONFIG_STACKTRACE_SUPPORT=y
Zdenek> CONFIG_SEMAPHORE_SLEEPERS=y
Zdenek> CONFIG_X86=y
Zdenek> CONFIG_MMU=y
Zdenek> CONFIG_ZONE_DMA=y
Zdenek> CONFIG_QUICKLIST=y
Zdenek> CONFIG_GENERIC_ISA_DMA=y
Zdenek> CONFIG_GENERIC_IOMAP=y
Zdenek> CONFIG_GENERIC_BUG=y
Zdenek> CONFIG_GENERIC_HWEIGHT=y
Zdenek> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
Zdenek> CONFIG_DMI=y
Zdenek> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
Zdenek> CONFIG_EXPERIMENTAL=y
Zdenek> CONFIG_LOCK_KERNEL=y
Zdenek> CONFIG_INIT_ENV_ARG_LIMIT=32
Zdenek> CONFIG_LOCALVERSION=""
Zdenek> CONFIG_LOCALVERSION_AUTO=y
Zdenek> CONFIG_SWAP=y
Zdenek> CONFIG_SYSVIPC=y
Zdenek> CONFIG_SYSVIPC_SYSCTL=y
Zdenek> CONFIG_IKCONFIG=y
Zdenek> CONFIG_IKCONFIG_PROC=y
Zdenek> CONFIG_LOG_BUF_SHIFT=15
Zdenek> CONFIG_SYSFS_DEPRECATED=y
Zdenek> CONFIG_BLK_DEV_INITRD=y
Zdenek> CONFIG_INITRAMFS_SOURCE=""
Zdenek> CONFIG_SYSCTL=y
Zdenek> CONFIG_UID16=y
Zdenek> CONFIG_SYSCTL_SYSCALL=y
Zdenek> CONFIG_KALLSYMS=y
Zdenek> CONFIG_KALLSYMS_ALL=y
Zdenek> CONFIG_HOTPLUG=y
Zdenek> CONFIG_PRINTK=y
Zdenek> CONFIG_BUG=y
Zdenek> CONFIG_ELF_CORE=y
Zdenek> CONFIG_BASE_FULL=y
Zdenek> CONFIG_FUTEX=y
Zdenek> CONFIG_ANON_INODES=y
Zdenek> CONFIG_EPOLL=y
Zdenek> CONFIG_SIGNALFD=y
Zdenek> CONFIG_TIMERFD=y
Zdenek> CONFIG_EVENTFD=y
Zdenek> CONFIG_SHMEM=y
Zdenek> CONFIG_VM_EVENT_COUNTERS=y
Zdenek> CONFIG_SLAB=y
Zdenek> CONFIG_RT_MUTEXES=y
Zdenek> CONFIG_BASE_SMALL=0
Zdenek> CONFIG_MODULES=y
Zdenek> CONFIG_MODULE_UNLOAD=y
Zdenek> CONFIG_MODULE_FORCE_UNLOAD=y
Zdenek> CONFIG_MODVERSIONS=y
Zdenek> CONFIG_KMOD=y
Zdenek> CONFIG_STOP_MACHINE=y
Zdenek> CONFIG_BLOCK=y
Zdenek> CONFIG_IOSCHED_NOOP=y
Zdenek> CONFIG_IOSCHED_AS=m
Zdenek> CONFIG_IOSCHED_DEADLINE=m
Zdenek> CONFIG_IOSCHED_CFQ=m
Zdenek> CONFIG_DEFAULT_NOOP=y
Zdenek> CONFIG_DEFAULT_IOSCHED="noop"
Zdenek> CONFIG_TICK_ONESHOT=y
Zdenek> CONFIG_NO_HZ=y
Zdenek> CONFIG_HIGH_RES_TIMERS=y
Zdenek> CONFIG_SMP=y
Zdenek> CONFIG_X86_PC=y
Zdenek> CONFIG_PARAVIRT=y
Zdenek> CONFIG_VMI=y
Zdenek> CONFIG_MPENTIUMIII=y
Zdenek> CONFIG_X86_CMPXCHG=y
Zdenek> CONFIG_X86_L1_CACHE_SHIFT=5
Zdenek> CONFIG_X86_XADD=y
Zdenek> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
Zdenek> CONFIG_GENERIC_CALIBRATE_DELAY=y
Zdenek> CONFIG_X86_WP_WORKS_OK=y
Zdenek> CONFIG_X86_INVLPG=y
Zdenek> CONFIG_X86_BSWAP=y
Zdenek> CONFIG_X86_POPAD_OK=y
Zdenek> CONFIG_X86_GOOD_APIC=y
Zdenek> CONFIG_X86_INTEL_USERCOPY=y
Zdenek> CONFIG_X86_USE_PPRO_CHECKSUM=y
Zdenek> CONFIG_X86_TSC=y
Zdenek> CONFIG_X86_CMOV=y
Zdenek> CONFIG_X86_MINIMUM_CPU_MODEL=4
Zdenek> CONFIG_HPET_TIMER=y
Zdenek> CONFIG_NR_CPUS=8
Zdenek> CONFIG_SCHED_MC=y
Zdenek> CONFIG_PREEMPT=y
Zdenek> CONFIG_PREEMPT_BKL=y
Zdenek> CONFIG_X86_LOCAL_APIC=y
Zdenek> CONFIG_X86_IO_APIC=y
Zdenek> CONFIG_X86_MCE=y
Zdenek> CONFIG_X86_MCE_NONFATAL=y
Zdenek> CONFIG_X86_MCE_P4THERMAL=y
Zdenek> CONFIG_VM86=y
Zdenek> CONFIG_MICROCODE=m
Zdenek> CONFIG_MICROCODE_OLD_INTERFACE=y
Zdenek> CONFIG_X86_MSR=m
Zdenek> CONFIG_X86_CPUID=m
Zdenek> CONFIG_EDD=m
Zdenek> CONFIG_HIGHMEM4G=y
Zdenek> CONFIG_PAGE_OFFSET=0xC0000000
Zdenek> CONFIG_HIGHMEM=y
Zdenek> CONFIG_ARCH_FLATMEM_ENABLE=y
Zdenek> CONFIG_ARCH_SPARSEMEM_ENABLE=y
Zdenek> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
Zdenek> CONFIG_ARCH_POPULATES_NODE_MAP=y
Zdenek> CONFIG_SELECT_MEMORY_MODEL=y
Zdenek> CONFIG_FLATMEM_MANUAL=y
Zdenek> CONFIG_FLATMEM=y
Zdenek> CONFIG_FLAT_NODE_MEM_MAP=y
Zdenek> CONFIG_SPARSEMEM_STATIC=y
Zdenek> CONFIG_SPLIT_PTLOCK_CPUS=4
Zdenek> CONFIG_ZONE_DMA_FLAG=1
Zdenek> CONFIG_NR_QUICK=1
Zdenek> CONFIG_MTRR=y
Zdenek> CONFIG_SECCOMP=y
Zdenek> CONFIG_HZ_300=y
Zdenek> CONFIG_HZ=300
Zdenek> CONFIG_KEXEC=y
Zdenek> CONFIG_PHYSICAL_START=0x100000
Zdenek> CONFIG_PHYSICAL_ALIGN=0x100000
Zdenek> CONFIG_HOTPLUG_CPU=y
Zdenek> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
Zdenek> CONFIG_PM=y
Zdenek> CONFIG_PM_LEGACY=y
Zdenek> CONFIG_SUSPEND_SMP=y
Zdenek> CONFIG_ACPI=y
Zdenek> CONFIG_ACPI_SLEEP=y
Zdenek> CONFIG_ACPI_SLEEP_PROC_FS=y
Zdenek> CONFIG_ACPI_PROCFS=y
Zdenek>  CONFIG_ACPI_AC=m
Zdenek> CONFIG_ACPI_BATTERY=m
Zdenek> CONFIG_ACPI_BUTTON=m
Zdenek> CONFIG_ACPI_VIDEO=m
Zdenek> CONFIG_ACPI_FAN=m
Zdenek> CONFIG_ACPI_PROCESSOR=m
Zdenek> CONFIG_ACPI_HOTPLUG_CPU=y
Zdenek> CONFIG_ACPI_THERMAL=m
Zdenek> CONFIG_ACPI_BLACKLIST_YEAR=0
Zdenek> CONFIG_ACPI_EC=y
Zdenek> CONFIG_ACPI_POWER=y
Zdenek> CONFIG_ACPI_SYSTEM=y
Zdenek> CONFIG_X86_PM_TIMER=y
Zdenek> CONFIG_ACPI_CONTAINER=m
Zdenek> CONFIG_CPU_FREQ=y
Zdenek> CONFIG_CPU_FREQ_TABLE=m
Zdenek> CONFIG_CPU_FREQ_STAT=m
Zdenek> CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
Zdenek> CONFIG_CPU_FREQ_GOV_PERFORMANCE=m
Zdenek> CONFIG_CPU_FREQ_GOV_POWERSAVE=m
Zdenek> CONFIG_CPU_FREQ_GOV_USERSPACE=y
Zdenek> CONFIG_CPU_FREQ_GOV_ONDEMAND=m
Zdenek> CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m
Zdenek> CONFIG_X86_ACPI_CPUFREQ=m
Zdenek> CONFIG_X86_SPEEDSTEP_CENTRINO=m
Zdenek> CONFIG_X86_SPEEDSTEP_CENTRINO_ACPI=y
Zdenek> CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
Zdenek> CONFIG_X86_SPEEDSTEP_ICH=m
Zdenek> CONFIG_X86_SPEEDSTEP_SMI=m
Zdenek> CONFIG_X86_P4_CLOCKMOD=m
Zdenek> CONFIG_X86_CPUFREQ_NFORCE2=m
Zdenek> CONFIG_X86_ACPI_CPUFREQ_PROC_INTF=y
Zdenek> CONFIG_X86_SPEEDSTEP_LIB=m
Zdenek> CONFIG_PCI=y
Zdenek> CONFIG_PCI_GOANY=y
Zdenek> CONFIG_PCI_BIOS=y
Zdenek> CONFIG_PCI_DIRECT=y
Zdenek> CONFIG_PCI_MMCONFIG=y
Zdenek> CONFIG_ARCH_SUPPORTS_MSI=y
Zdenek> CONFIG_HT_IRQ=y
Zdenek> CONFIG_ISA_DMA_API=y
Zdenek> CONFIG_ISA=y
Zdenek> CONFIG_K8_NB=y
Zdenek> CONFIG_PCCARD=m
Zdenek> CONFIG_PCMCIA=m
Zdenek> CONFIG_PCMCIA_LOAD_CIS=y
Zdenek> CONFIG_PCMCIA_IOCTL=y
Zdenek> CONFIG_CARDBUS=y
Zdenek> CONFIG_PCMCIA_PROBE=y
Zdenek> CONFIG_BINFMT_ELF=y
Zdenek> CONFIG_BINFMT_AOUT=m
Zdenek> CONFIG_BINFMT_MISC=m
Zdenek> CONFIG_NET=y
Zdenek> CONFIG_PACKET=y
Zdenek> CONFIG_UNIX=y
Zdenek> CONFIG_XFRM=y
Zdenek> CONFIG_XFRM_USER=m
Zdenek> CONFIG_INET=y
Zdenek> CONFIG_IP_MULTICAST=y
Zdenek> CONFIG_IP_ADVANCED_ROUTER=y
Zdenek> CONFIG_ASK_IP_FIB_HASH=y
Zdenek> CONFIG_IP_FIB_HASH=y
Zdenek> CONFIG_IP_MULTIPLE_TABLES=y
Zdenek> CONFIG_IP_ROUTE_VERBOSE=y
Zdenek> CONFIG_NET_IPIP=m
Zdenek> CONFIG_NET_IPGRE=m
Zdenek> CONFIG_SYN_COOKIES=y
Zdenek> CONFIG_INET_IPCOMP=m
Zdenek> CONFIG_INET_XFRM_TUNNEL=m
Zdenek> CONFIG_INET_TUNNEL=m
Zdenek> CONFIG_INET_XFRM_MODE_TRANSPORT=m
Zdenek> CONFIG_INET_XFRM_MODE_TUNNEL=m
Zdenek> CONFIG_INET_XFRM_MODE_BEET=y
Zdenek> CONFIG_INET_DIAG=y
Zdenek> CONFIG_INET_TCP_DIAG=y
Zdenek> CONFIG_TCP_CONG_CUBIC=y
Zdenek> CONFIG_DEFAULT_TCP_CONG="cubic"
Zdenek> CONFIG_IP_VS=m
Zdenek> CONFIG_IP_VS_TAB_BITS=12
Zdenek> CONFIG_IP_VS_PROTO_TCP=y
Zdenek> CONFIG_IP_VS_PROTO_UDP=y
Zdenek> CONFIG_IP_VS_RR=m
Zdenek> CONFIG_IP_VS_DH=m
Zdenek> CONFIG_IP_VS_FTP=m
Zdenek> CONFIG_IPV6=m
Zdenek> CONFIG_INET6_TUNNEL=m
Zdenek> CONFIG_INET6_XFRM_MODE_TRANSPORT=m
Zdenek> CONFIG_INET6_XFRM_MODE_TUNNEL=m
Zdenek> CONFIG_INET6_XFRM_MODE_BEET=m
Zdenek> CONFIG_IPV6_SIT=m
Zdenek> CONFIG_IPV6_TUNNEL=m
Zdenek> CONFIG_NETFILTER=y
Zdenek> CONFIG_NETFILTER_NETLINK=m
Zdenek> CONFIG_NETFILTER_NETLINK_QUEUE=m
Zdenek> CONFIG_NETFILTER_NETLINK_LOG=m
Zdenek> CONFIG_NF_CONNTRACK_ENABLED=m
Zdenek> CONFIG_NF_CONNTRACK=m
Zdenek> CONFIG_NF_CT_ACCT=y
Zdenek> CONFIG_NF_CONNTRACK_MARK=y
Zdenek> CONFIG_NF_CONNTRACK_FTP=m
Zdenek> CONFIG_NF_CONNTRACK_SIP=m
Zdenek> CONFIG_NF_CT_NETLINK=m
Zdenek> CONFIG_NETFILTER_XTABLES=m
Zdenek> CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
Zdenek> CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
Zdenek> CONFIG_NETFILTER_XT_TARGET_MARK=m
Zdenek> CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
Zdenek> CONFIG_NETFILTER_XT_TARGET_NFLOG=m
Zdenek> CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
Zdenek> CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
Zdenek> CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
Zdenek> CONFIG_NETFILTER_XT_MATCH_HELPER=m
Zdenek> CONFIG_NETFILTER_XT_MATCH_MAC=m
Zdenek> CONFIG_NETFILTER_XT_MATCH_MARK=m
Zdenek> CONFIG_NF_CONNTRACK_IPV4=m
Zdenek> CONFIG_NF_CONNTRACK_PROC_COMPAT=y
Zdenek> CONFIG_IP_NF_IPTABLES=m
Zdenek> CONFIG_IP_NF_MATCH_IPRANGE=m
Zdenek> CONFIG_IP_NF_MATCH_TOS=m
Zdenek> CONFIG_IP_NF_MATCH_RECENT=m
Zdenek> CONFIG_IP_NF_MATCH_ECN=m
Zdenek> CONFIG_IP_NF_MATCH_AH=m
Zdenek> CONFIG_IP_NF_MATCH_TTL=m
Zdenek> CONFIG_IP_NF_MATCH_OWNER=m
Zdenek> CONFIG_IP_NF_MATCH_ADDRTYPE=m
Zdenek> CONFIG_IP_NF_FILTER=m
Zdenek> CONFIG_IP_NF_TARGET_REJECT=m
Zdenek> CONFIG_IP_NF_TARGET_LOG=m
Zdenek> CONFIG_NF_NAT=m
Zdenek> CONFIG_NF_NAT_NEEDED=y
Zdenek> CONFIG_IP_NF_TARGET_MASQUERADE=m
Zdenek> CONFIG_IP_NF_TARGET_REDIRECT=m
Zdenek> CONFIG_IP_NF_TARGET_NETMAP=m
Zdenek> CONFIG_IP_NF_TARGET_SAME=m
Zdenek> CONFIG_NF_NAT_FTP=m
Zdenek> CONFIG_NF_NAT_SIP=m
Zdenek> CONFIG_IP_NF_MANGLE=m
Zdenek> CONFIG_IP_NF_TARGET_TOS=m
Zdenek> CONFIG_IP_NF_TARGET_ECN=m
Zdenek> CONFIG_IP_NF_TARGET_TTL=m
Zdenek> CONFIG_IP_NF_ARPTABLES=m
Zdenek> CONFIG_IP_NF_ARPFILTER=m
Zdenek> CONFIG_IP_NF_ARP_MANGLE=m
Zdenek> CONFIG_NET_SCHED=y
Zdenek> CONFIG_NET_SCH_FIFO=y
Zdenek> CONFIG_NET_SCH_CBQ=m
Zdenek> CONFIG_NET_SCH_HTB=m
Zdenek> CONFIG_NET_SCH_NETEM=m
Zdenek> CONFIG_NET_ESTIMATOR=y
Zdenek> CONFIG_NET_PKTGEN=m
Zdenek> CONFIG_IRDA=m
Zdenek> CONFIG_IRLAN=m
Zdenek> CONFIG_IRNET=m
Zdenek> CONFIG_IRCOMM=m
Zdenek> CONFIG_IRDA_ULTRA=y
Zdenek> CONFIG_IRDA_CACHE_LAST_LSAP=y
Zdenek> CONFIG_IRDA_FAST_RR=y
Zdenek> CONFIG_IRTTY_SIR=m
Zdenek> CONFIG_USB_IRDA=m
Zdenek> CONFIG_NSC_FIR=m
Zdenek> CONFIG_SMC_IRCC_FIR=m
Zdenek> CONFIG_BT=m
Zdenek> CONFIG_BT_L2CAP=m
Zdenek> CONFIG_BT_SCO=m
Zdenek> CONFIG_BT_RFCOMM=m
Zdenek> CONFIG_BT_RFCOMM_TTY=y
Zdenek> CONFIG_BT_BNEP=m
Zdenek> CONFIG_BT_BNEP_MC_FILTER=y
Zdenek> CONFIG_BT_BNEP_PROTO_FILTER=y
Zdenek> CONFIG_BT_HIDP=m
Zdenek> CONFIG_BT_HCIUSB=m
Zdenek> CONFIG_FIB_RULES=y
Zdenek> CONFIG_CFG80211=m
Zdenek> CONFIG_WIRELESS_EXT=y
Zdenek> CONFIG_IEEE80211=m
Zdenek> CONFIG_IEEE80211_CRYPT_WEP=m
Zdenek> CONFIG_IEEE80211_CRYPT_CCMP=m
Zdenek> CONFIG_IEEE80211_CRYPT_TKIP=m
Zdenek> CONFIG_PREVENT_FIRMWARE_BUILD=y
Zdenek> CONFIG_FW_LOADER=m
Zdenek> CONFIG_PARPORT=m
Zdenek> CONFIG_PARPORT_PC=m
Zdenek> CONFIG_PARPORT_PC_FIFO=y
Zdenek> CONFIG_PARPORT_1284=y
Zdenek> CONFIG_PNP=y
Zdenek> CONFIG_ISAPNP=y
Zdenek> CONFIG_PNPBIOS=y
Zdenek> CONFIG_PNPBIOS_PROC_FS=y
Zdenek> CONFIG_PNPACPI=y
Zdenek> CONFIG_BLK_DEV_FD=m
Zdenek> CONFIG_BLK_DEV_LOOP=m
Zdenek> CONFIG_BLK_DEV_CRYPTOLOOP=m
Zdenek> CONFIG_BLK_DEV_NBD=m
Zdenek> CONFIG_BLK_DEV_RAM=m
Zdenek> CONFIG_BLK_DEV_RAM_COUNT=16
Zdenek> CONFIG_BLK_DEV_RAM_SIZE=4096
Zdenek> CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
Zdenek> CONFIG_CDROM_PKTCDVD=m
Zdenek> CONFIG_CDROM_PKTCDVD_BUFFERS=8
Zdenek> CONFIG_CDROM_PKTCDVD_WCACHE=y
Zdenek> CONFIG_IDE=y
Zdenek> CONFIG_BLK_DEV_IDE=y
Zdenek> CONFIG_BLK_DEV_IDEDISK=y
Zdenek> CONFIG_BLK_DEV_IDECD=m
Zdenek> CONFIG_BLK_DEV_IDEFLOPPY=m
Zdenek> CONFIG_BLK_DEV_IDESCSI=m
Zdenek> CONFIG_BLK_DEV_IDEACPI=y
Zdenek> CONFIG_IDE_TASK_IOCTL=y
Zdenek> CONFIG_IDE_PROC_FS=y
Zdenek> CONFIG_IDE_GENERIC=y
Zdenek> CONFIG_BLK_DEV_CMD640=y
Zdenek> CONFIG_BLK_DEV_IDEPCI=y
Zdenek> CONFIG_IDEPCI_SHARE_IRQ=y
Zdenek> CONFIG_IDEPCI_PCIBUS_ORDER=y
Zdenek> CONFIG_BLK_DEV_GENERIC=y
Zdenek> CONFIG_BLK_DEV_IDEDMA_PCI=y
Zdenek> CONFIG_BLK_DEV_AMD74XX=y
Zdenek> CONFIG_BLK_DEV_CMD64X=y
Zdenek> CONFIG_BLK_DEV_HPT366=y
Zdenek> CONFIG_BLK_DEV_PIIX=y
Zdenek> CONFIG_BLK_DEV_PDC202XX_OLD=y
Zdenek> CONFIG_PDC202XX_BURST=y
Zdenek> CONFIG_BLK_DEV_PDC202XX_NEW=y
Zdenek> CONFIG_BLK_DEV_VIA82CXXX=y
Zdenek> CONFIG_BLK_DEV_IDEDMA=y
Zdenek> CONFIG_SCSI=m
Zdenek> CONFIG_SCSI_PROC_FS=y
Zdenek> CONFIG_BLK_DEV_SD=m
Zdenek> CONFIG_BLK_DEV_SR=m
Zdenek> CONFIG_CHR_DEV_SG=m
Zdenek> CONFIG_SCSI_MULTI_LUN=y
Zdenek> CONFIG_SCSI_CONSTANTS=y
Zdenek> CONFIG_SCSI_LOGGING=y
Zdenek>  CONFIG_SCSI_WAIT_SCAN=m
Zdenek> CONFIG_SCSI_SPI_ATTRS=m
Zdenek> CONFIG_SCSI_ISCSI_ATTRS=m
Zdenek> CONFIG_ATA=m
Zdenek> CONFIG_ATA_ACPI=y
Zdenek> CONFIG_PATA_HPT366=m
Zdenek> CONFIG_MD=y
Zdenek> CONFIG_BLK_DEV_MD=y
Zdenek> CONFIG_MD_LINEAR=m
Zdenek> CONFIG_MD_RAID0=m
Zdenek> CONFIG_MD_RAID1=y
Zdenek> CONFIG_MD_RAID456=m
Zdenek> CONFIG_MD_RAID5_RESHAPE=y
Zdenek> CONFIG_MD_MULTIPATH=m
Zdenek> CONFIG_BLK_DEV_DM=m
Zdenek> CONFIG_DM_CRYPT=m
Zdenek> CONFIG_DM_SNAPSHOT=m
Zdenek> CONFIG_DM_MIRROR=m
Zdenek> CONFIG_DM_ZERO=m
Zdenek> CONFIG_DM_MULTIPATH=m
Zdenek> CONFIG_DM_MULTIPATH_EMC=m
Zdenek> CONFIG_DM_DELAY=m
Zdenek> CONFIG_FUSION=y
Zdenek> CONFIG_FUSION_SPI=m
Zdenek> CONFIG_FUSION_MAX_SGE=128
Zdenek> CONFIG_I2O=m
Zdenek> CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
Zdenek> CONFIG_I2O_CONFIG=m
Zdenek> CONFIG_I2O_BUS=m
Zdenek>  CONFIG_I2O_BLOCK=m
Zdenek> CONFIG_I2O_SCSI=m
Zdenek> CONFIG_I2O_PROC=m
Zdenek> CONFIG_NETDEVICES=y
Zdenek> CONFIG_DUMMY=m
Zdenek> CONFIG_TUN=m
Zdenek> CONFIG_NET_ETHERNET=y
Zdenek> CONFIG_MII=m
Zdenek> CONFIG_NET_VENDOR_3COM=y
Zdenek> CONFIG_EL3=m
Zdenek> CONFIG_VORTEX=m
Zdenek> CONFIG_HP100=m
Zdenek> CONFIG_NET_PCI=y
Zdenek> CONFIG_EEPRO100=m
Zdenek> CONFIG_E100=m
Zdenek> CONFIG_NE2K_PCI=m
Zdenek> CONFIG_8139TOO=m
Zdenek> CONFIG_NETDEV_1000=y
Zdenek> CONFIG_E1000=m
Zdenek> CONFIG_TIGON3=m
Zdenek> CONFIG_BNX2=m
Zdenek> CONFIG_NETDEV_10000=y
Zdenek>  CONFIG_WLAN_80211=y
Zdenek> CONFIG_IPW2100=m
Zdenek> CONFIG_IPW2100_MONITOR=y
Zdenek> CONFIG_IPW2200=m
Zdenek> CONFIG_IPW2200_MONITOR=y
Zdenek> CONFIG_IPW2200_RADIOTAP=y
Zdenek> CONFIG_PPP=m
Zdenek> CONFIG_PPP_MULTILINK=y
Zdenek> CONFIG_PPP_FILTER=y
Zdenek> CONFIG_PPP_ASYNC=m
Zdenek> CONFIG_PPP_SYNC_TTY=m
Zdenek> CONFIG_PPP_DEFLATE=m
Zdenek> CONFIG_PPP_BSDCOMP=m
Zdenek> CONFIG_PPP_MPPE=m
Zdenek> CONFIG_PPPOE=m
Zdenek> CONFIG_SLHC=m
Zdenek> CONFIG_SHAPER=m
Zdenek> CONFIG_INPUT=y
Zdenek> CONFIG_INPUT_MOUSEDEV=y
Zdenek> CONFIG_INPUT_MOUSEDEV_PSAUX=y
Zdenek> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1400
Zdenek> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=1050
Zdenek> CONFIG_INPUT_EVDEV=m
Zdenek> CONFIG_INPUT_KEYBOARD=y
Zdenek> CONFIG_KEYBOARD_ATKBD=y
Zdenek> CONFIG_INPUT_MOUSE=y
Zdenek> CONFIG_MOUSE_PS2=y
Zdenek> CONFIG_MOUSE_PS2_ALPS=y
Zdenek> CONFIG_MOUSE_PS2_LOGIPS2PP=y
Zdenek> CONFIG_MOUSE_PS2_SYNAPTICS=y
Zdenek> CONFIG_MOUSE_PS2_LIFEBOOK=y
Zdenek> CONFIG_MOUSE_PS2_TRACKPOINT=y
Zdenek> CONFIG_MOUSE_SERIAL=y
Zdenek> CONFIG_SERIO=y
Zdenek> CONFIG_SERIO_I8042=y
Zdenek> CONFIG_SERIO_SERPORT=y
Zdenek> CONFIG_SERIO_LIBPS2=y
Zdenek> CONFIG_GAMEPORT=m
Zdenek> CONFIG_GAMEPORT_EMU10K1=m
Zdenek> CONFIG_VT=y
Zdenek> CONFIG_VT_CONSOLE=y
Zdenek> CONFIG_HW_CONSOLE=y
Zdenek> CONFIG_SERIAL_NONSTANDARD=y
Zdenek> CONFIG_CYCLADES=m
Zdenek> CONFIG_SERIAL_8250=m
Zdenek> CONFIG_SERIAL_8250_PCI=m
Zdenek> CONFIG_SERIAL_8250_PNP=m
Zdenek> CONFIG_SERIAL_8250_NR_UARTS=4
Zdenek> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
Zdenek> CONFIG_SERIAL_8250_EXTENDED=y
Zdenek> CONFIG_SERIAL_8250_MANY_PORTS=y
Zdenek> CONFIG_SERIAL_8250_SHARE_IRQ=y
Zdenek> CONFIG_SERIAL_8250_DETECT_IRQ=y
Zdenek> CONFIG_SERIAL_CORE=m
Zdenek> CONFIG_UNIX98_PTYS=y
Zdenek> CONFIG_LEGACY_PTYS=y
Zdenek> CONFIG_LEGACY_PTY_COUNT=256
Zdenek> CONFIG_PRINTER=m
Zdenek> CONFIG_PPDEV=m
Zdenek> CONFIG_HW_RANDOM=y
Zdenek> CONFIG_HW_RANDOM_INTEL=y
Zdenek> CONFIG_HW_RANDOM_AMD=y
Zdenek>  CONFIG_NVRAM=m
Zdenek> CONFIG_RTC=m
Zdenek> CONFIG_GEN_RTC=m
Zdenek> CONFIG_GEN_RTC_X=y
Zdenek> CONFIG_AGP=m
Zdenek> CONFIG_AGP_ATI=m
Zdenek> CONFIG_AGP_AMD=m
Zdenek> CONFIG_AGP_AMD64=m
Zdenek> CONFIG_AGP_INTEL=m
Zdenek> CONFIG_AGP_NVIDIA=m
Zdenek> CONFIG_AGP_VIA=m
Zdenek> CONFIG_DRM=m
Zdenek> CONFIG_DRM_R128=m
Zdenek> CONFIG_DRM_RADEON=m
Zdenek> CONFIG_DRM_I810=m
Zdenek> CONFIG_DRM_I830=m
Zdenek> CONFIG_DRM_I915=m
Zdenek> CONFIG_DRM_MGA=m
Zdenek> CONFIG_HPET=y
Zdenek> CONFIG_HPET_MMAP=y
Zdenek> CONFIG_HANGCHECK_TIMER=m
Zdenek> CONFIG_DEVPORT=y
Zdenek> CONFIG_I2C=m
Zdenek> CONFIG_I2C_BOARDINFO=y
Zdenek> CONFIG_I2C_CHARDEV=m
Zdenek> CONFIG_I2C_ALGOBIT=m
Zdenek> CONFIG_I2C_ALGOPCF=m
Zdenek> CONFIG_I2C_I810=m
Zdenek> CONFIG_I2C_PIIX4=m
Zdenek> CONFIG_I2C_ISA=m
Zdenek> CONFIG_I2C_PARPORT=m
Zdenek> CONFIG_I2C_VIAPRO=m
Zdenek> CONFIG_SENSORS_PCF8574=m
Zdenek> CONFIG_SENSORS_PCF8591=m
Zdenek> CONFIG_HWMON=m
Zdenek> CONFIG_HWMON_VID=m
Zdenek> CONFIG_SENSORS_ABITUGURU=m
Zdenek> CONFIG_SENSORS_CORETEMP=m
Zdenek> CONFIG_SENSORS_LM75=m
Zdenek> CONFIG_SENSORS_LM77=m
Zdenek> CONFIG_SENSORS_LM78=m
Zdenek> CONFIG_SENSORS_LM80=m
Zdenek> CONFIG_SENSORS_LM83=m
Zdenek> CONFIG_SENSORS_LM85=m
Zdenek> CONFIG_SENSORS_LM90=m
Zdenek> CONFIG_SENSORS_VIA686A=m
Zdenek> CONFIG_SENSORS_W83781D=m
Zdenek> CONFIG_SENSORS_W83792D=m
Zdenek> CONFIG_SENSORS_W83L785TS=m
Zdenek> CONFIG_SENSORS_W83627HF=m
Zdenek>  CONFIG_VIDEO_DEV=m
Zdenek> CONFIG_VIDEO_V4L1=y
Zdenek> CONFIG_VIDEO_V4L1_COMPAT=y
Zdenek> CONFIG_VIDEO_V4L2=y
Zdenek> CONFIG_VIDEO_CAPTURE_DRIVERS=y
Zdenek> CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
Zdenek> CONFIG_VIDEO_TVAUDIO=m
Zdenek> CONFIG_VIDEO_TDA7432=m
Zdenek> CONFIG_VIDEO_TDA9875=m
Zdenek> CONFIG_VIDEO_MSP3400=m
Zdenek> CONFIG_VIDEO_CS53L32A=m
Zdenek> CONFIG_VIDEO_WM8775=m
Zdenek> CONFIG_VIDEO_WM8739=m
Zdenek> CONFIG_VIDEO_SAA711X=m
Zdenek> CONFIG_VIDEO_CX25840=m
Zdenek> CONFIG_VIDEO_CX2341X=m
Zdenek> CONFIG_VIDEO_SAA7127=m
Zdenek> CONFIG_VIDEO_UPD64031A=m
Zdenek> CONFIG_VIDEO_UPD64083=m
Zdenek> CONFIG_VIDEO_VIVI=m
Zdenek> CONFIG_VIDEO_BT848=m
Zdenek> CONFIG_VIDEO_SAA7134=m
Zdenek> CONFIG_VIDEO_SAA7134_ALSA=m
Zdenek> CONFIG_VIDEO_SAA7134_DVB=m
Zdenek> CONFIG_VIDEO_CX88=m
Zdenek> CONFIG_VIDEO_IVTV=m
Zdenek> CONFIG_V4L_USB_DRIVERS=y
Zdenek> CONFIG_RADIO_ADAPTERS=y
Zdenek> CONFIG_DVB_CORE=m
Zdenek> CONFIG_DVB_CAPTURE_DRIVERS=y
Zdenek> CONFIG_DVB_TDA10086=m
Zdenek> CONFIG_DVB_TDA1004X=m
Zdenek> CONFIG_DVB_MT352=m
Zdenek> CONFIG_DVB_NXT200X=m
Zdenek> CONFIG_DVB_PLL=m
Zdenek> CONFIG_DVB_TDA826X=m
Zdenek>  CONFIG_DVB_TDA827X=m
Zdenek> CONFIG_DVB_ISL6421=m
Zdenek> CONFIG_VIDEO_TUNER=m
Zdenek> CONFIG_VIDEO_BUF=m
Zdenek> CONFIG_VIDEO_BUF_DVB=m
Zdenek> CONFIG_VIDEO_BTCX=m
Zdenek> CONFIG_VIDEO_IR=m
Zdenek> CONFIG_VIDEO_TVEEPROM=m
Zdenek> CONFIG_DAB=y
Zdenek> CONFIG_BACKLIGHT_LCD_SUPPORT=y
Zdenek> CONFIG_BACKLIGHT_CLASS_DEVICE=y
Zdenek> CONFIG_LCD_CLASS_DEVICE=m
Zdenek> CONFIG_DISPLAY_SUPPORT=m
Zdenek> CONFIG_VGASTATE=m
Zdenek> CONFIG_FB=y
Zdenek> CONFIG_FIRMWARE_EDID=y
Zdenek> CONFIG_FB_DDC=m
Zdenek> CONFIG_FB_CFB_FILLRECT=y
Zdenek> CONFIG_FB_CFB_COPYAREA=y
Zdenek> CONFIG_FB_CFB_IMAGEBLIT=y
Zdenek> CONFIG_FB_SYS_FILLRECT=m
Zdenek> CONFIG_FB_SYS_COPYAREA=m
Zdenek> CONFIG_FB_SYS_IMAGEBLIT=m
Zdenek> CONFIG_FB_SYS_FOPS=m
Zdenek> CONFIG_FB_DEFERRED_IO=y
Zdenek> CONFIG_FB_BACKLIGHT=y
Zdenek> CONFIG_FB_MODE_HELPERS=y
Zdenek>  CONFIG_FB_TILEBLITTING=y
Zdenek> CONFIG_FB_VGA16=m
Zdenek> CONFIG_FB_VESA=y
Zdenek> CONFIG_FB_I810=m
Zdenek> CONFIG_FB_I810_GTF=y
Zdenek> CONFIG_FB_I810_I2C=y
Zdenek> CONFIG_FB_INTEL=m
Zdenek> CONFIG_FB_INTEL_I2C=y
Zdenek> CONFIG_FB_MATROX=m
Zdenek> CONFIG_FB_MATROX_G=y
Zdenek> CONFIG_FB_MATROX_I2C=m
Zdenek> CONFIG_FB_MATROX_MAVEN=m
Zdenek> CONFIG_FB_MATROX_MULTIHEAD=y
Zdenek> CONFIG_FB_RADEON=m
Zdenek> CONFIG_FB_RADEON_I2C=y
Zdenek> CONFIG_FB_RADEON_BACKLIGHT=y
Zdenek> CONFIG_FB_ATY128=m
Zdenek> CONFIG_FB_ATY128_BACKLIGHT=y
Zdenek>  CONFIG_FB_VIRTUAL=m
Zdenek> CONFIG_VGA_CONSOLE=y
Zdenek> CONFIG_VIDEO_SELECT=y
Zdenek> CONFIG_DUMMY_CONSOLE=y
Zdenek> CONFIG_FRAMEBUFFER_CONSOLE=y
Zdenek> CONFIG_FONTS=y
Zdenek> CONFIG_FONT_8x16=y
Zdenek> CONFIG_LOGO=y
Zdenek> CONFIG_LOGO_LINUX_VGA16=y
Zdenek> CONFIG_LOGO_LINUX_CLUT224=y
Zdenek> CONFIG_SOUND=m
Zdenek> CONFIG_SND=m
Zdenek> CONFIG_SND_TIMER=m
Zdenek> CONFIG_SND_PCM=m
Zdenek> CONFIG_SND_HWDEP=m
Zdenek> CONFIG_SND_RAWMIDI=m
Zdenek> CONFIG_SND_OSSEMUL=y
Zdenek> CONFIG_SND_MIXER_OSS=m
Zdenek> CONFIG_SND_PCM_OSS=m
Zdenek> CONFIG_SND_PCM_OSS_PLUGINS=y
Zdenek> CONFIG_SND_RTCTIMER=m
Zdenek> CONFIG_SND_SUPPORT_OLD_API=y
Zdenek> CONFIG_SND_VERBOSE_PROCFS=y
Zdenek> CONFIG_SND_MPU401_UART=m
Zdenek> CONFIG_SND_OPL3_LIB=m
Zdenek> CONFIG_SND_AC97_CODEC=m
Zdenek> CONFIG_SND_DUMMY=m
Zdenek> CONFIG_SND_MPU401=m
Zdenek> CONFIG_SND_BT87X=m
Zdenek> CONFIG_SND_BT87X_OVERCLOCK=y
Zdenek> CONFIG_SND_CA0106=m
Zdenek> CONFIG_SND_CMIPCI=m
Zdenek> CONFIG_SND_EMU10K1=m
Zdenek> CONFIG_SND_EMU10K1X=m
Zdenek> CONFIG_SND_ES1968=m
Zdenek> CONFIG_SND_HDA_INTEL=m
Zdenek> CONFIG_SND_INTEL8X0=m
Zdenek> CONFIG_SND_VIA82XX=m
Zdenek> CONFIG_SND_AC97_POWER_SAVE=y
Zdenek> CONFIG_SOUND_PRIME=m
Zdenek> CONFIG_AC97_BUS=m
Zdenek> CONFIG_HID=y
Zdenek> CONFIG_USB_HID=m
Zdenek> CONFIG_HID_FF=y
Zdenek> CONFIG_USB_HIDDEV=y
Zdenek> CONFIG_USB_ARCH_HAS_HCD=y
Zdenek> CONFIG_USB_ARCH_HAS_OHCI=y
Zdenek> CONFIG_USB_ARCH_HAS_EHCI=y
Zdenek> CONFIG_USB=m
Zdenek> CONFIG_USB_DEBUG=y
Zdenek> CONFIG_USB_DEVICEFS=y
Zdenek> CONFIG_USB_SUSPEND=y
Zdenek> CONFIG_USB_EHCI_HCD=m
Zdenek> CONFIG_USB_EHCI_SPLIT_ISO=y
Zdenek> CONFIG_USB_EHCI_ROOT_HUB_TT=y
Zdenek> CONFIG_USB_OHCI_HCD=m
Zdenek> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
Zdenek> CONFIG_USB_UHCI_HCD=m
Zdenek> CONFIG_USB_ACM=m
Zdenek> CONFIG_USB_PRINTER=m
Zdenek> CONFIG_USB_STORAGE=m
Zdenek> CONFIG_USB_MON=y
Zdenek> CONFIG_USB_SERIAL=m
Zdenek> CONFIG_USB_SERIAL_GENERIC=y
Zdenek> CONFIG_USB_SERIAL_IPAQ=m
Zdenek> CONFIG_USB_SERIAL_KEYSPAN_PDA=m
Zdenek> CONFIG_USB_SERIAL_PL2303=m
Zdenek> CONFIG_USB_SERIAL_SAFE=m
Zdenek> CONFIG_USB_EZUSB=y
Zdenek> CONFIG_USB_TEST=m
Zdenek> CONFIG_USB_GADGET=m
Zdenek> CONFIG_USB_GADGET_SELECTED=y
Zdenek> CONFIG_USB_GADGET_NET2280=y
Zdenek> CONFIG_USB_NET2280=m
Zdenek> CONFIG_USB_GADGET_DUALSPEED=y
Zdenek> CONFIG_USB_G_SERIAL=m
Zdenek> CONFIG_MMC=m
Zdenek> CONFIG_MMC_BLOCK=m
Zdenek> CONFIG_RTC_LIB=m
Zdenek> CONFIG_RTC_CLASS=m
Zdenek> CONFIG_RTC_INTF_SYSFS=y
Zdenek> CONFIG_RTC_INTF_PROC=y
Zdenek> CONFIG_RTC_INTF_DEV=y
Zdenek> CONFIG_RTC_DRV_CMOS=m
Zdenek> CONFIG_DMA_ENGINE=y
Zdenek> CONFIG_NET_DMA=y
Zdenek> CONFIG_INTEL_IOATDMA=m
Zdenek> CONFIG_KVM=m
Zdenek> CONFIG_KVM_INTEL=m
Zdenek> CONFIG_EXT2_FS=y
Zdenek> CONFIG_EXT2_FS_XIP=y
Zdenek> CONFIG_FS_XIP=y
Zdenek> CONFIG_EXT3_FS=y
Zdenek> CONFIG_EXT3_FS_XATTR=y
Zdenek> CONFIG_EXT3_FS_POSIX_ACL=y
Zdenek> CONFIG_JBD=y
Zdenek> CONFIG_FS_MBCACHE=y
Zdenek> CONFIG_REISERFS_FS=y
Zdenek> CONFIG_REISERFS_PROC_INFO=y
Zdenek> CONFIG_FS_POSIX_ACL=y
Zdenek> CONFIG_XFS_FS=m
Zdenek> CONFIG_XFS_POSIX_ACL=y
Zdenek> CONFIG_INOTIFY=y
Zdenek> CONFIG_INOTIFY_USER=y
Zdenek> CONFIG_QUOTA=y
Zdenek> CONFIG_QFMT_V2=m
Zdenek> CONFIG_QUOTACTL=y
Zdenek> CONFIG_DNOTIFY=y
Zdenek> CONFIG_AUTOFS_FS=m
Zdenek> CONFIG_AUTOFS4_FS=m
Zdenek> CONFIG_FUSE_FS=m
Zdenek> CONFIG_ISO9660_FS=m
Zdenek> CONFIG_JOLIET=y
Zdenek> CONFIG_ZISOFS=y
Zdenek> CONFIG_UDF_FS=m
Zdenek> CONFIG_UDF_NLS=y
Zdenek> CONFIG_FAT_FS=m
Zdenek> CONFIG_MSDOS_FS=m
Zdenek> CONFIG_VFAT_FS=m
Zdenek> CONFIG_FAT_DEFAULT_CODEPAGE=852
Zdenek> CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-2"
Zdenek> CONFIG_NTFS_FS=m
Zdenek> CONFIG_PROC_FS=y
Zdenek> CONFIG_PROC_KCORE=y
Zdenek> CONFIG_PROC_SYSCTL=y
Zdenek> CONFIG_SYSFS=y
Zdenek> CONFIG_TMPFS=y
Zdenek> CONFIG_RAMFS=y
Zdenek> CONFIG_NFS_FS=m
Zdenek> CONFIG_NFS_V3=y
Zdenek> CONFIG_NFS_V4=y
Zdenek> CONFIG_NFS_DIRECTIO=y
Zdenek> CONFIG_NFSD=m
Zdenek> CONFIG_NFSD_V3=y
Zdenek> CONFIG_NFSD_V4=y
Zdenek> CONFIG_NFSD_TCP=y
Zdenek> CONFIG_LOCKD=m
Zdenek> CONFIG_LOCKD_V4=y
Zdenek> CONFIG_EXPORTFS=m
Zdenek> CONFIG_NFS_COMMON=y
Zdenek> CONFIG_SUNRPC=m
Zdenek> CONFIG_SUNRPC_GSS=m
Zdenek> CONFIG_RPCSEC_GSS_KRB5=m
Zdenek> CONFIG_SMB_FS=m
Zdenek> CONFIG_SMB_NLS_DEFAULT=y
Zdenek> CONFIG_SMB_NLS_REMOTE="cp852"
Zdenek> CONFIG_CIFS=m
Zdenek> CONFIG_PARTITION_ADVANCED=y
Zdenek> CONFIG_AMIGA_PARTITION=y
Zdenek> CONFIG_MSDOS_PARTITION=y
Zdenek> CONFIG_SOLARIS_X86_PARTITION=y
Zdenek> CONFIG_LDM_PARTITION=y
Zdenek> CONFIG_LDM_DEBUG=y
Zdenek> CONFIG_NLS=y
Zdenek> CONFIG_NLS_DEFAULT="iso8859-2"
Zdenek> CONFIG_NLS_CODEPAGE_437=m
Zdenek> CONFIG_NLS_CODEPAGE_850=m
Zdenek> CONFIG_NLS_CODEPAGE_852=m
Zdenek> CONFIG_NLS_CODEPAGE_1250=m
Zdenek> CONFIG_NLS_CODEPAGE_1251=m
Zdenek> CONFIG_NLS_ASCII=m
Zdenek> CONFIG_NLS_ISO8859_1=m
Zdenek> CONFIG_NLS_ISO8859_2=m
Zdenek> CONFIG_NLS_KOI8_R=m
Zdenek> CONFIG_NLS_UTF8=m
Zdenek> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
Zdenek> CONFIG_ENABLE_MUST_CHECK=y
Zdenek> CONFIG_MAGIC_SYSRQ=y
Zdenek> CONFIG_DEBUG_FS=y
Zdenek> CONFIG_DEBUG_KERNEL=y
Zdenek> CONFIG_DETECT_SOFTLOCKUP=y
Zdenek> CONFIG_TIMER_STATS=y
Zdenek> CONFIG_DEBUG_SPINLOCK=y
Zdenek> CONFIG_DEBUG_MUTEXES=y
Zdenek> CONFIG_DEBUG_SPINLOCK_SLEEP=y
Zdenek> CONFIG_DEBUG_BUGVERBOSE=y
Zdenek> CONFIG_FORCED_INLINING=y
Zdenek> CONFIG_EARLY_PRINTK=y
Zdenek> CONFIG_DEBUG_RODATA=y
Zdenek> CONFIG_X86_FIND_SMP_CONFIG=y
Zdenek> CONFIG_X86_MPPARSE=y
Zdenek> CONFIG_DOUBLEFAULT=y
Zdenek> CONFIG_CRYPTO=y
Zdenek> CONFIG_CRYPTO_ALGAPI=y
Zdenek> CONFIG_CRYPTO_BLKCIPHER=m
Zdenek> CONFIG_CRYPTO_HASH=m
Zdenek> CONFIG_CRYPTO_MANAGER=y
Zdenek> CONFIG_CRYPTO_HMAC=m
Zdenek> CONFIG_CRYPTO_MD5=y
Zdenek>  CONFIG_CRYPTO_SHA1=m
Zdenek> CONFIG_CRYPTO_ECB=m
Zdenek> CONFIG_CRYPTO_CBC=m
Zdenek> CONFIG_CRYPTO_PCBC=m
Zdenek> CONFIG_CRYPTO_DES=m
Zdenek> CONFIG_CRYPTO_BLOWFISH=m
Zdenek> CONFIG_CRYPTO_AES=m
Zdenek> CONFIG_CRYPTO_AES_586=m
Zdenek> CONFIG_CRYPTO_ARC4=m
Zdenek> CONFIG_CRYPTO_DEFLATE=m
Zdenek> CONFIG_CRYPTO_MICHAEL_MIC=m
Zdenek> CONFIG_CRYPTO_CRC32C=m
Zdenek> CONFIG_CRYPTO_DEV_GEODE=m
Zdenek> CONFIG_BITREVERSE=y
Zdenek> CONFIG_CRC_CCITT=m
Zdenek> CONFIG_CRC32=y
Zdenek> CONFIG_LIBCRC32C=m
Zdenek> CONFIG_ZLIB_INFLATE=m
Zdenek> CONFIG_ZLIB_DEFLATE=m
Zdenek> CONFIG_PLIST=y
Zdenek> CONFIG_HAS_IOMEM=y
Zdenek> CONFIG_HAS_IOPORT=y
Zdenek> CONFIG_HAS_DMA=y
Zdenek> CONFIG_GENERIC_HARDIRQS=y
Zdenek> CONFIG_GENERIC_IRQ_PROBE=y
Zdenek> CONFIG_GENERIC_PENDING_IRQ=y
Zdenek> CONFIG_X86_SMP=y
Zdenek> CONFIG_X86_HT=y
Zdenek> CONFIG_X86_BIOS_REBOOT=y
Zdenek> CONFIG_X86_TRAMPOLINE=y
Zdenek> CONFIG_KTIME_SCALAR=y
Zdenek> -
Zdenek> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
Zdenek> the body of a message to majordomo@vger.kernel.org
Zdenek> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Zdenek> Please read the FAQ at  http://www.tux.org/lkml/


Zdenek> !DSPAM:469ce0c6204911157667262!
