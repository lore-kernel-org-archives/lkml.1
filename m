Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbZFVGsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbZFVGsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 02:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbZFVGsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 02:48:09 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:41209 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbZFVGsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 02:48:08 -0400
Message-ID: <4A3F281F.9000408@in.ibm.com>
Date: Mon, 22 Jun 2009 12:13:43 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: alan@lxorguk.ukuu.org.uk, linuxppc-dev@ozlabs.org
Subject: Re: Badness at drivers/char/tty_ldisc.c:210 during shutdown
References: <4A3A2D2B.7070704@in.ibm.com>
In-Reply-To: <4A3A2D2B.7070704@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sachin Sant wrote:
> I came across the following badness message during shutdown on a 
> Power6 box.
> This was with 2.6.30-git12(3fe0344faf7fdcb158bd5c1a9aec960a8d70c8e8)
>
> ------------[ cut here ]------------
> Badness at drivers/char/tty_ldisc.c:210
The badness message is still present with git18.

------------[ cut here ]------------
Badness at drivers/char/tty_ldisc.c:210
NIP: c00000000040a3e8 LR: c00000000040a3d0 CTR: 0000000000000000
REGS: c00000003cf6b7f0 TRAP: 0700   Not tainted  (2.6.30-git18)
MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 24000424  XER: 00000001
TASK = c00000003e308660[3846] 'vhangup' THREAD: c00000003cf68000 CPU: 1
<6>GPR00: 0000000000000001 c00000003cf6ba70 c000000000ef48c0 0000000000000001 
<6>GPR04: 0000000000000001 c00000003819f000 c000000000407b60 0000000000000000 
<6>GPR08: 0000000000000000 0000000000000000 0000000000000001 c000000000e1bce8 
<6>GPR12: 0000000044000428 c000000001002600 00000000ffffffff ffffffffffffffff 
<6>GPR16: 0000000021fd8a50 0000000000000002 0000000000000000 0000000021fc03b0 
<6>GPR20: 0000000000000000 0000000000000000 c00000003d04c700 0000000000000001 
<6>GPR24: 0000000000000000 0000000000000000 0000000000000001 c000000040007e20 
<6>GPR28: 0000000000000000 c0000000013ffd38 c000000000e7e860 c00000003cf6ba70 
NIP [c00000000040a3e8] .tty_ldisc_put+0xbc/0xf4
LR [c00000000040a3d0] .tty_ldisc_put+0xa4/0xf4
Call Trace:
[c00000003cf6ba70] [c00000000040a3d0] .tty_ldisc_put+0xa4/0xf4 (unreliable)
[c00000003cf6bb10] [c00000000040a7c8] .tty_ldisc_reinit+0x38/0x80
[c00000003cf6bba0] [c00000000040b1d8] .tty_ldisc_hangup+0x190/0x260
[c00000003cf6bc40] [c000000000401090] .do_tty_hangup+0x188/0x4c0
[c00000003cf6bd20] [c000000000401440] .tty_vhangup_self+0x34/0x54
[c00000003cf6bdb0] [c00000000019236c] .sys_vhangup+0x38/0x58
[c00000003cf6be30] [c000000000008534] syscall_exit+0x0/0x40
Instruction dump:
912b0088 4bcd17bd 60000000 e87e8008 7f44d378 481c04fd 60000000 801b0008 
7c09fe70 7d200278 7c004850 54000ffe <0b000000> 7f63db78 4bd7c98d 60000000 

Let me know if i can provide any other information.

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

