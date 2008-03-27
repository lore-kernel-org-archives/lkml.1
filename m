Return-Path: <linux-kernel-owner+w=401wt.eu-S1760536AbYCZK3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760536AbYCZK3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 06:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758107AbYCZK2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 06:28:34 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:51352 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989AbYCZK2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 06:28:33 -0400
X-IronPort-AV: E=Sophos;i="4.25,557,1199682000"; 
   d="scan'208";a="50790839"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 3/3] Blackfin SPI Driver: Fix warning: remove unused label
Date: Wed, 26 Mar 2008 18:28:32 -0700
Message-Id: <1206581312-25869-4-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/spi/spi_bfin5xx.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index a4bf3af..6635e15 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -1319,7 +1319,6 @@ out_error_no_dma_ch:
 	iounmap((void *) drv_data->regs_base);
 out_error_ioremap:
 out_error_get_res:
-out_error:
 	spi_master_put(master);
 
 	return status;
-- 
1.5.4.3
