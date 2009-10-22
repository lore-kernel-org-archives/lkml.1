Return-Path: <linux-kernel-owner+w=401wt.eu-S1756945AbZJVWLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbZJVWLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 18:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756909AbZJVWLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 18:11:07 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:54623 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897AbZJVWLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 18:11:05 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+ue1qR+L3xkP5XQyZHidth
Subject: [PATCH 00/10] omap fixes for v2.6.32-rc5
To: linux-arm-kernel@lists.infradead.org
From: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 22 Oct 2009 15:11:06 -0700
Message-ID: <20091022221013.27408.443.stgit@localhost>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here are some omap fixes for review.

Regards,

Tony

---

Hiroshi DOYU (1):
      omap: iommu: fix wrong condition check for SUPERSECTION

Janusz Krzysztofik (3):
      omap1: Fix DSP public peripherals support for ams-delta
      omap1: Fix redundant UARTs pin muxing that can break other hardware support
      omap: Fix omap-keypad by restoring old keypad.h without breaking omap2 boards that use matrix_keypad

Kevin Hilman (1):
      omap3: PM: enable UART3 module wakeups

Santosh Shilimkar (3):
      omap4: Fix UART4 platform data on omap4
      omap4: Allow omap_serial_early_init() for OMAP4430 board
      omap: SDMA: Fix omap_stop_dma() API for channel linking

Tony Lindgren (2):
      omap2: Fix console serial port number for n8x0
      omap: Fix detection of n8x0


 arch/arm/configs/n8x0_defconfig              |    2 +-
 arch/arm/mach-omap1/board-ams-delta.c        |    6 ++++++
 arch/arm/mach-omap1/board-generic.c          |    8 ++++++++
 arch/arm/mach-omap1/board-innovator.c        |   20 ++++++++++++++++++++
 arch/arm/mach-omap1/board-palmte.c           |    8 ++++++++
 arch/arm/mach-omap1/board-palmtt.c           |    8 ++++++++
 arch/arm/mach-omap1/board-palmz71.c          |    8 ++++++++
 arch/arm/mach-omap1/board-sx1.c              |    8 ++++++++
 arch/arm/mach-omap1/board-voiceblue.c        |    8 ++++++++
 arch/arm/mach-omap1/serial.c                 |   26 --------------------------
 arch/arm/mach-omap2/Kconfig                  |   12 ++++++++++++
 arch/arm/mach-omap2/board-3430sdp.c          |    2 +-
 arch/arm/mach-omap2/board-4430sdp.c          |    4 ++--
 arch/arm/mach-omap2/board-ldp.c              |    2 +-
 arch/arm/mach-omap2/board-omap3evm.c         |    2 +-
 arch/arm/mach-omap2/board-omap3pandora.c     |    2 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c |    2 +-
 arch/arm/mach-omap2/board-rx51.c             |    1 -
 arch/arm/mach-omap2/board-zoom2.c            |    2 +-
 arch/arm/mach-omap2/io.c                     |    2 ++
 arch/arm/mach-omap2/pm34xx.c                 |    7 ++++---
 arch/arm/mach-omap2/serial.c                 |   10 ----------
 arch/arm/plat-omap/dma.c                     |   18 ++++++++----------
 arch/arm/plat-omap/include/mach/keypad.h     |    5 ++++-
 arch/arm/plat-omap/iommu.c                   |    2 +-
 25 files changed, 114 insertions(+), 61 deletions(-)

-- 
Signature
