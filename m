Return-Path: <linux-kernel-owner+w=401wt.eu-S1759979AbZFRPNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979AbZFRPNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 11:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758561AbZFRPMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 11:12:53 -0400
Received: from mail.atmel.fr ([81.80.104.162]:37925 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760820AbZFRPMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 11:12:53 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: avictor.za@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk
Cc: patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] at91: Introduction of at91sam9g10 SOC
Date: Thu, 18 Jun 2009 18:16:07 +0200
Message-Id: <1245341772-1689-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.3.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AT91sam9g10 is an ARM 926ej-s SOC. It is an evolution of the at91sam9261 with a
faster clock speed: 266/133MHz.

This patchset is relying on the integration of at91sam9g45 already posted. Here
is the patch series that you will have to take into account before applying
those patches.

clock.c changes:
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=5438/1

9g45 introduction:
http://lkml.org/lkml/2009/6/4/77
http://lkml.org/lkml/2009/6/4/76
http://lkml.org/lkml/2009/6/4/78

---
 arch/arm/mach-at91/Kconfig                    |   25 +++++++++++++-
 arch/arm/mach-at91/Makefile                   |    2 +
 arch/arm/mach-at91/at91sam9261.c              |   22 ++++++++++++-
 arch/arm/mach-at91/board-sam9261ek.c          |   14 ++++++++
 arch/arm/mach-at91/clock.c                    |    6 ++-
 arch/arm/mach-at91/include/mach/at91sam9261.h |    3 ++
 arch/arm/mach-at91/include/mach/cpu.h         |    7 ++++
 arch/arm/mach-at91/include/mach/hardware.h    |    2 +-
 arch/arm/mach-at91/include/mach/timex.h       |    5 +++
 arch/arm/mach-at91/pm.c                       |    3 +-
 drivers/usb/gadget/at91_udc.c                 |    6 ++--
 drivers/usb/host/ohci-at91.c                  |   10 +++---
 drivers/video/Kconfig                         |    4 +-
 drivers/video/atmel_lcdfb.c                   |    6 ++-
 drivers/video/backlight/Kconfig               |    2 +-
 15 files changed, 97 insertions(+), 20 deletions(-)


