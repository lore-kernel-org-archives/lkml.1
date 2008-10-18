Return-Path: <linux-kernel-owner+w=401wt.eu-S1752072AbYJRUY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbYJRUY5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 16:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751031AbYJRUYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 16:24:48 -0400
Received: from dispoweb.ifw.uni-hannover.de ([130.75.23.4]:52926 "EHLO
	ketschua.hedrich-winders.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750966AbYJRUYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 16:24:48 -0400
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Oct 2008 16:24:47 EDT
Message-ID: <48FA4464.4080100@hedrich-winders.com>
Date: Sat, 18 Oct 2008 22:17:40 +0200
From: =?UTF-8?B?SsO8cmdlbiBNZWxs?= <mell@hedrich-winders.com>
Reply-To: mell@hedrich-winders.com
Organization: Hedrich winding systems GmbH
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: linux-rt-users@vger.kernel.org
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       rostedt@goodmis.org
Subject: [-rt] 2.6.26.6-rt11: Another sleeping function called from invalid
 context
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when I boot the 2.6.26.6-rt11 kernel, I get another of these 'sleeping
function called from invalid context' error messages:

BUG: sleeping function called from invalid context IRQ-15(75) at
arch/x86/mm/highmem_32.c:8
in_atomic():0 [00000000], irqs_disabled():1
Pid: 75, comm: IRQ-15 Not tainted 2.6.26.6-rt11-HWS #2
 [<c01155ce>] __might_sleep+0xd4/0xdb
 [<c0113da9>] kmap+0x42/0x55
 [<f8cb7969>] ata_sff_hsm_move+0x3ca/0x671 [libata]
 [<f8cb8865>] ata_sff_interrupt+0x141/0x1c0 [libata]
 [<c014a1e6>] handle_IRQ_event+0x45/0xb6
 [<c014ac23>] do_irqd+0x126/0x223
 [<c014aafd>] ? do_irqd+0x0/0x223
 [<c012b8c5>] kthread+0x39/0x60
 [<c012b88c>] ? kthread+0x0/0x60
 [<c0104507>] kernel_thread_helper+0x7/0x10

Hardware is a Pentium-M Processor on an industrial PC mainboard with
Intel chip set, 1GB RAM, HDD + DVD ROM drives.
Software is OpenSUSE 10.3 with KDE 3.5.

The message comes up twice during start of the system and will be
repeated indefintely if there is a CD or DVD in the drive.

Bye,
            Jürgen

