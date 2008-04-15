Return-Path: <linux-kernel-owner+w=401wt.eu-S1758846AbYDOSQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846AbYDOSQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 14:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbYDOSQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 14:16:04 -0400
Received: from filter2.host.bg ([87.120.40.156]:39675 "EHLO filter2.host.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbYDOSQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 14:16:01 -0400
X-Greylist: delayed 515 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Apr 2008 14:16:01 EDT
Subject: Bad network performance over 2Gbps
From: Anton Titov <a.titov@host.bg>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Hosting Ltd.
Date: Tue, 15 Apr 2008 21:06:44 +0300
Message-Id: <1208282804.23631.27.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I use Linux for serving a huge amount of static web on few servers. When
network traffic goes above 2Gbit/sec ksoftirqd/5 (not every time 5, but
every time just one) starts using exactly 100% CPU time and packet
packet loss starts preventing traffic from going up. When the network
traffic is lower than 1.9Gbit ksoftirqds use 0% CPU according to top.

Uplink is 6 gigabit Intel cards bonded together using 802.3ad algorithm
with xmit_hash_policy set to layer3+4. On the other side is Cisco 2960
switch. Machine is with two quad core Intel Xeons @2.33GHz.

Here goes a screen snapshot of "top" command. The described behavior
have nothing to do with 13% io-wait. It happens even if it is 0%
io-wait.
http://www.titov.net/misc/top-snap.png

kernel configuration:
http://www.titov.net/misc/config.gz

/proc/interrupts, lspci, dmesg (nothing intresting there), ifconfig,
uname -a:
http://www.titov.net/misc/misc.txt.gz

Is it a Linux bug or some hardware limitation?

Regards,
Anton Titov

