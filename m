Return-Path: <linux-kernel-owner+w=401wt.eu-S1761149AbXGCQm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761149AbXGCQm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958AbXGCQmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:42:17 -0400
Received: from p02c11o142.mxlogic.net ([208.65.144.75]:53666 "EHLO
	p02c11o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbXGCQmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:42:15 -0400
X-Greylist: delayed 3723 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jul 2007 12:42:14 EDT
Subject: receive errors
From: Eli Cohen <eli@mellanox.co.il>
Reply-To: eli@mellanox.co.il
To: linux-net@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Mellanox Technologies
Date: Tue, 03 Jul 2007 18:39:20 +0300
Message-Id: <1183477160.25031.170.camel@mtls03>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-Spam: [F=0.0100000000; S=0.010(2007062701); SS=0.500]
X-MAIL-FROM: <eli@mellanox.co.il>
X-SOURCE-IP: [194.90.237.34]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am running a benchmark that uses a UDP socket to send small packets
(20 bytes) from on side to the other side. I experience packet loss
reported by the benchmark and I can see that it matches what I see with
netstat:

[root@sw174 opt]# netstat -us
Udp:
    26971289 packets received
    7 packets to unknown port received.
    32615 packet receive errors
    155761284 packets sent

Can someone please direct to the source code that detects such receive
errors and/or suggest why such a thing could happen?

Thanks
Eli

