Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbZJVTiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbZJVTiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 15:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756252AbZJVTiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 15:38:24 -0400
Received: from 139.254.232.72.static.reverse.ltdomains.com ([72.232.254.139]:41871
	"EHLO liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751815AbZJVTiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 15:38:23 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Andrea Paterniani <a.paterniani@swapp-eng.it>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] spidev: use DECLARE_BITMAP instead of declaring the array
Date: Thu, 22 Oct 2009 17:38:17 -0200
Message-Id: <1256240297-29419-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/spi/spidev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index d9b4100..10fc42f 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -54,7 +54,7 @@
 #define SPIDEV_MAJOR			153	/* assigned */
 #define N_SPI_MINORS			32	/* ... up to 256 */
 
-static unsigned long	minors[N_SPI_MINORS / BITS_PER_LONG];
+static DECLARE_BITMAP(minors,N_SPI_MINORS);
 
 
 /* Bit masks for spi_device.mode management.  Note that incorrect
-- 
1.6.3.3

