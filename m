Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbYGARsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbYGARsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 13:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYGARsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 13:48:07 -0400
Received: from mailout02.t-online.de ([194.25.134.17]:60332 "EHLO
	mailout02.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbYGARsG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 13:48:06 -0400
From: =?iso-8859-1?q?J=FCrgen_Mell?= <j.mell@t-online.de>
Reply-To: j.mell@t-online.de
To: Steven Rostedt <rostedt@goodmis.org>
Subject: BUG messages with real-time kernel 2.6.25.8-rt7
Date: Tue, 1 Jul 2008 19:47:48 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807011947.48725.j.mell@t-online.de>
X-ID: Ze4mOaZCYh2SX63k3jqYijA9IGo1AkiIgnY9Fy6GdtIvgRtFTtNGvJbxL3DcnfMwk3
X-TOI-MSGID: e592570a-0a50-4c63-a572-63205babd106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am getting this bug message from a real-time kernel 2.6.25.8-rt7:

Jul  1 07:58:30 cwc-003 kernel: BUG: sleeping function called from invalid 
context IRQ-15(416) at arch/x86/mm/highmem_32.c:8
Jul  1 07:58:30 cwc-003 kernel: in_atomic():0 [00000000], irqs_disabled():1
Jul  1 07:58:30 cwc-003 kernel: Pid: 416, comm: IRQ-15 Not tainted 
2.6.25.8-rt7-hws #2
Jul  1 07:58:30 cwc-003 kernel:  [<c01125f5>] kmap+0x44/0x54
Jul  1 07:58:30 cwc-003 kernel:  [<f88507fd>] ata_hsm_move+0x3d5/0x666 
[libata]
Jul  1 07:58:30 cwc-003 kernel:  [<f8854d8f>] ata_interrupt+0x14c/0x1cf 
[libata]
Jul  1 07:58:30 cwc-003 kernel:  [<c01418a6>] handle_IRQ_event+0x3f/0xad
Jul  1 07:58:30 cwc-003 kernel:  [<c0141fad>] do_irqd+0x0/0x280
Jul  1 07:58:30 cwc-003 kernel:  [<c0141c92>] thread_simple_irq+0x56/0x8f
Jul  1 07:58:30 cwc-003 kernel:  [<c0141fad>] do_irqd+0x0/0x280
Jul  1 07:58:30 cwc-003 kernel:  [<c014205b>] do_irqd+0xae/0x280
Jul  1 07:58:30 cwc-003 kernel:  [<c0141fad>] do_irqd+0x0/0x280
Jul  1 07:58:30 cwc-003 kernel:  [<c01283a6>] kthread+0x36/0x5c
Jul  1 07:58:30 cwc-003 kernel:  [<c0128370>] kthread+0x0/0x5c
Jul  1 07:58:30 cwc-003 kernel:  [<c010443f>] kernel_thread_helper+0x7/0x10
Jul  1 07:58:30 cwc-003 kernel:  =======================

This message comes always up once after the system is started. 

If a DVD is in the drive, the same message will be repeated over and over 
several times per second.

The system is an openSUSE 10.3 with the modifed kernel, KDE3 and all the 
fancy auto-mounting stuff. The kernel is not compiled for SMP (that gave 
other errors which were already discussed on LKML).

Hardware is a Pentium M processor on an industrial PC board with Intel 
chipset and integrated graphics.

Any ideas how to fix this? If you need any more information or if I can 
test something, please let me know.

Bye,
            Jürgen
