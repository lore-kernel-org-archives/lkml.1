Return-Path: <linux-kernel-owner+w=401wt.eu-S1756482AbYKTOZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbYKTOZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756008AbYKTOXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:23:55 -0500
Received: from mtl.rackplans.net ([69.90.0.18]:47467 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755984AbYKTOXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:23:53 -0500
Date: Thu, 20 Nov 2008 09:24:45 -0500 (EST)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: linux-kernel@vger.kernel.org
Subject: 2.6.26.x and 2.6.27.x 2.6.27-rc* regression: ssh and tun/tap
 problem.
In-Reply-To: <alpine.DEB.1.10.0811131133560.11705@mtl.rackplans.net>
Message-ID: <alpine.DEB.1.10.0811200916400.31851@mtl.rackplans.net>
References: <alpine.DEB.1.10.0811131133560.11705@mtl.rackplans.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have a series of gateways using ssh tunnels and I have discovered that 
they stop working if I upgrade them past kernel 2.6.25.  This seems to 
happen regardless of the reciving end's kernel version.

About 20 to 30 seconds after the tunnel comes up the interface stops 
recieving packets with no errors show on the remote side and the local 
side showing a single dropped packet.  If I tcpdump a ping it shows that 
the remote side is getting packets and is replying but the local side is 
only sending.  This problem is only cleared by resetting the tunnel but 
then it only works for another 20 to 30 seconds.

None of the other interfaces show any errors and traffic flows over them 
without problem.

Anyone have any idea what has gone wrong?

tun0      Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00
           inet addr:172.16.1.2  P-t-P:172.16.1.1  Mask:255.255.255.252
           UP POINTOPOINT RUNNING NOARP MULTICAST  MTU:1500  Metric:1
           RX packets:0 errors:0 dropped:1 overruns:0 frame:0
           TX packets:23 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 txqueuelen:500
           RX bytes:0 (0.0 B)  TX bytes:1884 (1.8 KiB)
 
--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
