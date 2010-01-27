Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726Ab0A0Tdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab0A0Tdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 14:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754596Ab0A0Tcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 14:32:39 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44197 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab0A0Tcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 14:32:35 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5874"; a="32915974"
From: adharmap@codeaurora.org
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Yinghai Lu <yinghai@kernel.org>, Tony Lindgren <tony@atomide.com>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Kalle Valo <kalle.valo@iki.fi>, Jean Pihet <jpihet@mvista.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Colin Tuckley <colin.tuckley@arm.com>,
       Philby John <pjohn@in.mvista.com>,
       Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
       Alessandro Rubini <rubini@unipv.it>,
       Andrea Gallo <andrea.gallo@stericsson.com>,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>
Subject: [PATCH 0/5] Arm Gic Changes
Date: Wed, 27 Jan 2010 11:32:24 -0800
Message-Id: <1264620749-24527-1-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijeet Dharmapurikar <adharmap@quicinc.com>

Few fixes and improvements to arch/arm/common/gic.c file.

Abhijeet Dharmapurikar (5):
  gic: prevent gic from crossing NR_IRQ
  gic: add callback for mask_ack
  gic: Add set_type callback
  gic: dont disable INT in ack callback
  gic: initialize interrupts as per argument

 arch/arm/common/gic.c                    |  114 ++++++++++++++++++++++++-----
 arch/arm/include/asm/hardware/gic.h      |    3 +-
 arch/arm/mach-omap2/board-4430sdp.c      |    3 +-
 arch/arm/mach-realview/realview_eb.c     |   10 ++-
 arch/arm/mach-realview/realview_pb1176.c |    7 ++-
 arch/arm/mach-realview/realview_pb11mp.c |    7 ++-
 arch/arm/mach-realview/realview_pba8.c   |    4 +-
 arch/arm/mach-realview/realview_pbx.c    |    5 +-
 arch/arm/mach-ux500/cpu-u8500.c          |    2 +-
 9 files changed, 122 insertions(+), 33 deletions(-)

