Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbZASNid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbZASNid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756738AbZASNhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:37:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34179 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756195AbZASNhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:37:09 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 5/5] regulator: Mark attributes table for virtual regulator static
Date: Mon, 19 Jan 2009 13:37:06 +0000
Message-Id: <1232372226-23319-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1232372226-23319-4-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1232372226-23319-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1232372226-23319-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1232372226-23319-3-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1232372226-23319-4-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not exported.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/virtual.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/virtual.c b/drivers/regulator/virtual.c
index 45ebbc2..3d08348 100644
--- a/drivers/regulator/virtual.c
+++ b/drivers/regulator/virtual.c
@@ -260,7 +260,7 @@ static DEVICE_ATTR(min_microamps, 0666, show_min_uA, set_min_uA);
 static DEVICE_ATTR(max_microamps, 0666, show_max_uA, set_max_uA);
 static DEVICE_ATTR(mode, 0666, show_mode, set_mode);
 
-struct device_attribute *attributes[] = {
+static struct device_attribute *attributes[] = {
 	&dev_attr_min_microvolts,
 	&dev_attr_max_microvolts,
 	&dev_attr_min_microamps,
-- 
1.5.6.5

