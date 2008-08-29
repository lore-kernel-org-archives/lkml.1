Return-Path: <linux-kernel-owner+w=401wt.eu-S1759255AbYH2WQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbYH2WQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 18:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbYH2WQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 18:16:19 -0400
Received: from poseidon.rz.tu-clausthal.de ([139.174.2.21]:65527 "EHLO
	poseidon.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751898AbYH2WQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 18:16:17 -0400
X-Greylist: delayed 1143 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Aug 2008 18:16:16 EDT
From: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
Subject: 2.6.26.3+reiser4 recursive fault/oops after screen blank in console and screen standby/screen off in X.
Date: Fri, 29 Aug 2008 23:57:07 +0200
User-Agent: KMail/1.10.0 (Linux/2.6.26.3r4; KDE/4.1.0; x86_64; ; )
MIME-Version: 1.0
Content-Disposition: inline
To: linux-kernel@vger.kernel.org
Cc: reiserfs-devel@vger.kernel.org
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_zCHuIa1fu0AqDKx"
Message-Id: <200808292357.07912.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_zCHuIa1fu0AqDKx
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,
the kernel is vanilla except reiser4-for-2.6.25 is patched in.

On thursday I created a raid 1 on my computer.

While the two disks were syncing I went shopping. Screen was blanked while =
I=20
was away.When I came back, I got this:

[ 1841.979101] BUG: unable to handle kernel paging request at 0000100000000=
000                                                                        =
                     =20
[ 1841.979154] IP: [<ffffffff8049c205>] _spin_lock+0x5/0x20                =
                                                                           =
                     =20
[ 1841.979189] PGD 0                                                       =
                                                                           =
                     =20
[ 1841.979221] Oops: 0002 [1] SMP                                          =
                                                                           =
                     =20
[ 1841.979268] CPU 1                                                       =
                                                                           =
                     =20
[ 1841.979299] Modules linked in: raid1 sr_mod cdrom k8temp w83627ehf=20
hwmon_vid hwmon i2c_nforce2 i2c_dev i2c_core usb_storage snd_seq_midi=20
snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_pcm_=
oss=20
snd_mixer_oss snd_seq_oss snd_seq_midi_event snd_seq mousedev snd_emu10k1=20
snd_rawmidi firmware_class snd_ac97_codec ac97_bus snd_pcm snd_seq_device=20
snd_timer snd_page_alloc snd_util_mem snd_hwdep snd soundcore ehci_hcd r816=
9                                                                        =20
[ 1841.979890] Pid: 1648, comm: nscd Not tainted 2.6.26.3r4 #3             =
                                                                           =
                     =20
[ 1841.979908] RIP: 0010:[<ffffffff8049c205>]  [<ffffffff8049c205>]=20
_spin_lock+0x5/0x20                                                        =
                            =20
[ 1841.979944] RSP: 0018:ffff81012b5d3c60  EFLAGS: 00010206                =
                                                                           =
                     =20
[ 1841.979961] RAX: 0000000000000100 RBX: 0000100000000000 RCX:=20
00007fd0e916a000                                                           =
                                =20
[ 1841.979980] RDX: 00007fd0e916a000 RSI: ffff81012cab4c00 RDI:=20
0000100000000000                                                           =
                                =20
[ 1841.979998] RBP: ffff81012e54b870 R08: ffff81012fb49460 R09:=20
00000000ffffffff                                                           =
                                =20
[ 1841.980017] R10: 0000000000000001 R11: 0000000000000000 R12:=20
00007fd0e915a000                                                           =
                                =20
[ 1841.980035] R13: 0000000000000000 R14: ffff81012b5d3cd0 R15:=20
0000000000000000                                                           =
                                =20
[ 1841.980056] FS:  000000004139b950(0000) GS:ffff81012fc6bd40(0000)=20
knlGS:00000000f7f89a10
[ 1841.980076] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1841.980094] CR2: 0000100000000000 CR3: 000000012c6bb000 CR4:=20
00000000000006e0
[ 1841.980112] DR0: 0000000000000000 DR1: 0000000000000000 DR2:=20
0000000000000000
[ 1841.980130] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:=20
0000000000000400
[ 1841.980149] Process nscd (pid: 1648, threadinfo ffff81012b5d2000, task=20
ffff81012f6bb8d0)
[ 1841.980169] Stack:  ffffffff80280b62 ffff81012e54b870 ffff81012e54b870=20
ffff81012e54b720
[ 1841.980261]  ffffffff8027a9d3 00007ffff87fefff ffff81012b5d3cd0=20
ffff81012cae23d8
[ 1841.980339]  ffff81012e71af00 0000000000000000 ffff81012e6bb648=20
ffff81012e6bae48
[ 1841.980401] Call Trace:
[ 1841.980436]  [<ffffffff80280b62>] ? anon_vma_unlink+0x22/0x80
[ 1841.980455]  [<ffffffff8027a9d3>] ? free_pgtables+0x53/0xb0
[ 1841.980474]  [<ffffffff8027c053>] ? exit_mmap+0x93/0x110
[ 1841.980494]  [<ffffffff8023231d>] ? mmput+0x2d/0xc0
[ 1841.980513]  [<ffffffff8023850c>] ? do_exit+0x19c/0x770
[ 1841.980533]  [<ffffffff80238b19>] ? do_group_exit+0x39/0xa0
[ 1841.980553]  [<ffffffff80242583>] ? get_signal_to_deliver+0x193/0x370
[ 1841.980573]  [<ffffffff8020b794>] ? sysret_signal+0x1c/0x27
[ 1841.980591]  [<ffffffff8020a950>] ? do_notify_resume+0x110/0x980
[ 1841.980611]  [<ffffffff80240665>] ? signal_wake_up+0x25/0x40
[ 1841.980630]  [<ffffffff802409ee>] ? send_signal+0x11e/0x2c0
[ 1841.980650]  [<ffffffff8023f03d>] ? sigprocmask+0x6d/0xf0
[ 1841.980669]  [<ffffffff8023f5e3>] ? sys_rt_sigprocmask+0x83/0x110
[ 1841.980688]  [<ffffffff8023f03d>] ? sigprocmask+0x6d/0xf0
[ 1841.980707]  [<ffffffff8020b794>] ? sysret_signal+0x1c/0x27
[ 1841.980725]  [<ffffffff8020ba17>] ? ptregscall_common+0x67/0xb0
[ 1841.980745]
[ 1841.980762]
[ 1841.980778] Code: 74 05 e8 ef 14 eb ff c3 66 66 66 66 66 2e 0f 1f 84 00 =
00=20
00 00 00 fa f0 81 2f 00 00 00 01 74 05 e8 d1 14 eb ff c3 b8 00 01 00 00 <f0=
>=20
66 0f c1 07 38 e0 74 06 f3 90 8a 07 eb f6 c3 66 66 2e 0f 1f
[ 1841.981717] RIP  [<ffffffff8049c205>] _spin_lock+0x5/0x20
[ 1841.981717]  RSP <ffff81012b5d3c60>
[ 1841.981717] CR2: 0000100000000000
[ 1841.983595] ---[ end trace 04a5b9909682865f ]---
[ 1841.983613] Fixing recursive fault but reboot is needed!

