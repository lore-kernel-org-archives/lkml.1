Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbZJAPv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbZJAPv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 11:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbZJAPv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 11:51:28 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:50193 "EHLO
	mimc.mimc.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753347AbZJAPv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 11:51:27 -0400
X-Greylist: delayed 2222 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Oct 2009 11:51:27 EDT
Message-ID: <4AC4C760.6080002@mimc.co.uk>
Date: Thu, 01 Oct 2009 16:14:40 +0100
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: Accessing PHY registers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On our custom AVR32 board, we've a pair of NatSemi DP83848 PHYs.

dmesg shows the following:-

MACB_mii_bus: probed
eth0: Atmel MACB at 0xfff01800 irq 25 (00:19:66:88:76:a4)
eth0: attached PHY driver [Generic PHY] (mii_bus:phy_addr=0:01, irq=-1)
macb macb.1: invalid hw address, using random
MACB_mii_bus: probed
eth1: Atmel MACB at 0xfff01c00 irq 26 (42:36:af:ab:e4:b5)
eth1: attached PHY driver [Generic PHY] (mii_bus:phy_addr=1:03, irq=-1)

Can anyone shed some light on how I might read / write the PHY registers
from userspace ?

I've looked at ethtool, but it doesn't appear to work:-

# ethtool eth0   
Settings for eth0:
	Supported ports: [ TP MII ]
	Supported link modes:   10baseT/Half 10baseT/Full 
	                        100baseT/Half 100baseT/Full 
	Supports auto-negotiation: Yes
	Advertised link modes:  10baseT/Half 10baseT/Full 
	                        100baseT/Half 100baseT/Full 
	Advertised auto-negotiation: Yes
	Speed: 100Mb/s
	Duplex: Full
	Port: MII
	PHYAD: 1
	Transceiver: external
	Auto-negotiation: on
	Link detected: yes
# ethtool -d eth0
Cannot get register dump: Operation not supported

Anyone got some sample code (I guess using sockets and ioctl calls ?)
I could take a look at ?

Thanks
Mark

