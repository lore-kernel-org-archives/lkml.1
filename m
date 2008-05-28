Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbYE1WJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbYE1WJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 18:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbYE1WJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 18:09:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34723 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbYE1WJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 18:09:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: Oops during hibernation - two times the same one
Date: Thu, 29 May 2008 00:09:36 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>
References: <200805282323.20679.linux@rainbow-software.org>
In-Reply-To: <200805282323.20679.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805290009.37281.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 28 of May 2008, Ondrej Zary wrote:
> Hello,
> I'm using hibernation on my desktop machine every day instead of power off. It 
> mostly works but sometimes aborts with "no space left on device" error. 
> Closing some programs and trying again usually fixes it - but recently, I got 
> two oopses instead. I'm sending them because they're the same, only some 
> details are different. Does anyone know what might be wrong?

Thanks for the report, but I have no idea of what could go wrong.

Rafael

 
> ------------[ cut here ]------------
> Kernel BUG at c015610b [verbose debug info unavailable]
> invalid opcode: 0000 [#1]
> Modules linked in: snd_sb16 ppdev snd_opl3_synth snd_seq_midi_emul 
> snd_opl3_lib snd_hwdep snd_sb16_dsp snd_sb_common snd_mpu401_uart snd_rawmidi 
> 3c509 de2104x sr_mod cdrom [last unloaded: snd_sb16]
> 
> Pid: 8634, comm: bash Not tainted (2.6.25.3-pentium #3)
> EIP: 0060:[<c015610b>] EFLAGS: 00210246 CPU: 0
> EIP is at iput+0x19/0x61
> EAX: c02db808 EBX: cf402c08 ECX: 0001ec9e EDX: 00000000
> ESI: cf402ba0 EDI: cf987c00 EBP: 00000000 ESP: c9a4deb4
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process bash (pid: 8634, ti=c9a4c000 task=c3975000 task.ti=c9a4c000)
> Stack: 00000000 c0163eb5 cf402bac ffffffe4 c142b000 c0329881 cf80b6a0 c012e212
>        00000001 c38de7ac 00200286 00001000 00000000 00000001 00000000 00000000
>        c142b000 00000000 00000000 0001ec82 0001ec82 00200246 0001ec82 fffffa5d
> Call Trace:
>  [<c0163eb5>] __blkdev_put+0xc2/0xda
>  [<c012e212>] swsusp_write+0x307/0x311
>  [<c012c81b>] hibernate+0xb4/0x131
>  [<c012b9ad>] state_store+0x41/0xa3
>  [<c012b96c>] state_store+0x0/0xa3
>  [<c01babcb>] kobj_attr_store+0x18/0x1c
>  [<c0173dd0>] sysfs_write_file+0xab/0xd8
>  [<c0173d25>] sysfs_write_file+0x0/0xd8
>  [<c0148a58>] vfs_write+0x7f/0xec
>  [<c0148e9c>] sys_write+0x3c/0x63
>  [<c01039d2>] syscall_call+0x7/0xb
>  [<c02d0000>] i8042_probe+0x4c4/0x4db
>  =======================
> Code: 08 01 00 00 77 ff ff ff eb e5 e8 90 ad 17 00 31 c0 c3 53 85 c0 89 c3 74 
> 58 8b 80 8c 00 00 00 83 bb 08 01 00 00 40 8b 40 20 75 04 <0f> 0b eb fe 85 c0 
> 74 0b 8b 50 10 85 d2 74 04 89 d8 ff d2 8d 43
> EIP: [<c015610b>] iput+0x19/0x61 SS:ESP 0068:c9a4deb4
> ---[ end trace a4ef9e45bccfe6a8 ]---
> ata2.01: configured for PIO2
> 
> 
> 
> 
> 
> ------------[ cut here ]------------
> Kernel BUG at c015610b [verbose debug info unavailable]
> invalid opcode: 0000 [#1]
> Modules linked in: snd_opl3_synth snd_seq_midi_emul snd_sb16 snd_opl3_lib 
> snd_hwdep snd_sb16_dsp snd_sb_common snd_mpu401_uart snd_rawmidi 3c509 ppdev 
> sr_mod cdrom de2104x
> 
> Pid: 31990, comm: bash Not tainted (2.6.25.3-pentium #3)
> EIP: 0060:[<c015610b>] EFLAGS: 00210246 CPU: 0
> EIP is at iput+0x19/0x61
> EAX: c02db808 EBX: cf402c08 ECX: 0000680c EDX: 00000000
> ESI: cf402ba0 EDI: cf987c00 EBP: 00000000 ESP: cf445eb4
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process bash (pid: 31990, ti=cf454000 task=cbbbeaa0 task.ti=cf454000)
> Stack: 00000000 c0163eb5 cf402bac ffffffe4 ce7d3000 c0329881 cf80b6a0 c012e212
>        00000001 cbbbeaa0 cf997260 00001000 00000000 00000001 00000000 00000000
>        ce7d3000 00000000 00000000 000067f0 000067f0 00200246 000067f0 fffffa65
> Call Trace:
>  [<c0163eb5>] __blkdev_put+0xc2/0xda
>  [<c012e212>] swsusp_write+0x307/0x311
>  [<c012c81b>] hibernate+0xb4/0x131
>  [<c012b9ad>] state_store+0x41/0xa3
>  [<c012b96c>] state_store+0x0/0xa3
>  [<c01babcb>] kobj_attr_store+0x18/0x1c
>  [<c0173dd0>] sysfs_write_file+0xab/0xd8
>  [<c0173d25>] sysfs_write_file+0x0/0xd8
>  [<c0148a58>] vfs_write+0x7f/0xec
>  [<c0148e9c>] sys_write+0x3c/0x63
>  [<c01039d2>] syscall_call+0x7/0xb
>  [<c02d0000>] i8042_probe+0x4c4/0x4db
>  =======================
> Code: 08 01 00 00 77 ff ff ff eb e5 e8 90 ad 17 00 31 c0 c3 53 85 c0 89 c3 74 
> 58 8b 80 8c 00 00 00 83 bb 08 01
> 00 00 40 8b 40 20 75 04 <0f> 0b eb fe 85 c0 74 0b 8b 50 10 85 d2 74 04 89 d8 
> ff d2 8d 43
> EIP: [<c015610b>] iput+0x19/0x61 SS:ESP 0068:cf455eb4
> ---[ end trace a135a0b42e7aa142 ]---
> ata2.01: configured for PIO2
> 
> 
> 
> 
> 
> 



-- 
"Premature optimization is the root of all evil." - Donald Knuth
