Return-Path: <linux-kernel-owner+w=401wt.eu-S1755064AbZKBMfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064AbZKBMfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 07:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754999AbZKBMfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 07:35:31 -0500
Received: from smtp.nokia.com ([192.100.122.233]:31303 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943AbZKBMf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 07:35:27 -0500
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
       sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, tony@atomide.com,
       broonie@opensource.wolfsonmicro.com
Subject: [PATCH 1/5] MFD: TWL4030: Add audio_mclk to the codec platform data
Date: Mon,  2 Nov 2009 14:34:51 +0200
Message-Id: <1257165295-9352-2-git-send-email-peter.ujfalusi@nokia.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257165295-9352-1-git-send-email-peter.ujfalusi@nokia.com>
References: <1257165295-9352-1-git-send-email-peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 02 Nov 2009 12:34:57.0139 (UTC) FILETIME=[E2D7E430:01CA5BB8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add audio_mclk to the twl4030-codec MFD

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>
---
 include/linux/i2c/twl4030.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/i2c/twl4030.h b/include/linux/i2c/twl4030.h
index 42d6c72..c188961 100644
--- a/include/linux/i2c/twl4030.h
+++ b/include/linux/i2c/twl4030.h
@@ -414,6 +414,7 @@ struct twl4030_codec_vibra_data {
 };
 
 struct twl4030_codec_data {
+	unsigned int	audio_mclk;
 	struct twl4030_codec_audio_data		*audio;
 	struct twl4030_codec_vibra_data		*vibra;
 };
-- 
1.6.5.2

