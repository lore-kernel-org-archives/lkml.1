Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbZJAVmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbZJAVmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 17:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZJAVmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 17:42:35 -0400
Received: from vague.se ([82.113.131.214]:1780 "EHLO mail.vague.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbZJAVmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 17:42:32 -0400
X-Greylist: delayed 1301 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Oct 2009 17:42:32 EDT
Date: Thu, 1 Oct 2009 23:20:51 +0200 (CEST)
From: Jari Matilainen <vague@vague.se>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: kernel BUG at
 /build/buildd-linux-2.6_2.6.30-1-i386-06t6n0/linux-2.6-2.6.30/debian/build/source_i386_none/kernel/sched.c:6923!
Message-ID: <Pine.LNX.4.64.0910012250440.9984@mordeth.vague.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I encountered the following problem earlier today:
[1.] One line summary of the problem:
      Laptop freezes after a moment of inactivity.
[2.] Full description of the problem/report:
      Laptop freezes a while after the screen has blanked(after 15min inactivity)
      Started happening today Oct 1, 2009 sometime during the day, I've
      reproduced the problem twice after that by booting and leaving the laptop
      inactive for some amount of time. I haven't put a timer on it.
      I haven't rebooted this laptop for a couple of months so for the kernel to
      start freezing quite suddenly makes me suspect some other parts of the
      computer, like memory, and given its age, 3,5 years, I wouldn't be
      surprised if the underlying problem IS hardware.
[3.] Keywords (i.e., modules, networking, kernel):
      Kernel
[4.] Kernel version (from /proc/version):
      Linux version 2.6.30-1-686-bigmem (Debian 2.6.30-1) (waldi@debian.org) (gcc
      version 4.3.3 (Debian 4.3.3-11) ) #1 SMP Sun Jun 14 17:26:05 UTC 2009
[5.] Output of Oops.. message (if applicable) with symbolic information
      resolved (see Documentation/oops-tracing.txt)
[ 5725.408648] ------------[ cut here ]------------
[ 5725.408664] kernel BUG at 
/build/buildd-linux-2.6_2.6.30-1-i386-06t6n0/linux-2.6-2.6.30/debian/build/source_i386_none/kernel/sched.c:6923!
[ 5725.408675] invalid opcode: 0000 [#1] SMP
[ 5725.408757] last sysfs file: 
/sys/devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT0/charge_full
[ 5725.408765] Modules linked in: netconsole configfs nls_utf8 nls_cp437 vfat 
fat nls_base i915 drm i2c_algo_bit rfcomm l2cap bluetooth xt_recent ipt_LOG 
xt_limit xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack 
iptable_filter ip_tables x_tables cpufreq_powersave cpufreq_userspace 
cpufreq_conservative cpufreq_stats firewire_sbp2 loop snd_hda_codec_realtek 
pcmcia snd_hda_intel snd_hda_codec uvcvideo videodev v4l1_compat snd_pcm_oss 
snd_mixer_oss iTCO_wdt video snd_usb_audio snd_pcm yenta_socket rsrc_nonstatic 
i2c_i801 joydev psmouse serio_raw pcspkr i2c_core rng_core pcmcia_core 
snd_usb_lib snd_seq_midi snd_rawmidi snd_hwdep output evdev battery ac button 
processor snd_seq_midi_event snd_seq snd_timer snd_seq_device intel_agp agpgart 
snd soundcore snd_page_alloc usbhid hid ext3 jbd mbcache dm_mirror 
dm_region_hash dm_log dm_snapshot dm_mod usb_storage sd_mod crc_t10dif 
ide_pci_generic ide_core ahci ata_generic ata_piix 8139too firewire_ohci libata 
uhci_hcd ehci_hcd firewire_core crc_itu_t 8139cp mii scsi_mod usbcore thermal 
fan thermal_sys [last unloaded: netconsole]
[ 5725.411377]
[ 5725.411446] Pid: 0, comm: swapper Not tainted (2.6.30-1-686-bigmem #1) 
MIM2120
[ 5725.411455] EIP: 0060:[<c0128e7f>] EFLAGS: 00010296 CPU: 0
[ 5725.411469] EIP is at idle_task_exit+0x23/0x52
[ 5725.411536] EAX: ffffffff EBX: f58f5740 ECX: c03f2300 EDX: c044fff8
[ 5725.411544] ESI: c044fff8 EDI: c0425000 EBP: 0088d003 ESP: c0455fd8
[ 5725.411552]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[ 5725.411621] Process swapper (pid: 0, ti=c0454000 task=c03f2300 
task.ti=c0454000)
[ 5725.411628] Stack:
[ 5725.411634]  00005348 c0113f29 c0113f6e c010690d c0487eac 00099800 c045ff7e 
c0485eac
[ 5725.411852]  00002812 00000000
[ 5725.411994] Call Trace:
[ 5725.412002]  [<c0113f29>] ? play_dead_common+0x5/0x45
[ 5725.412018]  [<c0113f6e>] ? native_play_dead+0x5/0x22
[ 5725.412018]  [<c010690d>] ? cpu_idle+0x3a/0x61
[ 5725.412018]  [<c045ff7e>] ? e820_reserve_resources+0xb4/0x152
[ 5725.412018] Code: ca b9 01 00 00 00 eb 8a 53 8b 15 38 0d 33 c0 64 8b 0d a8 7c 
4a c0 64 a1 28 81 4a c0 8b 99 08 01 00 00 0f a3 02 19 c0 85 c0 74 04 <0f> 0b eb 
fe 81 fb 60 21 3f c0 74 0c ba 60 21 3f c0 89 d8 e8 01
[ 5725.412018] EIP: [<c0128e7f>] idle_task_exit+0x23/0x52 SS:ESP 0068:c0455fd8
[ 5725.413929] ---[ end trace 9b6326522366f8da ]---
[ 5725.413938] Kernel panic - not syncing: Attempted to kill the idle task!
[ 5725.413948] Pid: 0, comm: swapper Tainted: G      D    2.6.30-1-686-bigmem #1
[ 5725.413963] Call Trace:
[ 5725.413979]  [<c03270ea>] ? panic+0x38/0xdd
[ 5725.413995]  [<c012f1a4>] ? do_exit+0x5a/0x5b8
[ 5725.414009]  [<c032719d>] ? printk+0xe/0x11
[ 5725.414025]  [<c010a22e>] ? oops_end+0x95/0x99
[ 5725.414039]  [<c0108604>] ? do_invalid_op+0x0/0x75
[ 5725.414054]  [<c0108670>] ? do_invalid_op+0x6c/0x75
[ 5725.414070]  [<c0128e7f>] ? idle_task_exit+0x23/0x52
[ 5725.414085]  [<c010d355>] ? __switch_to_xtra+0x14a/0x173
[ 5725.414101]  [<c0106532>] ? __switch_to+0x101/0x140
[ 5725.414118]  [<c013ecec>] ? hrtimer_get_next_event+0x8c/0xa0
[ 5725.414133]  [<c0123535>] ? pick_next_task_fair+0x80/0x87
[ 5725.414149]  [<c013459f>] ? get_next_timer_interrupt+0x146/0x1b9
[ 5725.414166]  [<c0328ffd>] ? error_code+0x6d/0x74
[ 5725.414181]  [<c0108604>] ? do_invalid_op+0x0/0x75
[ 5725.414196]  [<c0128e7f>] ? idle_task_exit+0x23/0x52
[ 5725.414212]  [<c0113f29>] ? play_dead_common+0x5/0x45
[ 5725.414227]  [<c0113f6e>] ? native_play_dead+0x5/0x22
[ 5725.414242]  [<c010690d>] ? cpu_idle+0x3a/0x61
[ 5725.414257]  [<c045ff7e>] ? e820_reserve_resources+0xb4/0x152
----------------[ END CUT ]-------------- 
[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)
Linux mordor 2.6.30-1-686-bigmem #1 SMP Sun Jun 14 17:26:05 UTC 2009 i686 
GNU/Linux

Gnu C                  4.3.2
Gnu make               3.81
binutils               2.18.0.20080103
util-linux             2.13.1.1
mount                  2.13.1.1
module-init-tools      3.4
e2fsprogs              1.41.3
pcmciautils            014
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               6.10
udev                   125
wireless-tools         29
Modules Loaded         i915 drm i2c_algo_bit rfcomm l2cap bluetooth xt_recent 
ipt_LOG xt_limit xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state 
nf_conntrack iptable_filter ip_tables x_tables cpufreq_powersave 
cpufreq_userspace cpufreq_conservative cpufreq_stats firewire_sbp2 loop joydev 
pcmcia psmouse serio_raw i2c_i801 pcspkr i2c_core snd_hda_codec_realtek uvcvideo 
videodev v4l1_compat yenta_socket rsrc_nonstatic pcmcia_core snd_usb_audio 
snd_usb_lib snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss 
snd_pcm iTCO_wdt video output rng_core ac evdev battery button processor 
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device 
intel_agp agpgart snd soundcore snd_page_alloc ext3 jbd mbcache dm_mirror 
dm_region_hash dm_log dm_snapshot dm_mod usbhid hid sd_mod crc_t10dif 
ide_pci_generic ide_core ahci ata_generic ata_piix firewire_ohci 8139too 8139cp 
mii libata firewire_core crc_itu_t scsi_mod uhci_hcd ehci_hcd usbcore thermal 
fan thermal_sys

[7.2.] Processor information (from /proc/cpuinfo):
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 13
model name	: Intel(R) Celeron(R) M processor         1.30GHz
stepping	: 8
cpu MHz		: 1296.671
cache size	: 1024 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
clflush dts acpi mmx fxsr sse sse2 ss tm pbe nx up bts
bogomips	: 2593.34
clflush size	: 64
power management:

[7.3.] Module information (from /proc/modules):
i915 147804 2 - Live 0xf8bae000
drm 138420 3 i915, Live 0xf8b57000
i2c_algo_bit 4868 1 i915, Live 0xf8b25000
rfcomm 30236 0 - Live 0xf8b14000
l2cap 18104 5 rfcomm, Live 0xf8afc000
bluetooth 46924 4 rfcomm,l2cap, Live 0xf8ae2000
xt_recent 7776 3 - Live 0xf8ac2000
ipt_LOG 4540 2 - Live 0xf8ab5000
xt_limit 2020 1 - Live 0xf8aab000
xt_tcpudp 2508 2 - Live 0xf8aa1000
nf_conntrack_ipv4 11912 2 - Live 0xf8a95000
nf_defrag_ipv4 1664 1 nf_conntrack_ipv4, Live 0xf8a87000
xt_state 1768 2 - Live 0xf8a7e000
nf_conntrack 57836 2 nf_conntrack_ipv4,xt_state, Live 0xf8a67000
iptable_filter 2956 1 - Live 0xf8a41000
ip_tables 10188 1 iptable_filter, Live 0xf8a35000
x_tables 14108 6 xt_recent,ipt_LOG,xt_limit,xt_tcpudp,xt_state,ip_tables, Live 
0xf8a25000
cpufreq_powersave 1292 0 - Live 0xf8a0a000
cpufreq_userspace 2768 0 - Live 0xf8a01000
cpufreq_conservative 6256 0 - Live 0xf89f6000
cpufreq_stats 3520 0 - Live 0xf89eb000
firewire_sbp2 12868 0 - Live 0xf8948000
loop 13316 0 - Live 0xf8937000
joydev 8576 0 - Live 0xf8892000
pcmcia 24304 0 - Live 0xf880c000
psmouse 37528 0 - Live 0xf87bf000
serio_raw 4556 0 - Live 0xf8675000
i2c_i801 8584 0 - Live 0xf866b000
pcspkr 2104 0 - Live 0xf8651000
i2c_core 20840 4 i915,drm,i2c_algo_bit,i2c_i801, Live 0xf8607000
snd_hda_codec_realtek 178316 1 - Live 0xf8782000
uvcvideo 49316 0 - Live 0xf8637000
videodev 31040 1 uvcvideo, Live 0xf85c9000
v4l1_compat 11416 2 uvcvideo,videodev, Live 0xf8570000
yenta_socket 21276 1 - Live 0xf8579000
rsrc_nonstatic 10016 1 yenta_socket, Live 0xf856b000
pcmcia_core 31188 3 pcmcia,yenta_socket,rsrc_nonstatic, Live 0xf8548000
snd_usb_audio 72080 0 - Live 0xf8593000
snd_usb_lib 13516 1 snd_usb_audio, Live 0xf84c1000
snd_hda_intel 22284 0 - Live 0xf848c000
snd_hda_codec 63520 2 snd_hda_codec_realtek,snd_hda_intel, Live 0xf84d1000
snd_hwdep 6104 2 snd_usb_audio,snd_hda_codec, Live 0xf842b000
snd_pcm_oss 32232 0 - Live 0xf849f000
snd_mixer_oss 12368 1 snd_pcm_oss, Live 0xf8419000
snd_pcm 62516 4 snd_usb_audio,snd_hda_intel,snd_hda_codec,snd_pcm_oss, Live 
0xf8437000
iTCO_wdt 9712 0 - Live 0xf83af000
video 17980 1 i915, Live 0xf837f000
output 2604 1 video, Live 0xf8379000
rng_core 3664 0 - Live 0xf8366000
ac 2960 0 - Live 0xf835c000
evdev 8028 10 - Live 0xf8351000
battery 6012 0 - Live 0xf8330000
button 5060 0 - Live 0xf8307000
processor 34484 1 - Live 0xf82f4000
snd_seq_midi 5688 0 - Live 0xf82de000
snd_rawmidi 18580 2 snd_usb_lib,snd_seq_midi, Live 0xf82b3000
snd_seq_midi_event 6212 1 snd_seq_midi, Live 0xf82af000
snd_seq 42436 2 snd_seq_midi,snd_seq_midi_event, Live 0xf8277000
snd_timer 17436 2 snd_pcm,snd_seq, Live 0xf824e000
snd_seq_device 6136 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0xf8243000
intel_agp 23100 1 - Live 0xf8660000
agpgart 30812 3 drm,intel_agp, Live 0xf8647000
snd 49040 12 
snd_hda_codec_realtek,snd_usb_audio,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_rawmidi,snd_seq,snd_timer,snd_seq_device, 
Live 0xf8629000
soundcore 6184 1 snd, Live 0xf860f000
snd_page_alloc 8252 2 snd_hda_intel,snd_pcm, Live 0xf8602000
ext3 107180 2 - Live 0xf85dc000
jbd 41040 1 ext3, Live 0xf85a6000
mbcache 6924 1 ext3, Live 0xf858f000
dm_mirror 12500 0 - Live 0xf8581000
dm_region_hash 10660 1 dm_mirror, Live 0xf8574000
dm_log 8436 2 dm_mirror,dm_region_hash, Live 0xf8566000
dm_snapshot 21404 0 - Live 0xf8555000
dm_mod 49896 3 dm_mirror,dm_log,dm_snapshot, Live 0xf8539000
usbhid 31596 0 - Live 0xf84e2000
hid 34516 1 usbhid, Live 0xf84c6000
sd_mod 28748 4 - Live 0xf84ac000
crc_t10dif 1632 1 sd_mod, Live 0xf849c000
ide_pci_generic 3632 0 - Live 0xf8493000
ide_core 88168 1 ide_pci_generic, Live 0xf8474000
ahci 30084 0 - Live 0xf8448000
ata_generic 4340 0 - Live 0xf8433000
ata_piix 20900 3 - Live 0xf8423000
firewire_ohci 19292 0 - Live 0xf840c000
8139too 21452 0 - Live 0xf83d6000
8139cp 17728 0 - Live 0xf83c1000
mii 4664 2 8139too,8139cp, Live 0xf83b4000
libata 150892 3 ahci,ata_generic,ata_piix, Live 0xf8385000
firewire_core 37812 2 firewire_sbp2,firewire_ohci, Live 0xf8345000
crc_itu_t 2148 1 firewire_core, Live 0xf8333000
scsi_mod 131608 3 firewire_sbp2,sd_mod,libata, Live 0xf830a000
uhci_hcd 19220 0 - Live 0xf82d2000
ehci_hcd 30056 0 - Live 0xf82b9000
usbcore 126220 7 uvcvideo,snd_usb_audio,snd_usb_lib,usbhid,uhci_hcd,ehci_hcd, 
Live 0xf8289000
thermal 12572 0 - Live 0xf8254000
fan 4040 0 - Live 0xf8246000
thermal_sys 13128 4 video,processor,thermal,fan, Live 0xf8239000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0077 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:1f.2
   0170-0177 : ata_piix
01f0-01f7 : 0000:00:1f.2
   01f0-01f7 : ata_piix
0376-0376 : 0000:00:1f.2
   0376-0376 : ata_piix
03c0-03df : vga+
03e0-03e1 : pnp 00:05
03f6-03f6 : 0000:00:1f.2
   03f6-03f6 : ata_piix
03f8-03ff : pnp 00:05
0600-060f : pnp 00:05
0680-06ff : pnp 00:05
0800-080f : pnp 00:05
0cf8-0cff : PCI conf1
1000-107f : 0000:00:1f.0
   1000-107f : pnp 00:05
     1000-1003 : ACPI PM1a_EVT_BLK
     1004-1005 : ACPI PM1a_CNT_BLK
     1008-100b : ACPI PM_TMR
     1010-1015 : ACPI CPU throttle
     1020-1020 : ACPI PM2_CNT_BLK
     1028-102f : ACPI GPE0_BLK
     1030-1033 : iTCO_wdt
     1060-107f : iTCO_wdt
1100-110f : 0000:00:1f.2
   1100-110f : ata_piix
1180-11bf : pnp 00:05
1200-121f : 0000:00:1d.0
   1200-121f : uhci_hcd
1220-123f : 0000:00:1d.1
   1220-123f : uhci_hcd
1240-125f : 0000:00:1d.2
   1240-125f : uhci_hcd
1300-133f : 0000:00:1f.0
1400-141f : 0000:00:1f.3
   1400-141f : i801_smbus
1640-164f : pnp 00:05
c000-dfff : PCI Bus 0000:01
   c000-c0ff : 0000:01:05.0
   c100-c17f : 0000:01:05.0
   c200-c2ff : 0000:01:04.0
     c200-c2ff : 8139too
   c400-c4ff : PCI CardBus 0000:02
   c800-c8ff : PCI CardBus 0000:02
e000-e007 : 0000:00:02.0

00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000e0000-000fffff : reserved
   000f0000-000fffff : System ROM
00100000-4f7defff : System RAM
   00100000-00329c4a : Kernel code
   00329c4b-0045242f : Kernel data
   004ad000-0056328f : Kernel bss
4f7e0000-4f7fffbf : ACPI Tables
4f7fffc0-4f7fffff : ACPI Non-volatile Storage
50000000-500003ff : 0000:00:1d.7
   50000000-500003ff : ehci_hcd
50001000-50001fff : Intel Flush Page
54000000-57ffffff : PCI CardBus 0000:02
9c000000-9fffffff : PCI Bus 0000:01
   9c000000-9fffffff : PCI CardBus 0000:02
a0000000-afffffff : 0000:00:02.0
cc000000-cfffffff : PCI Bus 0000:01
   cc000000-cc0001ff : 0000:01:05.0
   cc000200-cc0002ff : 0000:01:04.0
     cc000200-cc0002ff : 8139too
   cc001000-cc001fff : 0000:01:02.0
     cc001000-cc001fff : yenta_socket
   cc00c000-cc00ffff : 0000:01:02.2
d0000000-d007ffff : 0000:00:02.0
d0080000-d00bffff : 0000:00:02.0
d0100000-d017ffff : 0000:00:02.1
d0180000-d0183fff : 0000:00:1b.0
   d0180000-d0183fff : ICH HD audio
e0000000-efffffff : PCI MMCONFIG 0 [00-ff]
   e0000000-efffffff : pnp 00:01
     e0000000-efffffff : pnp 00:05
f0008000-f000bfff : pnp 00:01
   f0008000-f000bfff : pnp 00:05
fec00000-fec00fff : IOAPIC 0
   fec00000-fec00fff : pnp 00:01
fed14000-fed17fff : pnp 00:01
   fed14000-fed17fff : pnp 00:05
fed18000-fed18fff : pnp 00:01
   fed18000-fed18fff : pnp 00:05
fed19000-fed19fff : pnp 00:01
   fed19000-fed19fff : pnp 00:05
fed20000-fed8ffff : pnp 00:01
fedff800-fedfffff : 0000:01:02.2
   fedff800-fedfffff : firewire_ohci
fee00000-fee00fff : Local APIC
   fee00000-fee00fff : pnp 00:01
fff00000-ffffffff : reserved

[7.5.] PCI information ('lspci -vvv' as root)
00:00.0 Host bridge: Intel Corporation Mobile 915GM/PM/GMS/910GML Express 
Processor to DRAM Controller (rev 04)
 	Subsystem: Mitac Device 8048
 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ >SERR- <PERR- INTx-
 	Latency: 0
 	Capabilities: [e0] Vendor Specific Information <?>
 	Kernel driver in use: agpgart-intel
 	Kernel modules: intel-agp

00:02.0 VGA compatible controller: Intel Corporation Mobile 915GM/GMS/910GML 
Express Graphics Controller (rev 04) (prog-if 00 [VGA controller])
 	Subsystem: Mitac Device 8048
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
 	Latency: 0
 	Interrupt: pin A routed to IRQ 16
 	Region 0: Memory at d0000000 (32-bit, non-prefetchable) [size=512K]
 	Region 1: I/O ports at e000 [size=8]
 	Region 2: Memory at a0000000 (32-bit, prefetchable) [size=256M]
 	Region 3: Memory at d0080000 (32-bit, non-prefetchable) [size=256K]
 	Capabilities: [d0] Power Management version 2
 		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
 	Kernel modules: intelfb

00:02.1 Display controller: Intel Corporation Mobile 915GM/GMS/910GML Express 
Graphics Controller (rev 04)
 	Subsystem: Mitac Device 8048
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
 	Latency: 0
 	Region 0: Memory at d0100000 (32-bit, non-prefetchable) [size=512K]
 	Capabilities: [d0] Power Management version 2
 		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1b.0 Audio device: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) High 
Definition Audio Controller (rev 04)
 	Subsystem: Mitac Device 8048
 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
 	Latency: 0, Cache Line Size: 16 bytes
 	Interrupt: pin A routed to IRQ 16
 	Region 0: Memory at d0180000 (64-bit, non-prefetchable) [size=16K]
 	Capabilities: [50] Power Management version 2
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
 	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 
Enable-
 		Address: 0000000000000000  Data: 0000
 	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 
<1us
 			ExtTag- RBE- FLReset-
 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
 			MaxPayload 128 bytes, MaxReadReq 128 bytes
 		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
 		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency 
L0 <64ns, L1 <1us
 			ClockPM- Suprise- LLActRep- BwNot-
 		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- 
DLActive- BWMgmt- ABWMgmt-
 	Capabilities: [100] Virtual Channel <?>
 	Capabilities: [130] Root Complex Link <?>
 	Kernel driver in use: HDA Intel
 	Kernel modules: snd-hda-intel

00:1d.0 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) 
USB UHCI #1 (rev 04) (prog-if 00 [UHCI])
 	Subsystem: Mitac Device 8048
 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0
 	Interrupt: pin A routed to IRQ 23
 	Region 4: I/O ports at 1200 [size=32]
 	Kernel driver in use: uhci_hcd
 	Kernel modules: uhci-hcd

00:1d.1 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) 
USB UHCI #2 (rev 04) (prog-if 00 [UHCI])
 	Subsystem: Mitac Device 8048
 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0
 	Interrupt: pin B routed to IRQ 19
 	Region 4: I/O ports at 1220 [size=32]
 	Kernel driver in use: uhci_hcd
 	Kernel modules: uhci-hcd

