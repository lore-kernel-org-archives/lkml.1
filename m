Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbXKSPJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbXKSPJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbXKSPJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:09:28 -0500
Received: from kwall.cncz.cz ([194.213.192.9]:13426 "EHLO kwall.cncz.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563AbXKSPJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:09:27 -0500
X-Greylist: delayed 1543 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Nov 2007 10:09:27 EST
From: Pavel Krauz <krauz@cncz.cz>
To: linux-kernel@vger.kernel.org
Subject: wrong NUMA detection on HP385 G2
Date: Mon, 19 Nov 2007 15:43:30 +0100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711191543.30665.krauz@cncz.cz>
X-OriginalArrivalTime: 19 Nov 2007 14:43:32.0004 (UTC) FILETIME=[8E515E40:01C82ABA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello
my HP 385 G2 - 2x dual core Opteron 2216 running 2.6.23.1 with NUMA support says the following:

cat /sys/devices/system/node/node0/cpumap
0000000f

cat /sys/devices/system/node/node1/cpumap
00000000

and really in the node0 there are 4 sym links to cpu0-3 and there is no sym link in node1 subdirectory.
I do not think this is correct.
Consequently (I think because of this) the numa_run_on_node() function does not work correctly.

Furthermore kernel panics during boot (under Centos 5.0) with 2.6.23.1 and 2.6.22.12 with NUMA when
the machine is configured with less memory than it really has: with mem=3072M kernel boot parameter and 4GB of physical memory. 
Has anybody tried to boot NUMA enabled kernel with less memory configured than physical on dual Opteron system?

Thanks and b.r.
Pavel Krauz
