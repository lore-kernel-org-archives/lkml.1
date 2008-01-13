Return-Path: <linux-kernel-owner+w=401wt.eu-S1752428AbYAMOYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbYAMOYR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 09:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750704AbYAMOYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 09:24:06 -0500
Received: from www17.your-server.de ([213.133.104.17]:58266 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbYAMOYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 09:24:05 -0500
Message-ID: <1200234241.478a1f016a940@213.133.104.17>
Date: Sun, 13 Jan 2008 15:24:01 +0100
From: thomas@m3y3r.de
To: linux-kernel@vger.kernel.org
Subject: question regarding user mode linux
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.5
X-Originating-IP: 88.68.98.185
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I try to setup a user mode linux session and dmesg says:
"[cut]
 ubda: unknown partition table
Choosing a random ethernet address for device eth0
Netdevice 0 (9e:69:a0:f3:f1:f0) : TUN/TAP backend - IP = 192.168.5.1
Filesystem "ubda": Disabling barriers, not supported by the underlying device
[cut]"

id est eth0.

But the network device is:
# cat /proc/net/dev
Inter-|   Receive                                                |  Transmit
 face |bytes    packets errs drop fifo frame compressed multicast|bytes   
packets errs drop fifo colls carrier compressed
    lo:       0       0    0    0    0     0          0         0        0      
0    0    0    0     0       0          0
  eth6:       0       0    0    0    0     0          0         0        0      
0    0    0    0     0       0          0

id est eth6

# uname -a
Linux localhost 2.6.24-rc7-gd0c4c9d4 #1 Sat Jan 12 13:25:44 CET 2008 i686 UML
User Mode Linux GNU/Linux

Any ideas what could be wrong here?

mfg
thomas
