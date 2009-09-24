Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbZIXSXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbZIXSXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 14:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbZIXSW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 14:22:59 -0400
Received: from mailbackup.inode.at ([213.229.60.24]:59755 "EHLO
	mailbackup.inode.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbZIXSW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 14:22:58 -0400
Message-ID: <4ABBB8C2.2080901@sbg.ac.at>
Date: Thu, 24 Sep 2009 20:21:54 +0200
From: Alexander Huemer <alexander.huemer@sbg.ac.at>
User-Agent: Thunderbird 2.0.0.23 (X11/20090826)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: alexander.huemer@sbg.ac.at
Subject: 2.6.{30,31} x86_64 ahci problem - irq 23: nobody cared
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the problem appears under heavy system load and slows down the system to
unusable speed.
kernels before .30 were not affected.
irqpoll does not change behavior.

error message from .31:

    [157152.418524] irq 23: nobody cared (try booting with the "irqpoll"
    option)
    [157152.418530] Pid: 1359, comm: cc1plus Tainted: G        W 
    2.6.31-gentoo-blackbit #2
    [157152.418532] Call Trace:
    [157152.418534]  <IRQ>  [<ffffffff81066e3f>] ?
    __report_bad_irq+0x30/0x7d
    [157152.418544]  [<ffffffff81066f93>] ? note_interrupt+0x107/0x170
    [157152.418547]  [<ffffffff81067580>] ? handle_fasteoi_irq+0x8a/0xaa
    [157152.418551]  [<ffffffff8100d1cf>] ? handle_irq+0x17/0x1d
    [157152.418554]  [<ffffffff8100c84b>] ? do_IRQ+0x54/0xb2
    [157152.418558]  [<ffffffff8100b6d3>] ? ret_from_intr+0x0/0xa
    [157152.418559]  <EOI>
    [157152.418560] handlers:
    [157152.418562] [<ffffffff813d2a6f>] (ahci_interrupt+0x0/0x426)
    [157152.418566] Disabling IRQ #23


bios of the machine is up to date,
i tried all related bios settings, no change.

kernel config for .31     http://xx.vu/~ahuemer/config_ahuemer_20090923.gz
lspci -vxxx               http://xx.vu/~ahuemer/lspci_ahuemer_20090923
lsusb -v                  http://xx.vu/~ahuemer/lsusb_ahuemer_20090923
/proc/interrupts         
http://xx.vu/~ahuemer/proc_interrupts_ahuemer_20090923
thread in gentoo forums  
http://forums.gentoo.org/viewtopic-t-780725-start-0.html

please tell me what additional info is needed.
please CC me on replies, i am not subscribed.

-alex
