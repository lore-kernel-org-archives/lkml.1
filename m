Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640AbZKDH7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbZKDH7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 02:59:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbZKDH7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 02:59:00 -0500
Received: from smtp.nokia.com ([192.100.122.233]:16518 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbZKDH6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 02:58:42 -0500
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
       sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, tony@atomide.com,
       broonie@opensource.wolfsonmicro.com
Subject: [PATCH 1/4 v2] MFD: TWL4030: Add audio_mclk to the codec platform data
Date: Wed,  4 Nov 2009 09:58:17 +0200
Message-Id: <1257321500-27049-2-git-send-email-peter.ujfalusi@nokia.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257321500-27049-1-git-send-email-peter.ujfalusi@nokia.com>
References: <1257321500-27049-1-git-send-email-peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 04 Nov 2009 07:58:28.0464 (UTC) FILETIME=[980C7700:01CA5D24]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add audio_mclk to the platform data struct for the
twl4030-codec MFD driver.

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

