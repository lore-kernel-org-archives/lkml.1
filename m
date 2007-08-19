Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbXHSUuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbXHSUuz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 16:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbXHSUuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 16:50:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:31924 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbXHSUup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 16:50:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=RIsnhreiSDR7S3NNy945I/GVMh83vWbSwBCCD3xvYT8YG+WZdEW7YwzNnqGObm/WR6WVFiT3+5CWFc1yDMTd0r83gl6KAoImjW+UDthQoyHjIQlwoF4/7I7OtrmeELUC9SIt/hqMiRlAtUuCb2QFRniT7w+2LrAEYBjpobtLykE=
Message-ID: <f822aa1f0708191350k45269563u1422fc45d4f03fac@mail.gmail.com>
Date: Sun, 19 Aug 2007 22:50:44 +0200
From: h.verhagen.web104@dse.nl
To: linux-kernel@vger.kernel.org
Subject: kernel BUG at lib/list_debug.c:27!
In-Reply-To: <f822aa1f0708191008p64bdd6fcj3e6bbf848b24e134@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f822aa1f0708191008p64bdd6fcj3e6bbf848b24e134@mail.gmail.com>
X-Google-Sender-Auth: 4896212f2e3a074c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

According to dmesg, I encountered a kernel bug on my system.
I'm not sure if this is the appropriate place to report this problem
as this occured on a Fedora kernel. Maybe its a general problem?


kernel BUG at lib/list_debug.c:27!
invalid opcode: 0000 [2] SMP

 ===========================================
