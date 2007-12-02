Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239AbXLBRC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbXLBRC6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 12:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbXLBRCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 12:02:51 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:5082 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbXLBRCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 12:02:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=pg5cb3AriCjEzSIF6v4oPB9Kl0ozJ5eypE9ArtX6cKRiMNYT1M0FxhBS6bDOv30BbY+8Q9tMAEbphzwk/Xzm+8LPKmLbhXg6CO9tqX2AYEPlCvB1yqJfbleWvfcCdsz+MPjwXTWOStNLtYFjxCRNMNQyooRR3Rse9TBFaWcLu4s=
Message-ID: <3aa654a40712020902i7aa31320kc0bb89b7c1289c86@mail.gmail.com>
Date: Sun, 2 Dec 2007 09:02:48 -0800
From: "Avuton Olrich" <avuton@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: BUG: XFS/firefox-bin (2.6.23.8)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2.6.23.8 just crashed here, it had been up 8 days and suspended to
disk many times in those 8 days. The process that crashed it was
firefox-3.0b1. It crashed and could not be killed (please excuse me, I
failed to get ps auxf output).

All of the following information was after reboot, except, of course,
for the BUG.

cat /proc/fs/xfs/stat:
extent_alloc 590 6602 823 16626
abt 4378 35490 1501 1705
blk_map 53120 8935 1970 7588 1425 64034 0
bmbt 31 173 11 19
dir 14160 963 1095 3481
trans 264 6537 1170
ig 8078 563 177 7515 0 839 294
log 1088 30668 438 974 540
push_ail 7971 0 0 0 0 0 0 0 0 0
xstrat 577 0
rw 7928 34834
attr 0 0 0 0
icluster 394 157 1094
vnodes 6674 7867 0 6338 1193 1193 1193 0
buf 43987 29877 14148 14 10 0 0 39734 2450
xpc 26988544 33316872 63098104
debug 0


lspci -vvv:
http://avuton.googlepages.com/lspci-vvv

/proc/iomem:
00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000ccfff : Video ROM
000f0000-000fffff : System ROM
00100000-7ffeffff : System RAM
  00100000-00428abb : Kernel code
  00428abc-0051adbb : Kernel data
7fff0000-7fff2fff : ACPI Non-volatile Storage
7fff3000-7fffffff : ACPI Tables
88000000-880fffff : PCI Bus #01
  88000000-8801ffff : 0000:01:06.0
  88020000-8802ffff : 0000:01:08.0
d0000000-dfffffff : PCI Bus #02
  d0000000-d7ffffff : 0000:02:00.0
  d8000000-dfffffff : 0000:02:00.1
e0000000-e3ffffff : 0000:00:00.0
e4000000-e5ffffff : PCI Bus #02
  e4000000-e401ffff : 0000:02:00.0
  e5000000-e500ffff : 0000:02:00.0
  e5010000-e501ffff : 0000:02:00.1
e6000000-e7ffffff : PCI Bus #01
  e7000000-e70000ff : 0000:01:06.0
    e7000000-e70000ff : r8169
e8000000-e807ffff : 0000:00:05.0
e8080000-e8080fff : 0000:00:06.0
  e8080000-e8080fff : NVidia nForce2
e8081000-e8081fff : 0000:00:02.1
  e8081000-e8081fff : ohci_hcd
e8082000-e80820ff : 0000:00:02.2
  e8082000-e80820ff : ehci_hcd
e8083000-e8083fff : 0000:00:02.0
  e8083000-e8083fff : ohci_hcd
fec00000-fec00fff : reserved
fee00000-fee00fff : reserved
ffff0000-ffffffff : reserved

/proc/ioports:
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
0170-0177 : 0000:00:09.0
  0170-0177 : libata
01f0-01f7 : 0000:00:09.0
  01f0-01f7 : libata
0376-0376 : 0000:00:09.0
  0376-0376 : libata
03b0-03bf : ega
03f6-03f6 : 0000:00:09.0
  03f6-03f6 : libata
0cf8-0cff : PCI conf1
4000-407f : pnp 00:00
  4000-4003 : ACPI PM1a_EVT_BLK
  4004-4005 : ACPI PM1a_CNT_BLK
  4008-400b : ACPI PM_TMR
  4020-4027 : ACPI GPE0_BLK
4080-40ff : pnp 00:00
4200-427f : pnp 00:00
4280-42ff : pnp 00:00
4400-447f : pnp 00:00
4480-44ff : pnp 00:00
  44a0-44af : ACPI GPE1_BLK
5000-503f : pnp 00:01
  5000-503f : nForce2_smbus
5100-513f : pnp 00:01
  5100-513f : nForce2_smbus
a000-cfff : PCI Bus #01
  a000-a0ff : 0000:01:06.0
    a000-a0ff : r8169
  a400-a407 : 0000:01:08.0
  a800-a803 : 0000:01:08.0
  ac00-ac07 : 0000:01:08.0
  b000-b003 : 0000:01:08.0
  b400-b40f : 0000:01:08.0
  b800-b8ff : 0000:01:08.0
d000-dfff : PCI Bus #02
  d000-d0ff : 0000:02:00.0
e000-e07f : 0000:00:06.0
  e000-e07f : NVidia nForce2
e400-e41f : 0000:00:01.1
e800-e8ff : 0000:00:06.0
  e800-e8ff : NVidia nForce2
