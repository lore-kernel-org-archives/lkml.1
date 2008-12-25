Return-Path: <linux-kernel-owner+w=401wt.eu-S1751899AbYLYIyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbYLYIyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 03:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbYLYIyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 03:54:04 -0500
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:41339 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158AbYLYIyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 03:54:02 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEEAMrXUklXQUG+/2dsb2JhbACBbLxXWJAthkI
Message-Id: <200812250853.mBP8rxrr004080@server.home.lan>
From: Hans Lambrechts <hans.lambrechts@skynet.be>
Subject: Re: Happy v2.6.28
To: linux-kernel@vger.kernel.org
Date: Thu, 25 Dec 2008 09:53:59 +0100
References: <bMLNZ-3QM-1@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:

> 
> It doesn't really matter what day it is, or what holiday (if any) you're
> celebrating, because even if you sit at home, alone in your dank basement,
> without any holidays or friends, I bring you a tiding of great cheer: you
> can now download Linux-2.6.28, and compile it to your hearts content!
> 
> Listen to the cheerful grinding of your harddisk as you reboot into an
> all-new kernel - and I'm sure that if your computer could smile, it would
> have a big silly grin on its non-existent face. So as you sit there in
> your basement, give your computer the holiday cheer too.
> 
> In fact, even _if_ you have friends or family, leave them to their endless
> toil over that christmas ham or turkey, and during the night, when they're
> asleep, you can give them that magical present of a newly updated
> computer. When they wake up tomorrow morning, tell them how you saw Santa
> crawl down the chimney with his USB stick in hand, updating the OS of all
> good boys and girls.
> 
> Ho, ho, ho,
> 
> Linus "almost Santa" Torvalds
> 
> ---
> Not a whole lot has changed since -rc9: some DVB updates, some AMD IOMMU
> stuff, a few scsi driver updates, and some PCI hotplug regression fixes.
> 
> The dirstat looks complicated:
> 
>   11.3% arch/x86/kernel/
>   11.3% arch/x86/
>   12.9% arch/
>    4.9% drivers/acpi/
>    5.3% drivers/md/
>   19.0% drivers/media/dvb/dvb-usb/
>   23.2% drivers/media/dvb/
>    5.8% drivers/media/video/
>   29.1% drivers/media/
>    5.1% drivers/net/
>   12.6% drivers/pci/hotplug/
>   13.2% drivers/pci/
>    7.5% drivers/scsi/
>   70.0% drivers/
>    7.4% fs/9p/
> 
> but in fact it all boils down to just a couple hundred changed lines, in
> just 70 commits (average size: 5 lines each).
> 
> Andi Kleen (1):
>       x86: re-enable MCE on secondary CPUS after suspend/resume
> 
> Antti Seppälä (1):
>       V4L/DVB (9781): [PATCH] Cablestar 2 I2C retries (fix CableStar2
>       support)
> 
> Bjorn Helgaas (2):
>       x86 gart: don't complain if no AMD GART found
>       ACPI: fix 2.6.28 acpi.debug_level regression
> 
> Brian King (1):
>       [SCSI] ibmvstgt: move crq_queue_create to the end of initialization
> 
> Chris Elston (1):
>       rtc: rtc-isl1208: reject invalid dates
> 
> Dave Airlie (2):
>       drm/i915: GEM on PAE has problems - disable it for now.
>       drm/radeon: fix correctness of irq_enabled check for radeon.
> 
> David Daney (2):
>       MIPS: Fix preprocessor warnings flaged by GCC 4.4
>       MIPS: MIPS64R2: Fix buggy __arch_swab64
> 
> Devin Heitmueller (2):
>       V4L/DVB (9780): dib0700: Stop repeating after user stops pushing
>       button V4L/DVB (9920): em28xx: fix NULL pointer dereference in call
>       to VIDIOC_INT_RESET command
> 
> Dmitry Adamushko (1):
>       x86: fix resume (S2R) broken by Intel microcode module, on A110L
> 
> Duane Griffin (1):
>       9p: Remove potentially bad parameter from function entry debug
>       print.
> 
> Eric Anholt (1):
>       drm/i915: Don't return busy for buffers left on the flushing list.
> 
> Evgeniy Polyakov (1):
>       w1: fix slave selection on big-endian systems
> 
> Hans Verkuil (1):
>       V4L/DVB (9906): v4l2-compat: test for unlocked_ioctl as well.
> 
> Harry Ciao (1):
>       edac: fix edac core deadlock when removing a device
> 
> Herton Ronaldo Krzesinski (1):
>       ALSA: hda - Add missing terminators in patch_sigmatel.c
> 
> Hidetoshi Seto (1):
>       PCI: fix aer resume sanity check
> 
> Hillier, Gernot (1):
>       [SCSI] aacraid: disable Dell Percraid quirk on Adaptec 2200S and
>       [2120S
> 
> Ingo Molnar (1):
>       x86: disable X86_PTRACE_BTS
> 
> James Bottomley (2):
>       [SCSI] scsi_lib: only call scsi_unprep_request() under queue lock
>       [SCSI] mpt fusion: clear list of outstanding commands on host reset
> 
> James Chapman (1):
>       ppp: fix segfaults introduced by netdev_priv changes
> 
> Jim Paris (1):
>       V4L/DVB (9875): gspca - main: Fix vidioc_s_jpegcomp locking.
> 
> Jiri Slaby (1):
>       V4L/DVB (9908a): MAINTAINERS: mark linux-uvc-devel as subscribers
>       only
> 
> Joerg Roedel (3):
>       AMD IOMMU: allocate rlookup_table with __GFP_ZERO
>       AMD IOMMU: set cmd buffer pointers to zero manually
>       AMD IOMMU: panic if completion wait loop fails
> 
> Joerg Schirottke (1):
>       ALSA: hda - Add quirk for Dell Studio 17
> 
> Julia Lawall (2):
>       fs/9p: change simple_strtol to simple_strtoul
>       drivers/ide/{cs5530.c,sc1200.c}: Move a dereference below a NULL
>       test
> 
> Justin Chen (1):
>       PCI hotplug: acpiphp wants a 64-bit _SUN
> 
> Kenji Kaneshige (1):
>       PCI: pciehp: fix unexpected power off with pciehp_force
> 
> Kyle McMartin (1):
>       parisc: disable UP-optimized flush_tlb_mm
> 
> Li Zefan (1):
>       cgroups: avoid accessing uninitialized data in failure path
> 
> Linus Torvalds (1):
>       Linux 2.6.28
> 
> Mauro Carvalho Chehab (1):
>       V4L/DVB (9885): drivers/media Kconfig's: fix bugzilla #12204
> 
> Mike Christie (1):
>       [SCSI] libiscsi REGRESSION: fix passthrough support with older iscsi
>       [tools
> 
> Neil Horman (1):
>       PCI hotplug: ibmphp: Fix module ref count underflow
> 
> NeilBrown (1):
>       md: Don't read past end of bitmap when reading bitmap.
> 
> Sharyathi Nagesh (1):
>       cgroups: suppress bogus warning messages
> 
> Stanley Miao (1):
>       ALSA: Fix a Oops bug in omap soc driver.
> 
> Stephen M. Cameron (1):
>       cciss: fix problem that deleting multiple logical drives could cause
>       a panic
> 
> Takashi Iwai (4):
>       ALSA: hda - Fix silent HP output on D975
>       ALSA: Revert "ALSA: hda: removed unneeded hp_nid references"
>       ALSA: hda - Add no-jd model for IDT 92HD73xx
>       ALSA: hda - Remove non-working headphone control for Dell laptops
> 
> Thomas Gleixner (1):
>       Null pointer deref with hrtimer_try_to_cancel()
> 
> Wei Yongjun (1):
>       net: Fix module refcount leak in kernel_accept()
> 
> Wu Fengguang (2):
>       ACPI: don't cond_resched() when irqs_disabled()
>       9p: convert d_iname references to d_name.name
> --


Dear 'Santa',

this message appears in the log when the sendmail daemon tries to start.
This BUG appears in v2.6.28, -rc9 works fine.

Dec 25 09:30:45 server kernel: BUG: unable to handle kernel paging request
at 00442001
Dec 25 09:30:45 server kernel: IP: [<c01706c4>] kmem_cache_alloc+0x51/0x8c
Dec 25 09:30:45 server kernel: *pde = 00000000
Dec 25 09:30:45 server kernel: Oops: 0000 [#4] PREEMPT SMP
Dec 25 09:30:45 server kernel: last sysfs
file: /sys/devices/pci0000:00/0000:00:1e.0/0000:02:02.0/local_cpus
Dec 25 09:30:45 server kernel: Modules linked in: radeon drm snd_pcm_oss
snd_mixer_oss snd_seq w83627hf hwmon_vid snd_seq_device iptable_filter
ip_tables ip6table_filter ip6_tables x_tables ipv6 microcode tcp_cubic loop
snd_intel8x0 ohci1394 snd_ac97_codec 8139cp 8139too ieee1394 ac97_bus
snd_pcm snd_timer iTCO_wdt parport_pc rtc_cmos i2c_i801 snd mii
iTCO_vendor_support shpchp sr_mod intel_agp rtc_core i2c_core parport
soundcore agpgart pci_hotplug button rtc_lib cdrom snd_page_alloc sg
dm_mirror dm_region_hash dm_log ehci_hcd uhci_hcd sd_mod crc_t10dif usbcore
dm_snapshot dm_mod edd ext3 mbcache jbd fan ata_piix libata scsi_mod
thermal processor [last unloaded: speedstep_lib]
Dec 25 09:30:45 server kernel:
Dec 25 09:30:45 server kernel: Pid: 5918, comm: sendmail Tainted: G      D   
(2.6.28 #60)
Dec 25 09:30:45 server kernel: EIP: 0060:[<c01706c4>] EFLAGS: 00010002 CPU:
0
Dec 25 09:30:45 server kernel: EIP is at kmem_cache_alloc+0x51/0x8c
Dec 25 09:30:45 server kernel: EAX: 00000000 EBX: 00000282 ECX: 00442001
EDX: c1c0a404
Dec 25 09:30:45 server kernel: ESI: 00000504 EDI: 00442001 EBP: f6b076c0
ESP: f438dec4
Dec 25 09:30:45 server kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Dec 25 09:30:45 server kernel: Process sendmail (pid: 5918, ti=f438c000
task=f42c8f00 task.ti=f438c000)
Dec 25 09:30:45 server kernel: Stack:
Dec 25 09:30:45 server kernel:  00442001 c0265f06 000080d0 c015c35f 000080d0
f86d38b0 f86d38b0 f6b076c0
Dec 25 09:30:45 server kernel:  c0265f06 0000000a f86d38b0 f86d38b0 0000000a
00000600 c026729c f86d38b0
Dec 25 09:30:45 server kernel:  f86d39c8 ffffffa2 f869f77d f86d38b0 00000006
f3826600 c046ee00 06000000
Dec 25 09:30:45 server kernel: Call Trace:
Dec 25 09:30:45 server kernel:  [<c0265f06>] sk_prot_alloc+0x1c/0xac
Dec 25 09:30:45 server kernel:  [<c015c35f>] __inc_zone_state+0x10/0x61
Dec 25 09:30:45 server kernel:  [<c0265f06>] sk_prot_alloc+0x1c/0xac
Dec 25 09:30:45 server kernel:  [<c026729c>] sk_alloc+0x19/0x47
Dec 25 09:30:45 server kernel:  [<f869f77d>] inet6_create+0x166/0x2f2 [ipv6]
Dec 25 09:30:45 server kernel:  [<c02641e4>] __sock_create+0x169/0x245
Dec 25 09:30:45 server kernel:  [<c02642fb>] sock_create+0x22/0x27
Dec 25 09:30:45 server kernel:  [<c026450b>] sys_socket+0x2b/0x56
Dec 25 09:30:45 server kernel:  [<c026507d>] sys_socketcall+0x6c/0x1a1
Dec 25 09:30:45 server kernel:  [<c010391d>] sysenter_do_call+0x12/0x21
Dec 25 09:30:45 server kernel: Code: 8b 72 10 85 c9 89 0c 24 75 1b 52 89 e8
ff 74 24 08 83 c9 ff 8b 54 24 10 e8 37 f9 ff ff 89 44 24 08 5f 5d eb 0b 8b
3c 24 8b 42 0c <8b> 04 87 89 02 53 9d 66 83 7c 24 08 00 79 21 83 3c 24 00
74 1b
Dec 25 09:30:45 server kernel: EIP: [<c01706c4>] kmem_cache_alloc+0x51/0x8c
SS:ESP 0068:f438dec4
Dec 25 09:30:45 server kernel: ---[ end trace 9ece963f58896a61 ]---



