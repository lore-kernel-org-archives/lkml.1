Return-Path: <linux-kernel-owner+w=401wt.eu-S1763882AbXIKMqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763882AbXIKMqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 08:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763313AbXIKMqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 08:46:01 -0400
Received: from smtp20.orange.fr ([80.12.242.27]:61519 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763294AbXIKMqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 08:46:00 -0400
X-ME-UUID: 20070911124354367.59CDA1C000A3@mwinf2018.orange.fr
Subject: r8169: instant reboot and interface renaming
From: Xavier Bestel <xavier.bestel@free.fr>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 11 Sep 2007 14:43:51 +0200
Message-Id: <1189514631.20015.108.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just replaced a fast ethernet card with a Realtek 8169 Gigabit
ethernet card on an old DELL Poweredge running debian. I upgraded the
kernel to 2.6.22 but it didn't solve my problems.

At boot, the kernel says:
r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
eth0: RTL8169s/8110s at 0xe0848400, 00:1b:2f:2b:b3:b4, IRQ 17

but then eth0 doesn't exist and is renamed to eth3. Does anybody know
why, and how to get it back to eth0 ? There's probably a FAQ on this
somewhere, but I couldn't find it.


The other problem I have is, as soon as I do
ifconfig eth3 up
the machine is rebooting (like if I pressed the reset button).
Adding "acpi=noirq" to the boot cmdline seems to solve this, but I
wonder if it's the proper solution ?


Thanks for your help,

	Xav