today I started a big emerge -u world and went away. This time in X with=20
fglrx, so the kernel is tainted. Screen went into standby then off, when it=
=20
woke up konsole from kde4.1 misbehaved, and I found this:

[ 6048.745502] BUG: unable to handle kernel paging request at ffffbd012682b=
cf0                                                           =20
[ 6048.745507] IP: [<ffffffff804a67c5>] _spin_lock+0x5/0x20                =
                                                              =20
[ 6048.745511] PGD 0                                                       =
                                                              =20
[ 6048.745513] Oops: 0002 [1] SMP                                          =
                                                              =20
[ 6048.745515] CPU 1                                                       =
                                                              =20
[ 6048.745516] Modules linked in: fglrx(P) k8temp w83627ehf hwmon_vid hwmon=
=20
i2c_nforce2 i2c_dev i2c_core snd_seq_midi snd_emu10k1_synth snd_emux_synth=
=20
snd_seq_virmidi snd_seq_midi_emul snd_pcm_oss snd_mixer_oss snd_seq_oss=20
snd_seq_midi_event snd_seq snd_emu10k1 snd_rawmidi firmware_class=20
snd_ac97_codec ac97_bus snd_pcm snd_seq_device snd_timer snd_page_alloc=20
snd_util_mem snd_hwdep snd soundcore r8169 reiserfs ohci_hcd usb_storage=20
ehci_hcd aic7xxx sr_mod cdrom scsi_wait_scan                               =
      =20
[ 6048.745532] Pid: 5729, comm: kio_http Tainted: P          2.6.26.3r4 #1 =
                                                                           =
                     =20
[ 6048.745534] RIP: 0010:[<ffffffff804a67c5>]  [<ffffffff804a67c5>]=20
_spin_lock+0x5/0x20                                                        =
                            =20
[ 6048.745537] RSP: 0018:ffff810040bfbe40  EFLAGS: 00010286                =
                                                                           =
                     =20
[ 6048.745538] RAX: 0000000000000100 RBX: ffffbd012682bcf0 RCX:=20
0000003254a07000                                                           =
                                =20
[ 6048.745540] RDX: 0000003254a07000 RSI: ffff81012f885360 RDI:=20
ffffbd012682bcf0                                                           =
                                =20
[ 6048.745541] RBP: ffff8100c34cb330 R08: ffff81012f885360 R09:=20
00000000ffffffff                                                           =
                                =20
[ 6048.745543] R10: 0000000000000001 R11: 0000000000000589 R12:=20
0000003254800000                                                           =
                                =20
[ 6048.745544] R13: 0000000000000000 R14: ffff810040bfbeb0 R15:=20
0000000000000000                                                           =
                                =20
[ 6048.745545] FS:  00007fbab50fa750(0000) GS:ffff81012fc6bd40(0000)=20
knlGS:0000000000000000                                                     =
                           =20
[ 6048.745547] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b           =
                                                                           =
                     =20
[ 6048.745548] CR2: ffffbd012682bcf0 CR3: 0000000000201000 CR4:=20
00000000000006e0                                                           =
                                =20
[ 6048.745549] DR0: 0000000000000000 DR1: 0000000000000000 DR2:=20
0000000000000000                                                           =
                                =20
[ 6048.745551] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:=20
0000000000000400                                                           =
                                =20
[ 6048.745552] Process kio_http (pid: 5729, threadinfo ffff810040bfa000, ta=
sk=20
ffff81012ff2b4e0)                                                          =
                  =20
[ 6048.745554] Stack:  ffffffff80280b82 ffff8100c34cb330 ffff8100c34cb330=20
ffff8100c34cb9c0                                                           =
                      =20
[ 6048.745556]  ffffffff8027a9f3 00007fffbd1fffff ffff810040bfbeb0=20
ffff8100c4a7f720                                                           =
                             =20
[ 6048.745559]  ffff81012eed97c0 0000000000000000 00007fffbd141c9c=20
00007fffbd1473f0                                                           =
                             =20
[ 6048.745561] Call Trace:                                                 =
                                                                           =
                     =20
