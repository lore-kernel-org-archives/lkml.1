Return-Path: <linux-kernel-owner+w=401wt.eu-S1762019AbZAPI16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762019AbZAPI16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756713AbZAPI10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:27:26 -0500
Received: from smtp.nokia.com ([192.100.122.233]:41512 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbZAPI1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:27:24 -0500
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: [PATCH 00/10] arm: omap mailbox: add omap3 support with some fixes
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org
Date: Fri, 16 Jan 2009 10:27:01 +0200
Message-ID: <20090116081919.17571.34378.stgit@oreo.research.nokia.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2009 08:27:03.0081 (UTC) FILETIME=[356B4190:01C977B4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches add omap3 support and some cleanups.

This "omap mailbox" device driver has been used for the interprocessor
communication between ARM and some co-processors(DSP) inside of omap
SoC, which is a kind of interrupt driven FIFO.

---

Hiroshi DOYU (10):
      omap mailbox: remove unnecessary header file inclusion
      omap mailbox: convert sequence bit checking to module paramter
      omap mailbox: move mailbox.h into mailbox.c
      omap mailbox: add save_/restore_ctx() for PM
      omap mailbox: fix empty struct device for omap2
      omap mailbox: fix empty struct device for omap1
      omap mailbox: fix empty struct device for omap_mbox
      omap mailbox: print hardware revision at startup
      omap mailbox: add initial omap3 support
      omap mailbox: cleanup omap2 register definition with macro


 arch/arm/mach-omap1/devices.c              |    2 
 arch/arm/mach-omap1/mailbox.c              |   31 ++--
 arch/arm/mach-omap2/devices.c              |   38 ++++-
 arch/arm/mach-omap2/mailbox.c              |  195 +++++++++++++++++-----------
 arch/arm/plat-omap/Kconfig                 |    8 +
 arch/arm/plat-omap/include/mach/mailbox.h  |   27 ++++
 arch/arm/plat-omap/include/mach/omap34xx.h |    1 
 arch/arm/plat-omap/mailbox.c               |  152 ++++++++++++++++------
 arch/arm/plat-omap/mailbox.h               |  100 --------------
 9 files changed, 311 insertions(+), 243 deletions(-)
 delete mode 100644 arch/arm/plat-omap/mailbox.h

-- 
   Hiroshi DOYU

