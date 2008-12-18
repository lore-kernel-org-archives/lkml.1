Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752333AbYLRPlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbYLRPlm (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 10:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbYLRPld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 10:41:33 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36419 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750968AbYLRPlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 10:41:32 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Add missing break in WM8350 register cache setup
Date: Thu, 18 Dec 2008 15:41:30 +0000
Message-Id: <1229614890-20073-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

Followup patch to my previous series, fixing an underlying bug.

 drivers/mfd/wm8350-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index 3a519de..d4daa73 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -1169,6 +1169,7 @@ static int wm8350_create_cache(struct wm8350 *wm8350, int type, int mode)
 				mode);
 			return -EINVAL;
 		}
+		break;
 
 	case 1:
 		switch (mode) {
-- 
1.5.6.5

