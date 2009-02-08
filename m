Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbZBHLEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbZBHLEk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 06:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbZBHLEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 06:04:31 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:62343 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbZBHLEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 06:04:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer;
        b=uX6+c+pPQJUm+b9SNk6F6fPQP/WzU+MQkamFSqh2wYLSU43rykWIMdSjOKdnvbrckN
         e1Tzml1q4Jh2EMuojRmR+5H+bicVJOqUzcIAMw10HGXgn4pCboJOD03H8XzKfoVmMe6Q
         bwn/6kop1n5v4C+Sc35sFsLjgjudjBAJKdG4M=
Subject: second bug with 2.6.28.4 - BUG: unable to handle kernel paging
 request at 000011bbffff88f8
From: Alessandro Bono <alessandro.bono@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-z+sG+p0CLQ3z8Fr2Caa8"
Date: Sun, 08 Feb 2009 12:04:09 +0100
Message-Id: <1234091050.7967.52.camel@champagne.cantina>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-z+sG+p0CLQ3z8Fr2Caa8
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi

second bug with kernel 2.6.28.4 (first titled: XFS kernel BUG at
fs/buffer.c:470! with 2.6.28.4)
only "particular" operation was a night of rsync from a remote server to
a local usb ext4 disk
attached kernel log from machine boot to bug and .config
tell me if you need other info or test/patch to try

Feb  8 11:02:03 champagne kernel: [38665.956159] BUG: unable to handle
kernel paging request at 000011bbffff88f8
Feb  8 11:02:03 champagne kernel: [38665.956172] IP:
[<ffffffff802bd1e3>] pin_to_kill+0x21/0xd6
Feb  8 11:02:03 champagne kernel: [38665.956188] PGD 0
Feb  8 11:02:03 champagne kernel: [38665.956193] Oops: 0000 [#1] SMP
Feb  8 11:02:03 champagne kernel: [38665.956199] last sysfs
file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
Feb  8 11:02:03 champagne kernel: [38665.956204] CPU 1
Feb  8 11:02:03 champagne kernel: [38665.956208] Modules linked in: ext4
jbd2 crc16 usb_storage libusual af_packet binfmt_misc rfcomm bridge stp
llc bnep sco
 l2cap acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave
cpufreq_ondemand freq_table cpufreq_conservative sbs sbshc pci_slot
ipt_LOG xt_limit ip
t_addrtype xt_state xt_tcpudp xt_conntrack ip6table_filter ip6_tables
ipv6 nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_
conntrack_ftp nf_conntrack iptable_filter ip_tables x_tables ext3 jbd
mbcache hp_wmi coretemp sbp2 loop arc4 ecb iwlagn snd_seq_dummy
snd_hda_intel pcmcia sn
d_pcm_oss snd_seq_oss snd_seq_midi tpm_infineon tpm tpm_bios iwlcore
btusb sdhci_pci parport_pc parport snd_rawmidi rfkill sdhci
snd_mixer_oss lis3lv02d leds
_hp_disk snd_seq_midi_event mac80211 mmc_core ricoh_mmc yenta_socket
rsrc_nonstatic pcmcia_core bluetooth snd_pcm video output container
led_class snd_seq wm
i button cfg80211 battery iTCO_wdt iTCO_vendor_support psmouse serio_raw
ac snd_page_al
Feb  8 11:02:03 champagne kernel: oc snd_hwdep snd_timer snd_seq_device
snd pcspkr soundcore evdev dm_multipath xfs sd_mod crc_t10dif sg sr_mod
cdrom ahci at
a_piix libata ohci1394 scsi_mod ieee1394 ehci_hcd uhci_hcd usbcore
e1000e dm_crypt dm_mirror dm_region_hash dm_log dm_snapshot dm_mod
thermal processor fan t
hermal_sys hwmon fuse
Feb  8 11:02:03 champagne kernel: [38665.956410] Pid: 7403, comm: kded4
Not tainted 2.6.28.4 #1
Feb  8 11:02:03 champagne kernel: [38665.956414] RIP:
0010:[<ffffffff802bd1e3>]  [<ffffffff802bd1e3>] pin_to_kill+0x21/0xd6
Feb  8 11:02:03 champagne kernel: [38665.956426] RSP:
0018:ffff880037951ee8  EFLAGS: 00010286
Feb  8 11:02:03 champagne kernel: [38665.956431] RAX: 000011bbffff8800
RBX: ffff8800aed59c6c RCX: 0000000000000000
Feb  8 11:02:03 champagne kernel: [38665.956437] RDX: ffff8800aed59c6c
RSI: ffff8800aed59c6c RDI: ffffffff805dd960
Feb  8 11:02:03 champagne kernel: [38665.956442] RBP: ffff8800aed59c6c
R08: ffff8800bf415e68 R09: 0000000000000002
Feb  8 11:02:03 champagne kernel: [38665.956448] R10: 00000000021deca8
R11: 0000000000000246 R12: ffff880127003380
Feb  8 11:02:03 champagne kernel: [38665.956453] R13: ffff880127003360
R14: 0000000000000fc6 R15: 00000000000011bb
Feb  8 11:02:03 champagne kernel: [38665.956459] FS:
00007f67321af6f0(0000) GS:ffff88013b803a00(0000) knlGS:0000000000000000
Feb  8 11:02:03 champagne kernel: [38665.956465] CS:  0010 DS: 0000 ES:
0000 CR0: 000000008005003b
Feb  8 11:02:03 champagne kernel: [38665.956470] CR2: 000011bbffff88f8
CR3: 000000003793d000 CR4: 00000000000006e0
Feb  8 11:02:03 champagne kernel: [38665.956476] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
Feb  8 11:02:03 champagne kernel: [38665.956481] DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb  8 11:02:03 champagne kernel: [38665.956487] Process kded4 (pid:
7403, threadinfo ffff880037950000, task ffff88010208a2b0)
Feb  8 11:02:03 champagne kernel: [38665.956492] Stack:
Feb  8 11:02:03 champagne kernel: [38665.956495]  ffff8800aed59c6c
ffff880127003360 ffff880127003380 00000000021deca8
Feb  8 11:02:03 champagne kernel: [38665.956504]  0000000001f8a310
ffffffff802bd9e9 00000000000000df ffff8800bf415e40
Feb  8 11:02:03 champagne kernel: [38665.956513]  00000000ffffffea
00000000000011bb 00000000021deca8 0000000001f8a310
Feb  8 11:02:03 champagne kernel: [38665.956523] Call Trace:
Feb  8 11:02:03 champagne kernel: [38665.956527]  [<ffffffff802bd9e9>] ?
inotify_rm_wd+0x4d/0xb6
Feb  8 11:02:03 champagne kernel: [38665.956536]  [<ffffffff802be0ee>] ?
sys_inotify_rm_watch+0x46/0x62
Feb  8 11:02:03 champagne kernel: [38665.956545]  [<ffffffff8020b49b>] ?
system_call_fastpath+0x16/0x1b
Feb  8 11:02:03 champagne kernel: [38665.956554] Code: a4 07 32 00 31 c0
5a 5b 5d c3 41 56 41 55 49 89 fd 41 54 48 c7 c7 60 d9 5d 80 55 4d 8d 65
20 53 48 89f5 48 8b 46 30 44 8b 76 38 <48> 8b 98 f8 00 00 00 e8 44 a4 13
00 8b 83 a0 00 00 00 3d ff ff
Feb  8 11:02:03 champagne kernel: [38665.956619] RIP
[<ffffffff802bd1e3>] pin_to_kill+0x21/0xd6
Feb  8 11:02:03 champagne kernel: [38665.956628]  RSP <ffff880037951ee8>
Feb  8 11:02:03 champagne kernel: [38665.956631] CR2: 000011bbffff88f8
Feb  8 11:02:03 champagne kernel: [38665.956636] ---[ end trace
038082a5e57e3652 ]---

-- 
---
Cordiali Saluti
Alessandro Bono

--=-z+sG+p0CLQ3z8Fr2Caa8
Content-Disposition: attachment; filename="dmesg-2.6.28.4-bug"
Content-Type: text/plain; name="dmesg-2.6.28.4-bug"; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Feb  8 00:18:03 champagne kernel: Inspecting /boot/System.map-2.6.28.4
Feb  8 00:18:03 champagne kernel: Cannot find map file.
Feb  8 00:18:03 champagne kernel: Loaded 39793 symbols from 121 modules.
Feb  8 00:18:03 champagne kernel: [    0.000000] BIOS EBDA/lowmem at: 0009f=
c00/0009fc00
Feb  8 00:18:03 champagne kernel: [    0.000000] Initializing cgroup subsys=
 cpuset
Feb  8 00:18:03 champagne kernel: [    0.000000] Linux version 2.6.28.4 (ro=
ot@champagne) (gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu12) ) #1 SMP Sat Feb =
7 01:05:07 CET 2009
Feb  8 00:18:03 champagne kernel: [    0.000000] Command line: root=3D/dev/=
mapper/vol00-root ro quiet splash=20
Feb  8 00:18:03 champagne kernel: [    0.000000] KERNEL supported cpus:
Feb  8 00:18:03 champagne kernel: [    0.000000]   Intel GenuineIntel
Feb  8 00:18:03 champagne kernel: [    0.000000]   AMD AuthenticAMD
Feb  8 00:18:03 champagne kernel: [    0.000000]   Centaur CentaurHauls
Feb  8 00:18:03 champagne kernel: [    0.000000] BIOS-provided physical RAM=
 map:
Feb  8 00:18:03 champagne kernel: [    0.000000]  BIOS-e820: 00000000000000=
00 - 000000000009fc00 (usable)
Feb  8 00:18:03 champagne kernel: [    0.000000]  BIOS-e820: 000000000009fc=
00 - 00000000000a0000 (reserved)
Feb  8 00:18:03 champagne kernel: [    0.000000]  BIOS-e820: 00000000000e00=
00 - 0000000000100000 (reserved)
Feb  8 00:18:03 champagne kernel: [    0.000000]  BIOS-e820: 00000000001000=
00 - 00000000bffb0000 (usable)
Feb  8 00:18:03 champagne kernel: [    0.000000]  BIOS-e820: 00000000bffb00=
00 - 00000000bffc5400 (reserved)
Feb  8 00:18:03 champagne kernel: [    0.000000]  BIOS-e820: 00000000bffc54=
00 - 00000000bffe7fb8 (ACPI NVS)
Feb  8 00:18:03 champagne kernel: [    0.000000]  BIOS-e820: 00000000bffe7f=
b8 - 00000000c0000000 (reserved)
Feb  8 00:18:03 champagne kernel: [    0.000000]  BIOS-e820: 00000000fec000=
00 - 00000000fec01000 (reserved)
Feb  8 00:18:03 champagne kernel: [    0.000000]  BIOS-e820: 00000000fed200=
00 - 00000000fed9a000 (reserved)
Feb  8 00:18:03 champagne kernel: [    0.000000]  BIOS-e820: 00000000feda00=
00 - 00000000fedc0000 (reserved)
Feb  8 00:18:03 champagne kernel: [    0.000000]  BIOS-e820: 00000000fee000=
00 - 00000000fee01000 (reserved)
Feb  8 00:18:03 champagne kernel: [    0.000000]  BIOS-e820: 00000000ffb000=
00 - 00000000ffc00000 (reserved)
Feb  8 00:18:03 champagne kernel: [    0.000000]  BIOS-e820: 00000000fff000=
00 - 0000000100000000 (reserved)
Feb  8 00:18:03 champagne kernel: [    0.000000]  BIOS-e820: 00000001000000=
00 - 000000013c000000 (usable)
Feb  8 00:18:03 champagne kernel: [    0.000000] DMI 2.4 present.
Feb  8 00:18:03 champagne kernel: [    0.000000] last_pfn =3D 0x13c000 max_=
arch_pfn =3D 0x3ffffffff
Feb  8 00:18:03 champagne kernel: [    0.000000] x86 PAT enabled: cpu 0, ol=
d 0x7040600070406, new 0x7010600070106
Feb  8 00:18:03 champagne kernel: [    0.000000] last_pfn =3D 0xbffb0 max_a=
rch_pfn =3D 0x3ffffffff
Feb  8 00:18:03 champagne kernel: [    0.000000] init_memory_mapping: 00000=
00000000000-00000000bffb0000
Feb  8 00:18:03 champagne kernel: [    0.000000]  0000000000 - 00bfe00000 p=
age 2M
Feb  8 00:18:03 champagne kernel: [    0.000000]  00bfe00000 - 00bffb0000 p=
age 4k
Feb  8 00:18:03 champagne kernel: [    0.000000] kernel direct mapping tabl=
es up to bffb0000 @ 8000-d000
Feb  8 00:18:03 champagne kernel: [    0.000000] last_map_addr: bffb0000 en=
d: bffb0000
Feb  8 00:18:03 champagne kernel: [    0.000000] init_memory_mapping: 00000=
00100000000-000000013c000000
Feb  8 00:18:03 champagne kernel: [    0.000000]  0100000000 - 013c000000 p=
age 2M
Feb  8 00:18:03 champagne kernel: [    0.000000] kernel direct mapping tabl=
es up to 13c000000 @ b000-11000
Feb  8 00:18:03 champagne kernel: [    0.000000] last_map_addr: 13c000000 e=
nd: 13c000000
Feb  8 00:18:03 champagne kernel: [    0.000000] RAMDISK: 37a08000 - 37fef3=
82
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: RSDP 000F7D10, 0024 =
(r2 HP    )
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: XSDT BFFC81CC, 0084 =
(r1 HPQOEM SLIC-MPC        1 HP          1)
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: FACP BFFC8084, 00F4 =
(r4 HP     30C5            3 HP          1)
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: DSDT BFFC8544, 12EAD=
 (r1 HP        8510x    10000 MSFT  3000001)
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: FACS BFFE7D80, 0040
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: SLIC BFFC8250, 0176 =
(r1 HPQOEM SLIC-MPC        1 HP          1)
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: HPET BFFC83C8, 0038 =
(r1 HP     30C5            1 HP          1)
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: APIC BFFC8400, 0068 =
(r1 HP     30C5            1 HP          1)
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: MCFG BFFC8468, 003C =
(r1 HP     30C5            1 HP          1)
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: TCPA BFFC84A4, 0032 =
(r2 HP     30C5            1 HP          1)
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: ASF! BFFC84D8, 0069 =
(r16 HP     CHIMAYU         1 HP          0)
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: SSDT BFFDB3F1, 0328 =
(r1 HP       HPQSAT        1 MSFT  3000001)
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: SSDT BFFDB719, 017C =
(r1 HP       HPQMRM        1 MSFT  3000001)
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: SSDT BFFDC29D, 025F =
(r1 HP      Cpu0Tst     3000 INTL 20060317)
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: SSDT BFFDC4FC, 00A6 =
(r1 HP      Cpu1Tst     3000 INTL 20060317)
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: SSDT BFFDC5A2, 04D7 =
(r1 HP        CpuPm     3000 INTL 20060317)
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: Local APIC address 0=
xfee00000
Feb  8 00:18:03 champagne kernel: [    0.000000] (7 early reservations) =3D=
=3D> bootmem [0000000000 - 013c000000]
Feb  8 00:18:03 champagne kernel: [    0.000000]   #0 [0000000000 - 0000001=
000]   BIOS data page =3D=3D> [0000000000 - 0000001000]
Feb  8 00:18:03 champagne kernel: [    0.000000]   #1 [0000006000 - 0000008=
000]       TRAMPOLINE =3D=3D> [0000006000 - 0000008000]
Feb  8 00:18:03 champagne kernel: [    0.000000]   #2 [0000200000 - 00005f4=
2c8]    TEXT DATA BSS =3D=3D> [0000200000 - 00005f42c8]
Feb  8 00:18:03 champagne kernel: [    0.000000]   #3 [0037a08000 - 0037fef=
382]          RAMDISK =3D=3D> [0037a08000 - 0037fef382]
Feb  8 00:18:03 champagne kernel: [    0.000000]   #4 [000009fc00 - 0000100=
000]    BIOS reserved =3D=3D> [000009fc00 - 0000100000]
Feb  8 00:18:03 champagne kernel: [    0.000000]   #5 [0000008000 - 000000b=
000]          PGTABLE =3D=3D> [0000008000 - 000000b000]
Feb  8 00:18:03 champagne kernel: [    0.000000]   #6 [000000b000 - 000000c=
000]          PGTABLE =3D=3D> [000000b000 - 000000c000]
Feb  8 00:18:03 champagne kernel: [    0.000000]  [ffffe20000000000-ffffe20=
0045fffff] PMD -> [ffff880028200000-ffff88002c7fffff] on node 0
Feb  8 00:18:03 champagne kernel: [    0.000000] Zone PFN ranges:
Feb  8 00:18:03 champagne kernel: [    0.000000]   DMA      0x00000000 -> 0=
x00001000
Feb  8 00:18:03 champagne kernel: [    0.000000]   DMA32    0x00001000 -> 0=
x00100000
Feb  8 00:18:03 champagne kernel: [    0.000000]   Normal   0x00100000 -> 0=
x0013c000
Feb  8 00:18:03 champagne kernel: [    0.000000] Movable zone start PFN for=
 each node
