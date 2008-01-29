Return-Path: <linux-kernel-owner+w=401wt.eu-S1757023AbYA2RjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbYA2RjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYA2RjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:39:03 -0500
Received: from www.emergencycommunicationsystems.com ([24.123.23.170]:45611
	"EHLO unifiedpaging.messagenetsystems.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752017AbYA2RjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:39:00 -0500
Message-ID: <479F64A3.8040808@pagestation.com>
Date: Tue, 29 Jan 2008 12:38:43 -0500
From: Jerry Geis <geisj@pagestation.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071220)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel crash in 2.6.21
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is a kernel crash for 2.6.21

The kernel runs for a number of days/weeks and then the crash below.
I am not running X windows. Just a server.

Jerry

-------------------------------

00:00.0 RAM memory: nVidia Corporation MCP61 Memory Controller (rev a1)
00:01.0 ISA bridge: nVidia Corporation MCP61 LPC Bridge (rev a2)
00:01.1 SMBus: nVidia Corporation MCP61 SMBus (rev a2)
00:01.2 RAM memory: nVidia Corporation MCP61 Memory Controller (rev a2)
00:02.0 USB Controller: nVidia Corporation MCP61 USB Controller (rev a3)
00:02.1 USB Controller: nVidia Corporation MCP61 USB Controller (rev a3)
00:04.0 PCI bridge: nVidia Corporation MCP61 PCI bridge (rev a1)
00:05.0 Audio device: nVidia Corporation MCP61 High Definition Audio 
(rev a2)
00:06.0 IDE interface: nVidia Corporation MCP61 IDE (rev a2)
00:07.0 Bridge: nVidia Corporation MCP61 Ethernet (rev a2)
00:08.0 IDE interface: nVidia Corporation MCP61 SATA Controller (rev a2)
00:08.1 IDE interface: nVidia Corporation MCP61 SATA Controller (rev a2)
00:0d.0 VGA compatible controller: nVidia Corporation GeForce 6100 
nForce 430 (rev a2)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
01:08.0 Ethernet controller: Digium, Inc. Wildcard TDM800P 8-port analog 
card (rev 11)
01:0e.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23 
IEEE-1394a-2000 Controller (PHY/Link)

Module                  Size  Used by
ipv6                  447328  18
autofs4                57992  0
sunrpc                213480  1
iptable_filter         36736  0
ip_tables              55888  1 iptable_filter
x_tables               54664  1 ip_tables
dm_mirror              55488  0
dm_mod                 95632  1 dm_mirror
video                  52880  0
button                 42528  0
battery                44680  0
asus_acpi              52268  0
ac                     39432  0
ohci_hcd               55172  0
ehci_hcd               67980  0
snd_hda_intel          55840  4
snd_hda_codec         289096  1 snd_hda_intel
snd_pcm_oss            78080  0
snd_mixer_oss          50560  1 snd_pcm_oss
snd_pcm               118920  5 snd_hda_intel,snd_hda_codec,snd_pcm_oss
snd_timer              57992  3 snd_pcm
snd                    96680  10 
snd_hda_intel,snd_hda_codec,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_timer
soundcore              42272  1 snd
snd_page_alloc         43920  2 snd_hda_intel,snd_pcm
wctdm24xxp            144704  2
zaptel                230088  7 wctdm24xxp
crc_ccitt              35712  1 zaptel
forcedeth              81160  0
ide_cd                 74784  0
cdrom                  69800  1 ide_cd
ext3                  164752  2
jbd                    96880  1 ext3
raid1                  56832  2
sata_nv                54916  6
libata                155168  1 sata_nv
sd_mod                 54272  8
scsi_mod              189496  2 libata,sd_mod

Running Centos 4.6 x86_64.

