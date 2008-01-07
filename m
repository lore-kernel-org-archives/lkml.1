Return-Path: <linux-kernel-owner+w=401wt.eu-S1759121AbYAGXbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759121AbYAGXbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 18:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756733AbYAGXbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 18:31:36 -0500
Received: from wx-out-0506.google.com ([66.249.82.237]:14047 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950AbYAGXbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 18:31:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=l+e7qojIPHxmd/owXpVRkjABaorJPlVGzvp8WeyV8ZUAkqTRxuvfmsdprageEpqxtHXjNBDFtlpV4SWOrYySDiFCY87o8PmPcRWF8uTgLTs0b1KSOUu4CVCDRr/DLsASbAoWFeOuh8aGdwQCYnVmoHJUXc3F0cIwbZAgW05V69s=
Message-ID: <d2a348dd0801071531u5ecabd43i260639aae39b3ae@mail.gmail.com>
Date: Mon, 7 Jan 2008 15:31:32 -0800
From: "raki john" <raki4652@gmail.com>
To: "Pierre Ossman" <drzeus@drzeus.cx>
Subject: Crash in Kernel 2.6.22.1 after calling mmc_register_card
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Please CC me on responses.

I am working on a SD/MMC Host driver .

I am getting kerenl oops after mmc_register_card () is called.
i working on  LINUX 2.6.22.1 kerenl.

What might be the reason for this.

I installed the modules in follwing order. I did nothing else after
installing the modules. Do i need to run any Hotplug script.
1)insmod  mmc_core.ko
2)insmod  mmc_block.ko
3)insmod  sdcc.ko


Thanks in Advance for your help.


--
Thanks
kiran






============================

Unable to handle kernel NULL pointer dereference at virtual address 00000030
pgd = c0004000
[00000030] *pgd=00000000
Internal error: Oops: 17 [#1]
Modules linked in: sdcc mmc_block mmc_core
CPU: 0    Not tainted  (2.6.22.1-M7200JSDCAALBA____ #1)
PC is at create_dir+0x14/0x200
LR is at sysfs_create_dir+0x74/0xa0
pc : [<c00d3054>]    lr : [<c00d32b4>]    psr: a0000113
sp : c4993e18  ip : c4993e48  fp : c4993e44
r10: c48ac078  r9 : 00000000  r8 : 00000001
r7 : c48ac078  r6 : 00000000  r5 : 00000000  r4 : c4c0311c
r3 : c4993e4c  r2 : c4c0311c  r1 : 00000000  r0 : c4c03118
Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  Segment kernel
Control: 00c5387f  Table: 14c24008  DAC: 00000017
Process kmmcd (pid: 1054, stack limit = 0xc4992258)
Stack: (0xc4993e18 to 0xc4994000)
3e00:                                                       00000002 00000000
3e20: c011a9e8 c4c03118 00000000 00000000 c48ac078 00000001 c4993e64 c4993e48
3e40: c00d32b4 c00d304c c01fe5cc 00000000 00000000 c4c03118 c4993e8c c4993e68
3e60: c011aa4c c00d324c c4c03008 c4c03010 00000000 c48ac078 00000001 00000000
3e80: c4993e9c c4993e90 c011ab34 c011a96c c4993ee4 c4993ea0 c014a8e0 c011ab2c
3ea0: c4c03010 c4c0317c c4c03118 00000001 c48abf70 00000000 c4993edc c4c03008
3ec0: c4c03010 00000000 c48abf68 00000001 00000000 00000000 c4993f0c c4993ee8
3ee0: bf0f8c20 c014a84c 0000a95c c4993ef8 c4c032c4 c4c03008 00000000 c48abf68
3f00: c4993f4c c4993f10 bf0fa15c bf0f8bec 00000000 00000000 03534453 44313238
3f20: 55202732 1a003bd6 00000000 c48abf68 c4993f54 60000013 c48ac27c bf0f7ce0
3f40: c4993f74 c4993f50 bf0f7db0 bf0f9bac c4993f74 00ff8000 c01fe530 c48ac280
3f60: c4a209c8 c4992000 c4993f9c c4993f78 c00567d0 bf0f7cec c4992000 c4a209f8
3f80: c4992000 c4a209c8 00000000 00000000 c4993fd4 c4993fa0 c0057450 c005672c
3fa0: c06e0850 00000000 c06e0740 c005b040 c4993fb0 c4993fb0 00000000 c4992000
3fc0: c4a209c8 c0057360 c4993ff4 c4993fd8 c005aefc c005736c 00000000 00000000
3fe0: 00000000 00000000 00000000 c4993ff8 c0047920 c005aeac 00000000 00000000
Backtrace:
[<c00d3040>] (create_dir+0x0/0x200) from [<c00d32b4>]
(sysfs_create_dir+0x74/0xa0)
 r8:00000001 r7:c48ac078 r6:00000000 r5:00000000 r4:c4c03118
[<c00d3240>] (sysfs_create_dir+0x0/0xa0) from [<c011aa4c>]
(kobject_shadow_add+0xec/0x1c0)
 r4:c4c03118
[<c011a960>] (kobject_shadow_add+0x0/0x1c0) from [<c011ab34>]
(kobject_add+0x14/0x20)
[<c011ab20>] (kobject_add+0x0/0x20) from [<c014a8e0>] (device_add+0xa0/0x5a0)
[<c014a840>] (device_add+0x0/0x5a0) from [<bf0f8c20>]
(mmc_register_card+0x40/0xa0 [mmc_core])
[<bf0f8be0>] (mmc_register_card+0x0/0xa0 [mmc_core]) from [<bf0fa15c>]
(mmc_attach_sd+0x5bc/0x740 [mmc_core])
 r7:c48abf68 r6:00000000 r5:c4c03008 r4:c4c032c4
[<bf0f9ba0>] (mmc_attach_sd+0x0/0x740 [mmc_core]) from [<bf0f7db0>]
(mmc_rescan+0xd0/0x1a0 [mmc_core])
 r8:bf0f7ce0 r7:c48ac27c r6:60000013 r5:c4993f54 r4:c48abf68
[<bf0f7ce0>] (mmc_rescan+0x0/0x1a0 [mmc_core]) from [<c00567d0>]
(run_workqueue+0xb0/0x180)
 r6:c4992000 r5:c4a209c8 r4:c48ac280
[<c0056720>] (run_workqueue+0x0/0x180) from [<c0057450>]
(worker_thread+0xf0/0x120)
 r8:00000000 r7:00000000 r6:c4a209c8 r5:c4992000 r4:c4a209f8
[<c0057360>] (worker_thread+0x0/0x120) from [<c005aefc>] (kthread+0x5c/0xa0)
 r6:c0057360 r5:c4a209c8 r4:c4992000
[<c005aea0>] (kthread+0x0/0xa0) from [<c0047920>] (do_exit+0x0/0x820)
 r6:00000000 r5:00000000 r4:00000000
Code: e92dd9f0 e24cb004 e24dd00c e1a04002 (e5912030)

=======
