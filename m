Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbZKBMgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbZKBMgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 07:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbZKBMgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 07:36:35 -0500
Received: from smtp.nokia.com ([192.100.122.230]:19507 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973AbZKBMf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 07:35:27 -0500
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
       sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, tony@atomide.com,
       broonie@opensource.wolfsonmicro.com
Subject: [PATCH 2/5] OMAP: Configure audio_mclk for twl4030-codec MFD
Date: Mon,  2 Nov 2009 14:34:52 +0200
Message-Id: <1257165295-9352-3-git-send-email-peter.ujfalusi@nokia.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257165295-9352-2-git-send-email-peter.ujfalusi@nokia.com>
References: <1257165295-9352-1-git-send-email-peter.ujfalusi@nokia.com>
 <1257165295-9352-2-git-send-email-peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 02 Nov 2009 12:34:58.0514 (UTC) FILETIME=[E3A9B320:01CA5BB8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

audio_mclk value is going to be handled by the
twl4030-codec MFD driver, configure the correct
value for boards, which is using the twl4030 audio.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>
---
 arch/arm/mach-omap2/board-3430sdp.c      |    1 +
 arch/arm/mach-omap2/board-omap3beagle.c  |    1 +
 arch/arm/mach-omap2/board-omap3evm.c     |    1 +
 arch/arm/mach-omap2/board-omap3pandora.c |    1 +
 arch/arm/mach-omap2/board-overo.c        |    1 +
 arch/arm/mach-omap2/board-zoom2.c        |    1 +
 6 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-3430sdp.c b/arch/arm/mach-omap2/board-3430sdp.c
index 4f91f7a..9afd957 100644
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@ -415,6 +415,7 @@ static struct twl4030_codec_audio_data sdp3430_audio = {
 };
 
 static struct twl4030_codec_data sdp3430_codec = {
+	.audio_mclk = 26000000,
 	.audio = &sdp3430_audio,
 };
 
diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index 2161d85..8f0c106 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -259,6 +259,7 @@ static struct twl4030_codec_audio_data beagle_audio_data = {
 };
 
 static struct twl4030_codec_data beagle_codec_data = {
+	.audio_mclk = 26000000,
 	.audio = &beagle_audio_data,
 };
 
diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index d9a6103..5bb30cb 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -199,6 +199,7 @@ static struct twl4030_codec_audio_data omap3evm_audio_data = {
 };
 
 static struct twl4030_codec_data omap3evm_codec_data = {
+	.audio_mclk = 26000000,
 	.audio = &omap3evm_audio_data,
 };
 
diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-omap2/board-omap3pandora.c
index 5036b56..77790ee 100644
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@ -286,6 +286,7 @@ static struct twl4030_codec_audio_data omap3pandora_audio_data = {
 };
 
 static struct twl4030_codec_data omap3pandora_codec_data = {
+	.audio_mclk = 26000000,
 	.audio = &omap3pandora_audio_data,
 };
 
diff --git a/arch/arm/mach-omap2/board-overo.c b/arch/arm/mach-omap2/board-overo.c
index dc55008..e1fb504 100644
--- a/arch/arm/mach-omap2/board-overo.c
+++ b/arch/arm/mach-omap2/board-overo.c
@@ -334,6 +334,7 @@ static struct twl4030_codec_audio_data overo_audio_data = {
 };
 
 static struct twl4030_codec_data overo_codec_data = {
+	.audio_mclk = 26000000,
 	.audio = &overo_audio_data,
 };
 
diff --git a/arch/arm/mach-omap2/board-zoom2.c b/arch/arm/mach-omap2/board-zoom2.c
index f1b4e7c..de3a38d 100644
--- a/arch/arm/mach-omap2/board-zoom2.c
+++ b/arch/arm/mach-omap2/board-zoom2.c
@@ -234,6 +234,7 @@ static struct twl4030_codec_audio_data zoom2_audio_data = {
 };
 
 static struct twl4030_codec_data zoom2_codec_data = {
+	.audio_mclk = 26000000,
 	.audio = &zoom2_audio_data,
 };
 
-- 
1.6.5.2

