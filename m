Return-Path: <linux-kernel-owner+w=401wt.eu-S1751621AbXBWGEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbXBWGEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 01:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbXBWGEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 01:04:51 -0500
Received: from gherkin.frus.com ([192.158.254.49]:4681 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbXBWGEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 01:04:51 -0500
Subject: 2.6.21-rc1: Ethernet card not detected correctly
To: linux-kernel@vger.kernel.org
Date: Thu, 22 Feb 2007 23:45:20 -0600 (CST)
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070223054520.31C79DBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

My Ethernet card worked fine up through 2.6.20, but starting with 2.6.21-rc1,
I get the following:

Feb 22 23:27:39 gherkin kernel: natsemi dp8381x driver, version 2.1, Sept 11, 2006
Feb 22 23:27:39 gherkin kernel:   originally by Donald Becker <becker@scyld.com>
Feb 22 23:27:39 gherkin kernel:   http://www.scyld.com/network/natsemi.html
Feb 22 23:27:39 gherkin kernel:   2.4.x kernel port by Jeff Garzik, Tjeerd Mulder
Feb 22 23:27:39 gherkin kernel: PCI: setting IRQ 12 as level-triggered
Feb 22 23:27:39 gherkin kernel: PCI: Found IRQ 12 for device 0000:00:0a.0
Feb 22 23:27:39 gherkin kernel: PCI: Sharing IRQ 12 with 0000:00:08.1
Feb 22 23:27:39 gherkin kernel: natsemi eth0: Aculab E1/T1 PMXc cPCI carrier card at 0xdf005000 (0000:00:0a.0), 00:02:e3:15:25:90, IRQ 12, port MII, ignoring PHY
Feb 22 23:27:42 gherkin kernel: NETDEV WATCHDOG: eth0: transmit timed out
Feb 22 23:27:42 gherkin kernel: eth0: Transmit timed out, status 0x000200, resetting...
(above two lines repeated until reboot)

Here's the 2.6.20 output for comparison:

Feb 22 23:31:23 gherkin kernel: natsemi dp8381x driver, version 2.1, Sept 11, 2006
Feb 22 23:31:23 gherkin kernel:   originally by Donald Becker <becker@scyld.com>
Feb 22 23:31:23 gherkin kernel:   http://www.scyld.com/network/natsemi.html
Feb 22 23:31:23 gherkin kernel:   2.4.x kernel port by Jeff Garzik, Tjeerd Mulder
Feb 22 23:31:23 gherkin kernel: PCI: setting IRQ 12 as level-triggered
Feb 22 23:31:23 gherkin kernel: PCI: Found IRQ 12 for device 0000:00:0a.0
Feb 22 23:31:23 gherkin kernel: PCI: Sharing IRQ 12 with 0000:00:08.1
Feb 22 23:31:23 gherkin kernel: natsemi eth0: NatSemi DP8381[56] at 0xdf005000 (0000:00:0a.0), 00:02:e3:15:25:90, IRQ 12, port TP.

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
