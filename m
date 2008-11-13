Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbYKMQjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbYKMQjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 11:39:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbYKMQjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 11:39:39 -0500
Received: from [69.90.0.18] ([69.90.0.18]:41122 "EHLO mtl.rackplans.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbYKMQjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 11:39:39 -0500
Date: Thu, 13 Nov 2008 11:40:20 -0500 (EST)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: linux-kernel@vger.kernel.org
Subject: 2.6.27.5 tun/tap problem.
Message-ID: <alpine.DEB.1.10.0811131133560.11705@mtl.rackplans.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have one machine that refuses to keep it's ssh tunnels up.  None of the 
other interfaces show any errors and I've checked for mtu problems etc.

About 40 seconds after the tunnel comes up it stops recieving 
packets.  If I start a ping on the machine it shows outgoing but not 
incomming icmp.  The machine on the far side is getting the packets and 
replying but it's not making it over the tunnel.  Both machines are 
2.6.27.5.

tun0      Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00
          inet addr:172.16.1.2  P-t-P:172.16.1.1  Mask:255.255.255.252
          UP POINTOPOINT RUNNING NOARP MULTICAST  MTU:1000  Metric:1
          RX packets:0 errors:0 dropped:1 overruns:0 frame:0
          TX packets:23 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:500
          RX bytes:0 (0.0 B)  TX bytes:1884 (1.8 KiB)

Not even sure where to even begin debugging this.


	Gerhard

--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
