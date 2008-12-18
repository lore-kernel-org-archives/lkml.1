Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbYLRXGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbYLRXGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 18:06:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbYLRXG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 18:06:28 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:61268 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbYLRXG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 18:06:27 -0500
Message-ID: <494ad5dd.0e0f660a.2937.ffff82d3@mx.google.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Date: Thu, 18 Dec 2008 21:24:18 +0100
Subject: [PATCH 4/6] drm/i915: fix sparse warnings: returning void-valued expression
From: Hannes Eder <hannes@hanneseder.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:

  drivers/gpu/drm/i915/intel_display.c:216:3: warning: returning void-valued expression
  drivers/gpu/drm/i915/intel_display.c:218:3: warning: returning void-valued expression

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/gpu/drm/i915/intel_display.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 9094119..035be19 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -213,10 +213,9 @@ static void intel_clock(struct drm_device *dev, int refclk,
 			intel_clock_t *clock)
 {
 	if (IS_I9XX(dev))
-		return i9xx_clock (refclk, clock);
+		i9xx_clock(refclk, clock);
 	else
-		return i8xx_clock (refclk, clock);
+		i8xx_clock(refclk, clock);
 }
 
 /**
-- 
1.5.6.3

