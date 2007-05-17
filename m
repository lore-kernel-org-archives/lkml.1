Return-Path: <linux-kernel-owner+w=401wt.eu-S1761389AbXEQUUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761389AbXEQUUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 16:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbXEQUU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 16:20:29 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:48652 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554AbXEQUU2 (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 16:20:28 -0400
From: CIJOML <cijoml@volny.cz>
To: Linux-kernel@vger.kernel.org
Subject: Having problems with 8250 module in 2.6.20,2.6.21...
Date: Thu, 17 May 2007 22:20:10 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705172220.10469.cijoml@volny.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with kernel 2.6.20 and 2.6.21 I have problem with my good old router 
Dell Dual P2 333MHz.

Module 8250 getts loaded, but UPS driver is unable talk to UPS:

Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
eth0:  setting full-duplex.
eth1:  setting full-duplex.
prism2: wlan0: operating mode changed 3 -> 2
wifi0: LinkStatus=2 (Disconnected)
wifi0: LinkStatus: BSSID=00:60:b3:6a:5e:88
nf_conntrack version 0.5.0 (1024 buckets, 8192 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
wifi0: LinkStatus=1 (Connected)
wifi0: LinkStatus: BSSID=00:02:2d:ba:4e:7d
ttyS0: LSR safety check engaged!
ttyS0: LSR safety check engaged!
ttyS1: LSR safety check engaged!
ttyS1: LSR safety check engaged!
HTB: quantum of class 10001 is big. Consider r2q change.
HTB: quantum of class 10001 is big. Consider r2q change.
HTB: quantum of class 10015 is small. Consider r2q change.
HTB: quantum of class 10016 is small. Consider r2q change.
HTB: quantum of class 10017 is small. Consider r2q change.
HTB: quantum of class 10011 is small. Consider r2q change.
HTB: quantum of class 10015 is small. Consider r2q change.
HTB: quantum of class 10016 is small. Consider r2q change.
HTB: quantum of class 10017 is small. Consider r2q change.
u32 classifier
    OLD policer on
wifi0: LinkStatus=2 (Disconnected)
wifi0: LinkStatus: BSSID=00:02:2d:ba:4e:7d
wifi0: LinkStatus=2 (Disconnected)
wifi0: LinkStatus: BSSID=44:44:44:44:44:44
ttyS1: LSR safety check engaged!
wifi0: LinkStatus=1 (Connected)
wifi0: LinkStatus: BSSID=00:02:2d:ba:4e:7d
ttyS1: LSR safety check engaged!
ttyS1: LSR safety check engaged!
ttyS1: LSR safety check engaged!
ttyS1: LSR safety check engaged!
ttyS1: LSR safety check engaged!
ttyS1: LSR safety check engaged!
ttyS1: LSR safety check engaged!

Liboc01:/home/cijoml# upsdrvctl start
Network UPS Tools - UPS driver controller 2.0.4
Network UPS Tools - Tripp-Lite SmartUPS driver 0.8 (2.0.4)
tcgetattr(/dev/ttyS1): Input/output error
Driver failed to start (exit status=1)

Does anybody work on this problem or can help?

Thanks a LOT

Michal
