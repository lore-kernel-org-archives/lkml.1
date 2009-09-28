Return-Path: <linux-kernel-owner+w=401wt.eu-S1752879AbZI1Tbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbZI1Tbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 15:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZI1Tba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 15:31:30 -0400
Received: from mail.gmx.net ([213.165.64.20]:49092 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752358AbZI1Tba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 15:31:30 -0400
X-Authenticated: #272795
X-Provags-ID: V01U2FsdGVkX1/hdwtv5ErhIz26/jv+th4PrE/5v0DVCPbMTAEUpI
	qJs/5XS5mypOK3
Subject: Disabling DMA with ICH10?
From: Lennart Baruschka <FunFlyer@gmx.net>
Reply-To: FunFlyer@gmx.net
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 28 Sep 2009 23:31:21 +0200
Message-Id: <1254173481.4454.32.camel@goodbyte.homelinux.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm new to this list, so please forgive me if this is the wrong place to
ask. I'm trying to build a 2.6.30.5 kernel causing as little DMA traffic
as possible in order to reduce latencies on a real-time system (using
RTAI). 

1. Is there a way to completely disable DMA usage system-wide?
If not:
2. My system uses an ICH10 chipset, the harddrive is connected to the
Intel SATA controller. Is there a way to disable DMA and switch back to
PIO? I tried compiling with libata support and without SCSI support, but
the kernel is unable to mount root (no matter if /dev/sda1
or /dev/hda1), then.
3. Another source seems to be the ATL1E driver for ethernet. Is it
possible to either disable DMA for this? 

If disabling DMA is impossible for some reason for one or both drivers,
is it at least possible to reduce the burst sizes so the bus gets free
for a short time during which I could access it from my real time kernel
module?

Please point me in the right direction; any suggestion will be greatly
appreciated!

Cheers,
Lennart

