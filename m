Return-Path: <linux-kernel-owner+w=401wt.eu-S1758434AbZASNhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434AbZASNhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756475AbZASNhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:37:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34174 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756176AbZASNhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:37:09 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/5] regulator: Make fixed voltage regulators visible in Kconfig
Date: Mon, 19 Jan 2009 13:37:05 +0000
Message-Id: <1232372226-23319-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1232372226-23319-3-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1232372226-23319-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1232372226-23319-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1232372226-23319-3-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows users to enable or disable support for these regulators at
build time as they can for other regulators rather than having platforms
force the regulators to be built in.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/Kconfig |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index e7e0cf1..85a1f40 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -29,8 +29,12 @@ config REGULATOR_DEBUG
 	  Say yes here to enable debugging support.
 
 config REGULATOR_FIXED_VOLTAGE
-	tristate
+	tristate "Fixed voltage regulator support"
 	default n
+	help
+	  This driver provides support for fixed voltage regulators,
+	  useful for systems which use a combination of software
+	  managed regulators and simple non-configurable regulators.
 
 config REGULATOR_VIRTUAL_CONSUMER
 	tristate "Virtual regulator consumer support"
-- 
1.5.6.5

