Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999Ab0BYLGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 06:06:31 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:55365 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab0BYLG2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 06:06:28 -0500
From: "Chatterjee, Amit" <amit.chatterjee@ti.com>
To: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
Date: Thu, 25 Feb 2010 16:36:23 +0530
Subject: RE: 2.6.33-rc8-rt1 on Beagle
Thread-Topic: 2.6.33-rc8-rt1 on Beagle
Thread-Index: Acq1IfhmHMd+98WrQX6gShEwr0GljQAKTvwwAC/OYJA=
Message-ID: <2A3DCF3DA181AD40BDE86A3150B27B6B030CDCC2FD@dbde02.ent.ti.com>
References: <alpine.LFD.2.00.0908282326460.19335@localhost.localdomain>
 <alpine.LFD.2.00.0909152257590.8957@localhost.localdomain>
 <alpine.LFD.2.00.0909190027400.2889@localhost.localdomain>
 <alpine.LFD.2.00.0910061210400.2646@localhost.localdomain>
 <alpine.LFD.2.00.0910141115020.9428@localhost.localdomain>
 <alpine.LFD.2.00.0911061743210.12138@localhost.localdomain>
 <alpine.LFD.2.00.0911101326280.2725@localhost.localdomain>
 <alpine.LFD.2.00.1001212102220.2906@localhost.localdomain>
 <alpine.LFD.2.00.1002181748460.2811@localhost.localdomain>
 <alpine.LFD.2.00.1002212322450.2811@localhost.localdomain>
 <20100222132927.GC5416@bicker> <4B84D20B.9080600@osadl.org>
 <2A3DCF3DA181AD40BDE86A3150B27B6B030CDCBE65@dbde02.ent.ti.com>
In-Reply-To: <2A3DCF3DA181AD40BDE86A3150B27B6B030CDCBE65@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Migrated to 2.6.33-rc8-rt2 but still am facing the same issue.

Regards,
Amit

-----Original Message-----
From: linux-rt-users-owner@vger.kernel.org [mailto:linux-rt-users-owner@vger.kernel.org] On Behalf Of Chatterjee, Amit
Sent: Wednesday, February 24, 2010 5:50 PM
To: LKML; rt-users
Subject: 2.6.33-rc8-rt1 on Beagle

Hi,
	I am facing NULL pointer deference error with beagle board. The bootargs used are -

setenv bootargs 'console=ttyS2,115200n8 root=/dev/mmcblk0p2 rootwait rootfstype=ext3 omapfb.mode=dvi:800x600MR-24@60 omapdss.def_disp=dvi omapfb.vram=0:8M,1:2M,2:4M mem=216M'
setenv bootcmd 'mmc init;fatload mmc 0 0x80200000 uImage;bootm 0x80200000'

The crash log is as follows -

Waiting for root device /dev/mmcblk0p2...
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c0004000
[00000000] *pgd=00000000
Internal error: Oops: 805 [#1] PREEMPT
last sysfs file:
Modules linked in:
CPU: 0    Not tainted  (2.6.33-rc8-rt1 #3)
PC is at rt_spin_lock_slowlock+0x64/0x220
LR is at rt_spin_lock_slowlock+0x24/0x220
pc : [<c029f85c>]    lr : [<c029f81c>]    psr: 60000093
sp : cd1a1ed8  ip : cd1a1f08  fp : 00000053
r10: cd3bc664  r9 : c039c8c4  r8 : cd3bc400
r7 : cd1a0000  r6 : cd3bc664  r5 : 60000013  r4 : cd3bc664
r3 : 00000000  r2 : cd3fb480  r1 : 00000000  r0 : cd1a1ed8
Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 10c5387d  Table: 80004019  DAC: 00000017
Process irq/83-mmc0 (pid: 355, stack limit = 0xcd1a02e8)
Stack: (0xcd1a1ed8 to 0xcd1a2000)
1ec0:                                                       00000001 00000006
1ee0: cd070040 c0397f48 00000001 cd3fb480 ffffffff 00000002 cd3bc664 60000013
1f00: 00000000 cd1a0000 00000000 c029f9f0 00000000 cd3bc600 cd0c3ef4 cd3bc664
1f20: 00000000 cd3bc400 cd3bc664 c0213850 cd0c2000 cd0c201c cd3fb480 00000017
1f40: 00000000 cd3bc600 00000000 00018000 00000001 00000000 cd3bc664 c020bb94
1f60: cd0c3f24 c02145fc c039c880 cd3d07c0 cd1a0000 cd3d07e4 08000000 c039c8c4
1f80: c039c8dc c00768e8 cd3d07c0 00000032 cd1a1f88 cd021e58 cd1a1fbc c0076828
1fa0: cd3d07c0 00000000 00000000 00000000 00000000 c0060ae8 00000000 00000000
1fc0: cd1a1fc0 cd1a1fc0 cd1a1fc8 cd1a1fc8 00000000 00000000 cd1a1fd8 cd1a1fd8
1fe0: 00000000 00000000 00000000 00000000 00000000 c0028ec4 107fcd00 0a33ef94
[<c029f85c>] (rt_spin_lock_slowlock+0x64/0x220) from [<c0213850>] (omap_hsmmc_request+0x44/0x400)
[<c0213850>] (omap_hsmmc_request+0x44/0x400) from [<c020bb94>] (mmc_request_done+0x64/0x90)
[<c020bb94>] (mmc_request_done+0x64/0x90) from [<c02145fc>] (omap_hsmmc_irq+0x364/0x46c)
[<c02145fc>] (omap_hsmmc_irq+0x364/0x46c) from [<c00768e8>] (irq_thread+0xc0/0x208)
[<c00768e8>] (irq_thread+0xc0/0x208) from [<c0060ae8>] (kthread+0x78/0x80)
[<c0060ae8>] (kthread+0x78/0x80) from [<c0028ec4>] (kernel_thread_exit+0x0/0x8)
Code: e597300c e1520003 1a000002 e3a03000 (e5833000)
---[ end trace ce701f5d04d4ac19 ]---
exiting task "irq/83-mmc0" (355) is an active IRQ thread (irq 83)
note: irq/83-mmc0[355] exited with preempt_count 1

Regards,
Amit
--
To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
