Return-Path: <linux-kernel-owner+w=401wt.eu-S1762488AbZFRGyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762488AbZFRGyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 02:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbZFRGyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 02:54:36 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49798 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbZFRGyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 02:54:36 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: 
Date: Thu, 18 Jun 2009 08:54:30 +0200
Message-Id: <1245308072-14392-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.6.3.1
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew et al,

This series contains a SPI master driver for i.MX SoCs, it has been
posted several times on the arm linux kernel list and the spi devel list
without objections. As David Brownell doesn't seem to be available, maybe
you could pick it up?

Thanks
  Sascha


The following changes since commit 65795efbd380a832ae508b04dba8f8e53f0b84d9:
  Linus Torvalds (1):
        Merge branch 'next-i2c' of git://aeryn.fluff.org.uk/bjdooks/linux

are available in the git repository at:

  git://git.pengutronix.de/git/sha/linux-2.6.git for-david

Sascha Hauer (2):
      remove i.MX SPI driver
      SPI: Add SPI driver for most known i.MX SoCs

 arch/arm/plat-mxc/include/mach/spi.h |   27 +
 drivers/spi/Kconfig                  |    7 +-
 drivers/spi/Makefile                 |    2 +-
 drivers/spi/mxc_spi.c                |  685 +++++++++++++
 drivers/spi/spi_imx.c                | 1779 ----------------------------------
 5 files changed, 717 insertions(+), 1783 deletions(-)
 create mode 100644 arch/arm/plat-mxc/include/mach/spi.h
 create mode 100644 drivers/spi/mxc_spi.c
 delete mode 100644 drivers/spi/spi_imx.c

