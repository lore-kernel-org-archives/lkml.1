Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbYK0NTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbYK0NTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 08:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbYK0NTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 08:19:41 -0500
Received: from gateway12.websitewelcome.com ([67.18.82.6]:57429 "HELO
	gateway12.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751272AbYK0NTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 08:19:40 -0500
X-Greylist: delayed 8000 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Nov 2008 08:19:39 EST
Message-ID: <492E6628.2030004@ezono.com>
Date: Thu, 27 Nov 2008 10:19:36 +0100
From: Abdelghani Ouchabane <abdelghani@ezono.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Bug report  (27/11/08)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator51.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - ezono.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo,

  when the kernel boots on my machine I got the following Warning:

Do you have any idea?

Cheers,
Rani



WARNING: at kernel/sched.c:4308 sub_preempt_count+0x5a/0x64() (Not tainted)
Modules linked in:
Pid: 1, comm: init Not tainted 2.6.27.5-102.delos.i686 #1
 [<c0640e0a>] ? printk+0xf/0x15
 [<c041f061>] warn_on_slowpath+0x47/0x73
 [<c04aec00>] ? elf_map+0xd4/0xfe
 [<c04adaf7>] ? load_script+0x17b/0x18c
 [<c046c2c8>] ? follow_page+0x195/0x242
 [<c046ae2b>] ? page_address+0xc6/0xeb

 [<c046b13d>] ? kmap_high+0x18a/0x19d
 [<c046ae2b>] ? page_address+0xc6/0xeb
 [<c0422dfe>] ? jiffies_to_timeval+0x1e/0x35
 [<c047d049>] ? virt_to_head_page+0x22/0x2e
 [<c0487c88>] ? do_execve+0x197/0x20b
 [<c0644897>] sub_preempt_count+0x5a/0x64
 [<c0643693>] do_general_protection+0x279/0x2e8
 [<c064341a>] ? do_general_protection+0x0/0x2e8
 [<c0642c22>] error_code+0x6a/0x70
 [<c0403cdb>] irq_return+0x0/0x1
 [<c0401264>] init_post+0x78/0x13c
 [<c0403f0f>] kernel_thread_helper+0x7/0x10
 =======================
---[ end trace 3c4e43cd65c6c420 ]---




System information:

cat /proc/version
Linux version 2.6.27.5.41.fc9.i686 (abdelghani@alder.ezono.net) (gcc 
version 4.3.0 20080428 (Red Hat 4.3.0-8) (GCC) ) #1 PREEMPT Thu Nov 27 
08:41:53 CET 2008





cat /proc/cpuinfo
processor    : 0
vendor_id    : GenuineIntel
cpu family    : 6
model        : 14
model name    : Intel(R) Celeron(R) M CPU        423  @ 1.06GHz
stepping    : 8
cpu MHz        : 1063.986
cache size    : 1024 KB
fdiv_bug    : no
hlt_bug        : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 10
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov 
pat clflush dts acpi mmx fxsr sse sse2 ss tm pbe nx constant_tsc 
arch_perfmon bts pni monitor tm2 xtpr
bogomips    : 2127.97
clflush size    : 64
power management:


cat /proc/modules
cgosdrv 18392 0 - Live 0xf8c6d000 (P)
nfs 216304 3 - Live 0xf8c9d000
nfs_acl 2432 1 nfs, Live 0xf8a7e000
lockd 53556 1 nfs, Live 0xf8c8e000
sunrpc 153120 16 nfs,nfs_acl,lockd, Live 0xf8d0f000
ipv6 233124 12 - Live 0xf8cd5000
ext2 54088 1 - Live 0xf8c7f000
ext3 104776 1 - Live 0xf90e8000
jbd 39444 1 ext3, Live 0xf90bd000
mbcache 6400 2 ext2,ext3, Live 0xf8baf000
dm_mirror 16064 0 - Live 0xf8bb5000
dm_log 8256 1 dm_mirror, Live 0xf8bab000
dm_mod 45420 2 dm_mirror,dm_log, Live 0xf8bba000
joydev 8704 0 - Live 0xf8afc000
pcspkr 2240 0 - Live 0xf8af6000
i2c_i801 7760 0 - Live 0xf8ac6000
iTCO_wdt 9760 1 - Live 0xf8a85000
iTCO_vendor_support 2692 1 iTCO_wdt, Live 0xf88fe000
sg 28016 0 - Live 0xf8ba3000
asix 12416 0 - Live 0xf8ac9000
usbnet 13000 1 asix, Live 0xf8a8d000
mii 4032 2 asix,usbnet, Live 0xf8836000
usbtouchscreen 8324 0 - Live 0xf8a89000
snd_hda_intel 346836 1 - Live 0xf8bf3000
snd_seq_dummy 2436 0 - Live 0xf8838000
snd_seq_oss 27156 0 - Live 0xf8a6b000
snd_seq_midi_event 5824 1 snd_seq_oss, Live 0xf89cf000
snd_seq 46776 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event, Live 
0xf8ab6000
i915 82436 0 - Live 0xf8acf000
snd_seq_device 5900 3 snd_seq_dummy,snd_seq_oss,snd_seq, Live 0xf89cc000
snd_pcm_oss 38336 0 - Live 0xf8a73000
snd_mixer_oss 12928 2 snd_pcm_oss, Live 0xf89d2000
snd_pcm 61640 2 snd_hda_intel,snd_pcm_oss, Live 0xf89e9000
drm 142360 1 i915, Live 0xf8a92000
snd_timer 18500 2 snd_seq,snd_pcm, Live 0xf899c000
snd_page_alloc 6856 2 snd_hda_intel,snd_pcm, Live 0xf88fb000 cat 
/proc/ioports
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0071 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:1f.1
  0170-0177 : ata_piix
01f0-01f7 : 0000:00:1f.1
  01f0-01f7 : ata_piix
0376-0376 : 0000:00:1f.1
  0376-0376 : ata_piix
03c0-03df : vga+
03f6-03f6 : 0000:00:1f.1
  03f6-03f6 : ata_piix
0400-041f : 0000:00:1f.3
  0400-041f : i801_smbus
0480-04bf : 0000:00:1f.0
  0480-04bf : pnp 00:06
04d0-04d1 : pnp 00:06
0800-087f : 0000:00:1f.0
  0800-087f : pnp 00:06
    0800-0803 : ACPI PM1a_EVT_BLK
    0804-0805 : ACPI PM1a_CNT_BLK
    0808-080b : ACPI PM_TMR
    0810-0815 : ACPI CPU throttle
    0820-0820 : ACPI PM2_CNT_BLK
    0828-082f : ACPI GPE0_BLK
    0860-087f : iTCO_wdt
0cf8-0cff : PCI conf1
d480-d49f : 0000:00:1d.2
  d480-d49f : uhci_hcd
d800-d81f : 0000:00:1d.1
  d800-d81f : uhci_hcd
d880-d89f : 0000:00:1d.0
  d880-d89f : uhci_hcd
dc00-dc07 : 0000:00:02.0
e000-efff : PCI Bus 0000:03
  e800-e8ff : 0000:03:00.0
ffa0-ffaf : 0000:00:1f.1
  ffa0-ffaf : ata_piix
i2c_algo_bit 4740 1 i915, Live 0xf887b000
snd_hwdep 6532 1 snd_hda_intel, Live 0xf8856000
snd 46900 10 
snd_hda_intel,snd_seq_dummy,snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_timer,snd_hwdep, 
Live 0xf89dc000
i2c_core 17360 4 i2c_i801,i915,drm,i2c_algo_bit, Live 0xf89a3000
soundcore 5508 2 snd, Live 0xf8853000
ata_generic 4356 0 - Live 0xf8850000
ata_piix 20868 3 - Live 0xf8862000
pata_acpi 3584 0 - Live 0xf8832000
libata 133216 3 ata_generic,ata_piix,pata_acpi, Live 0xf89aa000
sd_mod 28372 4 - Live 0xf885a000
scsi_mod 122084 3 sg,libata,sd_mod, Live 0xf88c1000
crc_t10dif 1600 1 sd_mod, Live 0xf8834000
xfs 431144 2 - Live 0xf89fb000
uhci_hcd 19536 0 - Live 0xf884a000
ohci_hcd 21008 0 - Live 0xf8843000
ehci_hcd 29324 0 - Live 0xf883a000 cat /proc/ioports
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0071 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:1f.1
  0170-0177 : ata_piix
01f0-01f7 : 0000:00:1f.1
  01f0-01f7 : ata_piix
0376-0376 : 0000:00:1f.1
  0376-0376 : ata_piix
03c0-03df : vga+
03f6-03f6 : 0000:00:1f.1
  03f6-03f6 : ata_piix
0400-041f : 0000:00:1f.3
  0400-041f : i801_smbus
0480-04bf : 0000:00:1f.0
  0480-04bf : pnp 00:06
04d0-04d1 : pnp 00:06
0800-087f : 0000:00:1f.0
  0800-087f : pnp 00:06
    0800-0803 : ACPI PM1a_EVT_BLK
    0804-0805 : ACPI PM1a_CNT_BLK
    0808-080b : ACPI PM_TMR
    0810-0815 : ACPI CPU throttle
    0820-0820 : ACPI PM2_CNT_BLK
    0828-082f : ACPI GPE0_BLK
    0860-087f : iTCO_wdt
0cf8-0cff : PCI conf1
d480-d49f : 0000:00:1d.2
  d480-d49f : uhci_hcd
d800-d81f : 0000:00:1d.1
  d800-d81f : uhci_hcd
d880-d89f : 0000:00:1d.0
  d880-d89f : uhci_hcd
dc00-dc07 : 0000:00:02.0
e000-efff : PCI Bus 0000:03
  e800-e8ff : 0000:03:00.0
ffa0-ffaf : 0000:00:1f.1
  ffa0-ffaf : ata_piix




cat /proc/iomem
00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000e0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-3d5fffff : System RAM
  00400000-006464dd : Kernel code
  006464de-0075c417 : Kernel data
  007ab000-00843acf : Kernel bss
3f7c0000-3f7cdfff : ACPI Tables
3f7ce000-3f7fffff : ACPI Non-volatile Storage
d0000000-dfffffff : 0000:00:02.0
e0000000-e3ffffff : PCI MMCONFIG 0
  e0000000-e3ffffff : pnp 00:0c
fdf00000-fdffffff : PCI Bus 0000:02
  fdfc0000-fdfdffff : 0000:02:00.0
  fdffe000-fdffefff : 0000:02:00.0
  fdfff000-fdffffff : 0000:02:00.0
fe980000-fe9fffff : 0000:00:02.1
fea37c00-fea37fff : 0000:00:1d.7
  fea37c00-fea37fff : ehci_hcd
fea38000-fea3bfff : 0000:00:1b.0
  fea38000-fea3bfff : ICH HD audio
fea40000-fea7ffff : 0000:00:02.0
fea80000-feafffff : 0000:00:02.0
feb00000-febfffff : PCI Bus 0000:03
  febc0000-febdffff : 0000:03:00.0
  febff000-febfffff : 0000:03:00.0
fec00000-fec00fff : pnp 00:0b
fed13000-fed19fff : pnp 00:01
fed1c000-fed1ffff : pnp 00:06
fed20000-fed3ffff : pnp 00:06
fed40000-fed8ffff : pnp 00:06
fee00000-fee00fff : reserved
ffb00000-ffffffff : reserved


cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: InnoDisk Corp. - Rev: 0712
  Type:   Direct-Access                    ANSI  SCSI revision: 05












