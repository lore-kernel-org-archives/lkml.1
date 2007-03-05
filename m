Return-Path: <linux-kernel-owner+w=401wt.eu-S933020AbXCEKXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020AbXCEKXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 05:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933026AbXCEKXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 05:23:45 -0500
Received: from tide.yandex.ru ([213.180.200.37]:43488 "EHLO tide.yandex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933020AbXCEKXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 05:23:44 -0500
Date: Mon, 5 Mar 2007 13:23:24 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45EBEF9C.000003.25545@tide.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: linux-kernel@vger.kernel.org
Subject: Problem: Kernel oops
X-MsgDayCount: 1
X-BornDate: 1134853200
Reply-To: Mockern@yandex.ru
X-Source-Ip: 84.185.214.10
Content-Type: text/plain;
  charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have the Linux kernel oops problem sometime.
How can I fix it?
Thank you

---------------------------------------------------------------------------------
Unable to handle kernel NULL pointer dereference at virtual address 00000004
pgd = c0004000
[00000004] *pgd=00000000
Internal error: Oops: 17 [#1]
Modules linked in:
CPU: 0
PC is at serial_pxa_irq+0x14/0x510
LR is at __do_irq+0x4c/0x88
pc : [<c0171aa4>]    lr : [<c00229f8>]    Not tainted
sp : c024fea4  ip : c024fee4  fp : c024fee0
r10: c029dc20  r9 : 69052d06  r8 : c024ff54
r7 : 0000000d  r6 : 00000000  r5 : 00000000  r4 : 00000000
r3 : 40000013  r2 : c024ff54  r1 : 00000000  r0 : 0000000d
Flags: nZcv  IRQs on  FIQs on  Mode SVC_32  Segment kernel
Control: 397F  Table: A3B30000  DAC: 00000017
Process swapper (pid: 0, stack limit = 0xc024e198)
Stack: (0xc024fea4 to 0xc0250000)
fea0:          c02a5160 c024feec c024feb8 c00453c8 c0052a20 c3d47d00 00000000
fec0: 00000000 0000000d c024ff54 69052d06 c029dc20 c024ff04 c024fee4 c00229f8
fee0: c0171a9c c029def8 0000000d c024ff54 c02b3048 c024ff54 c024ff20 c024ff08
ff00: c0022c34 c00229b8 c029def8 f2d00000 00100000 c024ff50 c024ff24 c0022cd0
ff20: c0022bd8 c024e018 00000000 ffffffff f2d00000 00100000 c02b3048 a001e4ac
ff40: a001e44c c024ffa8 c024ff54 c00219a4 c0022c90 00000001 c036e000 00000000
ff60: 60000013 c00235f4 c024e000 c02a7918 c02b3048 a001e4ac 69052d06 a001e44c
ff80: c024ffa8 c024ffac c024ff9c c0023634 c0023640 60000013 ffffffff c024ffc0
ffa0: c024ffac c0023690 c0023600 0000397d c029d7dc c024ffd0 c024ffc4 c0021024
ffc0: c0023654 c024fff4 c024ffd4 c000881c c002100c c00082e4 c029f4a8 0000397d
ffe0: c029f444 c0251ba0 00000000 c024fff8 a0008030 c000865c 00000000 00000000
Backtrace:
[<c0171a90>] (serial_pxa_irq+0x0/0x510) from [<c00229f8>] (__do_irq+0x4c/0x88)
[<c00229ac>] (__do_irq+0x0/0x88) from [<c0022c34>] (do_level_IRQ+0x68/0xb8)
 r8 = C024FF54  r7 = C02B3048  r6 = C024FF54  r5 = 0000000D
 r4 = C029DEF8
[<c0022bcc>] (do_level_IRQ+0x0/0xb8) from [<c0022cd0>] (asm_do_IRQ+0x4c/0x118)
 r6 = 00100000  r5 = F2D00000  r4 = C029DEF8
[<c0022c84>] (asm_do_IRQ+0x0/0x118) from [<c00219a4>] (__irq_svc+0x24/0x80)
[<c00235f4>] (default_idle+0x0/0x54) from [<c0023690>] (cpu_idle+0x48/0x64)
[<c0023648>] (cpu_idle+0x0/0x64) from [<c0021024>] (__init_end+0x24/0x2c)
 r5 = C029D7DC  r4 = 0000397D
[<c0021000>] (__init_end+0x0/0x2c) from [<c000881c>] 
(start_kernel+0x1cc/0x224)
[<c0008650>] (start_kernel+0x0/0x224) from [<a0008030>] (0xa0008030)
Code: e92ddff0 e24cb004 e24dd014 e1a04001 (e5911004)
 <0>Kernel panic - not syncing: Aiee, killing interrupt handler