Feb  8 00:18:03 champagne kernel: [    0.000000] early_node_map[3] active P=
FN ranges
Feb  8 00:18:03 champagne kernel: [    0.000000]     0: 0x00000000 -> 0x000=
0009f
Feb  8 00:18:03 champagne kernel: [    0.000000]     0: 0x00000100 -> 0x000=
bffb0
Feb  8 00:18:03 champagne kernel: [    0.000000]     0: 0x00100000 -> 0x001=
3c000
Feb  8 00:18:03 champagne kernel: [    0.000000] On node 0 totalpages: 1032=
015
Feb  8 00:18:03 champagne kernel: [    0.000000]   DMA zone: 56 pages used =
for memmap
Feb  8 00:18:03 champagne kernel: [    0.000000]   DMA zone: 1115 pages res=
erved
Feb  8 00:18:03 champagne kernel: [    0.000000]   DMA zone: 2828 pages, LI=
FO batch:0
Feb  8 00:18:03 champagne kernel: [    0.000000]   DMA32 zone: 14280 pages =
used for memmap
Feb  8 00:18:03 champagne kernel: [    0.000000]   DMA32 zone: 767976 pages=
, LIFO batch:31
Feb  8 00:18:03 champagne kernel: [    0.000000]   Normal zone: 3360 pages =
used for memmap
Feb  8 00:18:03 champagne kernel: [    0.000000]   Normal zone: 242400 page=
s, LIFO batch:31
Feb  8 00:18:03 champagne kernel: [    0.000000]   Movable zone: 0 pages us=
ed for memmap
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x=
1008
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: Local APIC address 0=
xfee00000
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01]=
 lapic_id[0x00] enabled)
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x02]=
 lapic_id[0x01] enabled)
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0=
x01] high edge lint[0x1])
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0=
x02] high edge lint[0x1])
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: IOAPIC (id[0x01] add=
ress[0xfec00000] gsi_base[0])
Feb  8 00:18:03 champagne kernel: [    0.000000] IOAPIC[0]: apic_id 1, vers=
ion 0, address 0xfec00000, GSI 0-23
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 b=
us_irq 0 global_irq 2 dfl dfl)
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 b=
us_irq 9 global_irq 9 high level)
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: IRQ0 used by overrid=
e.
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: IRQ2 used by overrid=
e.
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: IRQ9 used by overrid=
e.
Feb  8 00:18:03 champagne kernel: [    0.000000] ACPI: HPET id: 0x8086a201 =
base: 0xfed00000
Feb  8 00:18:03 champagne kernel: [    0.000000] Using ACPI (MADT) for SMP =
configuration information
Feb  8 00:18:03 champagne kernel: [    0.000000] SMP: Allowing 2 CPUs, 0 ho=
tplug CPUs
Feb  8 00:18:03 champagne kernel: [    0.000000] PM: Registered nosave memo=
ry: 000000000009f000 - 00000000000a0000
Feb  8 00:18:03 champagne kernel: [    0.000000] PM: Registered nosave memo=
ry: 00000000000a0000 - 00000000000e0000
Feb  8 00:18:03 champagne kernel: [    0.000000] PM: Registered nosave memo=
ry: 00000000000e0000 - 0000000000100000
Feb  8 00:18:03 champagne kernel: [    0.000000] PM: Registered nosave memo=
ry: 00000000bffb0000 - 00000000bffc5000
Feb  8 00:18:03 champagne kernel: [    0.000000] PM: Registered nosave memo=
ry: 00000000bffc5000 - 00000000bffc6000
Feb  8 00:18:03 champagne kernel: [    0.000000] PM: Registered nosave memo=
ry: 00000000bffc6000 - 00000000bffe7000
Feb  8 00:18:03 champagne kernel: [    0.000000] PM: Registered nosave memo=
ry: 00000000bffe7000 - 00000000bffe8000
Feb  8 00:18:03 champagne kernel: [    0.000000] PM: Registered nosave memo=
ry: 00000000bffe8000 - 00000000c0000000
Feb  8 00:18:03 champagne kernel: [    0.000000] PM: Registered nosave memo=
ry: 00000000c0000000 - 00000000fec00000
Feb  8 00:18:03 champagne kernel: [    0.000000] PM: Registered nosave memo=
ry: 00000000fec00000 - 00000000fec01000
Feb  8 00:18:03 champagne kernel: [    0.000000] PM: Registered nosave memo=
ry: 00000000fec01000 - 00000000fed20000
Feb  8 00:18:03 champagne kernel: [    0.000000] PM: Registered nosave memo=
ry: 00000000fed20000 - 00000000fed9a000
Feb  8 00:18:03 champagne kernel: [    0.000000] PM: Registered nosave memo=
ry: 00000000fed9a000 - 00000000feda0000
Feb  8 00:18:03 champagne kernel: [    0.000000] PM: Registered nosave memo=
ry: 00000000feda0000 - 00000000fedc0000
Feb  8 00:18:03 champagne kernel: [    0.000000] PM: Registered nosave memo=
ry: 00000000fedc0000 - 00000000fee00000
Feb  8 00:18:03 champagne kernel: [    0.000000] PM: Registered nosave memo=
ry: 00000000fee00000 - 00000000fee01000
Feb  8 00:18:03 champagne kernel: [    0.000000] PM: Registered nosave memo=
ry: 00000000fee01000 - 00000000ffb00000
Feb  8 00:18:03 champagne kernel: [    0.000000] PM: Registered nosave memo=
ry: 00000000ffb00000 - 00000000ffc00000
Feb  8 00:18:03 champagne kernel: [    0.000000] PM: Registered nosave memo=
ry: 00000000ffc00000 - 00000000fff00000
Feb  8 00:18:03 champagne kernel: [    0.000000] PM: Registered nosave memo=
ry: 00000000fff00000 - 0000000100000000
Feb  8 00:18:03 champagne kernel: [    0.000000] Allocating PCI resources s=
tarting at c4000000 (gap: c0000000:3ec00000)
Feb  8 00:18:03 champagne kernel: [    0.000000] PERCPU: Allocating 53248 b=
ytes of per cpu data
Feb  8 00:18:03 champagne kernel: [    0.000000] NR_CPUS: 8, nr_cpu_ids: 2,=
 nr_node_ids 1
Feb  8 00:18:03 champagne kernel: [    0.000000] Built 1 zonelists in Zone =
order, mobility grouping on.  Total pages: 1013204
Feb  8 00:18:03 champagne kernel: [    0.000000] Kernel command line: root=
=3D/dev/mapper/vol00-root ro quiet splash=20
Feb  8 00:18:03 champagne kernel: [    0.000000] Initializing CPU#0
Feb  8 00:18:03 champagne kernel: [    0.000000] PID hash table entries: 40=
96 (order: 12, 32768 bytes)
Feb  8 00:18:03 champagne kernel: [    0.000000] Extended CMOS year: 2000
Feb  8 00:18:03 champagne kernel: [    0.000000] Fast TSC calibration using=
 PIT
Feb  8 00:18:03 champagne kernel: [    0.000000] Detected 2394.019 MHz proc=
essor.
Feb  8 00:18:03 champagne kernel: [    0.004000] Console: colour VGA+ 80x25
Feb  8 00:18:03 champagne kernel: [    0.004000] console [tty0] enabled
Feb  8 00:18:03 champagne kernel: [    0.004000] Dentry cache hash table en=
tries: 524288 (order: 10, 4194304 bytes)
Feb  8 00:18:03 champagne kernel: [    0.004000] Inode-cache hash table ent=
ries: 262144 (order: 9, 2097152 bytes)
Feb  8 00:18:03 champagne kernel: [    0.004000] allocated 52428800 bytes o=
f page_cgroup
Feb  8 00:18:03 champagne kernel: [    0.004000] please try cgroup_disable=
=3Dmemory option if you don't want
Feb  8 00:18:03 champagne kernel: [    0.004000] Checking aperture...
Feb  8 00:18:03 champagne kernel: [    0.004000] No AGP bridge found
Feb  8 00:18:03 champagne kernel: [    0.004000] PCI-DMA: Using software bo=
unce buffering for IO (SWIOTLB)
Feb  8 00:18:03 champagne kernel: [    0.004000] Placing software IO TLB be=
tween 0x20000000 - 0x24000000
Feb  8 00:18:03 champagne kernel: [    0.004000] Memory: 3921656k/5177344k =
available (2026k kernel code, 1049284k absent, 205412k reserved, 1029k data=
, 316k init)
Feb  8 00:18:03 champagne kernel: [    0.004000] SLUB: Genslabs=3D12, HWali=
gn=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, Nodes=3D1
Feb  8 00:18:03 champagne kernel: [    0.004000] hpet clockevent registered
Feb  8 00:18:03 champagne kernel: [    0.004000] HPET: 3 timers in total, 0=
 timers will be used for per-cpu timer
Feb  8 00:18:03 champagne kernel: [    0.004000] Calibrating delay loop (sk=
ipped), value calculated using timer frequency.. 4788.03 BogoMIPS (lpj=3D95=
76076)
Feb  8 00:18:03 champagne kernel: [    0.004000] Mount-cache hash table ent=
ries: 256
Feb  8 00:18:03 champagne kernel: [    0.004000] Initializing cgroup subsys=
 ns
Feb  8 00:18:03 champagne kernel: [    0.004000] Initializing cgroup subsys=
 cpuacct
Feb  8 00:18:03 champagne kernel: [    0.004000] Initializing cgroup subsys=
 memory
Feb  8 00:18:03 champagne kernel: [    0.004000] Initializing cgroup subsys=
 devices
Feb  8 00:18:03 champagne kernel: [    0.004000] Initializing cgroup subsys=
 freezer
Feb  8 00:18:03 champagne kernel: [    0.004000] CPU: L1 I cache: 32K, L1 D=
 cache: 32K
Feb  8 00:18:03 champagne kernel: [    0.004000] CPU: L2 cache: 4096K
Feb  8 00:18:03 champagne kernel: [    0.004000] CPU: Physical Processor ID=
: 0
Feb  8 00:18:03 champagne kernel: [    0.004000] CPU: Processor Core ID: 0
Feb  8 00:18:03 champagne kernel: [    0.004000] CPU0: Thermal monitoring h=
andled by SMI
Feb  8 00:18:03 champagne kernel: [    0.004000] using mwait in idle thread=
s.
Feb  8 00:18:03 champagne kernel: [    0.004000] ACPI: Core revision 200809=
26
Feb  8 00:18:03 champagne kernel: [    0.024048] Setting APIC routing to fl=
at
Feb  8 00:18:03 champagne kernel: [    0.024425] ..TIMER: vector=3D0x30 api=
c1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
Feb  8 00:18:03 champagne kernel: [    0.066179] CPU0: Intel(R) Core(TM)2 D=
uo CPU     T7700  @ 2.40GHz stepping 0b
Feb  8 00:18:03 champagne kernel: [    0.068001] Booting processor 1 APIC 0=
x1 ip 0x6000
Feb  8 00:18:03 champagne kernel: [    0.004000] Initializing CPU#1
Feb  8 00:18:03 champagne kernel: [    0.004000] Calibrating delay using ti=
mer specific routine.. 4787.95 BogoMIPS (lpj=3D9575908)
Feb  8 00:18:03 champagne kernel: [    0.004000] CPU: L1 I cache: 32K, L1 D=
 cache: 32K
