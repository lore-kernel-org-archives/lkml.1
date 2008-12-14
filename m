Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbYLNFGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbYLNFGX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 00:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750699AbYLNFGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 00:06:13 -0500
Received: from main.gmane.org ([80.91.229.2]:56521 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbYLNFGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 00:06:12 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: suspend/resume fails on second attempt in LNXVIDEO:00
Date: Sun, 14 Dec 2008 05:06:01 +0000 (UTC)
Message-ID: <gi247o$iog$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: d193-213-184.home3.cgocable.net
User-Agent: Pan/0.132 (Waxed in Black)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to debug a resume problem on a compaq presario C700 laptop on 
the Ubuntu 2.6.24-22-generic kernel.

I've used the /sys/power/pm_trace facility to debug the problem to the
following:

[   31.212062]   Magic number: 0:716:374
[   31.212115]   hash matches /build/buildd/linux-2.6.24/drivers/base/power/main.c:97
[   31.212255]   hash matches device LNXVIDEO:00

Not sure where to go from here though.  Devices in this machine are:

00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory Controller Hub (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 03)
00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 03)
00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3)
00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface Controller (rev 03)
00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 03)
00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA AHCI Controller (rev 03)
00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 03)
01:00.0 Ethernet controller: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter (rev 01)
02:01.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)

These symptoms mirror a lot of other reports with this machine in that 
the first suspend/resume cycle works but a second attempts (apparently) 
suspends fine but fails on resume.  The backlight on the video does not 
come back and neither does the wireless connection, so I'm not positive 
the problems are purely video related.

How can I proceed from here to further debug what kind of workarounds or
solutions I might be able to use to get reliable suspend/resume 
functionality?

Thanx,
b.

