Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbYJOKxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbYJOKxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 06:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbYJOKxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 06:53:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37655 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752207AbYJOKxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 06:53:36 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Build on non-ARM platforms
Date: Wed, 15 Oct 2008 11:53:34 +0100
Message-Id: <1224068014-24845-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the regulator API was merged it was added to the separate Kconfig
which ARM uses for drivers but not the generic one in drivers/.  Since
there is nothing ARM-specific about the API add it there too.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 59f33fa..9cad258 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -68,6 +68,8 @@ source "drivers/ssb/Kconfig"
 
 source "drivers/mfd/Kconfig"
 
+source "drivers/regulator/Kconfig"
+
 source "drivers/media/Kconfig"
 
 source "drivers/video/Kconfig"
-- 
1.5.6.5