Feb  8 00:18:03 champagne kernel: [    0.004000] CPU: L2 cache: 4096K
Feb  8 00:18:03 champagne kernel: [    0.004000] CPU: Physical Processor ID=
: 0
Feb  8 00:18:03 champagne kernel: [    0.004000] CPU: Processor Core ID: 1
Feb  8 00:18:03 champagne kernel: [    0.004000] CPU1: Thermal monitoring e=
nabled (TM2)
Feb  8 00:18:03 champagne kernel: [    0.004000] x86 PAT enabled: cpu 1, ol=
d 0x7040600070406, new 0x7010600070106
Feb  8 00:18:03 champagne kernel: [    0.153221] CPU1: Intel(R) Core(TM)2 D=
uo CPU     T7700  @ 2.40GHz stepping 0b
Feb  8 00:18:03 champagne kernel: [    0.153241] checking TSC synchronizati=
on [CPU#0 -> CPU#1]: passed.
Feb  8 00:18:03 champagne kernel: [    0.156020] Brought up 2 CPUs
Feb  8 00:18:03 champagne kernel: [    0.156022] Total of 2 processors acti=
vated (9575.99 BogoMIPS).
Feb  8 00:18:03 champagne kernel: [    0.156095] net_namespace: 1352 bytes
Feb  8 00:18:03 champagne kernel: [    0.156137] NET: Registered protocol f=
amily 16
Feb  8 00:18:03 champagne kernel: [    0.156137] ACPI FADT declares the sys=
tem doesn't support PCIe ASPM, so disable it
Feb  8 00:18:03 champagne kernel: [    0.156137] ACPI: bus type pci registe=
red
Feb  8 00:18:03 champagne kernel: [    0.156137] PCI: MCFG configuration 0:=
 base f8000000 segment 0 buses 0 - 63
Feb  8 00:18:03 champagne kernel: [    0.156137] PCI: Not using MMCONFIG.
Feb  8 00:18:03 champagne kernel: [    0.156137] PCI: Using configuration t=
ype 1 for base access
Feb  8 00:18:03 champagne kernel: [    0.156790] ACPI: EC: Look up EC in DS=
DT
Feb  8 00:18:03 champagne kernel: [    0.160019] ACPI: EC: non-query interr=
upt received, switching to interrupt mode
Feb  8 00:18:03 champagne kernel: [    0.217338] ACPI: Interpreter enabled
Feb  8 00:18:03 champagne kernel: [    0.217340] ACPI: (supports S0 S3 S4 S=
5)
Feb  8 00:18:03 champagne kernel: [    0.217353] ACPI: Using IOAPIC for int=
errupt routing
Feb  8 00:18:03 champagne kernel: [    0.217414] PCI: MCFG configuration 0:=
 base f8000000 segment 0 buses 0 - 63
Feb  8 00:18:03 champagne kernel: [    0.225449] PCI: MCFG area at f8000000=
 reserved in ACPI motherboard resources
Feb  8 00:18:03 champagne kernel: [    0.227992] PCI: Using MMCONFIG at f80=
00000 - fbffffff
Feb  8 00:18:03 champagne kernel: [    0.240191] ACPI: EC: GPE =3D 0x16, I/=
O: command/status =3D 0x66, data =3D 0x62
Feb  8 00:18:03 champagne kernel: [    0.240191] ACPI: EC: driver started i=
n interrupt mode
Feb  8 00:18:03 champagne kernel: [    0.240191] ACPI: No dock devices foun=
d.
Feb  8 00:18:03 champagne kernel: [    0.240191] ACPI: PCI Root Bridge [C00=
3] (0000:00)
Feb  8 00:18:03 champagne kernel: [    0.240209] pci 0000:00:01.0: PME# sup=
ported from D0 D3hot D3cold
Feb  8 00:18:03 champagne kernel: [    0.240209] pci 0000:00:01.0: PME# dis=
abled
Feb  8 00:18:03 champagne kernel: [    0.240209] pci 0000:00:03.0: reg 10 6=
4bit mmio: [0xe4500000-0xe450000f]
Feb  8 00:18:03 champagne kernel: [    0.240209] pci 0000:00:03.0: PME# sup=
ported from D0 D3hot D3cold
Feb  8 00:18:03 champagne kernel: [    0.240209] pci 0000:00:03.0: PME# dis=
abled
Feb  8 00:18:03 champagne kernel: [    0.240209] pci 0000:00:03.2: reg 10 i=
o port: [0x5000-0x5007]
Feb  8 00:18:03 champagne kernel: [    0.240209] pci 0000:00:03.2: reg 14 i=
o port: [0x5008-0x500b]
Feb  8 00:18:03 champagne kernel: [    0.240209] pci 0000:00:03.2: reg 18 i=
o port: [0x5010-0x5017]
Feb  8 00:18:03 champagne kernel: [    0.240209] pci 0000:00:03.2: reg 1c i=
o port: [0x5018-0x501b]
Feb  8 00:18:03 champagne kernel: [    0.240209] pci 0000:00:03.2: reg 20 i=
o port: [0x5020-0x502f]
Feb  8 00:18:03 champagne kernel: [    0.240209] pci 0000:00:03.3: reg 10 i=
o port: [0x5030-0x5037]
Feb  8 00:18:03 champagne kernel: [    0.240209] pci 0000:00:03.3: reg 14 3=
2bit mmio: [0xe4501000-0xe4501fff]
Feb  8 00:18:03 champagne kernel: [    0.240295] pci 0000:00:19.0: reg 10 3=
2bit mmio: [0xe4520000-0xe453ffff]
Feb  8 00:18:03 champagne kernel: [    0.240302] pci 0000:00:19.0: reg 14 3=
2bit mmio: [0xe4540000-0xe4540fff]
Feb  8 00:18:03 champagne kernel: [    0.240309] pci 0000:00:19.0: reg 18 i=
o port: [0x5040-0x505f]
Feb  8 00:18:03 champagne kernel: [    0.240341] pci 0000:00:19.0: PME# sup=
ported from D0 D3hot D3cold
Feb  8 00:18:03 champagne kernel: [    0.240345] pci 0000:00:19.0: PME# dis=
abled
Feb  8 00:18:03 champagne kernel: [    0.240395] pci 0000:00:1a.0: reg 20 i=
o port: [0x5060-0x507f]
Feb  8 00:18:03 champagne kernel: [    0.240453] pci 0000:00:1a.1: reg 20 i=
o port: [0x5080-0x509f]
Feb  8 00:18:03 champagne kernel: [    0.240518] pci 0000:00:1a.7: reg 10 3=
2bit mmio: [0xe4541000-0xe45413ff]
Feb  8 00:18:03 champagne kernel: [    0.240561] pci 0000:00:1a.7: PME# sup=
ported from D0 D3hot D3cold
Feb  8 00:18:03 champagne kernel: [    0.240566] pci 0000:00:1a.7: PME# dis=
abled
Feb  8 00:18:03 champagne kernel: [    0.240617] pci 0000:00:1b.0: reg 10 6=
4bit mmio: [0xe4544000-0xe4547fff]
Feb  8 00:18:03 champagne kernel: [    0.240655] pci 0000:00:1b.0: PME# sup=
ported from D0 D3hot D3cold
Feb  8 00:18:03 champagne kernel: [    0.240659] pci 0000:00:1b.0: PME# dis=
abled
Feb  8 00:18:03 champagne kernel: [    0.240722] pci 0000:00:1c.0: PME# sup=
ported from D0 D3hot D3cold
Feb  8 00:18:03 champagne kernel: [    0.240726] pci 0000:00:1c.0: PME# dis=
abled
Feb  8 00:18:03 champagne kernel: [    0.240791] pci 0000:00:1c.1: PME# sup=
ported from D0 D3hot D3cold
Feb  8 00:18:03 champagne kernel: [    0.240795] pci 0000:00:1c.1: PME# dis=
abled
Feb  8 00:18:03 champagne kernel: [    0.240865] pci 0000:00:1c.4: PME# sup=
ported from D0 D3hot D3cold
Feb  8 00:18:03 champagne kernel: [    0.240869] pci 0000:00:1c.4: PME# dis=
abled
Feb  8 00:18:03 champagne kernel: [    0.240929] pci 0000:00:1d.0: reg 20 i=
o port: [0x50a0-0x50bf]
Feb  8 00:18:03 champagne kernel: [    0.240987] pci 0000:00:1d.1: reg 20 i=
o port: [0x50c0-0x50df]
Feb  8 00:18:03 champagne kernel: [    0.241045] pci 0000:00:1d.2: reg 20 i=
o port: [0x50e0-0x50ff]
Feb  8 00:18:03 champagne kernel: [    0.241108] pci 0000:00:1d.7: reg 10 3=
2bit mmio: [0xe4548000-0xe45483ff]
Feb  8 00:18:03 champagne kernel: [    0.241152] pci 0000:00:1d.7: PME# sup=
ported from D0 D3hot D3cold
Feb  8 00:18:03 champagne kernel: [    0.241157] pci 0000:00:1d.7: PME# dis=
abled
Feb  8 00:18:03 champagne kernel: [    0.244027] pci 0000:00:1f.0: quirk: r=
egion 1000-107f claimed by ICH6 ACPI/GPIO/TCO
Feb  8 00:18:03 champagne kernel: [    0.244030] pci 0000:00:1f.0: quirk: r=
egion 1100-113f claimed by ICH6 GPIO
Feb  8 00:18:03 champagne kernel: [    0.244065] pci 0000:00:1f.1: reg 10 i=
o port: [0x00-0x07]
Feb  8 00:18:03 champagne kernel: [    0.244072] pci 0000:00:1f.1: reg 14 i=
o port: [0x00-0x03]
Feb  8 00:18:03 champagne kernel: [    0.244079] pci 0000:00:1f.1: reg 18 i=
o port: [0x00-0x07]
Feb  8 00:18:03 champagne kernel: [    0.244086] pci 0000:00:1f.1: reg 1c i=
o port: [0x00-0x03]
Feb  8 00:18:03 champagne kernel: [    0.244093] pci 0000:00:1f.1: reg 20 i=
o port: [0x5100-0x510f]
Feb  8 00:18:03 champagne kernel: [    0.244160] pci 0000:00:1f.2: reg 10 i=
o port: [0x13f0-0x13f7]
Feb  8 00:18:03 champagne kernel: [    0.244167] pci 0000:00:1f.2: reg 14 i=
o port: [0x15f4-0x15f7]
Feb  8 00:18:03 champagne kernel: [    0.244174] pci 0000:00:1f.2: reg 18 i=
o port: [0x1370-0x1377]
Feb  8 00:18:03 champagne kernel: [    0.244181] pci 0000:00:1f.2: reg 1c i=
o port: [0x1574-0x1577]
Feb  8 00:18:03 champagne kernel: [    0.244188] pci 0000:00:1f.2: reg 20 i=
o port: [0x5140-0x515f]
Feb  8 00:18:03 champagne kernel: [    0.244195] pci 0000:00:1f.2: reg 24 3=
2bit mmio: [0xe4549000-0xe45497ff]
Feb  8 00:18:03 champagne kernel: [    0.244214] pci 0000:00:1f.2: PME# sup=
ported from D3hot
Feb  8 00:18:03 champagne kernel: [    0.244218] pci 0000:00:1f.2: PME# dis=
abled
Feb  8 00:18:03 champagne kernel: [    0.244270] pci 0000:01:00.0: reg 10 3=
2bit mmio: [0xd0000000-0xdfffffff]
Feb  8 00:18:03 champagne kernel: [    0.244277] pci 0000:01:00.0: reg 14 i=
o port: [0x4000-0x40ff]
Feb  8 00:18:03 champagne kernel: [    0.244284] pci 0000:01:00.0: reg 18 3=
2bit mmio: [0xe4400000-0xe440ffff]
Feb  8 00:18:03 champagne kernel: [    0.244307] pci 0000:01:00.0: reg 30 3=
2bit mmio: [0x000000-0x01ffff]
Feb  8 00:18:03 champagne kernel: [    0.244317] pci 0000:01:00.0: supports=
 D1 D2
Feb  8 00:18:03 champagne kernel: [    0.244358] pci 0000:01:00.1: reg 10 3=
2bit mmio: [0xe4410000-0xe4413fff]
Feb  8 00:18:03 champagne kernel: [    0.244400] pci 0000:01:00.1: supports=
 D1 D2
Feb  8 00:18:03 champagne kernel: [    0.244465] pci 0000:00:01.0: bridge i=
o port: [0x4000-0x4fff]
Feb  8 00:18:03 champagne kernel: [    0.244468] pci 0000:00:01.0: bridge 3=
2bit mmio: [0xe4400000-0xe44fffff]
Feb  8 00:18:03 champagne kernel: [    0.244471] pci 0000:00:01.0: bridge 6=
4bit mmio pref: [0xd0000000-0xdfffffff]
Feb  8 00:18:03 champagne kernel: [    0.244650] pci 0000:10:00.0: reg 10 6=
4bit mmio: [0xe4000000-0xe4001fff]
Feb  8 00:18:03 champagne kernel: [    0.244736] pci 0000:10:00.0: PME# sup=
ported from D0 D3hot D3cold
Feb  8 00:18:03 champagne kernel: [    0.244748] pci 0000:10:00.0: PME# dis=
abled
Feb  8 00:18:03 champagne kernel: [    0.244832] pci 0000:00:1c.1: bridge 3=
2bit mmio: [0xe4000000-0xe40fffff]
Feb  8 00:18:03 champagne kernel: [    0.244894] pci 0000:00:1c.4: bridge i=
o port: [0x2000-0x3fff]
Feb  8 00:18:03 champagne kernel: [    0.244898] pci 0000:00:1c.4: bridge 3=
2bit mmio: [0xe0000000-0xe3ffffff]
Feb  8 00:18:03 champagne kernel: [    0.244956] pci 0000:02:06.0: reg 10 3=
2bit mmio: [0xe4100000-0xe4100fff]
Feb  8 00:18:03 champagne kernel: [    0.244967] pci 0000:02:06.0: supports=
 D1 D2
Feb  8 00:18:03 champagne kernel: [    0.244969] pci 0000:02:06.0: PME# sup=
ported from D0 D1 D2 D3hot D3cold
Feb  8 00:18:03 champagne kernel: [    0.244973] pci 0000:02:06.0: PME# dis=
abled
Feb  8 00:18:03 champagne kernel: [    0.245014] pci 0000:02:06.1: reg 10 3=
2bit mmio: [0xe4101000-0xe4101fff]
Feb  8 00:18:03 champagne kernel: [    0.245025] pci 0000:02:06.1: supports=
 D1 D2
Feb  8 00:18:03 champagne kernel: [    0.245026] pci 0000:02:06.1: PME# sup=
ported from D0 D1 D2 D3hot D3cold
Feb  8 00:18:03 champagne kernel: [    0.245031] pci 0000:02:06.1: PME# dis=
abled
Feb  8 00:18:03 champagne kernel: [    0.245072] pci 0000:02:06.2: reg 10 3=
2bit mmio: [0xe4102000-0xe41027ff]
Feb  8 00:18:03 champagne kernel: [    0.245118] pci 0000:02:06.2: supports=
 D1 D2
Feb  8 00:18:03 champagne kernel: [    0.245120] pci 0000:02:06.2: PME# sup=
ported from D0 D1 D2 D3hot D3cold
Feb  8 00:18:03 champagne kernel: [    0.245124] pci 0000:02:06.2: PME# dis=
abled
Feb  8 00:18:03 champagne kernel: [    0.245164] pci 0000:02:06.3: reg 10 3=
2bit mmio: [0xe4103000-0xe41030ff]
Feb  8 00:18:03 champagne kernel: [    0.245208] pci 0000:02:06.3: supports=
 D1 D2
Feb  8 00:18:03 champagne kernel: [    0.245210] pci 0000:02:06.3: PME# sup=
ported from D0 D1 D2 D3hot D3cold
Feb  8 00:18:03 champagne kernel: [    0.245214] pci 0000:02:06.3: PME# dis=
abled
Feb  8 00:18:03 champagne kernel: [    0.245255] pci 0000:02:06.4: reg 10 3=
2bit mmio: [0xe4104000-0xe41040ff]
Feb  8 00:18:03 champagne kernel: [    0.245301] pci 0000:02:06.4: supports=
 D1 D2
Feb  8 00:18:03 champagne kernel: [    0.245302] pci 0000:02:06.4: PME# sup=
ported from D0 D1 D2 D3hot D3cold
Feb  8 00:18:03 champagne kernel: [    0.245307] pci 0000:02:06.4: PME# dis=
abled
Feb  8 00:18:03 champagne kernel: [    0.245363] pci 0000:00:1e.0: transpar=
ent bridge
Feb  8 00:18:03 champagne kernel: [    0.245370] pci 0000:00:1e.0: bridge 3=
2bit mmio: [0xe4100000-0xe43fffff]
Feb  8 00:18:03 champagne kernel: [    0.245439] bus 00 -> node 0
Feb  8 00:18:03 champagne kernel: [    0.245444] ACPI: PCI Interrupt Routin=
g Table [\_SB_.C003._PRT]
Feb  8 00:18:03 champagne kernel: [    0.245937] ACPI: PCI Interrupt Routin=
g Table [\_SB_.C003.C096._PRT]
Feb  8 00:18:03 champagne kernel: [    0.246061] ACPI: PCI Interrupt Routin=
g Table [\_SB_.C003.C0B0._PRT]
Feb  8 00:18:03 champagne kernel: [    0.246246] ACPI: PCI Interrupt Routin=
g Table [\_SB_.C003.C11D._PRT]
Feb  8 00:18:03 champagne kernel: [    0.246395] ACPI: PCI Interrupt Routin=
g Table [\_SB_.C003.C131._PRT]
Feb  8 00:18:03 champagne kernel: [    0.246545] ACPI: PCI Interrupt Routin=
g Table [\_SB_.C003.C134._PRT]
Feb  8 00:18:03 champagne kernel: [    0.296145] ACPI: PCI Interrupt Link [=
C12D] (IRQs *10 11)
Feb  8 00:18:03 champagne kernel: [    0.296375] ACPI: PCI Interrupt Link [=
C12E] (IRQs *10 11)
Feb  8 00:18:03 champagne kernel: [    0.296601] ACPI: PCI Interrupt Link [=
C12F] (IRQs 10 *11)
Feb  8 00:18:03 champagne kernel: [    0.296828] ACPI: PCI Interrupt Link [=
C130] (IRQs 10 11) *5
Feb  8 00:18:03 champagne kernel: [    0.297054] ACPI: PCI Interrupt Link [=
C140] (IRQs *10 11)
Feb  8 00:18:03 champagne kernel: [    0.297279] ACPI: PCI Interrupt Link [=
C141] (IRQs 10 11) *5
Feb  8 00:18:03 champagne kernel: [    0.297505] ACPI: PCI Interrupt Link [=
C142] (IRQs 10 *11)
Feb  8 00:18:03 champagne kernel: [    0.297609] ACPI Exception (pci_link-0=
189): AE_NOT_FOUND, Evaluating _PRS [20080926]
Feb  8 00:18:03 champagne kernel: [    0.297724] ACPI: Power Resource [C22B=
] (on)
Feb  8 00:18:03 champagne kernel: [    0.297724] ACPI: Power Resource [C238=
] (on)
Feb  8 00:18:03 champagne kernel: [    0.297724] ACPI: Power Resource [C254=
] (on)
Feb  8 00:18:03 champagne kernel: [    0.297724] ACPI: Power Resource [C17C=
] (off)
Feb  8 00:18:03 champagne kernel: [    0.297724] ACPI: Power Resource [C363=
] (off)
Feb  8 00:18:03 champagne kernel: [    0.297724] ACPI: Power Resource [C366=
] (off)
Feb  8 00:18:03 champagne kernel: [    0.297724] ACPI: Power Resource [C367=
] (off)
Feb  8 00:18:03 champagne kernel: [    0.297724] ACPI: Power Resource [C368=
] (off)
Feb  8 00:18:03 champagne kernel: [    0.297724] ACPI: Power Resource [C369=
] (off)
Feb  8 00:18:03 champagne kernel: [    0.297724] ACPI: Power Resource [C36A=
] (off)
Feb  8 00:18:03 champagne kernel: [    0.297724] ACPI: Power Resource [C383=
] (off)
Feb  8 00:18:03 champagne kernel: [    0.297724] ACPI: Power Resource [C384=
] (off)
Feb  8 00:18:03 champagne kernel: [    0.297724] ACPI: Power Resource [C385=
] (off)
Feb  8 00:18:03 champagne kernel: [    0.297724] ACPI: Power Resource [C386=
] (off)
Feb  8 00:18:03 champagne kernel: [    0.297724] ACPI: Power Resource [C387=
] (off)
Feb  8 00:18:03 champagne kernel: [    0.300085] PCI: Using ACPI for IRQ ro=
uting
Feb  8 00:18:03 champagne kernel: [    0.320028] hpet0: at MMIO 0xfed00000,=
 IRQs 2, 8, 0
Feb  8 00:18:03 champagne kernel: [    0.320031] hpet0: 3 comparators, 64-b=
it 14.318180 MHz counter
Feb  8 00:18:03 champagne kernel: [    0.336006] pnp: PnP ACPI init
Feb  8 00:18:03 champagne kernel: [    0.336012] ACPI: bus type pnp registe=
red
Feb  8 00:18:03 champagne kernel: [    0.347570] pnp: PnP ACPI: found 16 de=
vices
Feb  8 00:18:03 champagne kernel: [    0.347572] ACPI: ACPI bus type pnp un=
registered
Feb  8 00:18:03 champagne kernel: [    0.347579] system 00:00: iomem range =
0x0-0x9ffff could not be reserved
Feb  8 00:18:03 champagne kernel: [    0.347581] system 00:00: iomem range =
0xe0000-0xfffff could not be reserved
Feb  8 00:18:03 champagne kernel: [    0.347583] system 00:00: iomem range =
0x100000-0xbfffffff could not be reserved
Feb  8 00:18:03 champagne kernel: [    0.347591] system 00:0c: ioport range=
 0x500-0x55f has been reserved
Feb  8 00:18:03 champagne kernel: [    0.347593] system 00:0c: ioport range=
 0x800-0x80f has been reserved
Feb  8 00:18:03 champagne kernel: [    0.347595] system 00:0c: iomem range =
0xffb00000-0xffbfffff has been reserved
Feb  8 00:18:03 champagne kernel: [    0.347597] system 00:0c: iomem range =
0xfff00000-0xffffffff has been reserved
Feb  8 00:18:03 champagne kernel: [    0.347601] system 00:0e: ioport range=
 0x4d0-0x4d1 has been reserved
Feb  8 00:18:03 champagne kernel: [    0.347604] system 00:0e: ioport range=
 0x1000-0x107f has been reserved
Feb  8 00:18:03 champagne kernel: [    0.347606] system 00:0e: ioport range=
 0x1100-0x113f has been reserved
Feb  8 00:18:03 champagne kernel: [    0.347608] system 00:0e: ioport range=
 0x1200-0x121f has been reserved
Feb  8 00:18:03 champagne kernel: [    0.347610] system 00:0e: iomem range =
0xf8000000-0xfbffffff has been reserved
Feb  8 00:18:03 champagne kernel: [    0.347612] system 00:0e: iomem range =
0xfec00000-0xfec000ff has been reserved
Feb  8 00:18:03 champagne kernel: [    0.347614] system 00:0e: iomem range =
0xfed20000-0xfed3ffff has been reserved
Feb  8 00:18:03 champagne kernel: [    0.347616] system 00:0e: iomem range =
0xfed45000-0xfed8ffff has been reserved
Feb  8 00:18:03 champagne kernel: [    0.347618] system 00:0e: iomem range =
0xfed90000-0xfed99fff has been reserved
Feb  8 00:18:03 champagne kernel: [    0.347622] system 00:0f: iomem range =
0xcf400-0xcffff has been reserved
Feb  8 00:18:03 champagne kernel: [    0.347625] system 00:0f: iomem range =
0xfeda0000-0xfedbffff has been reserved
Feb  8 00:18:03 champagne kernel: [    0.347627] system 00:0f: iomem range =
0xfee00000-0xfee00fff has been reserved
Feb  8 00:18:03 champagne kernel: [    0.352475] pci 0000:00:01.0: PCI brid=
ge, secondary bus 0000:01
Feb  8 00:18:03 champagne kernel: [    0.352478] pci 0000:00:01.0:   IO win=
dow: 0x4000-0x4fff
Feb  8 00:18:03 champagne kernel: [    0.352481] pci 0000:00:01.0:   MEM wi=
ndow: 0xe4400000-0xe44fffff
Feb  8 00:18:03 champagne kernel: [    0.352484] pci 0000:00:01.0:   PREFET=
CH window: 0x000000d0000000-0x000000dfffffff
Feb  8 00:18:03 champagne kernel: [    0.352488] pci 0000:00:1c.0: PCI brid=
ge, secondary bus 0000:08
Feb  8 00:18:03 champagne kernel: [    0.352489] pci 0000:00:1c.0:   IO win=
dow: disabled
Feb  8 00:18:03 champagne kernel: [    0.352495] pci 0000:00:1c.0:   MEM wi=
ndow: disabled
Feb  8 00:18:03 champagne kernel: [    0.352499] pci 0000:00:1c.0:   PREFET=
CH window: disabled
Feb  8 00:18:03 champagne kernel: [    0.352506] pci 0000:00:1c.1: PCI brid=
ge, secondary bus 0000:10
Feb  8 00:18:03 champagne kernel: [    0.352507] pci 0000:00:1c.1:   IO win=
dow: disabled
Feb  8 00:18:03 champagne kernel: [    0.352513] pci 0000:00:1c.1:   MEM wi=
ndow: 0xe4000000-0xe40fffff
Feb  8 00:18:03 champagne kernel: [    0.352517] pci 0000:00:1c.1:   PREFET=
CH window: disabled
Feb  8 00:18:03 champagne kernel: [    0.352524] pci 0000:00:1c.4: PCI brid=
ge, secondary bus 0000:28
Feb  8 00:18:03 champagne kernel: [    0.352527] pci 0000:00:1c.4:   IO win=
dow: 0x2000-0x3fff
Feb  8 00:18:03 champagne kernel: [    0.352533] pci 0000:00:1c.4:   MEM wi=
ndow: 0xe0000000-0xe3ffffff
Feb  8 00:18:03 champagne kernel: [    0.352537] pci 0000:00:1c.4:   PREFET=
CH window: disabled
Feb  8 00:18:03 champagne kernel: [    0.352547] pci 0000:02:06.0: CardBus =
bridge, secondary bus 0000:03
Feb  8 00:18:03 champagne kernel: [    0.352548] pci 0000:02:06.0:   IO win=
dow: 0x006000-0x0060ff
Feb  8 00:18:03 champagne kernel: [    0.352553] pci 0000:02:06.0:   IO win=
dow: 0x006400-0x0064ff
Feb  8 00:18:03 champagne kernel: [    0.352557] pci 0000:02:06.0:   PREFET=
CH window: 0xc4000000-0xc7ffffff
Feb  8 00:18:03 champagne kernel: [    0.352562] pci 0000:02:06.0:   MEM wi=
ndow: 0xcc000000-0xcfffffff
Feb  8 00:18:03 champagne kernel: [    0.352566] pci 0000:02:06.1: CardBus =
bridge, secondary bus 0000:04
Feb  8 00:18:03 champagne kernel: [    0.352567] pci 0000:02:06.1:   IO win=
dow: 0x006800-0x0068ff
Feb  8 00:18:03 champagne kernel: [    0.352572] pci 0000:02:06.1:   IO win=
dow: 0x006c00-0x006cff
Feb  8 00:18:03 champagne kernel: [    0.352576] pci 0000:02:06.1:   PREFET=
CH window: 0xc8000000-0xcbffffff
Feb  8 00:18:03 champagne kernel: [    0.352580] pci 0000:02:06.1:   MEM wi=
ndow: 0xe8000000-0xebffffff
Feb  8 00:18:03 champagne kernel: [    0.352585] pci 0000:00:1e.0: PCI brid=
ge, secondary bus 0000:02
Feb  8 00:18:03 champagne kernel: [    0.352588] pci 0000:00:1e.0:   IO win=
dow: 0x6000-0x6fff
Feb  8 00:18:03 champagne kernel: [    0.352593] pci 0000:00:1e.0:   MEM wi=
ndow: 0xe4100000-0xe43fffff
Feb  8 00:18:03 champagne kernel: [    0.352598] pci 0000:00:1e.0:   PREFET=
CH window: 0x000000c4000000-0x000000cbffffff
Feb  8 00:18:03 champagne kernel: [    0.352610] pci 0000:00:01.0: PCI INT =
A -> GSI 16 (level, low) -> IRQ 16
Feb  8 00:18:03 champagne kernel: [    0.352614] pci 0000:00:01.0: setting =
latency timer to 64
Feb  8 00:18:03 champagne kernel: [    0.352621] pci 0000:00:1c.0: PCI INT =
A -> GSI 16 (level, low) -> IRQ 16
Feb  8 00:18:03 champagne kernel: [    0.352625] pci 0000:00:1c.0: setting =
latency timer to 64
Feb  8 00:18:03 champagne kernel: [    0.352633] pci 0000:00:1c.1: PCI INT =
B -> GSI 17 (level, low) -> IRQ 17
Feb  8 00:18:03 champagne kernel: [    0.352638] pci 0000:00:1c.1: setting =
latency timer to 64
Feb  8 00:18:03 champagne kernel: [    0.352646] pci 0000:00:1c.4: PCI INT =
A -> GSI 16 (level, low) -> IRQ 16
Feb  8 00:18:03 champagne kernel: [    0.352650] pci 0000:00:1c.4: setting =
latency timer to 64
Feb  8 00:18:03 champagne kernel: [    0.352657] pci 0000:00:1e.0: setting =
latency timer to 64
Feb  8 00:18:03 champagne kernel: [    0.352665] pci 0000:02:06.0: PCI INT =
A -> GSI 16 (level, low) -> IRQ 16
Feb  8 00:18:03 champagne kernel: [    0.352675] pci 0000:02:06.1: PCI INT =
B -> GSI 17 (level, low) -> IRQ 17
Feb  8 00:18:03 champagne kernel: [    0.352680] bus: 00 index 0 io port: [=
0x00-0xffff]
Feb  8 00:18:03 champagne kernel: [    0.352682] bus: 00 index 1 mmio: [0x0=
00000-0xffffffffffffffff]
Feb  8 00:18:03 champagne kernel: [    0.352684] bus: 01 index 0 io port: [=
0x4000-0x4fff]
Feb  8 00:18:03 champagne kernel: [    0.352685] bus: 01 index 1 mmio: [0xe=
4400000-0xe44fffff]
Feb  8 00:18:03 champagne kernel: [    0.352687] bus: 01 index 2 mmio: [0xd=
0000000-0xdfffffff]
Feb  8 00:18:03 champagne kernel: [    0.352688] bus: 01 index 3 mmio: [0x0=
-0x0]
Feb  8 00:18:03 champagne kernel: [    0.352690] bus: 08 index 0 mmio: [0x0=
-0x0]
Feb  8 00:18:03 champagne kernel: [    0.352691] bus: 08 index 1 mmio: [0x0=
-0x0]
Feb  8 00:18:03 champagne kernel: [    0.352692] bus: 08 index 2 mmio: [0x0=
-0x0]
Feb  8 00:18:03 champagne kernel: [    0.352694] bus: 08 index 3 mmio: [0x0=
-0x0]
Feb  8 00:18:03 champagne kernel: [    0.352695] bus: 10 index 0 mmio: [0x0=
-0x0]
Feb  8 00:18:03 champagne kernel: [    0.352696] bus: 10 index 1 mmio: [0xe=
4000000-0xe40fffff]
Feb  8 00:18:03 champagne kernel: [    0.352698] bus: 10 index 2 mmio: [0x0=
-0x0]
Feb  8 00:18:03 champagne kernel: [    0.352699] bus: 10 index 3 mmio: [0x0=
-0x0]
Feb  8 00:18:03 champagne kernel: [    0.352701] bus: 28 index 0 io port: [=
0x2000-0x3fff]
Feb  8 00:18:03 champagne kernel: [    0.352702] bus: 28 index 1 mmio: [0xe=
0000000-0xe3ffffff]
Feb  8 00:18:03 champagne kernel: [    0.352704] bus: 28 index 2 mmio: [0x0=
-0x0]
Feb  8 00:18:03 champagne kernel: [    0.352705] bus: 28 index 3 mmio: [0x0=
-0x0]
Feb  8 00:18:03 champagne kernel: [    0.352706] bus: 02 index 0 io port: [=
0x6000-0x6fff]
Feb  8 00:18:03 champagne kernel: [    0.352708] bus: 02 index 1 mmio: [0xe=
4100000-0xe43fffff]
Feb  8 00:18:03 champagne kernel: [    0.352710] bus: 02 index 2 mmio: [0xc=
4000000-0xcbffffff]
Feb  8 00:18:03 champagne kernel: [    0.352711] bus: 02 index 3 io port: [=
0x00-0xffff]
Feb  8 00:18:03 champagne kernel: [    0.352713] bus: 02 index 4 mmio: [0x0=
00000-0xffffffffffffffff]
Feb  8 00:18:03 champagne kernel: [    0.352714] bus: 03 index 0 io port: [=
0x6000-0x60ff]
Feb  8 00:18:03 champagne kernel: [    0.352716] bus: 03 index 1 io port: [=
0x6400-0x64ff]
Feb  8 00:18:03 champagne kernel: [    0.352717] bus: 03 index 2 mmio: [0xc=
4000000-0xc7ffffff]
Feb  8 00:18:03 champagne kernel: [    0.352719] bus: 03 index 3 mmio: [0xc=
c000000-0xcfffffff]
Feb  8 00:18:03 champagne kernel: [    0.352721] bus: 04 index 0 io port: [=
0x6800-0x68ff]
Feb  8 00:18:03 champagne kernel: [    0.352722] bus: 04 index 1 io port: [=
0x6c00-0x6cff]
Feb  8 00:18:03 champagne kernel: [    0.352724] bus: 04 index 2 mmio: [0xc=
8000000-0xcbffffff]
Feb  8 00:18:03 champagne kernel: [    0.352725] bus: 04 index 3 mmio: [0xe=
8000000-0xebffffff]
Feb  8 00:18:03 champagne kernel: [    0.352733] NET: Registered protocol f=
amily 2
Feb  8 00:18:03 champagne kernel: [    0.392036] IP route cache hash table =
entries: 131072 (order: 8, 1048576 bytes)
Feb  8 00:18:03 champagne kernel: [    0.392452] TCP established hash table=
 entries: 262144 (order: 10, 4194304 bytes)
Feb  8 00:18:03 champagne kernel: [    0.394248] TCP bind hash table entrie=
s: 65536 (order: 8, 1048576 bytes)
Feb  8 00:18:03 champagne kernel: [    0.394874] TCP: Hash tables configure=
d (established 262144 bind 65536)
Feb  8 00:18:03 champagne kernel: [    0.394876] TCP reno registered
Feb  8 00:18:03 champagne kernel: [    0.404086] NET: Registered protocol f=
amily 1
Feb  8 00:18:03 champagne kernel: [    0.404184] checking if image is initr=
amfs...<7>Switched to high resolution mode on CPU 1
Feb  8 00:18:03 champagne kernel: [    0.503998] Switched to high resolutio=
n mode on CPU 0
Feb  8 00:18:03 champagne kernel: [    0.604736]  it is
Feb  8 00:18:03 champagne kernel: [    0.818237] Freeing initrd memory: 604=
4k freed
Feb  8 00:18:03 champagne kernel: [    0.821390] alg: cipher: Test 1 failed=
 on encryption for aes-asm
Feb  8 00:18:03 champagne kernel: [    0.821457] 00000000: 00 01 02 03 04 0=
5 06 07 08 08 08 08 08 08 08 08=20
Feb  8 00:18:03 champagne kernel: [    0.821624] audit: initializing netlin=
k socket (disabled)
Feb  8 00:18:03 champagne kernel: [    0.821642] type=3D2000 audit(12340486=
56.821:1): initialized
Feb  8 00:18:03 champagne kernel: [    0.821991] HugeTLB registered 2 MB pa=
ge size, pre-allocated 0 pages
Feb  8 00:18:03 champagne kernel: [    0.823719] msgmni has been set to 767=
3
Feb  8 00:18:03 champagne kernel: [    0.823917] alg: No test for stdrng (k=
rng)
Feb  8 00:18:03 champagne kernel: [    0.823989] Block layer SCSI generic (=
bsg) driver version 0.4 loaded (major 254)
Feb  8 00:18:03 champagne kernel: [    0.823992] io scheduler noop register=
ed
Feb  8 00:18:03 champagne kernel: [    0.824038] io scheduler cfq registere=
d (default)
Feb  8 00:18:03 champagne kernel: [    0.824181] pci 0000:01:00.0: Boot vid=
eo device
Feb  8 00:18:03 champagne kernel: [    0.832038] pcieport-driver 0000:00:01=
.0: setting latency timer to 64
Feb  8 00:18:03 champagne kernel: [    0.832066] pcieport-driver 0000:00:01=
.0: found MSI capability
Feb  8 00:18:03 champagne kernel: [    0.832087] pcieport-driver 0000:00:01=
.0: irq 511 for MSI/MSI-X
Feb  8 00:18:03 champagne kernel: [    0.832094] pci_express 0000:00:01.0:p=
cie00: allocate port service
Feb  8 00:18:03 champagne kernel: [    0.832124] pci_express 0000:00:01.0:p=
cie03: allocate port service
Feb  8 00:18:03 champagne kernel: [    0.832185] pcieport-driver 0000:00:1c=
.0: setting latency timer to 64
Feb  8 00:18:03 champagne kernel: [    0.832229] pcieport-driver 0000:00:1c=
.0: found MSI capability
Feb  8 00:18:03 champagne kernel: [    0.832260] pcieport-driver 0000:00:1c=
.0: irq 510 for MSI/MSI-X
Feb  8 00:18:03 champagne kernel: [    0.832274] pci_express 0000:00:1c.0:p=
cie00: allocate port service
Feb  8 00:18:03 champagne kernel: [    0.832301] pci_express 0000:00:1c.0:p=
cie03: allocate port service
Feb  8 00:18:03 champagne kernel: [    0.832387] pcieport-driver 0000:00:1c=
.1: setting latency timer to 64
Feb  8 00:18:03 champagne kernel: [    0.832431] pcieport-driver 0000:00:1c=
.1: found MSI capability
Feb  8 00:18:03 champagne kernel: [    0.832462] pcieport-driver 0000:00:1c=
.1: irq 509 for MSI/MSI-X
Feb  8 00:18:03 champagne kernel: [    0.832477] pci_express 0000:00:1c.1:p=
cie00: allocate port service
Feb  8 00:18:03 champagne kernel: [    0.832510] pci_express 0000:00:1c.1:p=
cie02: allocate port service
Feb  8 00:18:03 champagne kernel: [    0.832542] pci_express 0000:00:1c.1:p=
cie03: allocate port service
Feb  8 00:18:03 champagne kernel: [    0.832630] pcieport-driver 0000:00:1c=
.4: setting latency timer to 64
Feb  8 00:18:03 champagne kernel: [    0.832676] pcieport-driver 0000:00:1c=
.4: found MSI capability
Feb  8 00:18:03 champagne kernel: [    0.832706] pcieport-driver 0000:00:1c=
.4: irq 508 for MSI/MSI-X
Feb  8 00:18:03 champagne kernel: [    0.832721] pci_express 0000:00:1c.4:p=
cie00: allocate port service
Feb  8 00:18:03 champagne kernel: [    0.832748] pci_express 0000:00:1c.4:p=
cie02: allocate port service
Feb  8 00:18:03 champagne kernel: [    0.832774] pci_express 0000:00:1c.4:p=
cie03: allocate port service
Feb  8 00:18:03 champagne kernel: [    0.851823] Linux agpgart interface v0=
.103
Feb  8 00:18:03 champagne kernel: [    0.851826] Serial: 8250/16550 driver4=
 ports, IRQ sharing enabled
Feb  8 00:18:03 champagne kernel: [    0.851966] serial8250: ttyS0 at I/O 0=
x3f8 (irq =3D 4) is a 16550A
Feb  8 00:18:03 champagne kernel: [    0.852655] 00:02: ttyS0 at I/O 0x3f8 =
(irq =3D 4) is a 16550A
Feb  8 00:18:03 champagne kernel: [    0.852861] serial 0000:00:03.3: PCI I=
NT B -> GSI 17 (level, low) -> IRQ 17
Feb  8 00:18:03 champagne kernel: [    0.852964] 0000:00:03.3: ttyS1 at I/O=
 0x5030 (irq =3D 17) is a 16550A
Feb  8 00:18:03 champagne kernel: [    0.854335] brd: module loaded
Feb  8 00:18:03 champagne kernel: [    0.854412] PNP: PS/2 Controller [PNP0=
303:C251,PNP0f13:C252] at 0x60,0x64 irq 1,12
Feb  8 00:18:03 champagne kernel: [    0.856244] i8042.c: Detected active m=
ultiplexing controller, rev 1.1.
Feb  8 00:18:03 champagne kernel: [    0.856997] serio: i8042 KBD port at 0=
x60,0x64 irq 1
Feb  8 00:18:03 champagne kernel: [    0.857002] serio: i8042 AUX0 port at =
0x60,0x64 irq 12
Feb  8 00:18:03 champagne kernel: [    0.857004] serio: i8042 AUX1 port at =
0x60,0x64 irq 12
Feb  8 00:18:03 champagne kernel: [    0.857006] serio: i8042 AUX2 port at =
0x60,0x64 irq 12
Feb  8 00:18:03 champagne kernel: [    0.857008] serio: i8042 AUX3 port at =
0x60,0x64 irq 12
Feb  8 00:18:03 champagne kernel: [    0.857115] mice: PS/2 mouse device co=
mmon for all mice
Feb  8 00:18:03 champagne kernel: [    0.857154] cpuidle: using governor la=
dder
Feb  8 00:18:03 champagne kernel: [    0.857156] cpuidle: using governor me=
nu
Feb  8 00:18:03 champagne kernel: [    0.857394] TCP cubic registered
Feb  8 00:18:03 champagne kernel: [    0.857695] Freeing unused kernel memo=
ry: 316k freed
Feb  8 00:18:03 champagne kernel: [    0.857830] Write protecting the kerne=
l read-only data: 2772k
Feb  8 00:18:03 champagne kernel: [    0.933046] fuse init (API version 7.1=
0)
Feb  8 00:18:03 champagne kernel: [    0.937518] fan PNP0C0B:00: registered=
 as cooling_device0
Feb  8 00:18:03 champagne kernel: [    0.937523] ACPI: Fan [C36B] (off)
Feb  8 00:18:03 champagne kernel: [    0.937750] fan PNP0C0B:01: registered=
 as cooling_device1
Feb  8 00:18:03 champagne kernel: [    0.937755] ACPI: Fan [C36C] (off)
Feb  8 00:18:03 champagne kernel: [    0.937982] fan PNP0C0B:02: registered=
 as cooling_device2
Feb  8 00:18:03 champagne kernel: [    0.937986] ACPI: Fan [C36D] (off)
Feb  8 00:18:03 champagne kernel: [    0.938210] fan PNP0C0B:03: registered=
 as cooling_device3
Feb  8 00:18:03 champagne kernel: [    0.938214] ACPI: Fan [C36E] (off)
Feb  8 00:18:03 champagne kernel: [    0.938438] fan PNP0C0B:04: registered=
 as cooling_device4
Feb  8 00:18:03 champagne kernel: [    0.938443] ACPI: Fan [C36F] (off)
Feb  8 00:18:03 champagne kernel: [    0.938554] fan PNP0C0B:05: registered=
 as cooling_device5
Feb  8 00:18:03 champagne kernel: [    0.938559] ACPI: Fan [C370] (off)
Feb  8 00:18:03 champagne kernel: [    0.938786] fan PNP0C0B:06: registered=
 as cooling_device6
Feb  8 00:18:03 champagne kernel: [    0.938791] ACPI: Fan [C388] (off)
Feb  8 00:18:03 champagne kernel: [    0.939015] fan PNP0C0B:07: registered=
 as cooling_device7
Feb  8 00:18:03 champagne kernel: [    0.939020] ACPI: Fan [C389] (off)
Feb  8 00:18:03 champagne kernel: [    0.939244] fan PNP0C0B:08: registered=
 as cooling_device8
Feb  8 00:18:03 champagne kernel: [    0.939249] ACPI: Fan [C38A] (off)
Feb  8 00:18:03 champagne kernel: [    0.939474] fan PNP0C0B:09: registered=
 as cooling_device9
Feb  8 00:18:03 champagne kernel: [    0.939479] ACPI: Fan [C38B] (off)
Feb  8 00:18:03 champagne kernel: [    0.939705] fan PNP0C0B:0a: registered=
 as cooling_device10
Feb  8 00:18:03 champagne kernel: [    0.939710] ACPI: Fan [C38C] (off)
Feb  8 00:18:03 champagne kernel: [    0.943810] ACPI: SSDT BFFDB95D, 02C1 =
(r1 HP      Cpu0Ist     3000 INTL 20060317)
Feb  8 00:18:03 champagne kernel: [    0.944244] ACPI: SSDT BFFDBCA3, 05FA =
(r1 HP      Cpu0Cst     3001 INTL 20060317)
Feb  8 00:18:03 champagne kernel: [    0.946858] Monitor-Mwait will be used=
 to enter C-1 state
Feb  8 00:18:03 champagne kernel: [    0.946861] Monitor-Mwait will be used=
 to enter C-2 state
Feb  8 00:18:03 champagne kernel: [    0.946969] ACPI: CPU0 (power states: =
C1[C1] C2[C2])
Feb  8 00:18:03 champagne kernel: [    0.947000] processor ACPI_CPU:00: reg=
istered as cooling_device11
Feb  8 00:18:03 champagne kernel: [    0.947003] ACPI: Processor [CPU0] (su=
pports 8 throttling states)
Feb  8 00:18:03 champagne kernel: [    0.947321] ACPI: SSDT BFFDB895, 00C8 =
(r1 HP      Cpu1Ist     3000 INTL 20060317)
Feb  8 00:18:03 champagne kernel: [    0.947629] ACPI: SSDT BFFDBC1E, 0085 =
(r1 HP      Cpu1Cst     3000 INTL 20060317)
Feb  8 00:18:03 champagne kernel: [    0.948569] ACPI: CPU1 (power states: =
C1[C1] C2[C2])
Feb  8 00:18:03 champagne kernel: [    0.948598] processor ACPI_CPU:01: reg=
istered as cooling_device12
Feb  8 00:18:03 champagne kernel: [    0.948601] ACPI: Processor [CPU1] (su=
pports 8 throttling states)
Feb  8 00:18:03 champagne kernel: [    0.954521] thermal LNXTHERM:01: regis=
tered as thermal_zone0
Feb  8 00:18:03 champagne kernel: [    0.957738] Marking TSC unstable due t=
o TSC halts in idle
Feb  8 00:18:03 champagne kernel: [    0.972067] ACPI: Thermal Zone [TZ2] (=
65 C)
Feb  8 00:18:03 champagne kernel: [    0.975283] thermal LNXTHERM:02: regis=
tered as thermal_zone1
Feb  8 00:18:03 champagne kernel: [    0.976949] ACPI: Thermal Zone [TZ3] (=
62 C)
Feb  8 00:18:03 champagne kernel: [    0.984240] thermal LNXTHERM:03: regis=
tered as thermal_zone2
Feb  8 00:18:03 champagne kernel: [    0.996271] ACPI: Thermal Zone [TZ4] (=
35 C)
Feb  8 00:18:03 champagne kernel: [    0.999051] thermal LNXTHERM:04: regis=
tered as thermal_zone3
Feb  8 00:18:03 champagne kernel: [    1.005024] ACPI: Thermal Zone [TZ5] (=
97 C)
Feb  8 00:18:03 champagne kernel: [    1.023077] thermal LNXTHERM:05: regis=
tered as thermal_zone4
Feb  8 00:18:03 champagne kernel: [    1.040223] ACPI: Thermal Zone [TZ0] (=
70 C)
Feb  8 00:18:03 champagne kernel: [    1.043282] thermal LNXTHERM:06: regis=
tered as thermal_zone5
Feb  8 00:18:03 champagne kernel: [    1.045127] ACPI: Thermal Zone [TZ1] (=
83 C)
Feb  8 00:18:03 champagne kernel: [    1.051545] device-mapper: uevent: ver=
sion 1.0.3
Feb  8 00:18:03 champagne kernel: [    1.051675] device-mapper: ioctl: 4.14=
.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
Feb  8 00:18:03 champagne kernel: [    1.394349] input: AT Translated Set 2=
 keyboard as /class/input/input0
Feb  8 00:18:03 champagne kernel: [    1.428927] e1000e: Intel(R) PRO/1000 =
Network Driver - 0.3.3.3-k6
Feb  8 00:18:03 champagne kernel: [    1.428929] e1000e: Copyright (c) 1999=
-2008 Intel Corporation.
Feb  8 00:18:03 champagne kernel: [    1.428973] e1000e 0000:00:19.0: PCI I=
NT A -> GSI 22 (level, low) -> IRQ 22
Feb  8 00:18:03 champagne kernel: [    1.428981] e1000e 0000:00:19.0: setti=
ng latency timer to 64
Feb  8 00:18:03 champagne kernel: [    1.429115] e1000e 0000:00:19.0: irq 5=
07 for MSI/MSI-X
Feb  8 00:18:03 champagne kernel: [    1.440217] usbcore: registered new in=
terface driver usbfs
Feb  8 00:18:03 champagne kernel: [    1.440241] usbcore: registered new in=
terface driver hub
Feb  8 00:18:03 champagne kernel: [    1.440263] usbcore: registered new de=
vice driver usb
Feb  8 00:18:03 champagne kernel: [    1.441226] uhci_hcd: USB Universal Ho=
st Controller Interface driver
Feb  8 00:18:03 champagne kernel: [    1.446093] ehci_hcd: USB 2.0 'Enhance=
d' Host Controller (EHCI) Driver
Feb  8 00:18:03 champagne kernel: [    1.446096] Warning! ehci_hcd should a=
lways be loaded before uhci_hcd and ohci_hcd, not after
Feb  8 00:18:03 champagne kernel: [    1.483508] SCSI subsystem initialized
Feb  8 00:18:03 champagne kernel: [    1.484809] ohci1394 0000:02:06.2: PCI=
 INT C -> GSI 18 (level, low) -> IRQ 18
Feb  8 00:18:03 champagne kernel: [    1.498687] libata version 3.00 loaded=
.
Feb  8 00:18:03 champagne kernel: [    1.537570] ohci1394: fw-host0: OHCI-1=
394 1.1 (PCI): IRQ=3D[18]  MMIO=3D[e4102000-e41027ff]  Max Packet=3D[2048] =
 IR/IT contexts=3D[4/4]
Feb  8 00:18:03 champagne kernel: [    1.642409] 0000:00:19.0: eth0: (PCI E=
xpress:2.5GB/s:Width x1) 00:1a:4b:7a:9d:98
Feb  8 00:18:03 champagne kernel: [    1.642411] 0000:00:19.0: eth0: Intel(=
R) PRO/1000 Network Connection
Feb  8 00:18:03 champagne kernel: [    1.642440] 0000:00:19.0: eth0: MAC: 5=
, PHY: 6, PBA No: ffffff-0ff
Feb  8 00:18:03 champagne kernel: [    1.642558] uhci_hcd 0000:00:1a.0: PCI=
 INT A -> GSI 16 (level, low) -> IRQ 16
Feb  8 00:18:03 champagne kernel: [    1.642568] uhci_hcd 0000:00:1a.0: set=
ting latency timer to 64
Feb  8 00:18:03 champagne kernel: [    1.642571] uhci_hcd 0000:00:1a.0: UHC=
I Host Controller
Feb  8 00:18:03 champagne kernel: [    1.642602] uhci_hcd 0000:00:1a.0: new=
 USB bus registered, assigned bus number 1
Feb  8 00:18:03 champagne kernel: [    1.642639] uhci_hcd 0000:00:1a.0: irq=
 16, io base 0x00005060
Feb  8 00:18:03 champagne kernel: [    1.642775] usb usb1: configuration #1=
 chosen from 1 choice
Feb  8 00:18:03 champagne kernel: [    1.642799] hub 1-0:1.0: USB hub found
Feb  8 00:18:03 champagne kernel: [    1.642805] hub 1-0:1.0: 2 ports detec=
ted
Feb  8 00:18:03 champagne kernel: [    1.642950] ehci_hcd 0000:00:1a.7: PCI=
 INT C -> GSI 18 (level, low) -> IRQ 18
Feb  8 00:18:03 champagne kernel: [    1.642976] ehci_hcd 0000:00:1a.7: set=
ting latency timer to 64
Feb  8 00:18:03 champagne kernel: [    1.642980] ehci_hcd 0000:00:1a.7: EHC=
I Host Controller
Feb  8 00:18:03 champagne kernel: [    1.643001] ehci_hcd 0000:00:1a.7: new=
 USB bus registered, assigned bus number 2
Feb  8 00:18:03 champagne kernel: [    1.646895] ehci_hcd 0000:00:1a.7: deb=
ug port 1
Feb  8 00:18:03 champagne kernel: [    1.646901] ehci_hcd 0000:00:1a.7: cac=
he line size of 32 is not supported
Feb  8 00:18:03 champagne kernel: [    1.646905] ehci_hcd 0000:00:1a.7: irq=
 18, io mem 0xe4541000
Feb  8 00:18:03 champagne kernel: [    1.664055] ehci_hcd 0000:00:1a.7: USB=
 2.0 started, EHCI 1.00
Feb  8 00:18:03 champagne kernel: [    1.664129] usb usb2: configuration #1=
 chosen from 1 choice
Feb  8 00:18:03 champagne kernel: [    1.664155] hub 2-0:1.0: USB hub found
Feb  8 00:18:03 champagne kernel: [    1.664160] hub 2-0:1.0: 4 ports detec=
ted
Feb  8 00:18:03 champagne kernel: [    1.664260] ata_piix 0000:00:1f.1: ver=
sion 2.12
Feb  8 00:18:03 champagne kernel: [    1.664268] ata_piix 0000:00:1f.1: PCI=
 INT A -> GSI 16 (level, low) -> IRQ 16
Feb  8 00:18:03 champagne kernel: [    1.664303] ata_piix 0000:00:1f.1: set=
ting latency timer to 64
Feb  8 00:18:03 champagne kernel: [    1.664735] scsi0 : ata_piix
Feb  8 00:18:03 champagne kernel: [    1.664909] scsi1 : ata_piix
Feb  8 00:18:03 champagne kernel: [    1.665494] ata1: PATA max UDMA/100 cm=
d 0x1f0 ctl 0x3f6 bmdma 0x5100 irq 14
Feb  8 00:18:03 champagne kernel: [    1.665496] ata2: PATA max UDMA/100 cm=
d 0x170 ctl 0x376 bmdma 0x5108 irq 15
Feb  8 00:18:03 champagne kernel: [    1.828517] ata1.00: ATAPI: MATSHITADV=
D-RAM UJ-860H, 1.02, max MWDMA2
Feb  8 00:18:03 champagne kernel: [    1.844379] ata1.00: configured for MW=
DMA2
Feb  8 00:18:03 champagne kernel: [    1.844931] ata2: port disabled. ignor=
ing.
Feb  8 00:18:03 champagne kernel: [    1.847089] scsi 0:0:0:0: CD-ROM      =
      MATSHITA DVD-RAM UJ-860H  1.02 PQ: 0 ANSI: 5
Feb  8 00:18:03 champagne kernel: [    1.847410] ahci 0000:00:1f.2: version=
 3.0
Feb  8 00:18:03 champagne kernel: [    1.847423] ahci 0000:00:1f.2: PCI INT=
 D -> GSI 21 (level, low) -> IRQ 21
Feb  8 00:18:03 champagne kernel: [    1.847465] ahci 0000:00:1f.2: irq 506=
 for MSI/MSI-X
Feb  8 00:18:03 champagne kernel: [    1.847519] ahci 0000:00:1f.2: AHCI 00=
01.0100 32 slots 3 ports 3 Gbps 0x1 impl SATA mode
Feb  8 00:18:03 champagne kernel: [    1.847522] ahci 0000:00:1f.2: flags: =
64bit ncq sntf stag pm led clo pio slum part=20
Feb  8 00:18:03 champagne kernel: [    1.847527] ahci 0000:00:1f.2: setting=
 latency timer to 64
Feb  8 00:18:03 champagne kernel: [    1.851289] Driver 'sr' needs updating=
 - please use bus_type methods
Feb  8 00:18:03 champagne kernel: [    1.851480] scsi2 : ahci
Feb  8 00:18:03 champagne kernel: [    1.851983] scsi3 : ahci
Feb  8 00:18:03 champagne kernel: [    1.852375] scsi4 : ahci
Feb  8 00:18:03 champagne kernel: [    1.852424] ata3: SATA max UDMA/133 ab=
ar m2048@0xe4549000 port 0xe4549100 irq 506
Feb  8 00:18:03 champagne kernel: [    1.852426] ata4: DUMMY
Feb  8 00:18:03 champagne kernel: [    1.852427] ata5: DUMMY
Feb  8 00:18:03 champagne kernel: [    1.855902] sr0: scsi3-mmc drive: 24x/=
24x writer dvd-ram cd/rw xa/form2 cdda tray
Feb  8 00:18:03 champagne kernel: [    1.855905] Uniform CD-ROM driver Revi=
sion: 3.20
Feb  8 00:18:03 champagne kernel: [    1.855971] sr 0:0:0:0: Attached scsi =
CD-ROM sr0
Feb  8 00:18:03 champagne kernel: [    1.859522] sr 0:0:0:0: Attached scsi =
generic sg0 type 5
Feb  8 00:18:03 champagne kernel: [    2.000068] Clocksource tsc unstable (=
delta =3D -397200589 ns)
Feb  8 00:18:03 champagne kernel: [    2.084074] usb 2-2: new high speed US=
B device using ehci_hcd and address 3
Feb  8 00:18:03 champagne kernel: [    2.172091] ata3: SATA link up 1.5 Gbp=
s (SStatus 113 SControl 300)
Feb  8 00:18:03 champagne kernel: [    2.174437] ata3.00: ACPI cmd f5/00:00=
:00:00:00:a0 filtered out
Feb  8 00:18:03 champagne kernel: [    2.174439] ata3.00: ACPI cmd b1/c1:00=
:00:00:00:a0 filtered out
Feb  8 00:18:03 champagne kernel: [    2.174644] ata3.00: ACPI cmd c6/00:10=
:00:00:00:a0 succeeded
Feb  8 00:18:03 champagne kernel: [    2.174646] ata3.00: ACPI cmd ef/10:03=
:00:00:00:a0 filtered out
Feb  8 00:18:03 champagne kernel: [    2.175397] ata3.00: ATA-8: Hitachi HT=
S722012K9SA00, DCCOC60A, max UDMA/100
Feb  8 00:18:03 champagne kernel: [    2.175399] ata3.00: 234441648 sectors=
, multi 16: LBA48=20
Feb  8 00:18:03 champagne kernel: [    2.177906] ata3.00: ACPI cmd f5/00:00=
:00:00:00:a0 filtered out
Feb  8 00:18:03 champagne kernel: [    2.177908] ata3.00: ACPI cmd b1/c1:00=
:00:00:00:a0 filtered out
Feb  8 00:18:03 champagne kernel: [    2.178146] ata3.00: ACPI cmd c6/00:10=
:00:00:00:a0 succeeded
Feb  8 00:18:03 champagne kernel: [    2.178148] ata3.00: ACPI cmd ef/10:03=
:00:00:00:a0 filtered out
Feb  8 00:18:03 champagne kernel: [    2.178894] ata3.00: configured for UD=
MA/100
Feb  8 00:18:03 champagne kernel: [    2.193817] ata3.00: configured for UD=
MA/100
Feb  8 00:18:03 champagne kernel: [    2.193819] ata3: EH complete
Feb  8 00:18:03 champagne kernel: [    2.193976] scsi 2:0:0:0: Direct-Acces=
s     ATA      Hitachi HTS72201 DCCO PQ: 0 ANSI: 5
Feb  8 00:18:03 champagne kernel: [    2.194077] scsi 2:0:0:0: Attached scs=
i generic sg1 type 0
Feb  8 00:18:03 champagne kernel: [    2.194149] uhci_hcd 0000:00:1a.1: PCI=
 INT B -> GSI 17 (level, low) -> IRQ 17
Feb  8 00:18:03 champagne kernel: [    2.194159] uhci_hcd 0000:00:1a.1: set=
ting latency timer to 64
Feb  8 00:18:03 champagne kernel: [    2.194163] uhci_hcd 0000:00:1a.1: UHC=
I Host Controller
Feb  8 00:18:03 champagne kernel: [    2.194186] uhci_hcd 0000:00:1a.1: new=
 USB bus registered, assigned bus number 3
Feb  8 00:18:03 champagne kernel: [    2.194221] uhci_hcd 0000:00:1a.1: irq=
 17, io base 0x00005080
Feb  8 00:18:03 champagne kernel: [    2.194296] usb usb3: configuration #1=
 chosen from 1 choice
Feb  8 00:18:03 champagne kernel: [    2.194320] hub 3-0:1.0: USB hub found
Feb  8 00:18:03 champagne kernel: [    2.194325] hub 3-0:1.0: 2 ports detec=
ted
Feb  8 00:18:03 champagne kernel: [    2.194576] ehci_hcd 0000:00:1d.7: PCI=
 INT A -> GSI 20 (level, low) -> IRQ 20
Feb  8 00:18:03 champagne kernel: [    2.194624] ehci_hcd 0000:00:1d.7: set=
ting latency timer to 64
Feb  8 00:18:03 champagne kernel: [    2.194627] ehci_hcd 0000:00:1d.7: EHC=
I Host Controller
Feb  8 00:18:03 champagne kernel: [    2.194647] ehci_hcd 0000:00:1d.7: new=
 USB bus registered, assigned bus number 4
Feb  8 00:18:03 champagne kernel: [    2.198553] ehci_hcd 0000:00:1d.7: deb=
ug port 1
Feb  8 00:18:03 champagne kernel: [    2.198560] ehci_hcd 0000:00:1d.7: cac=
he line size of 32 is not supported
Feb  8 00:18:03 champagne kernel: [    2.198575] ehci_hcd 0000:00:1d.7: irq=
 20, io mem 0xe4548000
Feb  8 00:18:03 champagne kernel: [    2.201546] Driver 'sd' needs updating=
 - please use bus_type methods
Feb  8 00:18:03 champagne kernel: [    2.201608] sd 2:0:0:0: [sda] 23444164=
8 512-byte hardware sectors: (120 GB/111 GiB)
Feb  8 00:18:03 champagne kernel: [    2.201620] sd 2:0:0:0: [sda] Write Pr=
otect is off
Feb  8 00:18:03 champagne kernel: [    2.201622] sd 2:0:0:0: [sda] Mode Sen=
se: 00 3a 00 00
Feb  8 00:18:03 champagne kernel: [    2.201640] sd 2:0:0:0: [sda] Write ca=
che: disabled, read cache: enabled, doesn't support DPO or FUA
Feb  8 00:18:03 champagne kernel: [    2.201683] sd 2:0:0:0: [sda] 23444164=
8 512-byte hardware sectors: (120 GB/111 GiB)
Feb  8 00:18:03 champagne kernel: [    2.201694] sd 2:0:0:0: [sda] Write Pr=
otect is off
Feb  8 00:18:03 champagne kernel: [    2.201696] sd 2:0:0:0: [sda] Mode Sen=
se: 00 3a 00 00
Feb  8 00:18:03 champagne kernel: [    2.201714] sd 2:0:0:0: [sda] Write ca=
che: disabled, read cache: enabled, doesn't support DPO or FUA
Feb  8 00:18:03 champagne kernel: [    2.201716]  sda:<6>ehci_hcd 0000:00:1=
d.7: USB 2.0 started, EHCI 1.00
Feb  8 00:18:03 champagne kernel: [    2.216129] usb usb4: configuration #1=
 chosen from 1 choice
Feb  8 00:18:03 champagne kernel: [    2.216157] hub 4-0:1.0: USB hub found
Feb  8 00:18:03 champagne kernel: [    2.216167] hub 4-0:1.0: 6 ports detec=
ted
Feb  8 00:18:03 champagne kernel: [    2.216287] uhci_hcd 0000:00:1d.0: PCI=
 INT A -> GSI 20 (level, low) -> IRQ 20
Feb  8 00:18:03 champagne kernel: [    2.216295] uhci_hcd 0000:00:1d.0: set=
ting latency timer to 64
Feb  8 00:18:03 champagne kernel: [    2.216298] uhci_hcd 0000:00:1d.0: UHC=
I Host Controller
Feb  8 00:18:03 champagne kernel: [    2.216317] uhci_hcd 0000:00:1d.0: new=
 USB bus registered, assigned bus number 5
Feb  8 00:18:03 champagne kernel: [    2.216344] uhci_hcd 0000:00:1d.0: irq=
 20, io base 0x000050a0
Feb  8 00:18:03 champagne kernel: [    2.216416] usb usb5: configuration #1=
 chosen from 1 choice
Feb  8 00:18:03 champagne kernel: [    2.216436] hub 5-0:1.0: USB hub found
Feb  8 00:18:03 champagne kernel: [    2.216442] hub 5-0:1.0: 2 ports detec=
ted
Feb  8 00:18:03 champagne kernel: [    2.216536] uhci_hcd 0000:00:1d.1: PCI=
 INT B -> GSI 22 (level, low) -> IRQ 22
Feb  8 00:18:03 champagne kernel: [    2.216542] uhci_hcd 0000:00:1d.1: set=
ting latency timer to 64
Feb  8 00:18:03 champagne kernel: [    2.216545] uhci_hcd 0000:00:1d.1: UHC=
I Host Controller
Feb  8 00:18:03 champagne kernel: [    2.216570] uhci_hcd 0000:00:1d.1: new=
 USB bus registered, assigned bus number 6
Feb  8 00:18:03 champagne kernel: [    2.216602] uhci_hcd 0000:00:1d.1: irq=
 22, io base 0x000050c0
Feb  8 00:18:03 champagne kernel: [    2.216661] usb usb6: configuration #1=
 chosen from 1 choice
Feb  8 00:18:03 champagne kernel: [    2.216683] hub 6-0:1.0: USB hub found
Feb  8 00:18:03 champagne kernel: [    2.216687] hub 6-0:1.0: 2 ports detec=
ted
Feb  8 00:18:03 champagne kernel: [    2.216780] uhci_hcd 0000:00:1d.2: PCI=
 INT C -> GSI 18 (level, low) -> IRQ 18
Feb  8 00:18:03 champagne kernel: [    2.216786] uhci_hcd 0000:00:1d.2: set=
ting latency timer to 64
Feb  8 00:18:03 champagne kernel: [    2.216789] uhci_hcd 0000:00:1d.2: UHC=
I Host Controller
Feb  8 00:18:03 champagne kernel: [    2.216806] uhci_hcd 0000:00:1d.2: new=
 USB bus registered, assigned bus number 7
Feb  8 00:18:03 champagne kernel: [    2.216829] uhci_hcd 0000:00:1d.2: irq=
 18, io base 0x000050e0
Feb  8 00:18:03 champagne kernel: [    2.216889] usb usb7: configuration #1=
 chosen from 1 choice
Feb  8 00:18:03 champagne kernel: [    2.216908] hub 7-0:1.0: USB hub found
Feb  8 00:18:03 champagne kernel: [    2.216913] hub 7-0:1.0: 2 ports detec=
ted
Feb  8 00:18:03 champagne kernel: [    2.217889] usb 2-2: configuration #1 =
chosen from 1 choice
Feb  8 00:18:03 champagne kernel: [    2.217978] hub 2-2:1.0: USB hub found
Feb  8 00:18:03 champagne kernel: [    2.218082] hub 2-2:1.0: 4 ports detec=
ted
Feb  8 00:18:03 champagne kernel: [    2.219301]  sda1 sda2
Feb  8 00:18:03 champagne kernel: [    2.219389] sd 2:0:0:0: [sda] Attached=
 SCSI disk
Feb  8 00:18:03 champagne kernel: [    2.328064] usb 2-4: new high speed US=
B device using ehci_hcd and address 4
Feb  8 00:18:03 champagne kernel: [    2.468947] usb 2-4: configuration #1 =
chosen from 1 choice
Feb  8 00:18:03 champagne kernel: [    2.469110] hub 2-4:1.0: USB hub found
Feb  8 00:18:03 champagne kernel: [    2.469213] hub 2-4:1.0: 4 ports detec=
ted
Feb  8 00:18:03 champagne kernel: [    2.708061] usb 1-1: new full speed US=
B device using uhci_hcd and address 2
Feb  8 00:18:03 champagne kernel: [    2.812420] ieee1394: Host added: ID:B=
US[0-00:1023]  GUID[00023f9929ed5e0e]
Feb  8 00:18:03 champagne kernel: [    2.881777] usb 1-1: configuration #1 =
chosen from 1 choice
Feb  8 00:18:03 champagne kernel: [    3.368065] usb 5-2: new full speed US=
B device using uhci_hcd and address 2
Feb  8 00:18:03 champagne kernel: [    3.529499] usb 5-2: configuration #1 =
chosen from 1 choice
Feb  8 00:18:03 champagne kernel: [    7.408923] PM: Starting manual resume=
 from disk
Feb  8 00:18:03 champagne kernel: [    7.408926] PM: Resume from partition =
254:1
Feb  8 00:18:03 champagne kernel: [    7.408927] PM: Checking hibernation i=
mage.
Feb  8 00:18:03 champagne kernel: [    7.409120] PM: Resume from disk faile=
d.
Feb  8 00:18:03 champagne kernel: [    7.413758] SGI XFS with ACLs, securit=
y attributes, realtime, large block/inode numbers, no debug enabled
Feb  8 00:18:03 champagne kernel: [    7.417345] Filesystem "dm-2": Disabli=
ng barriers, trial barrier write failed
Feb  8 00:18:03 champagne kernel: [    7.421288] XFS mounting filesystem dm=
-2
Feb  8 00:18:03 champagne kernel: [    7.613339] Ending clean XFS mount for=
 filesystem: dm-2
Feb  8 00:18:03 champagne kernel: [   19.859024] udevd version 124 started
Feb  8 00:18:03 champagne kernel: [   20.179082] ata3.00: configured for UD=
MA/100
Feb  8 00:18:03 champagne kernel: [   20.179086] ata3: EH complete
Feb  8 00:18:03 champagne kernel: [   20.189862] sd 2:0:0:0: [sda] 23444164=
8 512-byte hardware sectors: (120 GB/111 GiB)
Feb  8 00:18:03 champagne kernel: [   20.199325] sd 2:0:0:0: [sda] Write Pr=
otect is off
Feb  8 00:18:03 champagne kernel: [   20.199328] sd 2:0:0:0: [sda] Mode Sen=
se: 00 3a 00 00
Feb  8 00:18:03 champagne kernel: [   20.207831] sd 2:0:0:0: [sda] Write ca=
che: disabled, read cache: enabled, doesn't support DPO or FUA
Feb  8 00:18:03 champagne kernel: [   20.693157] device-mapper: multipath: =
version 1.0.5 loaded
Feb  8 00:18:03 champagne kernel: [   20.853455] input: PC Speaker as /clas=
s/input/input1
Feb  8 00:18:03 champagne kernel: [   21.271377] ACPI: AC Adapter [C1F2] (o=
n-line)
Feb  8 00:18:03 champagne kernel: [   21.437971] iTCO_vendor_support: vendo=
r-support=3D0
Feb  8 00:18:03 champagne kernel: [   21.449767] iTCO_wdt: Intel TCO WatchD=
og Timer Driver v1.04
Feb  8 00:18:03 champagne kernel: [   21.449936] iTCO_wdt: Found a ICH8M-E =
TCO device (Version=3D2, TCOBASE=3D0x1060)
Feb  8 00:18:03 champagne kernel: [   21.450052] iTCO_wdt: initialized. hea=
rtbeat=3D30 sec (nowayout=3D0)
Feb  8 00:18:03 champagne kernel: [   21.532101] cfg80211: Calling CRDA to =
update world regulatory domain
Feb  8 00:18:03 champagne kernel: [   21.544049] input: Power Button (FF) a=
s /class/input/input2
Feb  8 00:18:03 champagne kernel: [   21.576179] ACPI: Power Button (FF) [P=
WRF]
Feb  8 00:18:03 champagne kernel: [   21.590343] ACPI: Battery Slot [C1F4] =
(battery present)
Feb  8 00:18:03 champagne kernel: [   21.590862] ACPI: WMI: Mapper loaded
Feb  8 00:18:03 champagne kernel: [   21.590917] input: Sleep Button (CM) a=
s /class/input/input3
Feb  8 00:18:03 champagne kernel: [   21.609179] logips2pp: Detected unknow=
n logitech mouse model 62
Feb  8 00:18:03 champagne kernel: [   21.620161] ACPI: Sleep Button (CM) [C=
274]
Feb  8 00:18:03 champagne kernel: [   21.620394] ACPI: Battery Slot [C1F3] =
(battery absent)
Feb  8 00:18:03 champagne kernel: [   21.620492] input: Lid Switch as /clas=
s/input/input4
Feb  8 00:18:03 champagne kernel: [   21.636185] ACPI: Lid Switch [C26E]
Feb  8 00:18:03 champagne kernel: [   21.728028] acpi device:03: registered=
 as cooling_device13
Feb  8 00:18:03 champagne kernel: [   21.728925] input: Video Bus as /class=
/input/input5
Feb  8 00:18:03 champagne kernel: [   21.753112] ACPI: Video Device [C14B] =
(multi-head: yes  rom: no  post: no)
Feb  8 00:18:03 champagne kernel: [   21.799142] Bluetooth: Core ver 2.13
Feb  8 00:18:03 champagne kernel: [   21.843038] NET: Registered protocol f=
amily 31
Feb  8 00:18:03 champagne kernel: [   21.843040] Bluetooth: HCI device and =
connection manager initialized
Feb  8 00:18:03 champagne kernel: [   21.843042] Bluetooth: HCI socket laye=
r initialized
Feb  8 00:18:03 champagne kernel: [   21.858887] yenta_cardbus 0000:02:06.0=
: CardBus bridge found [103c:30c5]
Feb  8 00:18:03 champagne kernel: [   21.904834] ricoh-mmc: Ricoh MMC Contr=
oller disabling driver
Feb  8 00:18:03 champagne kernel: [   21.904836] ricoh-mmc: Copyright(c) Ph=
ilip Langdale
Feb  8 00:18:03 champagne kernel: [   21.984913] yenta_cardbus 0000:02:06.0=
: ISA IRQ mask 0x0cb8, PCI irq 16
Feb  8 00:18:03 champagne kernel: [   21.984917] yenta_cardbus 0000:02:06.0=
: Socket status: 30000006
Feb  8 00:18:03 champagne kernel: [   21.984921] yenta_cardbus 0000:02:06.0=
: pcmcia: parent PCI bridge I/O window: 0x6000 - 0x6fff
Feb  8 00:18:03 champagne kernel: [   21.984924] yenta_cardbus 0000:02:06.0=
: pcmcia: parent PCI bridge Memory window: 0xe4100000 - 0xe43fffff
Feb  8 00:18:03 champagne kernel: [   21.984926] yenta_cardbus 0000:02:06.0=
: pcmcia: parent PCI bridge Memory window: 0xc4000000 - 0xcbffffff
Feb  8 00:18:03 champagne kernel: [   21.985232] ricoh-mmc: Ricoh MMC contr=
oller found at 0000:02:06.4 [1180:0843] (rev 10)
Feb  8 00:18:03 champagne kernel: [   21.985253] ricoh-mmc: Controller is n=
ow disabled.
Feb  8 00:18:03 champagne kernel: [   21.985314] yenta_cardbus 0000:02:06.1=
: CardBus bridge found [103c:30c5]
Feb  8 00:18:03 champagne kernel: [   22.028137] Registered led device: hp:=
red:hddprotection
Feb  8 00:18:03 champagne kernel: [   22.028160] leds-hp-disk driver loaded=
.
Feb  8 00:18:03 champagne kernel: [   22.053379] lis3lv02d driver loaded.
Feb  8 00:18:03 champagne kernel: [   22.112905] yenta_cardbus 0000:02:06.1=
: ISA IRQ mask 0x0000, PCI irq 17
Feb  8 00:18:03 champagne kernel: [   22.112909] yenta_cardbus 0000:02:06.1=
: Socket status: 30000810
Feb  8 00:18:03 champagne kernel: [   22.112912] pci_bus 0000:02: Raising s=
ubordinate bus# of parent bus (#02) from #04 to #07
Feb  8 00:18:03 champagne kernel: [   22.112919] yenta_cardbus 0000:02:06.1=
: pcmcia: parent PCI bridge I/O window: 0x6000 - 0x6fff
Feb  8 00:18:03 champagne kernel: [   22.112922] yenta_cardbus 0000:02:06.1=
: pcmcia: parent PCI bridge Memory window: 0xe4100000 - 0xe43fffff
Feb  8 00:18:03 champagne kernel: [   22.112924] yenta_cardbus 0000:02:06.1=
: pcmcia: parent PCI bridge Memory window: 0xc4000000 - 0xcbffffff
Feb  8 00:18:03 champagne kernel: [   22.127257] sdhci: Secure Digital Host=
 Controller Interface driver
Feb  8 00:18:03 champagne kernel: [   22.127259] sdhci: Copyright(c) Pierre=
 Ossman
Feb  8 00:18:03 champagne kernel: [   22.151127] input: ImExPS/2 Logitech E=
xplorer Mouse as /class/input/input6
Feb  8 00:18:03 champagne kernel: [   22.282002] parport_pc 00:03: reported=
 by Plug and Play ACPI
Feb  8 00:18:03 champagne kernel: [   22.282078] parport0: PC-style at 0x37=
8 (0x778), irq 7, dma 1 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
Feb  8 00:18:03 champagne kernel: [   22.337591] sdhci-pci 0000:02:06.3: SD=
HCI controller found [1180:0822] (rev 20)
Feb  8 00:18:03 champagne kernel: [   22.337609] sdhci-pci 0000:02:06.3: PC=
I INT D -> GSI 19 (level, low) -> IRQ 19
Feb  8 00:18:03 champagne kernel: [   22.339713] mmc0: SDHCI controller on =
PCI [0000:02:06.3] using PIO
Feb  8 00:18:03 champagne kernel: [   22.373396] Bluetooth: Generic Bluetoo=
th USB driver ver 0.3
Feb  8 00:18:03 champagne kernel: [   22.373478] usbcore: registered new in=
terface driver btusb
Feb  8 00:18:03 champagne kernel: [   22.424178] tpm_inf_pnp 00:04: Found C=
239 with ID IFX0102
Feb  8 00:18:03 champagne kernel: [   22.424232] tpm_inf_pnp 00:04: TPM fou=
nd: config base 0x560, data base 0x570, chip version 0x000b, vendor id 0x15=
d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
Feb  8 00:18:03 champagne kernel: [   22.588676] HDA Intel 0000:00:1b.0: po=
wer state changed by ACPI to D0
Feb  8 00:18:03 champagne kernel: [   22.588687] HDA Intel 0000:00:1b.0: PC=
I INT A -> GSI 17 (level, low) -> IRQ 17
Feb  8 00:18:03 champagne kernel: [   22.588737] HDA Intel 0000:00:1b.0: se=
tting latency timer to 64
Feb  8 00:18:03 champagne kernel: [   22.601103] iwlagn: Intel(R) Wireless =
WiFi Link AGN driver for Linux, 1.3.27ks
Feb  8 00:18:03 champagne kernel: [   22.601105] iwlagn: Copyright(c) 2003-=
2008 Intel Corporation
Feb  8 00:18:03 champagne kernel: [   22.601230] iwlagn 0000:10:00.0: PCI I=
NT A -> GSI 17 (level, low) -> IRQ 17
Feb  8 00:18:03 champagne kernel: [   22.601257] iwlagn 0000:10:00.0: setti=
ng latency timer to 64
Feb  8 00:18:03 champagne kernel: [   22.601312] iwlagn: Detected Intel Wir=
eless WiFi Link 4965AGN REV=3D0x4
Feb  8 00:18:03 champagne kernel: [   22.651181] iwlagn: Tunable channels: =
13 802.11bg, 19 802.11a channels
Feb  8 00:18:03 champagne kernel: [   22.651489] iwlagn 0000:10:00.0: PCI I=
NT A disabled
Feb  8 00:18:03 champagne kernel: [   22.651910] phy0: Selected rate contro=
l algorithm 'iwl-agn-rs'
Feb  8 00:18:03 champagne kernel: [   22.681798] HDA Intel 0000:01:00.1: PC=
I INT B -> GSI 17 (level, low) -> IRQ 17
Feb  8 00:18:03 champagne kernel: [   22.681853] HDA Intel 0000:01:00.1: se=
tting latency timer to 64
Feb  8 00:18:03 champagne kernel: [   22.751300] cfg80211: Calling CRDA for=
 country: IT
Feb  8 00:18:03 champagne kernel: [   22.753336] pcmcia_socket pcmcia_socke=
t1: pccard: PCMCIA card inserted into slot 1
Feb  8 00:18:03 champagne kernel: [   23.044069] pcmcia_socket pcmcia_socke=
t1: cs: memory probe 0xc4000000-0xcbffffff: excluding 0xc4000000-0xcbffffff
Feb  8 00:18:03 champagne kernel: [   23.044085] pcmcia_socket pcmcia_socke=
t1: cs: memory probe 0xe4100000-0xe43fffff: excluding 0xe4100000-0xe412ffff
Feb  8 00:18:03 champagne kernel: [   23.049192] pcmcia 1.0: pcmcia: regist=
ering new device pcmcia1.0
Feb  8 00:18:03 champagne kernel: [   23.225379] loop: module loaded
Feb  8 00:18:03 champagne kernel: [   23.336324] input: HP WMI hotkeys as /=
class/input/input7
Feb  8 00:18:03 champagne kernel: [   23.473477] Adding 8388600k swap on /d=
ev/mapper/vol00-swap.  Priority:-1 extents:1 across:8388600k
Feb  8 00:18:03 champagne kernel: [   24.570445] kjournald starting.  Commi=
t interval 5 seconds
Feb  8 00:18:03 champagne kernel: [   24.586350] EXT3 FS on sda1, internal =
journal
Feb  8 00:18:03 champagne kernel: [   24.586353] EXT3-fs: mounted filesyste=
m with ordered data mode.
Feb  8 00:18:03 champagne kernel: [   25.506577] ip_tables: (C) 2000-2006 N=
etfilter Core Team
Feb  8 00:18:03 champagne kernel: [   25.550197] nf_conntrack version 0.5.0=
 (16384 buckets, 65536 max)
Feb  8 00:18:03 champagne kernel: [   25.550339] CONFIG_NF_CT_ACCT is depre=
cated and will be removed soon. Please use
Feb  8 00:18:03 champagne kernel: [   25.550341] nf_conntrack.acct=3D1 kern=
el paramater, acct=3D1 nf_conntrack module option or
Feb  8 00:18:03 champagne kernel: [   25.550343] sysctl net.netfilter.nf_co=
nntrack_acct=3D1 to enable it.
Feb  8 00:18:03 champagne kernel: [   25.700051] NET: Registered protocol f=
amily 10
Feb  8 00:18:03 champagne kernel: [   25.700414] lo: Disabled Privacy Exten=
sions
Feb  8 00:18:03 champagne kernel: [   25.722101] ip6_tables: (C) 2000-2006 =
Netfilter Core Team
Feb  8 00:18:04 champagne kernel: [   28.350806] warning: `avahi-daemon' us=
es 32-bit capabilities (legacy support in use)
Feb  8 00:18:19 champagne kernel: [   43.006683] Bluetooth: L2CAP ver 2.11
Feb  8 00:18:19 champagne kernel: [   43.006688] Bluetooth: L2CAP socket la=
yer initialized
Feb  8 00:18:19 champagne kernel: [   43.023798] Bluetooth: SCO (Voice Link=
) ver 0.6
Feb  8 00:18:19 champagne kernel: [   43.023803] Bluetooth: SCO socket laye=
r initialized
Feb  8 00:18:19 champagne kernel: [   43.052174] Bluetooth: BNEP (Ethernet =
Emulation) ver 1.3
Feb  8 00:18:19 champagne kernel: [   43.052181] Bluetooth: BNEP filters: p=
rotocol multicast
Feb  8 00:18:19 champagne kernel: [   43.146618] Bridge firewalling registe=
red
Feb  8 00:18:19 champagne kernel: [   43.328292] Bluetooth: RFCOMM socket l=
ayer initialized
Feb  8 00:18:19 champagne kernel: [   43.328309] Bluetooth: RFCOMM TTY laye=
r initialized
Feb  8 00:18:19 champagne kernel: [   43.328313] Bluetooth: RFCOMM ver 1.10
Feb  8 00:18:22 champagne kernel: [   46.387521] pci 0000:01:00.0: PCI INT =
A -> GSI 16 (level, low) -> IRQ 16
Feb  8 00:18:24 champagne kernel: [   48.308407] e1000e 0000:00:19.0: irq 5=
07 for MSI/MSI-X
Feb  8 00:18:24 champagne kernel: [   48.364068] e1000e 0000:00:19.0: irq 5=
07 for MSI/MSI-X
Feb  8 00:18:24 champagne kernel: [   48.364946] ADDRCONF(NETDEV_UP): eth0:=
 link is not ready
Feb  8 00:18:24 champagne kernel: [   48.366116] iwlagn 0000:10:00.0: PCI I=
NT A -> GSI 17 (level, low) -> IRQ 17
Feb  8 00:18:24 champagne kernel: [   48.366193] iwlagn 0000:10:00.0: resto=
ring config space at offset 0x1 (was 0x100002, writing 0x100006)
Feb  8 00:18:24 champagne kernel: [   48.366294] iwlagn 0000:10:00.0: irq 5=
05 for MSI/MSI-X
Feb  8 00:18:24 champagne kernel: [   48.366355] iwlagn 0000:10:00.0: firmw=
are: requesting iwlwifi-4965-2.ucode
Feb  8 00:18:24 champagne kernel: [   48.905624] Registered led device: iwl=
-phy0:radio
Feb  8 00:18:24 champagne kernel: [   48.905668] Registered led device: iwl=
-phy0:assoc
Feb  8 00:18:24 champagne kernel: [   48.905708] Registered led device: iwl=
-phy0:RX
Feb  8 00:18:24 champagne kernel: [   48.905746] Registered led device: iwl=
-phy0:TX
Feb  8 00:18:24 champagne kernel: [   48.957738] ADDRCONF(NETDEV_UP): wlan0=
: link is not ready
Feb  8 00:18:25 champagne kernel: [   49.176182] NET: Registered protocol f=
amily 17
Feb  8 00:18:26 champagne kernel: [   50.993656] 0000:00:19.0: eth0: Link i=
s Up 1000 Mbps Full Duplex, Flow Control: RX/TX
Feb  8 00:18:26 champagne kernel: [   50.995956] ADDRCONF(NETDEV_CHANGE): e=
th0: link becomes ready
Feb  8 00:18:38 champagne kernel: [   61.824087] eth0: no IPv6 routers pres=
ent
Feb  8 00:20:35 champagne kernel: [  178.502467] [UFW BLOCK INPUT]: IN=3Det=
h0 OUT=3D MAC=3D00:1a:4b:7a:9d:98:00:17:a4:93:66:ec:08:00 SRC=3D10.151.1.5 =
DST=3D10.151.1.19 LEN=3D91 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D3504 PROTO=
=3DUDP SPT=3D161 DPT=3D51166 LEN=3D71=20
Feb  8 00:20:35 champagne kernel: [  178.531115] [UFW BLOCK INPUT]: IN=3Det=
h0 OUT=3D MAC=3D00:1a:4b:7a:9d:98:00:0f:66:c7:99:59:08:00 SRC=3D10.151.1.25=
3 DST=3D10.151.1.19 LEN=3D74 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D0 DF PROT=
O=3DUDP SPT=3D161 DPT=3D51166 LEN=3D54=20
Feb  8 00:22:59 champagne kernel: [  321.972076] usb 4-6: new high speed US=
B device using ehci_hcd and address 3
Feb  8 00:22:59 champagne kernel: [  322.107097] usb 4-6: configuration #1 =
chosen from 1 choice
Feb  8 00:22:59 champagne kernel: [  322.196046] usbcore: registered new in=
terface driver libusual
Feb  8 00:22:59 champagne kernel: [  322.217705] Initializing USB Mass Stor=
age driver...
Feb  8 00:22:59 champagne kernel: [  322.222149] scsi5 : SCSI emulation for=
 USB Mass Storage devices
Feb  8 00:22:59 champagne kernel: [  322.230344] usbcore: registered new in=
terface driver usb-storage
Feb  8 00:22:59 champagne kernel: [  322.230352] USB Mass Storage support r=
egistered.
Feb  8 00:22:59 champagne kernel: [  322.230629] usb-storage: device found =
at 3
Feb  8 00:22:59 champagne kernel: [  322.230633] usb-storage: waiting for d=
evice to settle before scanning
Feb  8 00:23:04 champagne kernel: [  327.228402] usb-storage: device scan c=
omplete
Feb  8 00:23:04 champagne kernel: [  327.228909] scsi 5:0:0:0: Direct-Acces=
s     Maxtor   OneTouch         0125 PQ: 0 ANSI: 4
Feb  8 00:23:04 champagne kernel: [  327.237977] sd 5:0:0:0: [sdb] 48839716=
8 512-byte hardware sectors: (250 GB/232 GiB)
Feb  8 00:23:04 champagne kernel: [  327.238596] sd 5:0:0:0: [sdb] Write Pr=
otect is off
Feb  8 00:23:04 champagne kernel: [  327.238601] sd 5:0:0:0: [sdb] Mode Sen=
se: 2d 08 00 00
Feb  8 00:23:04 champagne kernel: [  327.238606] sd 5:0:0:0: [sdb] Assuming=
 drive cache: write through
Feb  8 00:23:04 champagne kernel: [  327.239344] sd 5:0:0:0: [sdb] 48839716=
8 512-byte hardware sectors: (250 GB/232 GiB)
Feb  8 00:23:04 champagne kernel: [  327.239975] sd 5:0:0:0: [sdb] Write Pr=
otect is off
Feb  8 00:23:04 champagne kernel: [  327.239980] sd 5:0:0:0: [sdb] Mode Sen=
se: 2d 08 00 00
Feb  8 00:23:04 champagne kernel: [  327.239984] sd 5:0:0:0: [sdb] Assuming=
 drive cache: write through
Feb  8 00:23:04 champagne kernel: [  327.239991]  sdb: sdb1
Feb  8 00:23:04 champagne kernel: [  327.258377] sd 5:0:0:0: [sdb] Attached=
 SCSI disk
Feb  8 00:23:04 champagne kernel: [  327.258614] sd 5:0:0:0: Attached scsi =
generic sg2 type 0
Feb  8 00:23:05 champagne kernel: [  328.702211] EXT4-fs: barriers enabled
Feb  8 00:23:05 champagne kernel: [  328.719572] kjournald2 starting.  Comm=
it interval 5 seconds
Feb  8 00:23:05 champagne kernel: [  328.720298] EXT4 FS on sdb1, internal =
journal on sdb1:8
Feb  8 00:23:05 champagne kernel: [  328.720305] EXT4-fs: delayed allocatio=
n enabled
Feb  8 00:23:05 champagne kernel: [  328.720310] EXT4-fs: file extents enab=
led
Feb  8 00:23:05 champagne kernel: [  328.722303] EXT4-fs: mballoc enabled
Feb  8 00:23:05 champagne kernel: [  328.722311] EXT4-fs: mounted filesyste=
m with ordered data mode.
Feb  8 00:31:26 champagne kernel: [  828.913093] CE: hpet increasing min_de=
lta_ns to 15000 nsec
Feb  8 00:38:38 champagne kernel: [ 1261.661095] CE: hpet increasing min_de=
lta_ns to 22500 nsec
Feb  8 00:39:55 champagne kernel: [ 1338.769101] CE: hpet increasing min_de=
lta_ns to 33750 nsec
Feb  8 00:58:42 champagne kernel: [ 2464.873102] CE: hpet increasing min_de=
lta_ns to 50624 nsec
Feb  8 10:53:12 champagne kernel: [38135.592546] EXT4-fs: mballoc: 4725969 =
blocks 4503 reqs (2328 success)
Feb  8 10:53:12 champagne kernel: [38135.592549] EXT4-fs: mballoc: 2349 ext=
ents scanned, 3228 goal hits, 1262 2^N hits, 0 breaks, 0 lost
Feb  8 10:53:12 champagne kernel: [38135.592551] EXT4-fs: mballoc: 2550 gen=
erated and it took 85092960
Feb  8 10:53:12 champagne kernel: [38135.592552] EXT4-fs: mballoc: 1912951 =
preallocated, 39880 discarded
Feb  8 10:53:18 champagne kernel: [38141.518143] usb 4-6: USB disconnect, a=
ddress 3
Feb  8 11:00:38 champagne kernel: [38581.800121] usb 4-6: new high speed US=
B device using ehci_hcd and address 4
Feb  8 11:00:39 champagne kernel: [38581.937079] usb 4-6: configuration #1 =
chosen from 1 choice
Feb  8 11:00:39 champagne kernel: [38581.940124] scsi6 : SCSI emulation for=
 USB Mass Storage devices
Feb  8 11:00:39 champagne kernel: [38581.940292] usb-storage: device found =
at 4
Feb  8 11:00:39 champagne kernel: [38581.940297] usb-storage: waiting for d=
evice to settle before scanning
Feb  8 11:00:44 champagne kernel: [38586.940461] usb-storage: device scan c=
omplete
Feb  8 11:00:44 champagne kernel: [38586.940969] scsi 6:0:0:0: Direct-Acces=
s     Maxtor   OneTouch         0125 PQ: 0 ANSI: 4
Feb  8 11:00:44 champagne kernel: [38586.945417] sd 6:0:0:0: [sdb] 48839716=
8 512-byte hardware sectors: (250 GB/232 GiB)
Feb  8 11:00:44 champagne kernel: [38586.946044] sd 6:0:0:0: [sdb] Write Pr=
otect is off
Feb  8 11:00:44 champagne kernel: [38586.946049] sd 6:0:0:0: [sdb] Mode Sen=
se: 2d 08 00 00
Feb  8 11:00:44 champagne kernel: [38586.946054] sd 6:0:0:0: [sdb] Assuming=
 drive cache: write through
Feb  8 11:00:44 champagne kernel: [38586.972553] sd 6:0:0:0: [sdb] 48839716=
8 512-byte hardware sectors: (250 GB/232 GiB)
Feb  8 11:00:44 champagne kernel: [38586.981177] sd 6:0:0:0: [sdb] Write Pr=
otect is off
Feb  8 11:00:44 champagne kernel: [38586.981184] sd 6:0:0:0: [sdb] Mode Sen=
se: 2d 08 00 00
Feb  8 11:00:44 champagne kernel: [38586.981189] sd 6:0:0:0: [sdb] Assuming=
 drive cache: write through
Feb  8 11:00:44 champagne kernel: [38586.981200]  sdb: sdb1
Feb  8 11:00:44 champagne kernel: [38587.001076] sd 6:0:0:0: [sdb] Attached=
 SCSI disk
Feb  8 11:00:44 champagne kernel: [38587.001294] sd 6:0:0:0: Attached scsi =
generic sg2 type 0
Feb  8 11:00:45 champagne kernel: [38588.641142] EXT4-fs: barriers enabled
Feb  8 11:00:45 champagne kernel: [38588.658785] kjournald2 starting.  Comm=
it interval 5 seconds
Feb  8 11:00:45 champagne kernel: [38588.659600] EXT4 FS on sdb1, internal =
journal on sdb1:8
Feb  8 11:00:45 champagne kernel: [38588.659606] EXT4-fs: delayed allocatio=
n enabled
Feb  8 11:00:45 champagne kernel: [38588.659610] EXT4-fs: file extents enab=
led
Feb  8 11:00:45 champagne kernel: [38588.661730] EXT4-fs: mballoc enabled
Feb  8 11:00:45 champagne kernel: [38588.661738] EXT4-fs: mounted filesyste=
m with ordered data mode.
Feb  8 11:02:03 champagne kernel: [38665.956159] BUG: unable to handle kern=
el paging request at 000011bbffff88f8
Feb  8 11:02:03 champagne kernel: [38665.956172] IP: [<ffffffff802bd1e3>] p=
in_to_kill+0x21/0xd6
Feb  8 11:02:03 champagne kernel: [38665.956188] PGD 0=20
Feb  8 11:02:03 champagne kernel: [38665.956193] Oops: 0000 [#1] SMP=20
Feb  8 11:02:03 champagne kernel: [38665.956199] last sysfs file: /sys/devi=
ces/system/cpu/cpu1/cache/index2/shared_cpu_map
Feb  8 11:02:03 champagne kernel: [38665.956204] CPU 1=20
Feb  8 11:02:03 champagne kernel: [38665.956208] Modules linked in: ext4 jb=
d2 crc16 usb_storage libusual af_packet binfmt_misc rfcomm bridge stp llc b=
nep sco l2cap acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersav=
e cpufreq_ondemand freq_table cpufreq_conservative sbs sbshc pci_slot ipt_L=
OG xt_limit ipt_addrtype xt_state xt_tcpudp xt_conntrack ip6table_filter ip=
6_tables ipv6 nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ip=
v4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack iptable_filter ip_tables x_=
tables ext3 jbd mbcache hp_wmi coretemp sbp2 loop arc4 ecb iwlagn snd_seq_d=
ummy snd_hda_intel pcmcia snd_pcm_oss snd_seq_oss snd_seq_midi tpm_infineon=
 tpm tpm_bios iwlcore btusb sdhci_pci parport_pc parport snd_rawmidi rfkill=
 sdhci snd_mixer_oss lis3lv02d leds_hp_disk snd_seq_midi_event mac80211 mmc=
_core ricoh_mmc yenta_socket rsrc_nonstatic pcmcia_core bluetooth snd_pcm v=
ideo output container led_class snd_seq wmi button cfg80211 battery iTCO_wd=
t iTCO_vendor_support psmouse serio_raw ac snd_page_al
Feb  8 11:02:03 champagne kernel: oc snd_hwdep snd_timer snd_seq_device snd=
 pcspkr soundcore evdev dm_multipath xfs sd_mod crc_t10dif sg sr_mod cdrom =
ahci ata_piix libata ohci1394 scsi_mod ieee1394 ehci_hcd uhci_hcd usbcore e=
1000e dm_crypt dm_mirror dm_region_hash dm_log dm_snapshot dm_mod thermal p=
rocessor fan thermal_sys hwmon fuse
Feb  8 11:02:03 champagne kernel: [38665.956410] Pid: 7403, comm: kded4 Not=
 tainted 2.6.28.4 #1
Feb  8 11:02:03 champagne kernel: [38665.956414] RIP: 0010:[<ffffffff802bd1=
e3>]  [<ffffffff802bd1e3>] pin_to_kill+0x21/0xd6
Feb  8 11:02:03 champagne kernel: [38665.956426] RSP: 0018:ffff880037951ee8=
  EFLAGS: 00010286
Feb  8 11:02:03 champagne kernel: [38665.956431] RAX: 000011bbffff8800 RBX:=
 ffff8800aed59c6c RCX: 0000000000000000
Feb  8 11:02:03 champagne kernel: [38665.956437] RDX: ffff8800aed59c6c RSI:=
 ffff8800aed59c6c RDI: ffffffff805dd960
Feb  8 11:02:03 champagne kernel: [38665.956442] RBP: ffff8800aed59c6c R08:=
 ffff8800bf415e68 R09: 0000000000000002
Feb  8 11:02:03 champagne kernel: [38665.956448] R10: 00000000021deca8 R11:=
 0000000000000246 R12: ffff880127003380
Feb  8 11:02:03 champagne kernel: [38665.956453] R13: ffff880127003360 R14:=
 0000000000000fc6 R15: 00000000000011bb
Feb  8 11:02:03 champagne kernel: [38665.956459] FS:  00007f67321af6f0(0000=
) GS:ffff88013b803a00(0000) knlGS:0000000000000000
Feb  8 11:02:03 champagne kernel: [38665.956465] CS:  0010 DS: 0000 ES: 000=
0 CR0: 000000008005003b
Feb  8 11:02:03 champagne kernel: [38665.956470] CR2: 000011bbffff88f8 CR3:=
 000000003793d000 CR4: 00000000000006e0
Feb  8 11:02:03 champagne kernel: [38665.956476] DR0: 0000000000000000 DR1:=
 0000000000000000 DR2: 0000000000000000
Feb  8 11:02:03 champagne kernel: [38665.956481] DR3: 0000000000000000 DR6:=
 00000000ffff0ff0 DR7: 0000000000000400
Feb  8 11:02:03 champagne kernel: [38665.956487] Process kded4 (pid: 7403, =
threadinfo ffff880037950000, task ffff88010208a2b0)
Feb  8 11:02:03 champagne kernel: [38665.956492] Stack:
Feb  8 11:02:03 champagne kernel: [38665.956495]  ffff8800aed59c6c ffff8801=
27003360 ffff880127003380 00000000021deca8
Feb  8 11:02:03 champagne kernel: [38665.956504]  0000000001f8a310 ffffffff=
802bd9e9 00000000000000df ffff8800bf415e40
Feb  8 11:02:03 champagne kernel: [38665.956513]  00000000ffffffea 00000000=
000011bb 00000000021deca8 0000000001f8a310
Feb  8 11:02:03 champagne kernel: [38665.956523] Call Trace:
Feb  8 11:02:03 champagne kernel: [38665.956527]  [<ffffffff802bd9e9>] ? in=
otify_rm_wd+0x4d/0xb6
Feb  8 11:02:03 champagne kernel: [38665.956536]  [<ffffffff802be0ee>] ? sy=
s_inotify_rm_watch+0x46/0x62
Feb  8 11:02:03 champagne kernel: [38665.956545]  [<ffffffff8020b49b>] ? sy=
stem_call_fastpath+0x16/0x1b
Feb  8 11:02:03 champagne kernel: [38665.956554] Code: a4 07 32 00 31 c0 5a=
 5b 5d c3 41 56 41 55 49 89 fd 41 54 48 c7 c7 60 d9 5d 80 55 4d 8d 65 20 53=
 48 89 f5 48 8b 46 30 44 8b 76 38 <48> 8b 98 f8 00 00 00 e8 44 a4 13 00 8b =
83 a0 00 00 00 3d ff ff=20
Feb  8 11:02:03 champagne kernel: [38665.956619] RIP  [<ffffffff802bd1e3>] =
pin_to_kill+0x21/0xd6
Feb  8 11:02:03 champagne kernel: [38665.956628]  RSP <ffff880037951ee8>
Feb  8 11:02:03 champagne kernel: [38665.956631] CR2: 000011bbffff88f8
Feb  8 11:02:03 champagne kernel: [38665.956636] ---[ end trace 038082a5e57=
e3652 ]---
Feb  8 11:03:55 champagne kernel: [38778.120657] EXT4-fs: mballoc: 0 blocks=
 0 reqs (0 success)
Feb  8 11:03:55 champagne kernel: [38778.120666] EXT4-fs: mballoc: 0 extent=
s scanned, 0 goal hits, 0 2^N hits, 0 breaks, 0 lost
Feb  8 11:03:55 champagne kernel: [38778.120672] EXT4-fs: mballoc: 0 genera=
ted and it took 0
Feb  8 11:03:55 champagne kernel: [38778.120676] EXT4-fs: mballoc: 0 preall=
ocated, 0 discarded
Feb  8 11:04:00 champagne kernel: [38783.695892] usb 4-6: USB disconnect, a=
ddress 4

--=-z+sG+p0CLQ3z8Fr2Caa8
Content-Disposition: attachment; filename="config-2.6.28.4"
Content-Type: text/plain; name="config-2.6.28.4"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.28.4
# Sat Feb  7 00:49:53 2009
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y
CONFIG_IKCONFIG=m
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MM_OWNER=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_COMPAT_BRK is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
# CONFIG_MARKERS is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=m
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_CLASSIC_RCU=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR_64=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
# CONFIG_I8K is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y

#
# Memory hotplug is currently incompatible with Software Suspend
#
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x200000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_WMI=m
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=m
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=m
CONFIG_ACPI_SBS=m

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_DMAR is not set
# CONFIG_INTR_REMAP is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=m
CONFIG_PCIEAER=y
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=m
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=m
CONFIG_I82092=m
CONFIG_PCCARD_NONSTATIC=m
CONFIG_HOTPLUG_PCI=m
CONFIG_HOTPLUG_PCI_FAKE=m
CONFIG_HOTPLUG_PCI_ACPI=m
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=m
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=m
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_PPTP=m
# CONFIG_NF_CONNTRACK_SANE is not set
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_TPROXY=m
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
# CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT is not set
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_IP_VS=m
# CONFIG_IP_VS_IPV6 is not set
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_DCCP=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_RAW=m
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_TIPC is not set
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
CONFIG_ATM_MPOA=m
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_BRIDGE=m
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=m
CONFIG_LLC2=m
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
CONFIG_WAN_ROUTER=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
# CONFIG_CLS_U32_PERF is not set
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIDTL1=m
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
CONFIG_BT_HCIVHCI=m
# CONFIG_AF_RXRPC is not set
CONFIG_PHONET=m
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
CONFIG_NL80211=y
# CONFIG_WIRELESS_OLD_REGULATORY is not set
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_MAC80211=m

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_PID=y
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT_PID=y
# CONFIG_MAC80211_RC_DEFAULT_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT="pid"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_IEEE80211 is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_INPUT=m
CONFIG_RFKILL_LEDS=y
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_PC_PCMCIA=m
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_PARIDE is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=65536
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=m
CONFIG_VIRTIO_BLK=m
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_EEPROM_93CX6=m
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ACER_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
CONFIG_HP_WMI=m
# CONFIG_ICS932S401 is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_SGI_XP is not set
# CONFIG_HP_ILO is not set
# CONFIG_SGI_GRU is not set
# CONFIG_C2PORT is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
# CONFIG_SCSI_ENCLOSURE is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=m
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
CONFIG_SCSI_SRP=m
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
# CONFIG_PCMCIA_FDOMAIN is not set
# CONFIG_PCMCIA_QLOGIC is not set
# CONFIG_PCMCIA_SYM53C500 is not set
# CONFIG_SCSI_DH is not set
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set
CONFIG_SATA_AHCI=m
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=m
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_SCH is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=m
CONFIG_IEEE1394_OHCI1394=m
CONFIG_IEEE1394_PCILYNX=m
CONFIG_IEEE1394_SBP2=m
# CONFIG_IEEE1394_SBP2_PHYS_DMA is not set
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=m
CONFIG_IEEE1394_RAWIO=m
CONFIG_IEEE1394_VIDEO1394=m
CONFIG_IEEE1394_DV1394=m
# CONFIG_IEEE1394_VERBOSEDEBUG is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_IFB=m
CONFIG_DUMMY=m
CONFIG_BONDING=m
CONFIG_MACVLAN=m
CONFIG_EQUALIZER=m
CONFIG_TUN=m
CONFIG_VETH=m
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_MII=m
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
CONFIG_E1000E=m
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_JME is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
CONFIG_MAC80211_HWSIM=m
# CONFIG_P54_COMMON is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH9K is not set
CONFIG_IWLWIFI=m
CONFIG_IWLCORE=m
CONFIG_IWLWIFI_LEDS=y
CONFIG_IWLWIFI_RFKILL=y
# CONFIG_IWLWIFI_DEBUG is not set
CONFIG_IWLAGN=m
CONFIG_IWLAGN_SPECTRUM_MEASUREMENT=y
CONFIG_IWLAGN_LEDS=y
CONFIG_IWL4965=y
# CONFIG_IWL5000 is not set
# CONFIG_IWL3945 is not set
# CONFIG_HOSTAP is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_ZD1211RW is not set
# CONFIG_RT2X00 is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_DM9601=m
# CONFIG_USB_NET_SMSC95XX is not set
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
# CONFIG_USB_NET_ZAURUS is not set
CONFIG_USB_HSO=m
CONFIG_NET_PCMCIA=y
# CONFIG_PCMCIA_3C589 is not set
# CONFIG_PCMCIA_3C574 is not set
# CONFIG_PCMCIA_FMVJ18X is not set
# CONFIG_PCMCIA_PCNET is not set
# CONFIG_PCMCIA_NMCLAN is not set
# CONFIG_PCMCIA_SMC91C92 is not set
# CONFIG_PCMCIA_XIRC2PS is not set
# CONFIG_PCMCIA_AXNET is not set
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=m
CONFIG_HDLC_RAW=m
CONFIG_HDLC_RAW_ETH=m
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=m
CONFIG_HDLC_PPP=m

#
# X.25/LAPB support is disabled
#
# CONFIG_PCI200SYN is not set
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
# CONFIG_FARSYNC is not set
# CONFIG_DSCC4 is not set
CONFIG_DLCI=m
CONFIG_DLCI_MAX=8
CONFIG_WAN_ROUTER_DRIVERS=m
# CONFIG_CYCLADES_SYNC is not set
# CONFIG_SBNI is not set
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=m
CONFIG_ATM_TCP=m
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_FIRESTREAM is not set
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PLIP=m
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
CONFIG_PPPOATM=m
CONFIG_PPPOL2TP=m
# CONFIG_SLIP is not set
CONFIG_SLHC=m
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=m
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_SUNKBD=m
CONFIG_KEYBOARD_LKKBD=m
CONFIG_KEYBOARD_XTKBD=m
CONFIG_KEYBOARD_NEWTON=m
CONFIG_KEYBOARD_STOWAWAY=m
CONFIG_KEYBOARD_GPIO=m
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_VSXXXAA=m
CONFIG_MOUSE_GPIO=m
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
CONFIG_TABLET_USB_KBTAB=m
CONFIG_TABLET_USB_WACOM=m
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_FUJITSU=m
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_MTOUCH=m
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=m
CONFIG_TOUCHSCREEN_PENMOUNT=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_APANEL is not set
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_COMPUTONE is not set
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_DIGIEPCA is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_ISI is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
CONFIG_N_HDLC=m
# CONFIG_RISCOM8 is not set
# CONFIG_SPECIALIX is not set
# CONFIG_SX is not set
# CONFIG_RIO is not set
# CONFIG_STALDRV is not set
CONFIG_NOZOMI=m

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=48
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_NVRAM=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
CONFIG_IPWIRELESS=m
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_GPIO=m
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
CONFIG_I2C_STUB=m

#
# Miscellaneous I2C Chip support
#
CONFIG_DS1682=m
CONFIG_AT24=m
CONFIG_SENSORS_EEPROM=m
CONFIG_SENSORS_PCF8591=m
CONFIG_TPS65010=m
CONFIG_SENSORS_MAX6875=m
CONFIG_SENSORS_TSL2550=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y

#
# Memory mapped GPIO expanders:
#

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=m

#
# PCI GPIO expanders:
#

#
# SPI GPIO expanders:
#
CONFIG_W1=m
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2433=m
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=m
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=m
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_HWMON=m
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7462=m
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=m
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
CONFIG_ITCO_WDT=m
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_REGULATOR is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
# CONFIG_VIDEO_ALLOW_V4L1 is not set
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=m
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_CUSTOMIZE=y
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9875=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_M52790=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_TVP5150=m
CONFIG_VIDEO_CX25840=m
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m
CONFIG_VIDEO_VIVI=m
CONFIG_VIDEO_BT848=m
CONFIG_VIDEO_BT848_DVB=y
CONFIG_VIDEO_SAA6588=m
CONFIG_VIDEO_SAA5246A=m
CONFIG_VIDEO_SAA5249=m
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_SAA7134_DVB=m
CONFIG_VIDEO_HEXIUM_ORION=m
CONFIG_VIDEO_HEXIUM_GEMINI=m
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_VP3054=m
CONFIG_VIDEO_CX23885=m
CONFIG_VIDEO_AU0828=m
CONFIG_VIDEO_IVTV=m
CONFIG_VIDEO_FB_IVTV=m
CONFIG_VIDEO_CX18=m
CONFIG_VIDEO_CAFE_CCIC=m
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
CONFIG_USB_M5602=m
CONFIG_USB_GSPCA_CONEX=m
CONFIG_USB_GSPCA_ETOMS=m
CONFIG_USB_GSPCA_FINEPIX=m
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_PAC207=m
CONFIG_USB_GSPCA_PAC7311=m
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
CONFIG_USB_GSPCA_SPCA500=m
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
CONFIG_USB_GSPCA_SPCA561=m
CONFIG_USB_GSPCA_STK014=m
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
CONFIG_USB_GSPCA_TV8532=m
CONFIG_USB_GSPCA_VC032X=m
CONFIG_USB_GSPCA_ZC3XX=m
CONFIG_VIDEO_PVRUSB2=m
CONFIG_VIDEO_PVRUSB2_SYSFS=y
CONFIG_VIDEO_PVRUSB2_DVB=y
# CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
CONFIG_VIDEO_EM28XX=m
CONFIG_VIDEO_EM28XX_ALSA=m
CONFIG_VIDEO_EM28XX_DVB=m
CONFIG_VIDEO_USBVISION=m
CONFIG_USB_ET61X251=m
CONFIG_USB_SN9C102=m
CONFIG_USB_ZC0301=m
CONFIG_USB_ZR364XX=m
CONFIG_USB_STKWEBCAM=m
CONFIG_USB_S2255=m
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_GEMTEK_PCI is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_MAESTRO is not set
CONFIG_USB_DSBR=m
# CONFIG_USB_SI470X is not set
CONFIG_USB_MR800=m
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
# CONFIG_TTPCI_EEPROM is not set
# CONFIG_DVB_AV7110 is not set
# CONFIG_DVB_BUDGET_CORE is not set

#
# Supported USB Adapters
#
CONFIG_DVB_USB=m
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_A800=m
CONFIG_DVB_USB_DIBUSB_MB=m
CONFIG_DVB_USB_DIBUSB_MB_FAULTY=y
CONFIG_DVB_USB_DIBUSB_MC=m
CONFIG_DVB_USB_DIB0700=m
CONFIG_DVB_USB_UMT_010=m
CONFIG_DVB_USB_CXUSB=m
CONFIG_DVB_USB_M920X=m
CONFIG_DVB_USB_GL861=m
CONFIG_DVB_USB_AU6610=m
CONFIG_DVB_USB_DIGITV=m
CONFIG_DVB_USB_VP7045=m
CONFIG_DVB_USB_VP702X=m
CONFIG_DVB_USB_GP8PSK=m
CONFIG_DVB_USB_NOVA_T_USB2=m
CONFIG_DVB_USB_TTUSB2=m
CONFIG_DVB_USB_DTT200U=m
CONFIG_DVB_USB_OPERA1=m
CONFIG_DVB_USB_AF9005=m
CONFIG_DVB_USB_AF9005_REMOTE=m
CONFIG_DVB_USB_DW2102=m
CONFIG_DVB_USB_CINERGY_T2=m
CONFIG_DVB_USB_ANYSEE=m
CONFIG_DVB_USB_DTV5100=m
CONFIG_DVB_USB_AF9015=m
CONFIG_DVB_TTUSB_BUDGET=m
CONFIG_DVB_TTUSB_DEC=m
CONFIG_DVB_SIANO_SMS1XXX=m
CONFIG_DVB_SIANO_SMS1XXX_SMS_IDS=y

#
# Supported FlexCopII (B2C2) Adapters
#
CONFIG_DVB_B2C2_FLEXCOP=m
# CONFIG_DVB_B2C2_FLEXCOP_PCI is not set
CONFIG_DVB_B2C2_FLEXCOP_USB=m
# CONFIG_DVB_B2C2_FLEXCOP_DEBUG is not set

#
# Supported BT878 Adapters
#
CONFIG_DVB_BT8XX=m

#
# Supported Pluto2 Adapters
#
CONFIG_DVB_PLUTO2=m

#
# Supported SDMC DM1105 Adapters
#
# CONFIG_DVB_DM1105 is not set

#
# Supported DVB Frontends
#

#
# Customise DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_SI21XX=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_DRX397XD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_TDA10048=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_S5H1411=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_LGS8GL5=m

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=m
CONFIG_DVB_AF9013=m
CONFIG_DAB=y
CONFIG_USB_DABUSB=m

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_DRM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=m
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=m
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=m
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
CONFIG_FB_VGA16=m
CONFIG_FB_UVESA=m
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_VIRTUAL=m
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_CORGI=m
CONFIG_BACKLIGHT_PROGEAR=m
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=m
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_LOGO is not set
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_MPU401_UART=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_MTS64=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
CONFIG_SND_PORTMAN2X4=m
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
# CONFIG_SND_HDA_CODEC_NVHDMI is not set
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
CONFIG_SND_PCMCIA=y
# CONFIG_SND_VXPOCKET is not set
# CONFIG_SND_PDAUDIOCF is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=m
# CONFIG_HID_DEBUG is not set
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=m
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=m

#
# Special HID drivers
#
# CONFIG_HID_COMPAT is not set
CONFIG_HID_A4TECH=m
CONFIG_HID_APPLE=m
CONFIG_HID_BELKIN=m
CONFIG_HID_BRIGHT=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_DELL=m
CONFIG_HID_EZKEY=m
CONFIG_HID_GYRATION=m
CONFIG_HID_LOGITECH=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
CONFIG_HID_SUNPLUS=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_ZEROPLUS_FF is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=m
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=m
CONFIG_USB_SL811_CS=m
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_WHCI_HCD=m
CONFIG_USB_HWA_HCD=m

#
# Enable Host or Gadget support to see Inventra options
#

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
#

#
# see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_DPCM=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP2101=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
# CONFIG_USB_SERIAL_IR is not set
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
# CONFIG_USB_SERIAL_KEYSPAN is not set
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MOTOROLA=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_BERRY_CHARGE=m
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
CONFIG_USB_PHIDGET=m
CONFIG_USB_PHIDGETKIT=m
CONFIG_USB_PHIDGETMOTORCONTROL=m
CONFIG_USB_PHIDGETSERVO=m
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_SISUSBVGA=m
# CONFIG_USB_SISUSBVGA_CON is not set
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m
# CONFIG_USB_GADGET is not set
CONFIG_UWB=m
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=m
CONFIG_UWB_WLP=m
CONFIG_UWB_I1480U=m
CONFIG_UWB_I1480U_WLP=m
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=m
CONFIG_MMC_WBSD=m
CONFIG_MMC_TIFM_SD=m
CONFIG_MMC_SDRICOH_CS=m
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_HP_DISK=m
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1374=m
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_S35390A=m
CONFIG_RTC_DRV_FM3130=m
CONFIG_RTC_DRV_RX8581=m

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
CONFIG_INTEL_IOATDMA=m
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_DMATEST=m
CONFIG_DCA=m
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=m
CONFIG_CFAG12864B_RATE=20
CONFIG_UIO=m
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV=m
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_SMX is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_STAGING is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=m
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=m
# CONFIG_EXT4DEV_COMPAT is not set
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=m
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
# CONFIG_OCFS2_COMPAT_JBD is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_AUTOFS_FS=m
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=m
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=m
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
CONFIG_ROMFS_FS=m
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_REGISTER_V4=y
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_RPCSEC_GSS_SPKM3=m
CONFIG_SMB_FS=m
# CONFIG_SMB_NLS_DEFAULT is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_EXPERIMENTAL=y
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=m
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_DETECT_SOFTLOCKUP is not set
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_FRAME_POINTER is not set
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y

#
# Tracers
#
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_CONTEXT_SWITCH_TRACER is not set
# CONFIG_BOOT_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DIRECT_GBPAGES is not set
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_MMIOTRACE is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=m
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_XCBC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
CONFIG_VIRTIO=m
CONFIG_VIRTIO_RING=m
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=m

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=m
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--=-z+sG+p0CLQ3z8Fr2Caa8--

