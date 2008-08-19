Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbYHRVnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbYHRVnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbYHRVnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:43:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:58328 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbYHRVnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:43:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=jtCe1JbWckeYIAVGBzt5c6+BC6t5CoPLcpXljKXe88ScUyQXjOikTi1A+igMgInEhw
         CXUaz6moB1Uxfb2u5hLisZjJ7bUmGNI+evWP9arqSjLEygxqQw4GVPqtAWqYQATvo2R5
         /od0jTLfBLSaMycssy42Vy1ARPtTf3aYmi+o4=
Message-ID: <48AA4155.907@gmail.com>
Date: Mon, 18 Aug 2008 23:43:17 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] OSS: duplicate AFMT_S24_LE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

untested, is it correct?
---
duplicate AFMT_S24_LE

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
index 4c601b1..b27ca27 100644
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -1755,7 +1755,7 @@ static int snd_pcm_oss_get_formats(struct snd_pcm_oss_file *pcm_oss_file)
 		       AFMT_S8 | AFMT_U16_LE |
 		       AFMT_U16_BE |
 			AFMT_S32_LE | AFMT_S32_BE |
-			AFMT_S24_LE | AFMT_S24_LE |
+			AFMT_S24_LE | AFMT_S24_BE |
 			AFMT_S24_PACKED;
 	params = kmalloc(sizeof(*params), GFP_KERNEL);
 	if (!params)