[ 6048.745564]  [<ffffffff80280b82>] ? anon_vma_unlink+0x22/0x80           =
                                                                           =
                     =20
[ 6048.745566]  [<ffffffff8027a9f3>] ? free_pgtables+0x53/0xb0             =
                                                                           =
                     =20
[ 6048.745569]  [<ffffffff8027c073>] ? exit_mmap+0x93/0x110                =
                                                                           =
                     =20
[ 6048.745572]  [<ffffffff8023233d>] ? mmput+0x2d/0xc0                     =
                                                                           =
                     =20
[ 6048.745575]  [<ffffffff8023852c>] ? do_exit+0x19c/0x770                 =
                                                                           =
                     =20
[ 6048.745578]  [<ffffffff8023f9ee>] ? sys_rt_sigaction+0x8e/0xd0          =
                                                                           =
                     =20
[ 6048.745580]  [<ffffffff80238b39>] ? do_group_exit+0x39/0xa0             =
                                                                           =
                     =20
[ 6048.745583]  [<ffffffff8020b70b>] ? system_call_after_swapgs+0x7b/0x80  =
                                                                           =
                     =20
[ 6048.745587]                                                             =
                                                                           =
                     =20
[ 6048.745587]                                                             =
                                                                           =
                     =20
[ 6048.745588] Code: 74 05 e8 6f 6f ea ff c3 66 66 66 66 66 2e 0f 1f 84 00 =
00=20
00 00 00 fa f0 81 2f 00 00 00 01 74 05 e8 51 6f ea ff c3 b8 00 01 00 00 <f0=
>=20
66 0f c1 07 38 e0 74 06 f3 90 8a 07 eb f6 c3 66 66 2e 0f 1f                =
                                                                           =
                                      =20
[ 6048.745602] RIP  [<ffffffff804a67c5>] _spin_lock+0x5/0x20               =
                                                                           =
                     =20
[ 6048.745605]  RSP <ffff810040bfbe40>                                     =
                                                                           =
                     =20
[ 6048.745606] CR2: ffffbd012682bcf0                                       =
                                                                           =
                     =20
[ 6048.745611] ---[ end trace 9a849e48577fe237 ]---                        =
                                                                           =
                     =20
[ 6048.745612] Fixing recursive fault but reboot is needed!                =
                                                                           =
                     =20
[23041.829591] BUG: unable to handle kernel paging request at 0000040000000=
000                                                                        =
                     =20
[23041.829591] IP: [<ffffffff804a67c5>] _spin_lock+0x5/0x20                =
                                                                           =
                     =20
[23041.829591] PGD 0                                                       =
                                                                           =
                     =20
[23041.829591] Oops: 0002 [2] SMP                                          =
                                                                           =
                     =20
[23041.829591] CPU 0                                                       =
                                                                           =
                     =20
[23041.829591] Modules linked in: fglrx(P) k8temp w83627ehf hwmon_vid hwmon=
=20
i2c_nforce2 i2c_dev i2c_core snd_seq_midi snd_emu10k1_synth snd_emux_synth=
=20
snd_seq_virmidi snd_seq_midi_emul snd_pcm_oss snd_mixer_oss snd_seq_oss=20
snd_seq_midi_event snd_seq snd_emu10k1 snd_rawmidi firmware_class=20
snd_ac97_codec ac97_bus snd_pcm snd_seq_device snd_timer snd_page_alloc=20
snd_util_mem snd_hwdep snd soundcore r8169 reiserfs ohci_hcd usb_storage=20
ehci_hcd aic7xxx sr_mod cdrom scsi_wait_scan
[23041.829591] Pid: 6682, comm: zsh Tainted: P      D   2.6.26.3r4 #1
[23041.829591] RIP: 0010:[<ffffffff804a67c5>]  [<ffffffff804a67c5>]=20
_spin_lock+0x5/0x20
[23041.829591] RSP: 0018:ffff81010cc35df0  EFLAGS: 00010206
[23041.829591] RAX: 0000000000000100 RBX: 0000040000000000 RCX:=20
0000000000000000
[23041.829591] RDX: ffff81012fc21c00 RSI: ffff8101104c9918 RDI:=20
0000040000000000
[23041.829591] RBP: ffff810053a95f00 R08: ffff810053a952b8 R09:=20
0000000000000001
[23041.829591] R10: 0000000000000000 R11: 0000000000000076 R12:=20
0000000000000000
[23041.829591] R13: ffff81012d909c40 R14: ffff8101104c9870 R15:=20
0000000000000015
[23041.829591] FS:  00007f19b0dc36f0(0000) GS:ffffffff80598000(0000)=20
knlGS:0000000000000000
[23041.829591] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[23041.829591] CR2: 0000040000000000 CR3: 0000000112338000 CR4:=20
00000000000006e0
[23041.829591] DR0: 0000000000000000 DR1: 0000000000000000 DR2:=20
0000000000000000
[23041.829591] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:=20
0000000000000400
[23041.829591] Process zsh (pid: 6682, threadinfo ffff81010cc34000, task=20
ffff81012fcc7690)
[23041.829591] Stack:  ffffffff8027fd22 ffff81003bb3cf80 ffff810053a95f00=20
ffff81003bb3cf80
[23041.829591]  ffffffff802328a7 ffff810053a95600 ffff810053a95608=20
ffff810053a955e8
[23041.829591]  ffff81003bb3cfe0 ffff81012d909ca0 00000000fffffff4=20
ffff810040b652a0
[23041.829591] Call Trace:
[23041.829591]  [<ffffffff8027fd22>] ? anon_vma_link+0x22/0x50
[23041.829591]  [<ffffffff802328a7>] ? dup_mm+0x1e7/0x3a0
[23041.829591]  [<ffffffff8023354f>] ? copy_process+0xabf/0x10d0
[23041.829591]  [<ffffffff80233bd3>] ? do_fork+0x73/0x310
[23041.829591]  [<ffffffff8020b70b>] ? system_call_after_swapgs+0x7b/0x80
[23041.829591]  [<ffffffff8020ba17>] ? ptregscall_common+0x67/0xb0
[23041.829591]
[23041.829591]
[23041.829591] Code: 74 05 e8 6f 6f ea ff c3 66 66 66 66 66 2e 0f 1f 84 00 =
00=20
00 00 00 fa f0 81 2f 00 00 00 01 74 05 e8 51 6f ea ff c3 b8 00 01 00 00 <f0=
>=20
66 0f c1 07 38 e0 74 06 f3 90 8a 07 eb f6 c3 66 66 2e 0f 1f
[23041.829591] RIP  [<ffffffff804a67c5>] _spin_lock+0x5/0x20
[23041.829591]  RSP <ffff81010cc35df0>
[23041.829591] CR2: 0000040000000000
[23041.829591] ---[ end trace 9a849e48577fe237 ]---

