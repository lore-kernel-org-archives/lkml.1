Return-Path: <linux-kernel-owner+w=401wt.eu-S1753417AbYGCBDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbYGCBDN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 21:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYGCBC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 21:02:58 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:60541 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbYGCBC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 21:02:57 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v2 0/5] SPI OF bindings and mpc5200-spi driver
To: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Cc: fabrizio.garetto@gmail.com, jonsmirl@gmail.com, david-b@pacbell.net
Date: Wed, 02 Jul 2008 19:02:52 -0600
Message-ID: <20080703005749.26187.71719.stgit@trillian.secretlab.ca>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think I've addressed all the comments I've received.  This series
adds OpenFirmware device tree bindings for SPI devices.  SPI master
drivers which make use of of_spi.c can retrieve the set of spi
devices from the device tree and automatically create them.

This series depends on previously posted patch:
"spi: Change modalias from a pointer to a character array"

 Documentation/powerpc/booting-without-of.txt |   60 +++
 drivers/of/Kconfig                           |    6 +
 drivers/of/Makefile                          |    1 +
 drivers/of/of_spi.c                          |   88 ++++
 drivers/spi/Kconfig                          |    8 +
 drivers/spi/Makefile                         |    1 +
 drivers/spi/mpc52xx_spi.c                    |  595 ++++++++++++++++++++++++++
 drivers/spi/spi.c                            |  141 +++++--
 include/linux/of_spi.h                       |   18 +
 include/linux/spi/mpc52xx_spi.h              |   10 +
 include/linux/spi/spi.h                      |   12 +-
 11 files changed, 895 insertions(+), 45 deletions(-)

--
Grant Likely, B.Sc. P.Eng.
Secret Lab Technologies Ltd.