f000-f00f : 0000:00:09.0
  f000-f00f : libata

/proc/version:
Linux version 2.6.23.8 (sbh@tulip) (gcc version 4.2.2 (Gentoo 4.2.2
p1.0)) #4 PREEMPT Fri Nov 16 11:23:29 PST 2007

ver_linux:
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

/proc/modules:
netconsole 2528 0 - Live 0xf88aa000
snd_pcm_oss 36256 0 - Live 0xf8a81000
snd_mixer_oss 14144 1 snd_pcm_oss, Live 0xf8a70000
cdc_acm 13216 0 - Live 0xf88b0000

/proc/cpuinfo:
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 6
model           : 8
model name      : AMD Athlon(tm) XP 2700+
stepping        : 1
cpu MHz         : 2162.770
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 mmx fxsr sse syscall mmxext 3dnowext 3dnow ts
bogomips        : 4329.93
clflush size    : 32

/proc/version:
Linux tulip 2.6.23.8 #4 PREEMPT Fri Nov 16 11:23:29 PST 2007 i686 AMD
Athlon(tm) XP 2700+ AuthenticAMD GNU/Linux

Gnu C                  4.1.2
Gnu make               3.81
binutils               Binutils
util-linux             2.13
mount                  2.13
module-init-tools      3.4
e2fsprogs              1.40.2
xfsprogs               2.9.4
PPP                    2.4.4
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.13
Sh-utils               6.9
udev                   117
Modules Loaded         netconsole snd_pcm_oss snd_mixer_oss cdc_acm

Config:
http://avuton.googlepages.com/config.gz

Dmesg (After the next bootup):
http://avuton.googlepages.com/tulip.dmesg

This was the only interesting thing in the desg after the crash:
BUG:
[ 3158.936251] BUG: unable to handle kernel NULL pointer dereference
at virtual address 00000000
[ 3158.936260]  printing eip:
[ 3158.936261] c013405b
[ 3158.936262] *pde = 00000000
[ 3158.936266] Oops: 0002 [#1]
[ 3158.936276] PREEMPT
[ 3158.936282] Modules linked in: cdc_acm netconsole snd_pcm_oss snd_mixer_oss
[ 3158.936297] CPU:    0
[ 3158.936298] EIP:    0060:[<c013405b>]    Not tainted VLI
[ 3158.936299] EFLAGS: 00210246   (2.6.23.8 #4)
[ 3158.936312] EIP is at current_kernel_time+0x2b/0x40
[ 3158.936316] eax: 00000000   ebx: 24a60770   ecx: 00000000   edx: 0f99c038
[ 3158.936320] esi: 00402000   edi: 00000007   ebp: 000081a4   esp: ee429ce0
[ 3158.936323] ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
[ 3158.936327] Process firefox-bin (pid: 11154, ti=ee428000
task=eec00540 task.ti=ee428000)
[ 3158.936331] Stack: f177ac00 f21128c0 00000007 000081a4 c026495a
00008000 efeb4180 00000000
[ 3158.936348]        c023ac60 098c745c 00000000 00000001 00000004
ee429d30 00000000 f7c129e0
[ 3158.936366]        f21128c0 00000000 098c745c 00000000 f177ac00
f7c129e0 00000000 ee429e18
[ 3158.936451] Call Trace:
[ 3158.936455]  [<c026495a>] xfs_ichgtime+0x1a/0xa0
[ 3158.936465]  [<c023ac60>] xfs_ialloc+0x230/0x620
[ 3158.936473]  [<c0252345>] xfs_dir_ialloc+0x85/0x2d0
[ 3158.936483]  [<c024f0b2>] xfs_trans_reserve+0x82/0x200
[ 3158.936489]  [<c02585c6>] xfs_create+0x386/0x690
[ 3158.936494]  [<c01793b0>] dput+0x20/0x150
[ 3158.936501]  [<c013a3a6>] futex_wait+0x266/0x360
[ 3158.936507]  [<c0258240>] xfs_create+0x0/0x690
[ 3158.936511]  [<c026486b>] xfs_vn_mknod+0x15b/0x200
[ 3158.936516]  [<c0264930>] xfs_vn_create+0x0/0x10
[ 3158.936521]  [<c0170483>] vfs_create+0x93/0xd0
[ 3158.936525]  [<c017358e>] open_namei+0x53e/0x650
[ 3158.936530]  [<c0153802>] do_wp_page+0x312/0x4a0
[ 3158.936537]  [<c0166b7e>] do_filp_open+0x2e/0x60
[ 3158.936542]  [<c016681e>] get_unused_fd_flags+0x4e/0xe0
[ 3158.936546]  [<c0166bfc>] do_sys_open+0x4c/0xe0
[ 3158.936612]  [<c0166ccc>] sys_open+0x1c/0x20
[ 3158.936616]  [<c01040ee>] sysenter_past_esp+0x5f/0x85
[ 3158.936622]  =======================
[ 3158.936624] Code: 55 8b 0d 80 a4 56 c0 57 56 53 eb 06 8d 74 26 00
89 d1 8b 1d b4 a4 56 c0 8b 35 b0 a4 56 c0 8b 15 80 a4 56 c0 89 c8 83
e1 01 31 d0 <09> c8 75 e1 89 da 89 f0 5b 5e 5f 5d c3 90 8d b4 26 00 00
00 00
-- 
avuton
--
 Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