= What was I doing when this happened.
==========================================
I was   doing a  rm -rf   /media/somedir/   command  on a
USB harddisk.  This USB harddisk casing contained a flaky IDE
harddisk.  (smartd had been giving warnings about this drive for a
while, that it was about to break doing.

What happened.

The rm  stuck, (couldn't be killed, even with a kill -9 command).
dmesg showed a kernel bug.


===================================
=  Version
====================================
Fedora core 7.

[harm@localhost ~]# uname -a
Linux localhost.localdomain 2.6.22.1-41.fc7 #1 SMP Fri Jul 27 18:21:43
EDT 2007 x86_64 x86_64 x86_64 GNU/Linux



[harm@localhost scripts]$ ./ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux localhost.localdomain 2.6.22.1-41.fc7 #1 SMP Fri Jul 27 18:21:43
EDT 2007 x86_64 x86_64 x86_64 GNU/Linux

Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17.50.0.12-4
util-linux             2.13-pre7
mount                  2.13-pre7
module-init-tools      3.3-pre11
 e2fsprogs              1.39
pcmciautils            014
quota-tools            3.14.
PPP                    2.4.4
Linux C Library        > libc.2.6
Dynamic linker (ldd)   2.6
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
oprofile               0.9.2
Sh-utils               6.9
udev                   113
wireless-tools         28
Modules Loaded         loop ppdev tun nls_utf8 autofs4 hidp rfcomm
l2cap bluetooth sunrpc nf_conntrack_netbios_ns nf_conntrack_ipv4
xt_state nf_conntrack nfnetlink xt_tcpudp ipt_REJECT x_tables
cpufreq_ondemand acpi_cpufreq vfat fat dm_mirror dm_multipath dm_mod
video sbs button dock battery ac ipv6 sr_mod cdrom parport_pc parport
snd_hda_intel snd_seq_dummy via_rhine i2c_viapro snd_seq_oss
snd_seq_midi_event snd_seq serio_raw snd_seq_device rtc_cmos
snd_pcm_oss mii i2c_core usb_storage snd_mixer_oss floppy pata_via
shpchp snd_pcm snd_timer snd soundcore snd_page_alloc sg ahci sata_via
ata_generic libata sd_mod scsi_mod ext3 jbd mbcache ehci_hcd ohci_hcd
uhci_hcd


================================
= OOPS/kernel output
================================

kernel BUG at lib/list_debug.c:27!
invalid opcode: 0000 [2] SMP
last sysfs file: /block/sdf/size
CPU 1
Modules linked in: loop ppdev tun nls_utf8 autofs4 hidp rfcomm l2cap
bluetooth sunrpc nf_conntrack_netbios_ns nf_conntrack_ipv4 xt_state
nf_conntrack nfnetlink xt_tcpudp ipt_REJECT x_tables cpufreq_ondemand
acpi_cpufreq vfat fat dm_mirror dm_multipath dm_mod video sbs button
dock battery ac ipv6 sr_mod cdrom parport_pc parport snd_hda_intel
snd_seq_dummy via_rhine i2c_viapro snd_seq_oss snd_seq_midi_event
snd_seq serio_raw snd_seq_device rtc_cmos snd_pcm_oss mii i2c_core
usb_storage snd_mixer_oss floppy pata_via shpchp snd_pcm snd_timer snd
soundcore snd_page_alloc sg ahci sata_via ata_generic libata sd_mod
scsi_mod ext3 jbd mbcache ehci_hcd ohci_hcd uhci_hcd
Pid: 11136, comm: rm Not tainted 2.6.22.1-41.fc7 #1
RIP: 0010:[<ffffffff81118f7a>]  [<ffffffff81118f7a>] __list_add+0x27/0x5b
RSP: 0018:ffff810027079de8  EFLAGS: 00010282
RAX: 0000000000000079 RBX: 0000000000000000 RCX: 000000000004f977
RDX: 00000000ffffffff RSI: ffff8100076fd7c8 RDI: 0000000000000000
RBP: ffff81001f9029c8 R08: 0000000000000010 R09: 0000000000000010
R10: 0000000000000000 R11: 0000000000000000 R12: ffff810018398400
R13: ffff8100076fd7c8 R14: ffff81001f902900 R15: ffff810027079e08
FS:  00002aaaaaae0270(0000) GS:ffff810001591280(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000f183e0 CR3: 0000000011668000 CR4: 00000000000006e0
Process rm (pid: 11136, threadinfo ffff810027078000, task ffff81000b5ff000)
Stack:  ffff810027079e08 ffffffff8804303e ffff8100076fd7c8 ffff81001f902990
 ffff810017fc9888 0000000000000180 0000000000000029 ffffffff8803dc8e
 ffff8100072d17b8 ffff81001f9029c8 ffff8100076fd7c8 ffff810017ebf9c8
Call Trace:
 [<ffffffff8804303e>] :ext3:ext3_orphan_add+0x14b/0x187
 [<ffffffff8803dc8e>] :ext3:ext3_mark_inode_dirty+0x44/0x4d
 [<ffffffff88044087>] :ext3:ext3_unlink+0x16e/0x1d5
 [<ffffffff8109af23>] vfs_unlink+0xbc/0x102
 [<ffffffff8109ce8f>] do_unlinkat+0xaa/0x144
 [<ffffffff8109efda>] sys_getdents+0xaf/0xbd
 [<ffffffff8109e5b2>] sys_fcntl+0x2d7/0x2e3
 [<ffffffff81009b5e>] system_call+0x7e/0x83


Code: 0f 0b eb fe 4c 8b 00 49 39 f0 74 18 48 89 c1 4c 89 c2 48 c7
RIP  [<ffffffff81118f7a>] __list_add+0x27/0x5b
 RSP <ffff810027079de8>
WARNING: at kernel/exit.c:814 do_exit() (Not tainted)

 Call Trace:
 [<ffffffff81035f5e>] do_exit+0x59/0x7db
 [<ffffffff8100b31a>] kernel_math_error+0x0/0x71
 [<ffffffff8100b736>] do_invalid_op+0x85/0x8f
 [<ffffffff81118f7a>] __list_add+0x27/0x5b
 [<ffffffff810339b1>] printk+0x52/0xaf
 [<ffffffff88027bfc>] :jbd:do_get_write_access+0x4c1/0x4f6
 [<ffffffff812492fd>] error_exit+0x0/0x84
 [<ffffffff81118f7a>] __list_add+0x27/0x5b
  [<ffffffff81118f7a>] __list_add+0x27/0x5b
 [<ffffffff8804303e>] :ext3:ext3_orphan_add+0x14b/0x187
 [<ffffffff8803dc8e>] :ext3:ext3_mark_inode_dirty+0x44/0x4d
 [<ffffffff88044087>] :ext3:ext3_unlink+0x16e/0x1d5
 [<ffffffff8109af23>] vfs_unlink+0xbc/0x102
 [<ffffffff8109ce8f>] do_unlinkat+0xaa/0x144
 [<ffffffff8109efda>] sys_getdents+0xaf/0xbd
 [<ffffffff8109e5b2>] sys_fcntl+0x2d7/0x2e3
 [<ffffffff81009b5e>] system_call+0x7e/0x83

===============================================
=  CPU
===============================================

[root@localhost ~]# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
 cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz
stepping        : 6
cpu MHz         : 1600.000
cache size      : 4096 KB
physical id     : 0
 siblings        : 2
core id         : 0
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall
nx lm constant_tsc pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr
lahf_lm
bogomips        : 4790.92
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz
stepping        : 6
cpu MHz         : 1600.000
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall
nx lm constant_tsc pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr
lahf_lm
bogomips        : 4787.30
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
