Return-Path: <linux-kernel-owner+w=401wt.eu-S1752983AbZIWQBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbZIWQBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 12:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbZIWQBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 12:01:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbZIWQBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 12:01:32 -0400
From: Adam Jackson <ajax@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Adam Jackson <ajax@redhat.com>
Subject: [PATCH 3/4] drm/edid: Detailed standard timing blocks have six timings, not five.
Date: Wed, 23 Sep 2009 12:01:31 -0400
Message-Id: <1253721692-26165-3-git-send-email-ajax@redhat.com>
In-Reply-To: <1253721692-26165-2-git-send-email-ajax@redhat.com>
References: <1253721692-26165-1-git-send-email-ajax@redhat.com>
 <1253721692-26165-2-git-send-email-ajax@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adam Jackson <ajax@redhat.com>
---
 drivers/gpu/drm/drm_edid.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index dd35dc1..8ed732a 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -847,8 +847,7 @@ static int add_detailed_info(struct drm_connector *connector,
 			case EDID_DETAIL_MONITOR_CPDATA:
 				break;
 			case EDID_DETAIL_STD_MODES:
-				/* Five modes per detailed section */
-				for (j = 0; j < 5; i++) {
+				for (j = 0; j < 6; i++) {
 					struct std_timing *std;
 					struct drm_display_mode *newmode;
 
-- 
1.6.4.2