00:1d.2 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) 
USB UHCI #3 (rev 04) (prog-if 00 [UHCI])
 	Subsystem: Mitac Device 8048
 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0
 	Interrupt: pin C routed to IRQ 18
 	Region 4: I/O ports at 1240 [size=32]
 	Kernel driver in use: uhci_hcd
 	Kernel modules: uhci-hcd

00:1d.7 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) 
USB2 EHCI Controller (rev 04) (prog-if 20 [EHCI])
 	Subsystem: Mitac Device 8048
 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0
 	Interrupt: pin A routed to IRQ 23
 	Region 0: Memory at 50000000 (32-bit, non-prefetchable) [size=1K]
 	Capabilities: [50] Power Management version 2
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
 	Capabilities: [58] Debug port: BAR=1 offset=00a0
 	Kernel driver in use: ehci_hcd
 	Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev d4) (prog-if 
01 [Subtractive decode])
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
 	Latency: 0
 	Bus: primary=00, secondary=01, subordinate=05, sec-latency=32
 	I/O behind bridge: 0000c000-0000dfff
 	Memory behind bridge: cc000000-cfffffff
 	Prefetchable memory behind bridge: 000000009c000000-000000009fffffff
 	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
 	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
 	Capabilities: [50] Subsystem: Mitac Device 8048

