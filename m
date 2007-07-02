Return-Path: <linux-kernel-owner+w=401wt.eu-S1757955AbXGBMCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbXGBMCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 08:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbXGBMCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 08:02:38 -0400
Received: from mailfe02.tele2.dk ([212.247.154.35]:28271 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752880AbXGBMCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 08:02:37 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Jul 2007 08:02:37 EDT
X-Cloudmark-Score: 0.000000 []
Subject: Forcedeth: Nvidia NIC goes up and down
From: Anders Rune Jensen <anders@gnulinux.dk>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 02 Jul 2007 21:08:44 +0200
Message-Id: <1183403324.11262.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I recently invested in a asus m2n-mx. The motherboard features a nvidia
1gbit NIC (lspci says 00:07.0 Bridge: nVidia Corporation MCP61 Ethernet
(rev a2)). I have it connected to my 1gbit switch together with another
machine. The problem is that very frequently (sometimes several times
each minute), the NIC goes down for a few seconds and then goes up
again. In the dmesg log I can see:

Jul  2 21:01:26 [kernel] eth0: link down.
Jul  2 21:01:28 [kernel] eth0: link up.
Jul  2 21:01:57 [kernel] eth0: link down.
Jul  2 21:01:59 [kernel] eth0: link up.
Jul  2 21:02:34 [kernel] eth0: link down.
Jul  2 21:02:36 [kernel] eth0: link up.
Jul  2 21:03:15 [kernel] eth0: link down.
Jul  2 21:03:18 [kernel] eth0: link up.

I've tried changing the cable and changing the port in the switch
without luck.

Sadly the motherboard only has 2 pci slots, which is already taken, so
adding another NIC is not an option. The wireless interface is working
perfectly fine on the machine so the problem seems related to the NIC.

I've tried fiddling with ethtool but I can't seem to make the NIC run at
100mbit. If I disable autoneg nothing seems to be working. Output from
ethtool:

Settings for eth0:
	Supported ports: [ MII ]
	Supported link modes:   10baseT/Half 10baseT/Full 
	                        100baseT/Half 100baseT/Full 
	                        1000baseT/Full 
	Supports auto-negotiation: Yes
	Advertised link modes:  10baseT/Half 10baseT/Full 
	                        100baseT/Half 100baseT/Full 
	                        1000baseT/Full 
	Advertised auto-negotiation: Yes
	Speed: 1000Mb/s
	Duplex: Full
	Port: MII
	PHYAD: 1
	Transceiver: external
	Auto-negotiation: on
	Supports Wake-on: g
	Wake-on: d
	Link detected: yes

Any idea how what I can do to debug this issue further?

Please cc me as I'm not subscribed. Thanks in advance

--
Anders Rune Jensen

