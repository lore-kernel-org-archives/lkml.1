Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933777Ab0BES4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 13:56:30 -0500
Received: from adelie.canonical.com ([91.189.90.139]:40681 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933601Ab0BES42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 13:56:28 -0500
From: Amit Kucheria <amit.kucheria@canonical.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, s.hauer@pengutronix.de,
       gerg@uclinux.org, u.kleine-koenig@pengutronix.de,
       amit.kucheria@verdurent.com
Subject: [PATCH 0/3] net: fec fixes
Date: Fri,  5 Feb 2010 10:56:19 -0800
Message-Id: <cover.1265396105.git.amit.kucheria@canonical.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some fixes to the fec driver to get it to work on the Freescale i.MX5 SoC
platform

Amit Kucheria (2):
  fec: Add LAN8700 phy support
  fec: Add ARCH_MX5 as a dependency

Rob Herring (1):
  fec: fix uninitialized rx buffer usage

 drivers/net/Kconfig |    3 +-
 drivers/net/fec.c   |   78 ++++++++++++++++++++++++++++++++------------------
 2 files changed, 52 insertions(+), 29 deletions(-)

