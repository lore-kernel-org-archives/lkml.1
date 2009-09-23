Return-Path: <linux-kernel-owner+w=401wt.eu-S1752901AbZIWQBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbZIWQBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 12:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbZIWQBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 12:01:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861AbZIWQBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 12:01:31 -0400
From: Adam Jackson <ajax@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Adam Jackson <ajax@redhat.com>
Subject: [PATCH 1/4] drm/edid: const cleanup
Date: Wed, 23 Sep 2009 12:01:29 -0400
Message-Id: <1253721692-26165-1-git-send-email-ajax@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adam Jackson <ajax@redhat.com>
---
 drivers/gpu/drm/drm_edid.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 90d76ba..3326987 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -109,7 +109,9 @@ static struct edid_quirk {
 
 
 /* Valid EDID header has these bytes */
-static u8 edid_header[] = { 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00 };
+static const u8 edid_header[] = {
+	0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00
+};
 
 /**
  * edid_is_valid - sanity check EDID data
-- 
1.6.4.2

