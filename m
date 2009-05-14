Return-Path: <linux-kernel-owner+w=401wt.eu-S1757790AbZENPsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790AbZENPsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 11:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbZENPrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 11:47:52 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:36022 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337AbZENPru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 11:47:50 -0400
Message-ID: <4A0C3D79.2060308@oracle.com>
Date: Thu, 14 May 2009 08:49:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH] pcsp: fix printk format warning
References: <200905132354.n4DNsGbo008387@imap1.linux-foundation.org>
In-Reply-To: <200905132354.n4DNsGbo008387@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.4A0C3CFC.0229:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning:

sound/drivers/pcsp/pcsp_mixer.c:54: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Takashi Iwai <tiwai@suse.de>
---
 sound/drivers/pcsp/pcsp_mixer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm-2009-0513-1634.orig/sound/drivers/pcsp/pcsp_mixer.c
+++ mmotm-2009-0513-1634/sound/drivers/pcsp/pcsp_mixer.c
@@ -50,7 +50,7 @@ static int pcsp_treble_info(struct snd_k
 	uinfo->value.enumerated.items = chip->max_treble + 1;
 	if (uinfo->value.enumerated.item > chip->max_treble)
 		uinfo->value.enumerated.item = chip->max_treble;
-	sprintf(uinfo->value.enumerated.name, "%d",
+	sprintf(uinfo->value.enumerated.name, "%lu",
 			PCSP_CALC_RATE(uinfo->value.enumerated.item));
 	return 0;
 }


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
