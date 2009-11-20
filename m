Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbZKTPvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbZKTPvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 10:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbZKTPvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 10:51:44 -0500
Received: from huecha.unizar.es ([155.210.1.51]:45953 "EHLO huecha.unizar.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbZKTPvn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 10:51:43 -0500
From: "=?utf-8?Q?=22J.A._Magall=C3=B3n=22?=" <jamagallon@ono.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Performance of bonding driver
Date: Fri, 20 Nov 2009 16:51:47 +0100
Message-Id: <A58902EC-8913-46FC-A8FF-0F67961B8C11@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Mime-Version: 1.0 (Apple Message framework v1077)
X-Mailer: Apple Mail (2.1077)
X-Mail-Scanned: Criba 2.0 + Clamd & Bogofilter
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi...

I have tw boxes which I linked together vi 2x gigabit interfaces and a
3Com switch. Each interface is:

02:0a.0 Ethernet controller: Intel Corporation 82541EI Gigabit Ethernet Controller
02:0b.0 Ethernet controller: Intel Corporation 82541EI Gigabit Ethernet Controller

The switch is private for them, so there is no more taffic.
One interface alone works pretty well:

[  3] local 192.168.1.208 port 37739 connected with 192.168.1.226 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  1.00 GBytes    861 Mbits/sec

I loaded bondin driver with no parameters, and using iperf to test the connection
I get:

[  5] local 192.168.1.208 port 5001 connected with 192.168.1.226 port 40036
[ ID] Interval       Transfer     Bandwidth
[  5]  0.0-10.0 sec    812 MBytes    679 Mbits/sec

In the node which receives, two instances of iftop on slave interfaces
show that load is balanced, but none flies higher than about 300 Mb/s.

Any ideas ?
Is bonding dependent on CPU power ? Boxes are P4-HT@2.8, 3Gb of RAM.

TIA

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free




