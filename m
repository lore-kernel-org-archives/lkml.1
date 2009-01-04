Return-Path: <linux-kernel-owner+w=401wt.eu-S1753592AbZADAz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbZADAz6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 19:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbZADAzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 19:55:50 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:28583 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbZADAzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 19:55:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=JnFjcPtUp3pjowLJ4O1QAYBfgkNmJfMMbEdNG1JgSHMrhl5WwwCIm7C4gUoX06VCBB
         Wu/46yhGCKmwy0WiBfzixXBX45LPBLSflIGiCPi8Rmes0UTa/aefRekZfzriLUZQsH66
         wWiuLmzt0DVH5ZieufvbSCHYKTZHCkU5SwuIc=
Message-ID: <a0adeea50901031655x3323e1fex302d0671cfa82967@mail.gmail.com>
Date: Sun, 4 Jan 2009 08:55:47 +0800
From: Grissiom <chaos.proton@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Kernel warning from latest 2.6.28-gitX
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, maybe I have the same problem, here is a snippet of dmesg:

[    0.728735] Probing IDE interface ide0...
[    1.430414] hda: HL-DT-ST DVD+/-RW GSA-T11N, ATAPI CD/DVD-ROM drive
[    1.760120] hda: host max PIO4 wanted PIO255(auto-tune) selected
PIO4
[    1.760946] hda: UDMA/33 mode selected
[    1.773525] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    1.789149] ide-cd driver 5.00
[    1.802700] ide-cd: hda: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive,
2048kB Cache
[    1.814860] Uniform CD-ROM driver Revision: 3.20
[    1.828677] ------------[ cut here ]------------
[    1.831992] WARNING: at kernel/lockdep.c:2197
trace_hardirqs_on_caller+0x134/0x1a0()
[    1.831992] Hardware name: Inspiron 1501
[    1.831992] Modules linked in:
[    1.831992] Pid: 0, comm: swapper Not tainted
2.6.28-g14-rfkill-nophy-ledon-05692-g7d3b56b #57
[    1.831992] Call Trace:
[    1.831992]  [<c012a049>] warn_slowpath+0x99/0xc0
[    1.831992]  [<c0140030>] posix_cpu_timer_set+0x3e0/0x410
[    1.831992]  [<c0104f5a>] dump_trace+0x6a/0xb0
[    1.831992]  [<c014e83a>] validate_chain+0x41a/0x11a0
[    1.831992]  [<c014f853>] __lock_acquire+0x293/0xa20
[    1.831992]  [<c014f853>] __lock_acquire+0x293/0xa20
[    1.831992]  [<c014e83a>] validate_chain+0x41a/0x11a0
[    1.831992]  [<c014e83a>] validate_chain+0x41a/0x11a0
[    1.831992]  [<c04d7de0>] _spin_unlock_irq+0x20/0x40
[    1.831992]  [<c014dc84>] trace_hardirqs_on_caller+0x134/0x1a0
[    1.831992]  [<c04d7de0>] _spin_unlock_irq+0x20/0x40
[    1.831992]  [<c0322280>] do_ide_request+0x40/0x570
[    1.831992]  [<c014f853>] __lock_acquire+0x293/0xa20
[    1.831992]  [<c04d7a4b>] _spin_lock_irqsave+0x4b/0x60
[    1.831992]  [<c0254435>] blk_start_queueing+0x15/0x30
[    1.831992]  [<c03219ea>] ide_do_drive_cmd+0x4a/0x70
[    1.831992]  [<c032d4c6>] cdrom_decode_status+0x116/0x380
[    1.831992]  [<c032dd40>] cdrom_newpc_intr+0x0/0x680
[    1.831992]  [<c032dd83>] cdrom_newpc_intr+0x43/0x680
[    1.831992]  [<c032dd40>] cdrom_newpc_intr+0x0/0x680
[    1.831992]  [<c0321b94>] ide_intr+0x134/0x1b0
[    1.831992]  [<c01696b0>] handle_IRQ_event+0x20/0x50
[    1.831992]  [<c016b365>] handle_edge_irq+0xb5/0x120
[    1.831992]  [<c0104dc8>] do_IRQ+0x48/0x90
[    1.831992]  [<c02688a4>] trace_hardirqs_off_thunk+0xc/0x18
[    1.831992]  [<c01039ac>] common_interrupt+0x2c/0x34
[    1.831992]  [<c01091ed>] default_idle+0x3d/0x60
[    1.831992]  [<c01093f3>] c1e_idle+0x93/0x110
[    1.831992]  [<c0101c8b>] cpu_idle+0x6b/0xd0
[    1.831992] ---[ end trace 5a56406b278561cb ]---
[    2.204724] Driver 'sd' needs updating - please use bus_type methods
-- 
Cheers,
Grissiom