Jan 26 04:05:28 ksdsigns kernel: CR2: 00000000007ac000 CR3: 
000000003b2cd000 CR4: 00000000000006e0
Jan 26 04:05:28 ksdsigns kernel: Process prelink (pid: 29143, threadinfo 
ffff81004d830000, task ffff810033a61780)
Jan 26 04:05:28 ksdsigns kernel: Stack:  0000000000776ca0 
0000000000001000 ffff81004d831bb8 0000000000000000
Jan 26 04:05:28 ksdsigns kernel:  0000000000775ca0 ffffffff8100f933 
ffff81007bfd9380 ffff810035700780
Jan 26 04:05:28 ksdsigns kernel:  0000000000000012 ffff810035700780 
ffffffff880b1440 ffff810035700890
Jan 26 04:05:28 ksdsigns kernel: Call Trace:
Jan 26 04:05:28 ksdsigns kernel:  [<ffffffff8100f933>] 
generic_file_buffered_write+0x18b/0x6d4
Jan 26 04:05:28 ksdsigns kernel:  [<ffffffff81015a14>] 
__generic_file_aio_write_nolock+0x403/0x436
Jan 26 04:05:28 ksdsigns kernel:  [<ffffffff81018bdf>] __getblk+0x24/0x213
Jan 26 04:05:28 ksdsigns kernel:  [<ffffffff880ae87a>] 
:ext3:__ext3_journal_dirty_metadata+0x1b/0x45
Jan 26 04:05:28 ksdsigns kernel:  [<ffffffff81020961>] 
generic_file_aio_write+0x61/0xc1
Jan 26 04:05:28 ksdsigns kernel:  [<ffffffff880a11b1>] 
:ext3:ext3_file_write+0x16/0x9d
Jan 26 04:05:28 ksdsigns kernel:  [<ffffffff8101750d>] 
do_sync_write+0xc8/0x10b
Jan 26 04:05:28 ksdsigns kernel:  [<ffffffff81098987>] 
autoremove_wake_function+0x0/0x2e
Jan 26 04:05:28 ksdsigns kernel:  [<ffffffff8102b870>] 
notify_change+0x307/0x319
Jan 26 04:05:28 ksdsigns kernel:  [<ffffffff81015de8>] vfs_write+0xd4/0x158
Jan 26 04:05:28 ksdsigns kernel:  [<ffffffff81041b61>] 
sys_pwrite64+0x56/0x76
Jan 26 04:05:28 ksdsigns kernel:  [<ffffffff8105a11e>] system_call+0x7e/0x83
Jan 26 04:05:28 ksdsigns kernel:
Jan 26 04:05:29 ksdsigns kernel:
Jan 26 04:05:29 ksdsigns kernel: Code: 8b 00 f6 c4 40 74 04 48 8b 55 10 
f0 ff 42 08 f0 0f ba 6d 00
Jan 26 04:05:29 ksdsigns kernel: RIP  [<ffffffff81013124>] 
find_lock_page+0x2e/0x95
Jan 26 04:05:29 ksdsigns kernel:  RSP <ffff81004d831b28>
                                             

[root@ksdsigns log]# more /proc/ioports
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:06.0
01f0-01f7 : 0000:00:06.0
  01f0-01f7 : ide0
02f8-02ff : serial
0376-0376 : 0000:00:06.0
03c0-03df : vga+
03f6-03f6 : 0000:00:06.0
  03f6-03f6 : ide0
03f8-03ff : serial
0960-0967 : 0000:00:08.1
  0960-0967 : sata_nv
0970-0977 : 0000:00:08.0
  0970-0977 : sata_nv
09e0-09e7 : 0000:00:08.1
  09e0-09e7 : sata_nv
09f0-09f7 : 0000:00:08.0
  09f0-09f7 : sata_nv
0b60-0b63 : 0000:00:08.1
  0b60-0b63 : sata_nv
0b70-0b73 : 0000:00:08.0
  0b70-0b73 : sata_nv
0be0-0be3 : 0000:00:08.1
  0be0-0be3 : sata_nv
0bf0-0bf3 : 0000:00:08.0
  0bf0-0bf3 : sata_nv
0cf8-0cff : PCI conf1
1000-107f : pnp 00:01
  1000-1003 : ACPI PM1a_EVT_BLK
  1004-1005 : ACPI PM1a_CNT_BLK
  1008-100b : ACPI PM_TMR
  101c-101c : ACPI PM2_CNT_BLK
  1020-1027 : ACPI GPE0_BLK
1080-10ff : pnp 00:01
1400-147f : pnp 00:01
1480-14ff : pnp 00:01
  14a0-14af : ACPI GPE1_BLK
1800-187f : pnp 00:01
1880-18ff : pnp 00:01
1c00-1c3f : 0000:00:01.1
1c40-1c7f : 0000:00:01.1
a000-afff : PCI Bus #01
  a000-a0ff : 0000:01:08.0
    a000-a0fe : wctdm24xxp
b800-b83f : 0000:00:01.1
bc00-bc07 : 0000:00:07.0
  bc00-bc07 : forcedeth
d000-d00f : 0000:00:08.0
  d000-d00f : sata_nv
e400-e40f : 0000:00:08.1
  e400-e40f : sata_nv
f000-f00f : 0000:00:06.0
  f000-f007 : ide0

                                     
