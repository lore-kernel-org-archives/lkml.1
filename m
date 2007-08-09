Return-Path: <linux-kernel-owner+w=401wt.eu-S939277AbXHIPMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939277AbXHIPMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 11:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760057AbXHIPL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 11:11:58 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4459 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760198AbXHIPL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 11:11:57 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc2-mm1: kernel BUG at mm/swap_state.c:78!
Date: Thu, 9 Aug 2007 17:11:52 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org>
In-Reply-To: <20070809015106.cd0bfc53.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708091711.53898.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	Nothing unusual happening, allmodconfig compiling etc.
Not sure why it says kernel was tainted though ... hmmm.

------------[ cut here ]------------
kernel BUG at mm/swap_state.c:78!
invalid opcode: 0000 [#1]
PREEMPT 
Modules linked in: orinoco_cs orinoco hermes pl2303 usbserial pcmcia 8250_pci 8250 serial_core yenta_socket rsrc_nonstatic pcmcia_core 8139too
CPU:    0
EIP:    0060:[<c01504b7>]    Tainted: P        VLI
EFLAGS: 00010246   (2.6.23-rc2-mm1 #1)
EIP is at __add_to_swap_cache+0xc6/0xd7
eax: 40000000   ebx: c11285c0   ecx: 000000d0   edx: 00000283
esi: c11285c0   edi: 00000283   ebp: c1858f90   esp: c1858f84
ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
Process kprefetchd (pid: 236, ti=c1858000 task=c18d14d0 task.ti=c1858000)
Stack: 00000283 c11285c0 c3d5a3c8 c1858fa0 c01504ea c11285c0 00000000 c1858fcc 
       c015307c 00000001 00000007 00000002 00000002 00000283 00000000 fffffffc 
       00000000 c0152d5c c1858fe0 c0127f2e c0127ef8 00000000 00000000 00000000 
Call Trace:
 [<c010456a>] show_trace_log_lvl+0x1a/0x30
 [<c0104629>] show_stack_log_lvl+0xa9/0xd5
 [<c010486e>] show_registers+0x219/0x38d
 [<c0104ae6>] die+0x104/0x23e
 [<c0419bd3>] do_trap+0x83/0xad
 [<c0104edf>] do_invalid_op+0x88/0x92
 [<c04199b2>] error_code+0x6a/0x70
 [<c01504ea>] add_to_swap_cache+0x22/0x58
 [<c015307c>] kprefetchd+0x320/0x364
 [<c0127f2e>] kthread+0x36/0x58
 [<c0104233>] kernel_thread_helper+0x7/0x14
 =======================
INFO: lockdep is turned off.
Code: 0f 89 7b 0c 83 05 fc c9 53 c0 01 8b 13 c1 ea 1e 8d 04 12 01 d0 c1 e0 03 29 d0 c1 e0 05 ff 80 b8 c0 53 c0 ff 05 34 1d 68 c0 eb 96 <0f> 0b eb fe 0f 0b eb fe 0f 0b eb fe 8b 53 0c eb be 55 89 e5 56 
EIP: [<c01504b7>] __add_to_swap_cache+0xc6/0xd7 SS:ESP 0068:c1858f84

Regards,

	Mariusz
