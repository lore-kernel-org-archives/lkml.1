Return-Path: <linux-kernel-owner+w=401wt.eu-S1752239AbZKDGej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbZKDGej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 01:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZKDGei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 01:34:38 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:60718 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbZKDGeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 01:34:37 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: Pierre Ossman <drzeus@drzeus.cx>,
       Anton Vorontsov <avorontsov@ru.mvista.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] mmc: fix missing module license declaration in of_mmc_spi.c
Date: Tue,  3 Nov 2009 23:34:04 -0700
Message-Id: <1257316444-7385-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver cannot be used as a module without this patch.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/mmc/host/of_mmc_spi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/of_mmc_spi.c b/drivers/mmc/host/of_mmc_spi.c
index fb2921f..644f67e 100644
--- a/drivers/mmc/host/of_mmc_spi.c
+++ b/drivers/mmc/host/of_mmc_spi.c
@@ -22,6 +22,8 @@
 #include <linux/mmc/core.h>
 #include <linux/mmc/host.h>
 
+MODULE_LICENSE("GPL");
+
 enum {
 	CD_GPIO = 0,
 	WP_GPIO,
-- 
1.6.3.3

