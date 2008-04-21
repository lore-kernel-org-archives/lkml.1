Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbYDUIcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbYDUIcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbYDUIbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:31:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:60442 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbYDUIbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:31:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Ih9pXzbR31auPtX2CpQ5mlkc/6A5Fo6XoXlO9rktdfY8owWKjH4gMIcZJLHk7JbX56AP+owzbG6TgQmeBv29EkzxhveG5h/5PRuszXLTYrDrB2niEVWRlh2K8VBwWbQLQvbEJrysLYhe0XWUv6gXx8wrw+VdmKqwFy33bDXgkJM=
Message-ID: <480C50EC.2090803@gmail.com>
Date: Mon, 21 Apr 2008 10:31:40 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
       linux-fsdevel@vger.kernel.org
Subject: [Was: 2.6.25-mm1]
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
In-Reply-To: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2008 10:47 AM, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25/2.6.25-mm1/ 

Hi,

$ ls /usr/share/man/cat3readlin
Segmentation fault

[the file doesn't exist.]
This is probably the same bug as in -rc8-mm2 I reported here:
http://www.opensubscriber.com/message/linux-kernel@vger.kernel.org/9008289.html

general protection fault: 0000 [1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:19.0/net/eth0/statistics/collisions
CPU 0
Modules linked in: test ipv6 tun bitrev arc4 ecb crypto_blkcipher cryptomgr 
crypto_algapi ath5k mac80211 crc32 sr_mod usbhid ohci1394 rtc_cmos hid rtc_core 
cfg80211 ieee1394 cdrom ehci_hcd rtc_lib ff_memless floppy evdev
Pid: 24838, comm: man Not tainted 2.6.25-mm1_64 #403
RIP: 0010:[<ffffffff802aca27>]  [<ffffffff802aca27>] __d_lookup+0x97/0x160
RSP: 0018:ffff8100337d1b98  EFLAGS: 00010206
RAX: 00f0000000000000 RBX: 00f0000000000000 RCX: 0000000000000012
RDX: ffff8100200830e0 RSI: ffff8100337d1ca8 RDI: ffff810079195708
RBP: ffff8100337d1bf8 R08: ffff8100337d1ca8 R09: 0000000000000000
R10: 000000000000013d R11: 0000000000000246 R12: ffff8100200830c8
R13: 00000000198eaed5 R14: ffff810079195708 R15: ffff8100337d1bc8
FS:  00007f447b5c06f0(0000) GS:ffffffff80664000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000001484f88 CR3: 000000005fac4000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process man (pid: 24838, threadinfo ffff8100337d0000, task ffff810034418000)
Stack:  ffff8100337d1ca8 000000000000000b ffff810079195710 0000000b792561a0
  ffff81003136600f ffffffff802f9073 00f0000000000000 0000000000000001
  ffff8100337d1e48 ffff8100337d1e48 ffff8100337d1ca8 ffff8100337d1cb8
Call Trace:
  [<ffffffff802f9073>] ? ext3_lookup+0xc3/0x100
  [<ffffffff802a1e85>] do_lookup+0x35/0x220
  [<ffffffff802a22c2>] __link_path_walk+0x252/0x1010
  [<ffffffff802b20ba>] ? mntput_no_expire+0x2a/0x140
  [<ffffffff802a30ee>] path_walk+0x6e/0xe0
  [<ffffffff802a33b2>] do_path_lookup+0xa2/0x240
  [<ffffffff802a38b7>] __path_lookup_intent_open+0x67/0xd0
  [<ffffffff802a392c>] path_lookup_open+0xc/0x10
  [<ffffffff802a487a>] do_filp_open+0xaa/0x990
  [<ffffffff8024f8b4>] ? up+0x34/0x50
  [<ffffffff804fd619>] ? unlock_kernel+0x29/0x30
  [<ffffffff802b20ba>] ? mntput_no_expire+0x2a/0x140
  [<ffffffff80295ddc>] ? get_unused_fd_flags+0x8c/0x140
  [<ffffffff80295f06>] do_sys_open+0x76/0x110
  [<ffffffff80295fcb>] sys_open+0x1b/0x20
  [<ffffffff8020b91b>] system_call_after_swapgs+0x7b/0x80


Code: 48 89 c3 48 8b 55 d0 8b 45 bc 48 85 d2 48 89 45 a8 75 18 eb 5f 0f 1f 80 00 
00 00 00 48 8b 1b 48 89 5d d0 49 8b 07 48 85 c0 74 49 <48> 8b 03 4c 8d 63 e8 0f 
18 08 45 39 6c 24 30 75 e0 4d 39 74 24
RIP  [<ffffffff802aca27>] __d_lookup+0x97/0x160
  RSP <ffff8100337d1b98>
---[ end trace cb4ec4895332b217 ]---
