Return-Path: <linux-kernel-owner+w=401wt.eu-S939420AbXGSTQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939420AbXGSTQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 15:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933856AbXGSTQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 15:16:35 -0400
Received: from gw.goop.org ([64.81.55.164]:59302 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933737AbXGSTQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 15:16:34 -0400
Message-ID: <469FB856.6030000@goop.org>
Date: Thu, 19 Jul 2007 12:15:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: drzeus-sdhci@drzeus.cx
CC: sdhci-devel@list.drzeus.cx,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: SDHCI: mmc0: Unexpected interrupt 0x00008000.
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting this with current GIT kernels when I plug an SD card into
the side of my machine.  It appears to see the filesystem OK anyway, but
for some reason all the hal/gnome desktop stuff isn't seeing it.  Was
working last week.

The message is:

mmc0: Unexpected interrupt 0x00008000.
sdhci: ============== REGISTER DUMP ==============
sdhci: Sys addr: 0x2d7d4600 | Version:  0x00000200
sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000000
sdhci: Argument: 0x000001aa | Trn mode: 0x00000033
sdhci: Present:  0x01ff0001 | Host ctl: 0x00000001
sdhci: Power:    0x0000000f | Blk gap:  0x00000000
sdhci: Wake-up:  0x00000000 | Clock:    0x00008007
sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
sdhci: Int enab: 0x00ff00fb | Sig enab: 0x00ff00fb
sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
sdhci: Caps:     0x018021a1 | Max curr: 0x00000040
sdhci: ===========================================
PM: Adding info for mmc:mmc0:b368
mmcblk0: mmc0:b368 LEXAR 999936KiB 
 mmcblk0: p1


The machine is a Thinkpad X60, and the SD device is:

15:00.2 Generic system peripheral [0805]: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 18)
        Subsystem: Lenovo Thinkpad X60s
        Flags: bus master, medium devsel, latency 64, IRQ 22
        Memory at e4301800 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2


Seems to work OK if I manually mount it.  To be honest, I don't know if
this message was always appearing or not; I only checked because it
didn't seem to be working.

    J
