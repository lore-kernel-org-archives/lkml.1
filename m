Return-Path: <linux-kernel-owner+w=401wt.eu-S1760669AbXENK2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669AbXENK2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 06:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755790AbXENK2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 06:28:46 -0400
Received: from c2bthomr11.btconnect.com ([213.123.20.143]:18577 "EHLO
	c2bthomr11.btconnect.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583AbXENK2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 06:28:45 -0400
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 May 2007 06:28:45 EDT
Message-ID: <46483868.5040106@onelan.co.uk>
Date: Mon, 14 May 2007 11:22:32 +0100
From: Barry Scott <barry.scott@onelan.co.uk>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Opss: 2.6.21-1.3116.ONELAN Kernel last sysfs file: /class/vc/vcsa7/dev
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm testing the robustness of Xorg 1.3 server with intel 2.0 driver
by restarting the X and a set of apps every 30 seconds. After
about an hour this happened.

2.6.21-1.3116.ONELAN is the same as 2.6.21-1.3116 from FC7
but with the spec file change so that we can run the kernel on an FC4
system.

eth0: no IPv6 routers present
BUG: unable to handle kernel paging request at virtual address 6b6b6b6b
 printing eip:
6b6b6b6b
*pde = 00000000
Oops: 0000 [#1]
SMP
last sysfs file: /class/vc/vcsa7/dev
Modules linked in: ipv6(U) autofs4(U) usbvision(U) videodev(U) 
v4l2_common(U) v4l1_compat(U) i2c_core(U) video(U) dock(U) button(U) 
battery(U) ac(U) uhci_hcd(U) ehci_hcd(U) iTCO_wdt(U) 
iTCO_vendor_support(U) snd_hda_intel(U) snd_hda_codec(U) 
snd_seq_dummy(U) snd_seq_oss(U) snd_seq_midi_event(U) snd_seq(U) 
snd_seq_device(U) snd_pcm_oss(U) snd_mixer_oss(U) snd_pcm(U) 
snd_timer(U) snd(U) soundcore(U) snd_page_alloc(U) e1000(U) floppy(U) 
sr_mod(U) cdrom(U) ata_generic(U) ext3(U) jbd(U) mbcache(U) 
dm_snapshot(U) dm_zero(U) dm_mirror(U) dm_mod(U) ata_piix(U) libata(U) 
sd_mod(U) scsi_mod(U)
CPU:    0
EIP:    0060:[<6b6b6b6b>]    Not tainted VLI
EFLAGS: 00010202   (2.6.21-1.3116.ONELAN #1)
EIP is at 0x6b6b6b6b
eax: dc2588d4   ebx: 6b6b6b6b   ecx: cdf27000   edx: d4438c18
esi: dc2588d4   edi: c0711e94   ebp: d236df34   esp: d236df28
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process udev (pid: 10208, ti=d236d000 task=ccccb550 task.ti=d236d000)
Stack: c05602bd cd383164 ce92457c d236df6c c04b6e2c c04421da c04849d0 
00000000
       de879e54 00001000 09e8e708 ce924598 d4438c18 dc2589ac d765dc24 
c04b6d8c
       09e8e708 d236df90 c047e706 d236df9c c0404fd4 00000000 00001000 
d765dc24
Call Trace:
 [<c0405e46>] show_trace_log_lvl+0x19/0x2e
 [<c0405ef8>] show_stack_log_lvl+0x9d/0xa5
 [<c04063bf>] show_registers+0x1d1/0x2a3
 [<c04066c3>] die+0x12a/0x204
 [<c0617fd9>] do_page_fault+0x3f5/0x4c1
 [<c061674c>] error_code+0x7c/0x84
 [<c04b6e2c>] sysfs_read_file+0xa0/0x14e
 [<c047e706>] vfs_read+0xaf/0x163
 [<c047f04d>] sys_read+0x3d/0x61
 [<c0404f8c>] syscall_call+0x7/0xb
 =======================
Code:  Bad EIP value.
EIP: [<6b6b6b6b>] 0x6b6b6b6b SS:ESP 0068:d236df28


