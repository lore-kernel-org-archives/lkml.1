Return-Path: <linux-kernel-owner+w=401wt.eu-S932583AbXBNW0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583AbXBNW0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 17:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932606AbXBNW0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 17:26:38 -0500
Received: from [69.90.0.18] ([69.90.0.18]:53103 "EHLO mtl.rackplans.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932583AbXBNW0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 17:26:38 -0500
Date: Wed, 14 Feb 2007 17:26:20 -0500 (EST)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: linux-kernel@vger.kernel.org
Subject: 2.6.20 trouble with Nvidia MCP51 Ethernet Controller
Message-ID: <Pine.LNX.4.64.0702141719070.3884@mtl.rackplans.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hello,

I just got a new motherboard with an MCP51. The kernel detects it but then 
I have no eth0 device.

from lspci:
00:14.0 Bridge: nVidia Corporation MCP51 Ethernet Controller (rev a3)

dmesg shows:
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.59.
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:14.0[A] -> Link [APCH] -> GSI 23 (level, low) 
-> IRQ 23
PCI: Setting latency timer of device 0000:00:14.0 to 64
forcedeth: using HIGHDMA
eth0: forcedeth.c: subsystem: 01043:816a bound to 0000:00:14.0

mgerhard:~# ifup eth0
SIOCSIFADDR: No such device
eth0: ERROR while getting interface flags: No such device
SIOCSIFNETMASK: No such device
SIOCSIFBRDADDR: No such device
eth0: ERROR while getting interface flags: No such device
eth0: ERROR while getting interface flags: No such device
Failed to bring up eth0.


--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
