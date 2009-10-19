Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbZJSMKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbZJSMKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 08:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbZJSMKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 08:10:16 -0400
Received: from smtp.nokia.com ([192.100.122.233]:49760 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbZJSMKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 08:10:15 -0400
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] mfd: twl4030: Various twl4030-power fixes
Date: Mon, 19 Oct 2009 15:10:11 +0300
Message-Id: <1255954211-28496-1-git-send-email-amit.kucheria@verdurent.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 19 Oct 2009 12:10:12.0522 (UTC) FILETIME=[1C28D0A0:01CA50B5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support of remapping of power states and supply optimised power scripts
for the rx51 board. There are also some cleanups to made the code easier to
read.

Boot-tested on rx51 using linux-omap + Kevin's PM branch. We continue to hit
OFF states.

The scripts can be used as a reference for other OMAP3-based boards, but I'm
not sending patches since I don't have any HW.

Regards,
Amit

Amit Kucheria (5):
  mfd: twl4030-power: Rename DEVGROUP to DEV_GRP
  mfd: twl4030-power: Add comments for the register and bit layout
  mfd: twl4030-power: Move power-related data closer together in the
    header file
  mfd: twl4030-power: Add support for remapping power states
  mfd: twl4030-power: Optimised power scripts for the rx51

 arch/arm/mach-omap2/board-rx51-peripherals.c |  118 +++++++++++++------
 drivers/mfd/twl4030-power.c                  |   64 +++++++++--
 include/linux/i2c/twl4030.h                  |  157 +++++++++++++-------------
 3 files changed, 217 insertions(+), 122 deletions(-)

