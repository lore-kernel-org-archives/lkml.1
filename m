Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbXDWVjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbXDWVjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 17:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbXDWVjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 17:39:13 -0400
Received: from mail.gmx.net ([213.165.64.20]:42412 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753807AbXDWVjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 17:39:12 -0400
X-Authenticated: #19367833
X-Provags-ID: V01U2FsdGVkX1/58QQvQN/5NXIb9Wq6VxTBvN//jLbXvtubNxUdzd
	T7fAzS4dvKFi/V
Message-ID: <462D27AF.90403@gmx.com>
Date: Mon, 23 Apr 2007 23:39:59 +0200
From: Karsten Vieth <k.vieth@gmx.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: SATA SB600 works in 2.6.20.4 but not in 2.6.21-rc5 with irqpoll
 parameter
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I can't report this problem from a new kernel, but i have the same
problem with the kernel 2.6.20.1-33x from f7-test3.

I managed to boot with these options:
linux noapic acpi=off pci=nomsi irqpoll

Here is my lspci -tv

-[0000:00]-+-00.0  ATI Technologies Inc Radeon Xpress 200 Host Bridge
           +-01.0-[0000:01]----05.0  ATI Technologies Inc RC410 [Radeon
Xpress 200]
           +-07.0-[0000:02]----00.0  Marvell Technology Group Ltd.
88E8056 PCI-E Gigabit Ethernet Controller
           +-12.0  ATI Technologies Inc SB600 Non-Raid-5 SATA
           +-13.0  ATI Technologies Inc SB600 USB (OHCI0)
           +-13.1  ATI Technologies Inc SB600 USB (OHCI1)
           +-13.2  ATI Technologies Inc SB600 USB (OHCI2)
           +-13.3  ATI Technologies Inc SB600 USB (OHCI3)
           +-13.4  ATI Technologies Inc SB600 USB (OHCI4)
           +-13.5  ATI Technologies Inc SB600 USB Controller (EHCI)
           +-14.0  ATI Technologies Inc SB600 SMBus
           +-14.1  ATI Technologies Inc SB600 IDE
           +-14.2  ATI Technologies Inc SB600 Azalia
           +-14.3  ATI Technologies Inc SB600 PCI to LPC Bridge
           \-14.4-[0000:03]----04.0  Texas Instruments TSB43AB23
IEEE-1394a-2000 Controller (PHY/Link)


and lspci -nn

00:00.0 0600: 1002:5a33 (rev 01)
00:01.0 0604: 1002:5a3f
00:07.0 0604: 1002:5a39
00:12.0 0106: 1002:4380
00:13.0 0c03: 1002:4387
00:13.1 0c03: 1002:4388
00:13.2 0c03: 1002:4389
00:13.3 0c03: 1002:438a
00:13.4 0c03: 1002:438b
00:13.5 0c03: 1002:4386
00:14.0 0c05: 1002:4385 (rev 13)
00:14.1 0101: 1002:438c
00:14.2 0403: 1002:4383
00:14.3 0601: 1002:438d
00:14.4 0604: 1002:4384
01:05.0 0300: 1002:5a61
02:00.0 0200: 11ab:4364 (rev 12)
03:04.0 0c00: 104c:8024
