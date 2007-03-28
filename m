Return-Path: <linux-kernel-owner+w=401wt.eu-S1751834AbXC1NwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbXC1NwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 09:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbXC1NwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 09:52:12 -0400
Received: from [69.90.0.18] ([69.90.0.18]:55253 "EHLO mtl.rackplans.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbXC1NwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 09:52:11 -0400
Date: Wed, 28 Mar 2007 09:52:07 -0400 (EDT)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: linux-kernel@vger.kernel.org
Subject: [2.6.21-rc5] forcedeth slow ifup.
Message-ID: <Pine.LNX.4.64.0703280948240.23747@mtl.rackplans.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure what's causing it but the onboard ethernet is taking a rather 
long time to come up.. the old nforce board worked fine and any other card 
is fast.

mgerhard:~# time ifup eth0
real    0m12.397s
user    0m0.214s
sys     0m0.160s

eth0      Link encap:Ethernet  HWaddr 00:18:F3:EB:DF:88
          inet addr:10.0.0.1  Bcast:10.0.0.255  Mask:255.255.255.0
          inet6 addr: fe80::218:f3ff:feeb:df88/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:162472 errors:0 dropped:0 overruns:0 frame:0
          TX packets:176386 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:82252621 (78.4 MiB)  TX bytes:30913296 (29.4 MiB)
          Interrupt:23 Base address:0x2000

lspci shows:
00:14.0 Bridge: nVidia Corporation MCP51 Ethernet Controller (rev a3)

--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
