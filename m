Return-Path: <linux-kernel-owner+w=401wt.eu-S1423111AbXBBOEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423111AbXBBOEl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 09:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423114AbXBBOEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 09:04:41 -0500
Received: from jutrzenka.firma.o2.pl ([193.222.135.194]:44285 "EHLO
	jutrzenka.firma.o2.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423111AbXBBOEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 09:04:40 -0500
X-Greylist: delayed 1548 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Feb 2007 09:04:40 EST
From: "Krzysztof Sierota (o2.pl/Tlen.pl)" <Krzysztof.Sierota@firma.o2.pl>
Organization: o2.pl Sp z o.o.
To: linux-kernel@vger.kernel.org
Subject: BUG 2.6.20-rc7-git1 - soft lockup detected
Date: Fri, 2 Feb 2007 14:38:50 +0100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200702021438.50126.Krzysztof.Sierota@firma.o2.pl>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get a lockup short after a bootup, hand written from the screenshot from 
remote location:

<c012d02b>]	softlockup_tick+0x87/0x96
<c011cf1a>]	update_process_times+0x33/0x55
<c0105213>]	timer_interrupt+0x40/0x60
<c012d46d>]	handle_IRQ_event+0x1a/0x3f
<c012e1b8>]	handle_level_irq+0x84/0xcb
<c010442f>]	do_IRQ+0x5a/0x71
<c0102d3f>]	common_interrupt+0x23/0x28
<c02c00d8>]	out_of_line_wait_on_bit_lock+0x45/???
<c01190b3>]	__do_softirq+0x2c/0x73
<c011911c>]	do_softirq+0x22/0x26
<c0102d3f>]	common_interrupt+0x23/0x28

UP, i686, eth0: RTL8168b/8111b at 0xf8802000, 00:16:e6:86:f3:17, IRQ 10
During bootup the: Spurious Interrupt message can be seen after the eth0 
interface is brought up.

Kernel 2.6.19-rc6 works fine. This is easy to reproduce, I am willing to try 
patches.

TIA,

Krzysztof
