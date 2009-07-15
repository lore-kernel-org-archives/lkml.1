Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbZGOAuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbZGOAuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 20:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756813AbZGOAuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 20:50:03 -0400
Received: from mail-out2.netspace.net.au ([203.10.110.72]:58923 "EHLO
	mail.netspace.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756814AbZGOAuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 20:50:02 -0400
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jul 2009 20:50:01 EDT
Message-ID: <1247618643.4a5d265392efc@webmail.netspace.net.au>
Date: Wed, 15 Jul 2009 10:44:03 +1000
From: renevant@netspace.net.au
To: linux-kernel@vger.kernel.org
Subject: possible problem with 2.6.31-rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Got this last night, possible problem when using pppoe-relay ?

Jul 15 05:01:47 Athas kernel: BUG: unable to handle kernel NULL pointer
dereference at 0000000000000030
Jul 15 05:01:47 Athas kernel: IP: [<ffffffff810a62e9>] fput+0x14/0x53
Jul 15 05:01:47 Athas kernel: PGD 21410c067 PUD 21f508067 PMD 0 
Jul 15 05:01:47 Athas kernel: Oops: 0002 [#1] SMP 
Jul 15 05:01:47 Athas kernel: last sysfs file:
/sys/devices/platform/it87.552/cpu0_vid
Jul 15 05:01:47 Athas kernel: CPU 3 
Jul 15 05:01:47 Athas kernel: Modules linked in: tun kvm_amd kvm bridge stp llc
raid456 raid6_pq async_xor async_memcpy async_tx xor md_mod usbhid snd_seq_oss
snd_seq_midi_event snd_hda_codec_atihdmi snd_seq snd_seq_device
snd_hda_codec_realtek i2c_piix4 snd_pcm_oss snd_mixer_oss sr_mod cdrom ohci1394
snd_hda_intel snd_hda_codec snd_pcm snd_timer snd r8169 8250_pnp ohci_hcd
ehci_hcd 8250 ieee1394 usbcore sg nls_base pcspkr i2c_core serio_raw e1000e
soundcore snd_page_alloc mii pata_atiixp serial_core thermal evdev processor fan
button battery ac it87_wdt it87 hwmon_vid rtc_cmos rtc_core rtc_lib
Jul 15 05:01:47 Athas kernel: Pid: 569, comm: pppoe-relay Not tainted 2.6.31-rc3
#16 GA-MA790GP-UD4H
Jul 15 05:01:47 Athas kernel: RIP: 0010:[<ffffffff810a62e9>] 
[<ffffffff810a62e9>] fput+0x14/0x53
Jul 15 05:01:47 Athas kernel: RSP: 0018:ffff8802141899b8  EFLAGS: 00010246
Jul 15 05:01:47 Athas kernel: RAX: 0000000000000000 RBX: 0000000000000000 RCX:
ffff88022359a808
Jul 15 05:01:47 Athas kernel: RDX: 0000000000000000 RSI: 0000000000000246 RDI:
0000000000000000
Jul 15 05:01:47 Athas kernel: RBP: 0000000000000005 R08: ffff8802231adb40 R09:
00000000bdd9e2e4
Jul 15 05:01:47 Athas kernel: R10: 0000000000000246 R11: ffffffff8127aab3 R12:
ffff880214189ab8
Jul 15 05:01:47 Athas kernel: R13: 0000000000000000 R14: 0000000000000000 R15:
0000000000000001
Jul 15 05:01:47 Athas kernel: FS:  00007f066c7fa6f0(0000)
GS:ffff88002807f000(0000) knlGS:000000000098fb70
Jul 15 05:01:47 Athas kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jul 15 05:01:47 Athas kernel: CR2: 0000000000000030 CR3: 0000000214142000 CR4:
00000000000006e0
Jul 15 05:01:47 Athas kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
Jul 15 05:01:47 Athas kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
Jul 15 05:01:47 Athas kernel: Process pppoe-relay (pid: 569, threadinfo
ffff880214188000, task ffff88021f46f080)
Jul 15 05:01:47 Athas kernel: Stack:
Jul 15 05:01:47 Athas kernel: ffff8802231adb40 00000000bdd9e2e4 0000000000000000
ffffffff810b3bde
Jul 15 05:01:47 Athas kernel: <0> 0000000000000000 00000000bdd9e2e4
ffff880214189d98 0000000000000001
Jul 15 05:01:47 Athas kernel: <0> 0000000000000000 ffffffff810b4702
ffff8802238b1e28 ffff8802231adb40
Jul 15 05:01:47 Athas kernel: Call Trace:
Jul 15 05:01:47 Athas kernel: [<ffffffff810b3bde>] ? poll_freewait+0x36/0x8b
Jul 15 05:01:47 Athas kernel: [<ffffffff810b4702>] ? do_select+0x499/0x4cc
Jul 15 05:01:47 Athas kernel: [<ffffffff810b4bfd>] ? __pollwait+0x0/0x10b
Jul 15 05:01:47 Athas kernel: [<ffffffff810b4d08>] ? pollwake+0x0/0x74
Jul 15 05:01:47 Athas kernel: [<ffffffff810b4d08>] ? pollwake+0x0/0x74
Jul 15 05:01:47 Athas kernel: [<ffffffff810b4d08>] ? pollwake+0x0/0x74
Jul 15 05:01:47 Athas kernel: [<ffffffff810b4d08>] ? pollwake+0x0/0x74
Jul 15 05:01:47 Athas kernel: [<ffffffff810b4d08>] ? pollwake+0x0/0x74
Jul 15 05:01:47 Athas kernel: [<ffffffff8121e117>] ? skb_free_datagram+0x20/0x72
Jul 15 05:01:47 Athas kernel: [<ffffffff8127a113>] ? packet_recvmsg+0x223/0x24b
Jul 15 05:01:47 Athas kernel: [<ffffffff81213673>] ? sock_sendmsg+0xde/0x10e
Jul 15 05:01:47 Athas kernel: [<ffffffff8100bcee>] ? apic_timer_interrupt+0xe/0x20
Jul 15 05:01:47 Athas kernel: [<ffffffff810b48aa>] ? core_sys_select+0x175/0x220
Jul 15 05:01:47 Athas kernel: [<ffffffff8100bcee>] ? apic_timer_interrupt+0xe/0x20
Jul 15 05:01:47 Athas kernel: [<ffffffff810537b3>] ? enqueue_hrtimer+0x71/0x94
Jul 15 05:01:47 Athas kernel: [<ffffffff81212c9a>] ? sockfd_lookup_light+0x2a/0x78
Jul 15 05:01:47 Athas kernel: [<ffffffff812139f8>] ? sys_sendto+0xf5/0x122
Jul 15 05:01:47 Athas kernel: [<ffffffff810b24f0>] ? sys_dup3+0x2e/0x15e
Jul 15 05:01:47 Athas kernel: [<ffffffff810b4bbf>] ? sys_select+0x9d/0xdb
Jul 15 05:01:47 Athas kernel: [<ffffffff8100b26b>] ? system_call_fastpath+0x16/0x1b
Jul 15 05:01:47 Athas kernel: Code: 00 74 05 e8 dc 42 f9 ff 48 83 c4 28 5b 5d 41
5c 41 5d 41 5e 41 5f c3 48 83 ec 18 65 48 8b 04 25 28 00 00 00 48 89 44 24 08 31
c0 <f0> 48 ff 4f 30 0f 94 c0 84 c0 74 19 48 8b 44 24 08 65 48 33 04 
Jul 15 05:01:47 Athas kernel: RIP  [<ffffffff810a62e9>] fput+0x14/0x53
Jul 15 05:01:47 Athas kernel: RSP <ffff8802141899b8>
Jul 15 05:01:47 Athas kernel: CR2: 0000000000000030
Jul 15 05:01:47 Athas kernel: ---[ end trace 95d5eea73b626779 ]---

I've merged my kernel with the latest kernel virtual machine branch as well. I'm
not a programmer so i'm not sure what i'm looking at, it could be a problem with
my system but incase it's not I thought i'd post here.


Can provide lspci and dmesg and .config output if necessary.



------------------------------------------------------------
This email was sent from Netspace Webmail: http://www.netspace.net.au

