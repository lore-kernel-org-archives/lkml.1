Return-Path: <linux-kernel-owner+w=401wt.eu-S935360AbXJPSfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935360AbXJPSfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 14:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759700AbXJPSfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 14:35:46 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:45695 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759551AbXJPSfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 14:35:46 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Organization: Mandriva
To: LKML <linux-kernel@vger.kernel.org>
Subject: Asus Eeepc missing in alsa models list?
Date: Tue, 16 Oct 2007 16:35:34 -0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200710161635.35861.herton@mandriva.com.br>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at the change 291702f017efdfe556cb87b8530eb7d1ff08cbae, may be the 
addition of the Asus Eeepc model was missed? The following patch fixes it if 
it was not intended originally:

diff --git a/Documentation/sound/alsa/ALSA-Configuration.txt 
b/Documentation/sound/alsa/ALSA-Configuration.txt
index 4b48c2e..e2a1985 100644
--- a/Documentation/sound/alsa/ALSA-Configuration.txt
+++ b/Documentation/sound/alsa/ALSA-Configuration.txt
@@ -843,6 +843,7 @@ Prior to version 0.9.0rc4 options had a 'snd_' prefix. 
This was removed.
 	  3stack-6ch-dig 3-stack (6-channel) with SPDIF
 	  6stack-dig	 6-stack with SPDIF
 	  lenovo-101e	 Lenovo laptop
+	  eeepc-p701	 ASUS Eeepc
 	  auto		auto-config reading BIOS (default)
 
 	ALC882/885
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 53b0428..2ceaf4c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -12058,6 +12058,7 @@ static const char *alc662_models[ALC662_MODEL_LAST] = 
{
 	[ALC662_3ST_6ch]	= "3stack-6ch",
 	[ALC662_5ST_DIG]	= "6stack-dig",
 	[ALC662_LENOVO_101E]	= "lenovo-101e",
+	[ALC662_ASUS_EEEPC_P701]	= "eeepc-p701",
 	[ALC662_AUTO]		= "auto",
 };
 
-- 
[]'s
Herton
