Return-Path: <linux-kernel-owner+w=401wt.eu-S1763542AbXE2DkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763542AbXE2DkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 23:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759630AbXE2Djz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 23:39:55 -0400
Received: from [59.60.157.102] ([59.60.157.102]:53901 "EHLO dev.extmail.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759002AbXE2Djy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 23:39:54 -0400
X-Greylist: delayed 1176 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 May 2007 23:39:54 EDT
Message-ID: <465B9BD8.8040102@westea.org>
Date: Tue, 29 May 2007 11:19:52 +0800
From: Wang Penghui <wangpenghui@westea.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Network broken in kernel level.
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, list,

Recently, i have messed up with the follow problem, i have two server
both with two ethernet cards. Here are them:

[root@db1 ~]# lspci | grep -i eth
05:00.0 Ethernet controller: Marvell Technology Group Ltd. Gigabit
Ethernet Controller (rev 18)
07:04.0 Ethernet controller: Intel Corp. 82541GI/PI Gigabit Ethernet
Controller (rev 05)

And they are running MySQL server on both of them. The OS is RHEL 4 with
the default kernel 2.6.9-5.ELsmp. These days there are lots of error
message comming out in /var/log/message and dmesg.

KERNEL: assertion (tp->copied_seq == tp->rcv_nxt || (flags & (MSG_PEEK |
MSG_TRUNC))) failed at net/ipv4/tcp.c (1348)
KERNEL: assertion (tp->copied_seq == tp->rcv_nxt || (flags & (MSG_PEEK |
MSG_TRUNC))) failed at net/ipv4/tcp.c (1348)
KERNEL: assertion (tp->copied_seq == tp->rcv_nxt || (flags & (MSG_PEEK |
MSG_TRUNC))) failed at net/ipv4/tcp.c (1348)
KERNEL: assertion (flags & MSG_PEEK) failed at net/ipv4/tcp.c (1284)
KERNEL: assertion (flags & MSG_PEEK) failed at net/ipv4/tcp.c (1284)

When it appeared, the network of Marvell card has been broken. It
connected but accessable.
We have installed the driver of the Marvell card manully with the driver
"Driver version: 8.30.2.3 (Dec-14-2005)".

I have digged in google for a long time. But unluckly, i haven't got the
sulotion.

Did i need a kernel upgrade or driver upgrade or anything else?

Every response is apperciated.

Wang.
