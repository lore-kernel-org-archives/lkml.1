Return-Path: <linux-kernel-owner+w=401wt.eu-S1753274AbYK1NJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbYK1NJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 08:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbYK1NJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 08:09:08 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:52928 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbYK1NJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 08:09:07 -0500
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2008-11-26-17-00 uploaded
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200811270101.mAR114rp016378@imap1.linux-foundation.org>
In-Reply-To: <200811270101.mAR114rp016378@imap1.linux-foundation.org>
Message-Id: <200811282209.FDC95384.tLQJFOFOHFMSOV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Fri, 28 Nov 2008 22:09:06 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

> The mm-of-the-moment snapshot 2008-11-26-17-00 has been uploaded to
I got below bug.
CentOS 5.2 (gcc (GCC) 4.1.2 20071124 (Red Hat 4.1.2-42)) on VMware Workstation 6.5.1.

[   24.978638] BUG: unable to handle kernel NULL pointer dereference at 00000004
[   24.980541] IP: [<c056bfb7>] loopback_get_stats+0x26/0x51
[   24.982191] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   24.982989] last sysfs file: /sys/class/firmware/microcode/loading
[   24.982989] Modules linked in: rfkill input_polldev sbs sbshc battery floppy serio_raw rtc_cmos rtc_core rtc_lib ac button pcnet32 mii i2c_piix4 i2c_core mptspi mptscsih mptbase scsi_transport_spi ext3 jbd mbcache [last unloaded: microcode]
[   24.982989] 
[   24.982989] Pid: 2213, comm: sadc Not tainted (2.6.28-rc6-mm1 #1) VMware Virtual Platform
[   24.982989] EIP: 0060:[<c056bfb7>] EFLAGS: 00010297 CPU: 0
[   24.982989] EIP is at loopback_get_stats+0x26/0x51
[   24.982989] EAX: 00000000 EBX: debf8848 ECX: 00000001 EDX: 00000001
[   24.982989] ESI: 00000000 EDI: 00000000 EBP: de7b9efc ESP: de7b9eec
[   24.982989]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   24.982989] Process sadc (pid: 2213, ti=de7b9000 task=de5fc0b0 task.ti=de7b9000)
[   24.982989] Stack:
[   24.982989]  21415ecf debf8800 ddc2fda0 ddc2fda0 de7b9f04 c05a71be de7b9f14 c05a7613
[   24.982989]  c062db2c debf8800 de7b9f54 c049d8be 00001000 b7d58000 ddf08310 ddc2fdc0
[   24.982989]  00000000 00000000 000000c8 00000001 00000000 00000000 00000000 fffffffb
[   24.982989] Call Trace:
[   24.982989]  [<c05a71be>] ? dev_get_stats+0x19/0x1b
[   24.982989]  [<c05a7613>] ? dev_seq_show+0x21/0x80
[   24.982989]  [<c049d8be>] ? seq_read+0x1f2/0x2d8
[   24.982989]  [<c049d6cc>] ? seq_read+0x0/0x2d8
[   24.982989]  [<c04b5b0f>] ? proc_reg_read+0x60/0x74
[   24.982989]  [<c04b5aaf>] ? proc_reg_read+0x0/0x74
[   24.982989]  [<c048a6da>] ? vfs_read+0x6d/0x91
[   24.982989]  [<c048a930>] ? sys_read+0x3b/0x5d
[   24.982989]  [<c04032d1>] ? sysenter_do_call+0x12/0x31
[   24.982989] Code: 66 c0 56 c0 c3 55 83 c9 ff 89 e5 57 31 ff 56 31 f6 53 83 ec 04 8d 58 48 8b 80 20 03 00 00 89 45 f0 eb 0d 8b 45 f0 f7 d0 8b 04 88 <03> 78 04 03 30 89 c8 ba 50 96 79 c0 e8 72 a3 f7 ff 83 f8 1f 89 
[   24.982989] EIP: [<c056bfb7>] loopback_get_stats+0x26/0x51 SS:ESP 0068:de7b9eec
[   25.029067] ---[ end trace a599d5330cca1e8d ]---