00:1f.0 ISA bridge: Intel Corporation 82801FBM (ICH6M) LPC Interface Bridge (rev 
04)
 	Subsystem: Mitac Device 8048
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0
 	Kernel modules: iTCO_wdt, intel-rng

00:1f.2 IDE interface: Intel Corporation 82801FBM (ICH6M) SATA Controller (rev 
04) (prog-if 80 [Master])
 	Subsystem: Mitac Device 8048
 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx+
 	Latency: 0
 	Interrupt: pin B routed to IRQ 19
 	Region 0: I/O ports at 01f0 [size=8]
 	Region 1: I/O ports at 03f4 [size=1]
 	Region 2: I/O ports at 0170 [size=8]
 	Region 3: I/O ports at 0374 [size=1]
 	Region 4: I/O ports at 1100 [size=16]
 	Capabilities: [70] Power Management version 2
 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
 	Kernel driver in use: ata_piix
 	Kernel modules: ata_piix, ahci

00:1f.3 SMBus: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) SMBus 
Controller (rev 04)
 	Subsystem: Mitac Device 8048
 	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
 	Interrupt: pin B routed to IRQ 19
 	Region 4: I/O ports at 1400 [size=32]
 	Kernel driver in use: i801_smbus
 	Kernel modules: i2c-i801

