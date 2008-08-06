Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbYHFNXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbYHFNXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbYHFNT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:19:59 -0400
Received: from lopsy-lu.misterjones.org ([62.4.18.26]:53645 "EHLO
	young-lust.wild-wind.fr.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753414AbYHFNT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:19:58 -0400
From: Marc Zyngier <maz@misterjones.org>
To: linux-kernel@vger.kernel.org
Cc: Amit Walambe <amit.walambe@eurotech-ltd.co.uk>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH 0/5] Support for Arcom/Eurotech Viper SBC
Date: Wed,  6 Aug 2008 15:19:49 +0200
Message-Id: <1218028794-850-1-git-send-email-maz@misterjones.org>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-SA-Exim-Connect-IP: 81.255.32.141
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, amit.walambe@eurotech-ltd.co.uk, linux@dominikbrodowski.net
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on young-lust.wild-wind.fr.eu.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch serie, against 2.6.27-rc2, adds support for the PXA-255 based 
Arcom/Eurotech Viper SBC. It is roughly based on the old 2.6.16.28 port
made by Arcom, though all bugs are of course mine.

It's been heavily tested over the last two months.

Most of these patches are quite straightforward, except for the generic
PCMCIA patch that may be questionable.

As usual, I'll be glad to receive any comment you may have about this patch.

Thanks,

	M.

 arch/arm/configs/viper_defconfig | 1657 ++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-pxa/Kconfig        |    6 +
 arch/arm/mach-pxa/Makefile       |    1 +
 arch/arm/mach-pxa/viper.c        |  952 ++++++++++++++++++++++
 drivers/net/smc91x.h             |   21 +
 drivers/pcmcia/Kconfig           |    2 +-
 drivers/pcmcia/Makefile          |    1 +
 drivers/pcmcia/pxa2xx_base.c     |   20 +-
 drivers/pcmcia/pxa2xx_base.h     |    7 +
 drivers/pcmcia/pxa2xx_viper.c    |  183 +++++
 drivers/pcmcia/soc_common.h      |    2 +
 include/asm-arm/arch-pxa/irqs.h  |   23 +
 include/asm-arm/arch-pxa/viper.h |   91 +++


