Return-Path: <linux-kernel-owner+w=401wt.eu-S1752464AbYHRVQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbYHRVQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbYHRVP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:15:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:36023 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbYHRVPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:15:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=nLnY9ps0DytrrEFGh82oY1T1Vf5X2+dJ9zTuHBrxwkE2nyutxnRsLg98Ra6X+mmonj
         avevIQlBN6p0CM7sAIQlF1jF3yIZ25i0v1i9WgrWwLZzuCEHhM64DT2LOWvPkk5TkC1b
         jLFGrC2fYERAmZ7lfE/a7BJ0XGUno0ZPbHQ6U=
Message-ID: <48AA3AE2.2090107@gmail.com>
Date: Mon, 18 Aug 2008 23:15:46 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: thomas@winischhofer.net, linux-kernel@vger.kernel.org
Subject: [PATCH] SIS: duplicate TV_PALN
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

untested, is it correct?
---
duplicate TV_PALN

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index 346d645..e251486 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -2113,7 +2113,7 @@ sisfb_detect_VB_connect(struct sis_video_info *ivideo)
 	   if( (!(ivideo->vbflags2 & VB2_SISBRIDGE)) &&
 	       (!((ivideo->sisvga_engine == SIS_315_VGA) &&
 			(ivideo->vbflags2 & VB2_CHRONTEL))) ) {
-	      if(ivideo->sisfb_tvstd & (TV_PALN | TV_PALN | TV_NTSCJ)) {
+	      if(ivideo->sisfb_tvstd & (TV_PALM | TV_PALN | TV_NTSCJ)) {
 		 ivideo->sisfb_tvstd = -1;
 		 printk(KERN_ERR "sisfb: PALM/PALN/NTSCJ not supported\n");
 	      }