01:02.0 CardBus bridge: Texas Instruments PCIxx21/x515 Cardbus Controller
 	Subsystem: Mitac Device 8048
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 168, Cache Line Size: 32 bytes
 	Interrupt: pin A routed to IRQ 17
 	Region 0: Memory at cc001000 (32-bit, non-prefetchable) [size=4K]
 	Bus: primary=01, secondary=02, subordinate=05, sec-latency=176
 	Memory window 0: 9c000000-9ffff000 (prefetchable)
 	Memory window 1: 54000000-57fff000
 	I/O window 0: 0000c400-0000c4ff
 	I/O window 1: 0000c800-0000c8ff
 	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
 	16-bit legacy interface ports at 0001
 	Kernel driver in use: yenta_cardbus
 	Kernel modules: yenta_socket

01:02.2 FireWire (IEEE 1394): Texas Instruments OHCI Compliant IEEE 1394 Host 
Controller (prog-if 10 [OHCI])
 	Subsystem: Mitac Device 8048
 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 128 (750ns min, 1000ns max), Cache Line Size: 16 bytes
 	Interrupt: pin C routed to IRQ 19
 	Region 0: Memory at fedff800 (32-bit, non-prefetchable) [size=2K]
 	Region 1: Memory at cc00c000 (32-bit, non-prefetchable) [size=16K]
 	Capabilities: [44] Power Management version 2
 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
 		Status: D0 PME-Enable- DSel=0 DScale=0 PME+
 	Kernel driver in use: firewire_ohci
 	Kernel modules: firewire-ohci

