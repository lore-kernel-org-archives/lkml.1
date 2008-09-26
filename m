Return-Path: <linux-kernel-owner+w=401wt.eu-S1753637AbYIZOUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbYIZOUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 10:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbYIZOUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 10:20:08 -0400
Received: from main.gmane.org ([80.91.229.2]:50466 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbYIZOUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 10:20:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Rafal <newsgroup@limcore.com>
Subject: Kernel unable to adjust timeofday
Date: Fri, 26 Sep 2008 15:29:53 +0200
Organization: LimCore.com
Message-ID: <gbio4j$aqq$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: dbs185.neoplus.adsl.tpnet.pl
User-Agent: KNode/0.10.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, my system (64bit Ubuntu amd64 box) drifts about 10 seconds per hour
(i.e. time visible in the system).

When I adjust the date (i.e. by ntpdate) then the adjust works (but has to
be repeated each few minutes at least).

When I use adjtime(), or when I use ntpd that uses adjtime() then the
adjustment is slower then the speed of drift.

The default rate of adjustment seems to be really low, can we set the
default adjustment rate to be a higher?




Hardware (parts from lshw)

     description: Motherboard
       product: RS780-SB700
       physical id: 0
       version: Unknox
       serial: Thu Jan 20 03:32:34 2000
       slot: Internal Cache
     *-firmware
          description: BIOS
          vendor: Award Software International, Inc.
          physical id: 0
          version: F1 (01/21/2008)
          size: 128KiB
          capacity: 960KiB
          capabilities: isa pci pnp apm upgrade shadowing cdboot bootselect
socketedrom edd int13floppy360 int13floppy1200 int13floppy720
int13floppy2880 int5printscreen int9keyboard int14serial int17printer
int10video acpi usb agp ls120boot zipboot biosbootspecification
     *-cpu:0
          description: CPU
          product: AMD Athlon(tm) 64 X2 Dual Core Processor 4200+

     *-pci:0
          description: Host bridge
          product: RS780 Host Bridge
          vendor: Advanced Micro Devices [AMD]

-- 
Rafał Maj
Software developer
http://www.limcore.com/

