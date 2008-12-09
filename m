Return-Path: <linux-kernel-owner+w=401wt.eu-S1755766AbYLJQOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbYLJQOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:14:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbYLJQNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:13:34 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:55799 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739AbYLJQNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:13:33 -0500
Message-ID: <493feaa9.0e0f660a.18a9.69b8@mx.google.com>
To: Karsten Keil <kkeil@suse.de>
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Date: Tue, 9 Dec 2008 20:49:30 +0100
Subject: [PATCH 1/9] mISDN: fix sparse warnings
From: Hannes Eder <hannes@hanneseder.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Use NULL pointer instead of plain integer

Fix more than 100 sparse warnings:

  drivers/isdn/hardware/mISDN/hfcmulti.c:***:**: warning: Using plain integer as NULL pointer
  drivers/isdn/mISDN/dsp_tones.c:***:**: warning: Using plain integer as NULL pointer
  drivers/isdn/mISDN/dsp_pipeline.c:***:**: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c |    2 +-
 drivers/isdn/mISDN/dsp_pipeline.c      |    2 +-
 drivers/isdn/mISDN/dsp_tones.c         |   90 ++++++++++++++++----------------
 3 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 1eac03f..46684e1 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -887,7 +887,7 @@ vpm_echocan_off(struct hfc_multi *hc, int ch)
 static inline void
 hfcmulti_resync(struct hfc_multi *locked, struct hfc_multi *newmaster, int rm)
 {
-	struct hfc_multi *hc, *next, *pcmmaster = 0;
+	struct hfc_multi *hc, *next, *pcmmaster = NULL;
 	u_int *plx_acc_32, pv;
 	u_long flags;
 
diff --git a/drivers/isdn/mISDN/dsp_pipeline.c b/drivers/isdn/mISDN/dsp_pipeline.c
index fdc800b..83639be 100644
--- a/drivers/isdn/mISDN/dsp_pipeline.c
+++ b/drivers/isdn/mISDN/dsp_pipeline.c
@@ -249,7 +249,7 @@ int dsp_pipeline_build(struct dsp_pipeline *pipeline, const char *cfg)
 		name = strsep(&tok, "(");
 		args = strsep(&tok, ")");
 		if (args && !*args)
-			args = 0;
+			args = NULL;
 
 		list_for_each_entry_safe(entry, n, &dsp_elements, list)
 			if (!strcmp(entry->elem->name, name)) {
diff --git a/drivers/isdn/mISDN/dsp_tones.c b/drivers/isdn/mISDN/dsp_tones.c
index 23dd0dd..de4d0c9 100644
--- a/drivers/isdn/mISDN/dsp_tones.c
+++ b/drivers/isdn/mISDN/dsp_tones.c
@@ -238,113 +238,113 @@ struct pattern {
 	u32 seq[10];
 } pattern[] = {
 	{TONE_GERMAN_DIALTONE,
-	{DATA_GA, 0, 0, 0, 0, 0, 0, 0, 0, 0},
-	{SIZE_GA, 0, 0, 0, 0, 0, 0, 0, 0, 0},
+	{DATA_GA, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
+	{SIZE_GA, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
 	{1900, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 
 	{TONE_GERMAN_OLDDIALTONE,
-	{DATA_GO, 0, 0, 0, 0, 0, 0, 0, 0, 0},
-	{SIZE_GO, 0, 0, 0, 0, 0, 0, 0, 0, 0},
+	{DATA_GO, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
+	{SIZE_GO, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
 	{1998, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 
 	{TONE_AMERICAN_DIALTONE,
-	{DATA_DT, 0, 0, 0, 0, 0, 0, 0, 0, 0},
-	{SIZE_DT, 0, 0, 0, 0, 0, 0, 0, 0, 0},
+	{DATA_DT, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
+	{SIZE_DT, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
 	{8000, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 
 	{TONE_GERMAN_DIALPBX,
-	{DATA_GA, DATA_S, DATA_GA, DATA_S, DATA_GA, DATA_S, 0, 0, 0, 0},
-	{SIZE_GA, SIZE_S, SIZE_GA, SIZE_S, SIZE_GA, SIZE_S, 0, 0, 0, 0},
+	{DATA_GA, DATA_S, DATA_GA, DATA_S, DATA_GA, DATA_S, NULL, NULL, NULL, NULL},
+	{SIZE_GA, SIZE_S, SIZE_GA, SIZE_S, SIZE_GA, SIZE_S, NULL, NULL, NULL, NULL},
 	{2000, 2000, 2000, 2000, 2000, 12000, 0, 0, 0, 0} },
 
 	{TONE_GERMAN_OLDDIALPBX,
-	{DATA_GO, DATA_S, DATA_GO, DATA_S, DATA_GO, DATA_S, 0, 0, 0, 0},
-	{SIZE_GO, SIZE_S, SIZE_GO, SIZE_S, SIZE_GO, SIZE_S, 0, 0, 0, 0},
+	{DATA_GO, DATA_S, DATA_GO, DATA_S, DATA_GO, DATA_S, NULL, NULL, NULL, NULL},
+	{SIZE_GO, SIZE_S, SIZE_GO, SIZE_S, SIZE_GO, SIZE_S, NULL, NULL, NULL, NULL},
 	{2000, 2000, 2000, 2000, 2000, 12000, 0, 0, 0, 0} },
 
 	{TONE_AMERICAN_DIALPBX,
-	{DATA_DT, DATA_S, DATA_DT, DATA_S, DATA_DT, DATA_S, 0, 0, 0, 0},
-	{SIZE_DT, SIZE_S, SIZE_DT, SIZE_S, SIZE_DT, SIZE_S, 0, 0, 0, 0},
+	{DATA_DT, DATA_S, DATA_DT, DATA_S, DATA_DT, DATA_S, NULL, NULL, NULL, NULL},
+	{SIZE_DT, SIZE_S, SIZE_DT, SIZE_S, SIZE_DT, SIZE_S, NULL, NULL, NULL, NULL},
 	{2000, 2000, 2000, 2000, 2000, 12000, 0, 0, 0, 0} },
 
 	{TONE_GERMAN_RINGING,
-	{DATA_GA, DATA_S, 0, 0, 0, 0, 0, 0, 0, 0},
-	{SIZE_GA, SIZE_S, 0, 0, 0, 0, 0, 0, 0, 0},
+	{DATA_GA, DATA_S, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
+	{SIZE_GA, SIZE_S, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
 	{8000, 32000, 0, 0, 0, 0, 0, 0, 0, 0} },
 
 	{TONE_GERMAN_OLDRINGING,
-	{DATA_GO, DATA_S, 0, 0, 0, 0, 0, 0, 0, 0},
-	{SIZE_GO, SIZE_S, 0, 0, 0, 0, 0, 0, 0, 0},
+	{DATA_GO, DATA_S, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
+	{SIZE_GO, SIZE_S, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
 	{8000, 40000, 0, 0, 0, 0, 0, 0, 0, 0} },
 
 	{TONE_AMERICAN_RINGING,
-	{DATA_RI, DATA_S, 0, 0, 0, 0, 0, 0, 0, 0},
-	{SIZE_RI, SIZE_S, 0, 0, 0, 0, 0, 0, 0, 0},
+	{DATA_RI, DATA_S, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
+	{SIZE_RI, SIZE_S, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
 	{8000, 32000, 0, 0, 0, 0, 0, 0, 0, 0} },
 
 	{TONE_GERMAN_RINGPBX,
-	{DATA_GA, DATA_S, DATA_GA, DATA_S, 0, 0, 0, 0, 0, 0},
-	{SIZE_GA, SIZE_S, SIZE_GA, SIZE_S, 0, 0, 0, 0, 0, 0},
+	{DATA_GA, DATA_S, DATA_GA, DATA_S, NULL, NULL, NULL, NULL, NULL, NULL},
+	{SIZE_GA, SIZE_S, SIZE_GA, SIZE_S, NULL, NULL, NULL, NULL, NULL, NULL},
 	{4000, 4000, 4000, 28000, 0, 0, 0, 0, 0, 0} },
 
 	{TONE_GERMAN_OLDRINGPBX,
-	{DATA_GO, DATA_S, DATA_GO, DATA_S, 0, 0, 0, 0, 0, 0},
-	{SIZE_GO, SIZE_S, SIZE_GO, SIZE_S, 0, 0, 0, 0, 0, 0},
+	{DATA_GO, DATA_S, DATA_GO, DATA_S, NULL, NULL, NULL, NULL, NULL, NULL},
+	{SIZE_GO, SIZE_S, SIZE_GO, SIZE_S, NULL, NULL, NULL, NULL, NULL, NULL},
 	{4000, 4000, 4000, 28000, 0, 0, 0, 0, 0, 0} },
 
 	{TONE_AMERICAN_RINGPBX,
-	{DATA_RI, DATA_S, DATA_RI, DATA_S, 0, 0, 0, 0, 0, 0},
-	{SIZE_RI, SIZE_S, SIZE_RI, SIZE_S, 0, 0, 0, 0, 0, 0},
+	{DATA_RI, DATA_S, DATA_RI, DATA_S, NULL, NULL, NULL, NULL, NULL, NULL},
+	{SIZE_RI, SIZE_S, SIZE_RI, SIZE_S, NULL, NULL, NULL, NULL, NULL, NULL},
 	{4000, 4000, 4000, 28000, 0, 0, 0, 0, 0, 0} },
 
 	{TONE_GERMAN_BUSY,
-	{DATA_GA, DATA_S, 0, 0, 0, 0, 0, 0, 0, 0},
-	{SIZE_GA, SIZE_S, 0, 0, 0, 0, 0, 0, 0, 0},
+	{DATA_GA, DATA_S, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
+	{SIZE_GA, SIZE_S, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
 	{4000, 4000, 0, 0, 0, 0, 0, 0, 0, 0} },
 
 	{TONE_GERMAN_OLDBUSY,
-	{DATA_GO, DATA_S, 0, 0, 0, 0, 0, 0, 0, 0},
-	{SIZE_GO, SIZE_S, 0, 0, 0, 0, 0, 0, 0, 0},
+	{DATA_GO, DATA_S, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
+	{SIZE_GO, SIZE_S, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
 	{1000, 5000, 0, 0, 0, 0, 0, 0, 0, 0} },
 
 	{TONE_AMERICAN_BUSY,
-	{DATA_BU, DATA_S, 0, 0, 0, 0, 0, 0, 0, 0},
-	{SIZE_BU, SIZE_S, 0, 0, 0, 0, 0, 0, 0, 0},
+	{DATA_BU, DATA_S, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
+	{SIZE_BU, SIZE_S, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
 	{4000, 4000, 0, 0, 0, 0, 0, 0, 0, 0} },
 
 	{TONE_GERMAN_HANGUP,
-	{DATA_GA, DATA_S, 0, 0, 0, 0, 0, 0, 0, 0},
-	{SIZE_GA, SIZE_S, 0, 0, 0, 0, 0, 0, 0, 0},
+	{DATA_GA, DATA_S, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
+	{SIZE_GA, SIZE_S, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
 	{4000, 4000, 0, 0, 0, 0, 0, 0, 0, 0} },
 
 	{TONE_GERMAN_OLDHANGUP,
-	{DATA_GO, DATA_S, 0, 0, 0, 0, 0, 0, 0, 0},
-	{SIZE_GO, SIZE_S, 0, 0, 0, 0, 0, 0, 0, 0},
+	{DATA_GO, DATA_S, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
+	{SIZE_GO, SIZE_S, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
 	{1000, 5000, 0, 0, 0, 0, 0, 0, 0, 0} },
 
 	{TONE_AMERICAN_HANGUP,
-	{DATA_DT, 0, 0, 0, 0, 0, 0, 0, 0, 0},
-	{SIZE_DT, 0, 0, 0, 0, 0, 0, 0, 0, 0},
+	{DATA_DT, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
+	{SIZE_DT, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
 	{8000, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 
 	{TONE_SPECIAL_INFO,
-	{DATA_S1, DATA_S2, DATA_S3, DATA_S, 0, 0, 0, 0, 0, 0},
-	{SIZE_S1, SIZE_S2, SIZE_S3, SIZE_S, 0, 0, 0, 0, 0, 0},
+	{DATA_S1, DATA_S2, DATA_S3, DATA_S, NULL, NULL, NULL, NULL, NULL, NULL},
+	{SIZE_S1, SIZE_S2, SIZE_S3, SIZE_S, NULL, NULL, NULL, NULL, NULL, NULL},
 	{2666, 2666, 2666, 8002, 0, 0, 0, 0, 0, 0} },
 
 	{TONE_GERMAN_GASSENBESETZT,
-	{DATA_GA, DATA_S, 0, 0, 0, 0, 0, 0, 0, 0},
-	{SIZE_GA, SIZE_S, 0, 0, 0, 0, 0, 0, 0, 0},
+	{DATA_GA, DATA_S, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
+	{SIZE_GA, SIZE_S, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
 	{2000, 2000, 0, 0, 0, 0, 0, 0, 0, 0} },
 
 	{TONE_GERMAN_AUFSCHALTTON,
-	{DATA_GO, DATA_S, DATA_GO, DATA_S, 0, 0, 0, 0, 0, 0},
-	{SIZE_GO, SIZE_S, SIZE_GO, SIZE_S, 0, 0, 0, 0, 0, 0},
+	{DATA_GO, DATA_S, DATA_GO, DATA_S, NULL, NULL, NULL, NULL, NULL, NULL},
+	{SIZE_GO, SIZE_S, SIZE_GO, SIZE_S, NULL, NULL, NULL, NULL, NULL, NULL},
 	{1000, 5000, 1000, 17000, 0, 0, 0, 0, 0, 0} },
 
 	{0,
-	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
-	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
+	{NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
+	{NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL},
 	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 };
 
@@ -467,7 +467,7 @@ dsp_tone_timeout(void *arg)
 
 	/* set next tone */
 	if (pat->data[index] == DATA_S)
-		dsp_tone_hw_message(dsp, 0, 0);
+		dsp_tone_hw_message(dsp, NULL, 0);
 	else
 		dsp_tone_hw_message(dsp, pat->data[index], *(pat->siz[index]));
 	/* set timer */
-- 
1.5.6.3