01:04.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL-8139/8139C/8139C+ (rev 10)
 	Subsystem: Mitac Device 8048
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 128 (8000ns min, 16000ns max)
 	Interrupt: pin A routed to IRQ 20
 	Region 0: I/O ports at c200 [size=256]
 	Region 1: Memory at cc000200 (32-bit, non-prefetchable) [size=256]
 	Capabilities: [50] Power Management version 2
 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0-,D1+,D2+,D3hot+,D3cold+)
 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
 	Kernel driver in use: 8139too
 	Kernel modules: 8139cp, 8139too

01:05.0 Ethernet controller: Winbond Electronics Corp W89C33D 802.11 a/b/g 
BB/MAC
 	Subsystem: Winbond Electronics Corp W89C33D 802.11 a/b/g BB/MAC
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 128 (16000ns min, 8000ns max), Cache Line Size: 16 bytes
 	Interrupt: pin A routed to IRQ 11
 	Region 0: I/O ports at c000 [size=256]
 	Region 1: I/O ports at c100 [size=128]
 	Region 2: Memory at cc000000 (32-bit, non-prefetchable) [size=512]
 	Capabilities: [dc] Power Management version 2
 		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA 
PME(D0-,D1+,D2-,D3hot+,D3cold-)
 		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

[7.6.] SCSI information (from /proc/scsi/scsi)
        No such file