System is AMD64 with a X2 6000+, 4gb ram. Cool&Quiet enabled.
I haven't had any problems with 2.6.26-rcX, or 2.6.26.1
Complete dmesg after a clean boot is attached.

I haven't got any of this without screen blanking/dpms standby/dpms off.=20

Gl=FCck Auf,
Volker

--Boundary-00=_zCHuIa1fu0AqDKx
Content-Type: text/plain;
  charset="us-ascii";
  name="dmesg.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg.out"

[    0.000000] Linux version 2.6.26.3r4 (root@energy) (gcc version 4.3.1 (Gentoo 4.3.1-r1 p1.1) ) #1 SMP Thu Aug 28 20:17:38 CEST 2008
[    0.000000] Command line: root=/dev/ram0 init=/linuxrc ramdisk=8192 real_root=/dev/md1 md=1,/dev/sda3,/dev/sdb3 nopat udev doadm
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000cffb0000 - 00000000cffc0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cffc0000 - 00000000cfff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfff0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] PAT support disabled.
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 used
[    0.000000] max_pfn_mapped = 1245184
[    0.000000] init_memory_mapping
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F98F0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT CFFB0000, 003C (r1 A M I  OEMRSDT   4000809 MSFT       97)
[    0.000000] ACPI: FACP CFFB0200, 0084 (r2 A_M_I  OEMFACP  12000601 MSFT       97)
[    0.000000] ACPI: DSDT CFFB0450, 4FFA (r1  ASR19 ASR19201      201 INTL 20051117)
[    0.000000] ACPI: FACS CFFC0000, 0040
[    0.000000] ACPI: APIC CFFB0390, 0080 (r1 A M I  OEMAPIC   4000809 MSFT       97)
[    0.000000] ACPI: MCFG CFFB0410, 003C (r1 A M I  OEMMCFG   4000809 MSFT       97)
[    0.000000] ACPI: OEMB CFFC0040, 0060 (r1 A M I  AMI_OEM   4000809 MSFT       97)
[    0.000000] ACPI: HPET CFFB5450, 0038 (r1 A M I  OEMHPET0  4000809 MSFT       97)
[    0.000000] ACPI: SSDT CFFB5490, 030E (r1 A M I  POWERNOW        1 AMD         1)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 851888) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 used
[    0.000000]   early res: 0 [0-fff] BIOS data page
[    0.000000]   early res: 1 [6000-7fff] TRAMPOLINE
[    0.000000]   early res: 2 [200000-631e97] TEXT DATA BSS
[    0.000000]   early res: 3 [37f10000-37fef507] RAMDISK
[    0.000000]   early res: 4 [9fc00-fffff] BIOS reserved
[    0.000000]   early res: 5 [8000-dfff] PGTABLE
[    0.000000]  [ffffe20000000000-ffffe20002dfffff] PMD -> [ffff810001200000-ffff810003ffffff] on node 0
[    0.000000]  [ffffe20002e00000-ffffe200043fffff] PMD -> [ffff81000c000000-ffff81000d5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1245184
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   851888
[    0.000000]     0:  1048576 ->  1245184
[    0.000000] On node 0 totalpages: 1048399
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1178 pages reserved
[    0.000000]   DMA zone: 2765 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833512 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e6000
[    0.000000] PM: Registered nosave memory: 00000000000e6000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cffb0000 - 00000000cffc0000
[    0.000000] PM: Registered nosave memory: 00000000cffc0000 - 00000000cfff0000
[    0.000000] PM: Registered nosave memory: 00000000cfff0000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fef00000
[    0.000000] PM: Registered nosave memory: 00000000fef00000 - 00000000ff380000
[    0.000000] PM: Registered nosave memory: 00000000ff380000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at d4000000 (gap: d0000000:2ec00000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 30512 bytes of per cpu data
[    0.000000] NR_CPUS: 2, nr_cpu_ids: 2
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1030197
[    0.000000] Kernel command line: root=/dev/ram0 init=/linuxrc ramdisk=8192 real_root=/dev/md1 md=1,/dev/sda3,/dev/sdb3 nopat udev doadm
[    0.000000] md: Will configure md1 (super-block) from /dev/sda3,/dev/sdb3, below.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[    0.000000] time.c: Detected 3013.881 MHz processor.
[    0.003333] spurious 8259A interrupt: IRQ7.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.003333] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.003333] Checking aperture...
[    0.003333] Node 0: aperture @ 4000000 size 32 MB
[    0.003333] Aperture pointing to e820 RAM. Ignoring.
[    0.003333] No AGP bridge found
[    0.003333] Your BIOS doesn't leave a aperture memory hole
[    0.003333] Please enable the IOMMU option in the BIOS setup
[    0.003333] This costs you 64 MB of RAM
[    0.003333] Mapping aperture over 65536 KB of RAM @ 4000000
[    0.003333] PM: Registered nosave memory: 0000000004000000 - 0000000008000000
[    0.003333] Memory: 4046192k/4980736k available (2726k kernel code, 146828k reserved, 952k data, 252k init)
[    0.003333] CPA: page pool initialized 1 of 1 pages preallocated
[    0.003333] hpet clockevent registered
[    0.086484] Calibrating delay using timer specific routine.. 6034.73 BogoMIPS (lpj=10053981)
[    0.086567] Mount-cache hash table entries: 256
[    0.086661] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.086661] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.086661] CPU: Physical Processor ID: 0
[    0.086661] CPU: Processor Core ID: 0
[    0.086661] ACPI: Core revision 20080321
[    0.123325] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[    0.123325] Using local APIC timer interrupts.
[    0.126658] APIC timer calibration result 12557846
[    0.126658] Detected 12.557 MHz APIC timer.
[    0.126658] Booting processor 1/1 ip 6000
[    0.136657] Initializing CPU#1
[    0.136657] Calibrating delay using timer specific routine.. 6030.94 BogoMIPS (lpj=10046310)
[    0.136657] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.136657] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.136657] CPU: Physical Processor ID: 0
[    0.136657] CPU: Processor Core ID: 1
[    0.219817] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[    0.219985] Brought up 2 CPUs
[    0.219985] Total of 2 processors activated (12065.68 BogoMIPS).
[    0.219985] net_namespace: 936 bytes
[    0.219985] NET: Registered protocol family 16
[    0.219985] No dock devices found.
[    0.219985] node 0 link 0: io port [1000, ffffff]
[    0.219985] node 0 link 0: io port [2000, 2fff]
[    0.219985] TOM: 00000000d0000000 aka 3328M
[    0.219985] node 0 link 0: mmio [e0000000, efffffff]
[    0.219985] node 0 link 0: mmio [a0000, bffff]
[    0.219985] node 0 link 0: mmio [d0000000, fe0bffff]
[    0.219985] TOM2: 0000000130000000 aka 4864M
[    0.219985] bus: [00,07] on node 0 link 0
[    0.219985] bus: 00 index 0 io port: [0, ffff]
[    0.219985] bus: 00 index 1 mmio: [d0000000, ffffffff]
[    0.219985] bus: 00 index 2 mmio: [a0000, bffff]
[    0.219985] bus: 00 index 3 mmio: [130000000, fcffffffff]
[    0.219985] ACPI: bus type pci registered
[    0.219985] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.219985] PCI: Not using MMCONFIG.
[    0.219985] PCI: Using configuration type 1 for base access
[    0.219985] ACPI: EC: Look up EC in DSDT
[    0.226301] ACPI: Interpreter enabled
[    0.226328] ACPI: (supports S0 S1 S3 S4 S5)
[    0.226651] ACPI: Using IOAPIC for interrupt routing
[    0.226651] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.229985] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.236651] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.243317] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.243851] PCI: Transparent bridge - 0000:00:08.0
[    0.244126] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.244313] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.244451] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[    0.244530] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[    0.244609] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[    0.244687] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[    0.249983] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
[    0.249983] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
[    0.249983] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *10
[    0.249983] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
[    0.250327] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *10
[    0.250647] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[    0.250967] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disabled.
[    0.251309] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[    0.251629] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[    0.251950] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0, disabled.
[    0.252291] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[    0.252612] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disabled.
[    0.252954] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0, disabled.
[    0.253296] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[    0.253630] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, disabled.
[    0.253972] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
[    0.254294] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, disabled.
[    0.254663] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disabled.
[    0.255005] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0, disabled.
[    0.255347] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0, disabled.
[    0.255808] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.255929] pnp: PnP ACPI init
[    0.255956] ACPI: bus type pnp registered
[    0.259983] pnp: PnP ACPI: found 13 devices
[    0.259983] ACPI: ACPI bus type pnp unregistered
[    0.259983] SCSI subsystem initialized
[    0.259983] libata version 3.00 loaded.
[    0.259983] usbcore: registered new interface driver usbfs
[    0.259983] usbcore: registered new interface driver hub
[    0.259983] usbcore: registered new device driver usb
[    0.259983] PCI: Using ACPI for IRQ routing
[    0.276648] PCI-DMA: Disabling AGP.
[    0.276648] PCI-DMA: aperture base @ 4000000 size 65536 KB
[    0.276648] PCI-DMA: using GART IOMMU.
[    0.276648] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.276648] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.276648] hpet0: 3 32-bit timers, 25000000 Hz
[    0.278080] Switched to high resolution mode on CPU 0
[    0.278080] Switched to high resolution mode on CPU 1
[    0.284774] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[    0.284801] system 00:05: ioport range 0x800-0x80f has been reserved
[    0.284827] system 00:05: ioport range 0x2000-0x207f has been reserved
[    0.284853] system 00:05: ioport range 0x2080-0x20ff has been reserved
[    0.284879] system 00:05: ioport range 0x2400-0x247f has been reserved
[    0.285535] system 00:05: ioport range 0x2480-0x24ff has been reserved
[    0.285562] system 00:05: ioport range 0x2800-0x287f has been reserved
[    0.285593] system 00:05: ioport range 0x2880-0x28ff has been reserved
[    0.285619] system 00:05: ioport range 0x2c00-0x2c7f has been reserved
[    0.285645] system 00:05: ioport range 0x2c80-0x2cff has been reserved
[    0.285672] system 00:05: iomem range 0xfee01000-0xfeefffff could not be reserved
[    0.285705] system 00:07: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.285733] system 00:07: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.285765] system 00:0a: ioport range 0x290-0x29f has been reserved
[    0.285795] system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[    0.285825] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.285851] system 00:0c: iomem range 0xc0000-0xcffff has been reserved
[    0.285876] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[    0.285902] system 00:0c: iomem range 0x100000-0xcfffffff could not be reserved
[    0.285930] system 00:0c: iomem range 0xff380000-0xffffffff could not be reserved
[    0.286671] PCI: Bridge: 0000:00:08.0
[    0.286671]   IO window: d000-dfff
[    0.286671]   MEM window: 0xfea00000-0xfeafffff
[    0.286671]   PREFETCH window: 0x00000000f0000000-0x00000000f00fffff
[    0.286671] PCI: Bridge: 0000:00:0b.0
[    0.286671]   IO window: c000-cfff
[    0.286671]   MEM window: 0xfe900000-0xfe9fffff
[    0.286671]   PREFETCH window: disabled.
[    0.286671] PCI: Bridge: 0000:00:0c.0
[    0.286671]   IO window: disabled.
[    0.286671]   MEM window: disabled.
[    0.286671]   PREFETCH window: disabled.
[    0.286671] PCI: Bridge: 0000:00:0d.0
[    0.286671]   IO window: e000-efff
[    0.286671]   MEM window: 0xfeb00000-0xfebfffff
[    0.286671]   PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
[    0.286671] PCI: Bridge: 0000:00:0e.0
[    0.286671]   IO window: disabled.
[    0.286671]   MEM window: disabled.
[    0.286671]   PREFETCH window: disabled.
[    0.286671] PCI: Setting latency timer of device 0000:00:08.0 to 64
[    0.286671] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.286671] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.286671] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.286671] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    0.286671] NET: Registered protocol family 2
[    0.314415] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.314804] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.316221] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.316671] TCP: Hash tables configured (established 262144 bind 65536)
[    0.316671] TCP reno registered
[    0.324337] NET: Registered protocol family 1
[    0.324430] checking if image is initramfs... it is
[    0.366321] Freeing initrd memory: 893k freed
[    0.370008] Loading Reiser4. See www.namesys.com for a description of Reiser4.
[    0.370008] msgmni has been set to 7905
[    0.370008] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.370008] io scheduler noop registered
[    0.370008] io scheduler cfq registered (default)
[    0.370008] pci 0000:00:00.0: Enabling HT MSI Mapping
[    0.370008] pci 0000:00:08.0: Enabling HT MSI Mapping
[    0.370008] pci 0000:00:0a.0: Enabling HT MSI Mapping
[    0.370008] pci 0000:00:0b.0: Enabling HT MSI Mapping
[    0.370008] pci 0000:00:0c.0: Enabling HT MSI Mapping
[    0.370008] pci 0000:00:0d.0: Enabling HT MSI Mapping
[    0.370008] pci 0000:00:0e.0: Enabling HT MSI Mapping
[    0.370008] pci 0000:04:00.0: Boot video device
[    0.370008] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.370008] assign_interrupt_mode Found MSI capability
[    0.370008] Allocate Port Service[0000:00:0b.0:pcie00]
[    0.370008] Allocate Port Service[0000:00:0b.0:pcie03]
[    0.370008] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.370008] assign_interrupt_mode Found MSI capability
[    0.370008] Allocate Port Service[0000:00:0c.0:pcie00]
[    0.370008] Allocate Port Service[0000:00:0c.0:pcie03]
[    0.370008] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.370008] assign_interrupt_mode Found MSI capability
[    0.370008] Allocate Port Service[0000:00:0d.0:pcie00]
[    0.370008] Allocate Port Service[0000:00:0d.0:pcie03]
[    0.370008] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    0.370008] assign_interrupt_mode Found MSI capability
[    0.370008] Allocate Port Service[0000:00:0e.0:pcie00]
[    0.370008] Allocate Port Service[0000:00:0e.0:pcie03]
[    0.370008] input: Power Button (FF) as /class/input/input0
[    0.370008] ACPI: Power Button (FF) [PWRF]
[    0.370008] input: Power Button (CM) as /class/input/input1
[    0.370008] ACPI: Power Button (CM) [PWRB]
[    0.370008] ACPI: ACPI0007:00 is registered as cooling_device0
[    0.370008] ACPI: ACPI0007:01 is registered as cooling_device1
[    0.406671] Real Time Clock Driver v1.12ac
[    0.406671] hpet_resources: 0xfed00000 is busy
[    0.406671] Linux agpgart interface v0.103
[    0.406672] brd: module loaded
[    0.406672] loop: module loaded
[    0.406672] Driver 'sd' needs updating - please use bus_type methods
[    0.406672] ahci 0000:00:0a.0: version 3.0
[    0.406672] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[    0.406672] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 (level, low) -> IRQ 23
[    0.425546] ahci 0000:00:0a.0: controller can do NCQ, turning on CAP_NCQ
[    1.427835] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    1.427864] ahci 0000:00:0a.0: flags: 64bit ncq sntf led clo pmp pio 
[    1.427890] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[    1.430005] scsi0 : ahci
[    1.430005] scsi1 : ahci
[    1.430005] scsi2 : ahci
[    1.430005] scsi3 : ahci
[    1.430005] ata1: SATA max UDMA/133 abar m8192@0xfe8fc000 port 0xfe8fc100 irq 23
[    1.430005] ata2: SATA max UDMA/133 abar m8192@0xfe8fc000 port 0xfe8fc180 irq 23
[    1.430005] ata3: SATA max UDMA/133 abar m8192@0xfe8fc000 port 0xfe8fc200 irq 23
[    1.430005] ata4: SATA max UDMA/133 abar m8192@0xfe8fc000 port 0xfe8fc280 irq 23
[    1.747747] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.754004] ata1.00: ATA-7: SAMSUNG HD502IJ, 1AA01109, max UDMA7
[    1.754004] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.757738] ata1.00: configured for UDMA/133
[    2.078422] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.084405] ata2.00: ATA-7: SAMSUNG HD502IJ, 1AA01110, max UDMA7
[    2.084405] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.087738] ata2.00: configured for UDMA/133
[    2.407746] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.408295] ata3.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[    2.408320] ata3.00: 312581808 sectors, multi 16: LBA48 
[    2.408940] ata3.00: configured for UDMA/133
[    2.727746] ata4: SATA link down (SStatus 0 SControl 300)
[    2.727746] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1AA0 PQ: 0 ANSI: 5
[    2.727746] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[    2.727746] sd 0:0:0:0: [sda] Write Protect is off
[    2.727746] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.727746] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.727746] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[    2.727746] sd 0:0:0:0: [sda] Write Protect is off
[    2.727746] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.727746] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.727746]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    2.755254] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.755254] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.755254] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1AA0 PQ: 0 ANSI: 5
[    2.755254] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[    2.755254] sd 1:0:0:0: [sdb] Write Protect is off
[    2.755254] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.755254] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.755254] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[    2.755254] sd 1:0:0:0: [sdb] Write Protect is off
[    2.755254] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.755254] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.755254]  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 >
[    2.776422] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.776422] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    2.776422] scsi 2:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 PQ: 0 ANSI: 5
[    2.776422] sd 2:0:0:0: [sdc] 312581808 512-byte hardware sectors (160042 MB)
[    2.776422] sd 2:0:0:0: [sdc] Write Protect is off
[    2.776422] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    2.776422] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.776422] sd 2:0:0:0: [sdc] 312581808 512-byte hardware sectors (160042 MB)
[    2.776422] sd 2:0:0:0: [sdc] Write Protect is off
[    2.776422] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    2.776422] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.776422]  sdc: sdc1
[    2.795296] sd 2:0:0:0: [sdc] Attached SCSI disk
[    2.795296] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    2.795296] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    2.798596] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.798624] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.828570] md: raid1 personality registered for level 1
[    2.828570] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
[    2.828570] EDAC MC: Ver: 2.1.0 Aug 28 2008
[    2.828570] cpuidle: using governor ladder
[    2.828570] cpuidle: using governor menu
[    2.828570] usbcore: registered new interface driver usbhid
[    2.828570] usbhid: v2.6:USB HID core driver
[    2.828570] TCP cubic registered
[    2.828570] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ processors (2 cpu cores) (version 2.20.00)
[    2.828570] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[    2.828570] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[    2.828570] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[    2.828570] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[    2.828570] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[    2.828570] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[    2.828570] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[    2.828570] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[    2.828570] Freeing unused kernel memory: 252k freed
[    2.835237] ata1: hard resetting link
[    2.851788] input: AT Translated Set 2 keyboard as /class/input/input2
[    3.154414] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.167049] ata1.00: configured for UDMA/133
[    3.167051] ata1: EH complete
[    3.167108] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[    3.167119] sd 0:0:0:0: [sda] Write Protect is off
[    3.167121] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.167136] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.351905] Driver 'sr' needs updating - please use bus_type methods
[    3.362655] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 19
[    3.362655] ACPI: PCI Interrupt 0000:02:08.0[A] -> Link [LNKA] -> GSI 19 (level, low) -> IRQ 19
[    3.371901] scsi4 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[    3.371901]         <Adaptec 2944 Ultra SCSI adapter>
[    3.371901]         aic7880: Ultra Wide Channel A, SCSI Id=7, 16/253 SCBs
[    3.371901] 
[    4.501910] Clocksource tsc unstable (delta = -330947176 ns)
[    7.511234] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[    7.511240] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 22 (level, low) -> IRQ 22
[    7.511247] PCI: Setting latency timer of device 0000:00:02.1 to 64
[    7.511249] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    7.511906] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[    7.511906] ehci_hcd 0000:00:02.1: debug port 1
[    7.511906] PCI: cache line size of 64 is not supported by device 0000:00:02.1
[    7.511906] ehci_hcd 0000:00:02.1: irq 22, io mem 0xfe8fec00
[    7.518574] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    7.519757] usb usb1: configuration #1 chosen from 1 choice
[    7.520910] hub 1-0:1.0: USB hub found
[    7.520915] hub 1-0:1.0: 10 ports detected
[    7.654547] Initializing USB Mass Storage driver...
[    7.847744] usb 1-3: new high speed USB device using ehci_hcd and address 2
[    7.975238] usb 1-3: configuration #1 chosen from 1 choice
[    7.975238] hub 1-3:1.0: USB hub found
[    7.975238] hub 1-3:1.0: 4 ports detected
[    8.261994] usb 1-3.1: new low speed USB device using ehci_hcd and address 3
[    8.351905] usb 1-3.1: configuration #1 chosen from 1 choice
[    8.363478] input: Logitech USB Receiver as /class/input/input3
[    8.376394] input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:02.1-3.1
[    8.383762] input: Logitech USB Receiver as /class/input/input4
[    8.409824] input: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:02.1-3.1
[    8.411981] usbcore: registered new interface driver usb-storage
[    8.411981] USB Mass Storage support registered.
[    8.438573] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[    8.438573] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 21
[    8.438573] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUB0] -> GSI 21 (level, low) -> IRQ 21
[    8.438573] PCI: Setting latency timer of device 0000:00:02.0 to 64
[    8.438573] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    8.438573] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[    8.438573] ohci_hcd 0000:00:02.0: irq 21, io mem 0xfe8ff000
[    8.491907] usb usb2: configuration #1 chosen from 1 choice
[    8.491907] hub 2-0:1.0: USB hub found
[    8.491907] hub 2-0:1.0: 10 ports detected
[   11.738572] md: Autodetecting RAID arrays.
[   11.815237] md: Scanned 8 and added 8 devices.
[   11.815237] md: autorun ...
[   11.815237] md: considering sdb6 ...
[   11.815237] md:  adding sdb6 ...
[   11.815237] md: sdb5 has different UUID to sdb6
[   11.815237] md: sdb3 has different UUID to sdb6
[   11.815237] md: sdb1 has different UUID to sdb6
[   11.815237] md:  adding sda6 ...
[   11.815237] md: sda5 has different UUID to sdb6
[   11.815237] md: sda3 has different UUID to sdb6
[   11.815237] md: sda1 has different UUID to sdb6
[   11.815237] md: created md3
[   11.815237] md: bind<sda6>
[   11.815237] md: bind<sdb6>
[   11.815237] md: running: <sdb6><sda6>
[   11.841904] raid1: raid set md3 active with 2 out of 2 mirrors
[   11.841904] md: considering sdb5 ...
[   11.841904] md:  adding sdb5 ...
[   11.841904] md: sdb3 has different UUID to sdb5
[   11.841904] md: sdb1 has different UUID to sdb5
[   11.841904] md:  adding sda5 ...
[   11.841904] md: sda3 has different UUID to sdb5
[   11.841904] md: sda1 has different UUID to sdb5
[   11.841905] md: created md2
[   11.841905] md: bind<sda5>
[   11.841905] md: bind<sdb5>
[   11.841905] md: running: <sdb5><sda5>
[   11.848571] raid1: raid set md2 active with 2 out of 2 mirrors
[   11.848571] md: considering sdb3 ...
[   11.848571] md:  adding sdb3 ...
[   11.848571] md: sdb1 has different UUID to sdb3
[   11.848571] md:  adding sda3 ...
[   11.848571] md: sda1 has different UUID to sdb3
[   11.848571] md: created md1
[   11.848571] md: bind<sda3>
[   11.848571] md: bind<sdb3>
[   11.848571] md: running: <sdb3><sda3>
[   11.856478] raid1: raid set md1 active with 2 out of 2 mirrors
[   11.857632] md: considering sdb1 ...
[   11.857635] md:  adding sdb1 ...
[   11.857639] md:  adding sda1 ...
[   11.858571] md: created md0
[   11.858571] md: bind<sda1>
[   11.858571] md: bind<sdb1>
[   11.858571] md: running: <sdb1><sda1>
[   11.865238] raid1: raid set md0 active with 2 out of 2 mirrors
[   11.865238] md: ... autorun DONE.
[   11.901904] reiser4: md1: found disk format 4.0.0.
[   16.599855] r8169 Gigabit Ethernet driver 2.2LK loaded
[   16.600092] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 18
[   16.600096] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 18 (level, low) -> IRQ 18
[   16.600105] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   16.600175] eth0: RTL8168b/8111b at 0xffffc2000005e000, 00:19:66:47:f3:cb, XID 38000000 IRQ 315
[   17.039079] reiser4: md2: found disk format 4.0.0.
[   18.235752] reiser4: md3: found disk format 4.0.0.
[   42.928883] Adding 7815612k swap on /dev/sda2.  Priority:1 extents:1 across:7815612k
[   42.969544] Adding 7815612k swap on /dev/sdb2.  Priority:1 extents:1 across:7815612k
[   43.421902] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 17
[   43.421902] ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI 17 (level, low) -> IRQ 17
[   43.423375] Audigy2 value: Special config.
[   43.536318] r8169: eth0: link up
[   43.536321] r8169: eth0: link up
[   44.241906] i2c /dev entries driver
[   44.278391] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x2d00
[   44.278413] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x2e00
[   44.348568] w83627ehf: Found W83627EHG chip at 0x290
[   48.565349] fglrx: module license 'Proprietary. (C) 2002 - ATI Technologies, Starnberg, GERMANY' taints kernel.
[   48.608566] [fglrx] Maximum main memory to use for locked dma buffers: 3791 MBytes.
[   48.608691] [fglrx]   vendor: 1002 device: 9501 count: 1
[   48.609024] [fglrx] ioport: bar 4, base 0xe000, size: 0x100
[   48.609263] ACPI: PCI Interrupt Link [LNED] enabled at IRQ 16
[   48.609269] ACPI: PCI Interrupt 0000:04:00.0[A] -> Link [LNED] -> GSI 16 (level, low) -> IRQ 16
[   48.609273] PCI: Setting latency timer of device 0000:04:00.0 to 64
[   48.612001] [fglrx] PAT is enabled successfully!
[   48.612035] [fglrx] module loaded - fglrx 8.52.3 [Aug  1 2008] with 1 minors
[   50.351902] [fglrx] Maximum main memory to use for locked dma buffers: 3791 MBytes.
[   50.361539] [fglrx] Reserved FB block: Shared offset:0, size:1000000 
[   50.361544] [fglrx] Reserved FB block: Unshared offset:ff7f000, size:80000 

--Boundary-00=_zCHuIa1fu0AqDKx--