[   26.174009] BUG: unable to handle kernel NULL pointer dereference at 00000004
[   26.179987] IP: [<c056bfb7>] loopback_get_stats+0x26/0x51
[   26.182919] *pde = 00000000 
[   26.184089] Oops: 0000 [#2] SMP DEBUG_PAGEALLOC
[   26.185005] last sysfs file: /sys/class/firmware/microcode/loading
[   26.185005] Modules linked in: rfkill input_polldev sbs sbshc battery floppy serio_raw rtc_cmos rtc_core rtc_lib ac button pcnet32 mii i2c_piix4 i2c_core mptspi mptscsih mptbase scsi_transport_spi ext3 jbd mbcache [last unloaded: microcode]
[   26.185005] 
[   26.185005] Pid: 2288, comm: ip Tainted: G      D    (2.6.28-rc6-mm1 #1) VMware Virtual Platform
[   26.185005] EIP: 0060:[<c056bfb7>] EFLAGS: 00010297 CPU: 0
[   26.185005] EIP is at loopback_get_stats+0x26/0x51
[   26.185005] EAX: 00000000 EBX: debf8848 ECX: 00000001 EDX: 00000001
[   26.185005] ESI: 00000000 EDI: 00000000 EBP: dda6dc64 ESP: dda6dc54
[   26.185005]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   26.185005] Process ip (pid: 2288, ti=dda6d000 task=ddc00130 task.ti=dda6d000)
[   26.185005] Stack:
[   26.185005]  21415ecf de75a08c debf8800 de692a90 dda6dc6c c05a71be dda6dcb0 c05b08e9
[   26.185005]  dda6dc84 de75a000 c075a184 c075a180 00000000 00000000 00000000 00000000
[   26.185005]  00000000 00000000 00000000 00004034 debf8800 dda81918 00000000 dda6dcdc
[   26.185005] Call Trace:
[   26.185005]  [<c05a71be>] ? dev_get_stats+0x19/0x1b
[   26.185005]  [<c05b08e9>] ? rtnl_fill_ifinfo+0x2c1/0x44a
[   26.185005]  [<c05b1027>] ? rtnl_dump_ifinfo+0x44/0x72
[   26.185005]  [<c05b5881>] ? netlink_dump+0x4e/0x157
[   26.185005]  [<c05b7025>] ? netlink_dump_start+0xb6/0xc8
[   26.185005]  [<c05b0fe3>] ? rtnl_dump_ifinfo+0x0/0x72
[   26.185005]  [<c05b1107>] ? rtnetlink_rcv_msg+0xb2/0x1ae
[   26.185005]  [<c05b0fe3>] ? rtnl_dump_ifinfo+0x0/0x72
[   26.185005]  [<c05b1055>] ? rtnetlink_rcv_msg+0x0/0x1ae
[   26.185005]  [<c05b64b2>] ? netlink_rcv_skb+0x30/0x75
[   26.185005]  [<c05b0e72>] ? rtnetlink_rcv+0x17/0x1f
[   26.185005]  [<c05b6362>] ? netlink_unicast+0xd6/0x12b
[   26.185005]  [<c05b6998>] ? netlink_sendmsg+0x229/0x236
[   26.185005]  [<c059d952>] ? __sock_sendmsg+0x22/0x29
[   26.185005]  [<c059e763>] ? sock_sendmsg+0xb8/0xce
[   26.185005]  [<c043bdcc>] ? autoremove_wake_function+0x0/0x33
[   26.185005]  [<c0478b62>] ? might_fault+0x36/0x74
[   26.185005]  [<c0478b62>] ? might_fault+0x36/0x74
[   26.185005]  [<c04ec46d>] ? __copy_from_user_ll+0x11/0xce
[   26.185005]  [<c059ef09>] ? move_addr_to_kernel+0x39/0x41
[   26.185005]  [<c059efb5>] ? sys_sendto+0xa4/0xc0
[   26.185005]  [<c0476430>] ? __do_fault+0x179/0x29d
[   26.185005]  [<c0469fba>] ? wake_up_page+0x17/0x1b
[   26.185005]  [<c046a019>] ? unlock_page+0x25/0x28
[   26.185005]  [<c0476519>] ? __do_fault+0x262/0x29d
[   26.185005]  [<c059f6e4>] ? sys_socketcall+0xf2/0x18d
[   26.185005]  [<c04032d1>] ? sysenter_do_call+0x12/0x31
[   26.185005] Code: 66 c0 56 c0 c3 55 83 c9 ff 89 e5 57 31 ff 56 31 f6 53 83 ec 04 8d 58 48 8b 80 20 03 00 00 89 45 f0 eb 0d 8b 45 f0 f7 d0 8b 04 88 <03> 78 04 03 30 89 c8 ba 50 96 79 c0 e8 72 a3 f7 ff 83 f8 1f 89 
[   26.185005] EIP: [<c056bfb7>] loopback_get_stats+0x26/0x51 SS:ESP 0068:dda6dc54
[   26.279258] ---[ end trace a599d5330cca1e8e ]---