[7.7.] Other information that might be relevant to the problem
        (please look in /proc and include all information that you
        think to be relevant):

mordor:~# cat /proc/sched_debug
Sched Debug Version: v0.09, 2.6.30-1-686-bigmem #1
now at 673691.041475 msecs
   .jiffies                                 : 93422
   .sysctl_sched_latency                    : 20.000000
   .sysctl_sched_min_granularity            : 4.000000
   .sysctl_sched_wakeup_granularity         : 5.000000
   .sysctl_sched_child_runs_first           : 0.000001
   .sysctl_sched_features                   : 113917

cpu#0, 1296.671 MHz
   .nr_running                    : 2
   .load                          : 2048
   .nr_switches                   : 94933
   .nr_load_updates               : 25172
   .nr_uninterruptible            : 0
   .next_balance                  : 0.093570
   .curr->pid                     : 3436
   .clock                         : 673690.197688
   .cpu_load[0]                   : 0
   .cpu_load[1]                   : 0
   .cpu_load[2]                   : 0
   .cpu_load[3]                   : 0
   .cpu_load[4]                   : 0

cfs_rq[0]:/
   .exec_clock                    : 0.000000
   .MIN_vruntime                  : 27016.942054
   .min_vruntime                  : 27016.937847
   .max_vruntime                  : 27016.942054
   .spread                        : 0.000000
   .spread0                       : 0.000000
   .nr_running                    : 2
   .load                          : 2048
   .nr_spread_over                : 0
   .shares                        : 0

rt_rq[0]:
   .rt_nr_running                 : 0
   .rt_throttled                  : 0
   .rt_time                       : 0.000000
   .rt_runtime                    : 950.000000

runnable tasks:
             task   PID         tree-key  switches  prio     exec-runtime 
sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
             bash  3328     27016.942054       287   120               0 
0               0.000000               0.000000               0.000000 /
R            cat  3436     26996.937847         1   120               0 
0               0.000000               0.000000               0.000000 /



Thanks,
/Jari
