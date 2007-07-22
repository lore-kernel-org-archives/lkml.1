Return-Path: <linux-kernel-owner+w=401wt.eu-S1765474AbXGVVBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765474AbXGVVBU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 17:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765053AbXGVVBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 17:01:05 -0400
Received: from smtpa1.netcabo.pt ([212.113.174.16]:51353 "EHLO
	exch01smtp04.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765074AbXGVVBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 17:01:00 -0400
Message-ID: <46A3C586.7030504@rncbc.org>
Date: Sun, 22 Jul 2007 22:00:54 +0100
From: Rui Nuno Capela <rncbc@rncbc.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>
Subject: Re: 2.6.22.1-rt4 lockups
References: <1184325752.12353.312.camel@chaos> <46A283A1.6030005@rncbc.org>
In-Reply-To: <46A283A1.6030005@rncbc.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jul 2007 21:00:55.0772 (UTC) FILETIME=[657C29C0:01C7CCA3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

Sorry to bother, but got another one. Please advise whether these dumps
are any useful or are just garbage.

...
Oops: 0000 [#1]
PREEMPT SMP
Modules linked in: appletalk ax25 ipx p8023 snd_rtctimer snd_seq_dummy
snd_pcm_oss snd_mixer_oss snd_seq_midi snd_seq_midi_event snd_seq
w83627hf hwmon_vid hwmon button eeprom battery ac loop dm_mod ohci1394
ieee1394 snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda snd_cs8427
nvidia(P) snd_i2c wacom usbhid hid ff_memless firewire_ohci snd_cs46xx
snd_mpu401_uart gameport snd_rawmidi firewire_core crc_itu_t
snd_seq_device sk98lin snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm
snd_timer snd intel_agp soundcore ide_cd ehci_hcd uhci_hcd cdrom
iTCO_wdt shpchp snd_page_alloc agpgart usbcore i2c_i801 pci_hotplug
i2c_core rtc_cmos rtc_core rtc_lib ext3 mbcache jbd edd fan piix thermal
processor ide_disk ide_core
CPU:    0
EIP:    0060:[<00000000>]    Tainted: P       VLI
EFLAGS: 00010003   (2.6.22.1-rt4.0 #1)
EIP is at _stext+0x3feff000/0x20
eax: c1812a80   ebx: c03bb540   ecx: 00000001   edx: c038e3c0
esi: c038e3c0   edi: 00000001   ebp: c64a9d6c   esp: c64a9d50
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068  preempt:00000003
Process thunderbird-bin (pid: 12848, ti=c64a9000 task=e4514db0
task.ti=c64a9000)
Stack: c011a94c d1027dbe 00001dc1 c1812a80 c1812a80 d1027dbe 00001dc1
c64a9d90
       c011b4af d1027dbe 00001dc1 00000001 c038e3c0 00000000 00000000
c038e3c0
       c64a9df4 c011e09d 00000000 00000000 00000000 0000001f c1812a80
c64a9e20
Call Trace:
 [<c010622a>] show_trace_log_lvl+0x1a/0x30
 [<c01062f6>] show_stack_log_lvl+0xb6/0xe0
 [<c0106521>] show_registers+0x201/0x330
 [<c0106768>] die+0x118/0x260
 [<c0304233>] do_page_fault+0x193/0x600
 [<c030294a>] error_code+0x72/0x78
 [<c011b4af>] activate_task+0x4f/0xb0
 [<c011e09d>] try_to_wake_up+0x2bd/0x420
 [<c011e279>] wake_up_process_mutex+0x19/0x20
 [<c01425cc>] wakeup_next_waiter+0xec/0x1a0
 [<c030173c>] rt_spin_lock_slowunlock+0x4c/0x70
 [<c0301ff6>] rt_spin_unlock+0x26/0x30
 [<c015b3e4>] put_zone_pcp+0x14/0x20
 [<c015c265>] get_page_from_freelist+0x145/0x380
 [<c015c4f4>] __alloc_pages+0x54/0x2d0
 [<c01652bd>] __handle_mm_fault+0x7dd/0x9a0
 [<c0304398>] do_page_fault+0x2f8/0x600
 [<c030294a>] error_code+0x72/0x78
 =======================
Code:  Bad EIP value.
EIP: [<00000000>] _stext+0x3feff000/0x20 SS:ESP 0068:c64a9d50
NMI watchdog detected lockup on CPU#1 (5000/5000)

Pid: 2882, comm:                klogd
EIP: 0060:[<c0302309>] CPU: 1
EIP is at __spin_lock+0x19/0x20
 EFLAGS: 00000082    Tainted: P        (2.6.22.1-rt4.0 #1)
EAX: c1812a80 EBX: c1812a80 ECX: 00000001 EDX: f6c57000
ESI: c0403a80 EDI: dff03230 EBP: f6c57d1c DS: 007b ES: 007b FS: 00d8
CR0: 8005003b CR2: ae41a000 CR3: 3730e000 CR4: 000006d0
 [<c010622a>] show_trace_log_lvl+0x1a/0x30
 [<c0106e12>] show_trace+0x12/0x20
 [<c0103af3>] show_regs+0x183/0x190
 [<c0303470>] nmi_watchdog_tick+0x1f0/0x290
 [<c0302ea7>] do_nmi+0x77/0x260
 [<c03029f3>] nmi_stack_correct+0x26/0x2b
 [<c011bbc7>] task_rq_lock+0x37/0x70
 [<c011de07>] try_to_wake_up+0x27/0x420
 [<c011e218>] default_wake_function+0x18/0x20
 [<c011a6f9>] __wake_up_common+0x39/0x60
 [<c012055b>] __wake_up_sync+0x3b/0x50
 [<c0293a09>] sock_def_readable+0x79/0x80
 [<c02fb010>] unix_dgram_sendmsg+0x450/0x500
 [<c028f044>] sock_aio_write+0x114/0x130
 [<c01781b0>] do_sync_write+0xd0/0x110
 [<c0178aad>] vfs_write+0x14d/0x160
 [<c01790cd>] sys_write+0x3d/0x70
 [<c01051d2>] sysenter_past_esp+0x5f/0x85
 =======================
NMI watchdog detected lockup on CPU#0 (0/5000)

Pid: 12848, comm:      thunderbird-bin
EIP: 0060:[<c0302309>] CPU: 0
EIP is at __spin_lock+0x19/0x20
 EFLAGS: 00000082    Tainted: P        (2.6.22.1-rt4.0 #1)
EAX: c1812a80 EBX: c1812a80 ECX: 00000000 EDX: c040d000
ESI: c0403a80 EDI: f74cf8f0 EBP: c040df50 DS: 007b ES: 007b FS: 00d8
CR0: 8005003b CR2: ffffffd5 CR3: 0c391000 CR4: 000006d0
 [<c010622a>] show_trace_log_lvl+0x1a/0x30
 [<c0106e12>] show_trace+0x12/0x20
 [<c0103af3>] show_regs+0x183/0x190
 [<c0303470>] nmi_watchdog_tick+0x1f0/0x290
 [<c0302ea7>] do_nmi+0x77/0x260
 [<c03029f3>] nmi_stack_correct+0x26/0x2b
 [<c011bbc7>] task_rq_lock+0x37/0x70
 [<c011de07>] try_to_wake_up+0x27/0x420
 [<c011e2b9>] wake_up_process+0x19/0x20
 [<c01519c7>] redirect_hardirq+0x47/0x60
 [<c015343b>] handle_fasteoi_irq+0x6b/0x100
 [<c01075f4>] do_IRQ+0x94/0x100
 [<c0105beb>] common_interrupt+0x23/0x28
 [<c0126798>] do_exit+0x88/0x890
 [<c01068a7>] die+0x257/0x260
 [<c0304233>] do_page_fault+0x193/0x600
 [<c030294a>] error_code+0x72/0x78
 [<c011b4af>] activate_task+0x4f/0xb0
 [<c011e09d>] try_to_wake_up+0x2bd/0x420
 [<c011e279>] wake_up_process_mutex+0x19/0x20
 [<c01425cc>] wakeup_next_waiter+0xec/0x1a0
 [<c030173c>] rt_spin_lock_slowunlock+0x4c/0x70
 [<c0301ff6>] rt_spin_unlock+0x26/0x30
 [<c015b3e4>] put_zone_pcp+0x14/0x20
 [<c015c265>] get_page_from_freelist+0x145/0x380
 [<c015c4f4>] __alloc_pages+0x54/0x2d0
 [<c01652bd>] __handle_mm_fault+0x7dd/0x9a0
 [<c0304398>] do_page_fault+0x2f8/0x600
 [<c030294a>] error_code+0x72/0x78
 =======================
...


Complete serial console capture:

  http://www.rncbc.org/datahub/console-2.6.22.1-rt4.0-2.log

.config evidence:

  http://www.rncbc.org/datahub/config-2.6.22.1-rt4.0

Bye now
-- 
rncbc aka Rui Nuno Capela
rncbc@rncbc.org
