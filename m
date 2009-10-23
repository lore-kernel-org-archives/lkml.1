Return-Path: <linux-kernel-owner+w=401wt.eu-S1752291AbZJWP3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbZJWP3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 11:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbZJWP3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 11:29:18 -0400
Received: from mail.atmel.fr ([81.80.104.162]:38665 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752184AbZJWP3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 11:29:17 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-mmc@vger.kernel.org, haavard.skinnemoen@atmel.com
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/2 v2]mmc: atmel-mci: introduce MCI2 support on at91
Date: Fri, 23 Oct 2009 18:34:11 +0200
Message-Id: <1256315654-21589-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20090930155557.7dae503b@hskinnemoen-d830>
References: <20090930155557.7dae503b@hskinnemoen-d830>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces the support of a new revision of the MCI IP on AT91
SOCs. The use of an alternate DMA engine on those platforms introduces the need
of a generic way of handling dma slave interface.

Note: those patches goes on top of the following patch that is already in
mainline:
	atmel-mci: unified Atmel MCI drivers (AVR32 & AT91)

Nicolas Ferre (3):
      atmel-mci: change use of dma slave interface
      mmc: atmel-mci: New MCI2 module support in atmel-mci driver
      at91/atmel-mci: inclusion of sd/mmc driver in at91sam9g45 chip and board

 arch/arm/mach-at91/at91sam9g45_devices.c        |  164 +++++++++++++++++++++++
 arch/arm/mach-at91/board-sam9m10g45ek.c         |   24 ++++
 arch/arm/mach-at91/include/mach/atmel-mci.h     |   24 ++++
 arch/avr32/mach-at32ap/at32ap700x.c             |   18 ++-
 arch/avr32/mach-at32ap/include/mach/atmel-mci.h |   24 ++++
 drivers/mmc/host/Kconfig                        |    2 +-
 drivers/mmc/host/atmel-mci.c                    |  141 +++++++++++++++----
 include/linux/atmel-mci.h                       |    4 +-
 8 files changed, 362 insertions(+), 39 deletions(-)
 create mode 100644 arch/arm/mach-at91/include/mach/atmel-mci.h
 create mode 100644 arch/avr32/mach-at32ap/include/mach/atmel-mci.h


