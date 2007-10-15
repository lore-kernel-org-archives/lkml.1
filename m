Return-Path: <linux-kernel-owner+w=401wt.eu-S1758628AbXJOVDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628AbXJOVDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756594AbXJOVDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:03:15 -0400
Received: from ms4-1.1blu.de ([213.83.63.61]:39634 "EHLO ms4-1.1blu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758060AbXJOVDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:03:12 -0400
X-Greylist: delayed 14273 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Oct 2007 17:03:12 EDT
MIME-Version: 1.0
Date: Mon, 15 Oct 2007 19:05:18 +0200
From: Lukas Razik <linux@razik.name>
To: linux-kernel@vger.kernel.org
Subject: [BUG] RTL8169/8139 based network card
Message-ID: <fac9621a7d6bd667a2e879c344e7f8a5@mb8-2.1blu.de>
User-Agent: 1blu Webmail/0.1-rc1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Con-Id: 21979
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel Version: 2.6.22.9 (and others)

Hello!

I've an issue with a RTL8169 based network card (the same with a RTL8139
card and another system)

# lspci -v :
00:0a.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169
Gigabit Ethernet (rev 10)
        Subsystem: Realtek Semiconductor Co., Ltd. RTL-8169 Gigabit
Ethernet
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 12
        I/O ports at e000 [size=256]
        Memory at f9fdd000 (32-bit, non-prefetchable) [size=256]
        [virtual] Expansion ROM at 10000000 [disabled] [size=128K]
        Capabilities: [dc] Power Management version 2

At system startup I get the following messages:
# dmesg :
...
r8169 Gigabit Ethernet driver 2.2LK loaded
eth0: RTL8169sb/8110sb at 0xc4830000, 00:0c:76:a0:05:92, IRQ 12
...

But if I try to ifconfig the eth0 interface, I get these error messages:
# ifconfig eth0 192.168.0.2
SIOCSIFADDR: No such device
eth0: ERROR while getting interface flags: No such device

But if I try to ifconfig eth1 then it configures my network device which
was detected as eth0 at boot time...
ifconfig eth1 192.168.0.2

This leads to errors with other ethernet interfaces...
Any ideas what there's going wrong?
Many thanks for any answers!!!

Regards,
Lukas


