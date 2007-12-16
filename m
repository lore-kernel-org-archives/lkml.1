Return-Path: <linux-kernel-owner+w=401wt.eu-S1762768AbXLPAg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762768AbXLPAg0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 19:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbXLPAgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 19:36:19 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:34712 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbXLPAgS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 19:36:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=nf4TbQHXSEBvjfdraBQS8Px/9kIod1oamzCphI5D0cCboMSF0vWgZD4OS6xQt3o64GL0zIDAubqlYm+4n5z5x9fWBmDWqopWuhA8xcasA+7Wol7k3vkwpJ4Q8ok+XeiVYkgfhvDL1BtUKhF+Oli0mG7W0Lw1Dwv9jRMsfraNims=
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] alsa: fix SNDRV_PCM_IOCTL_TTSTAMP value.
Date: Sun, 16 Dec 2007 01:36:30 +0100
User-Agent: KMail/1.9.7
Cc: perex@perex.cz
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712160136.30622.mboton@gmail.com>
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"[ALSA] Use posix clock monotonic for PCM and timer timestamps" introduces
a bug that makes audio device unusable in some computers.

Signed-off-by: Miguel Botón <mboton@gmail.com>

diff --git a/include/sound/asound.h b/include/sound/asound.h
index 475eb71..d35aa44 100644
--- a/include/sound/asound.h
+++ b/include/sound/asound.h
@@ -443,7 +443,7 @@ enum {
 enum {
 	SNDRV_PCM_IOCTL_PVERSION = _IOR('A', 0x00, int),
 	SNDRV_PCM_IOCTL_INFO = _IOR('A', 0x01, struct snd_pcm_info),
-	SNDRV_PCM_IOCTL_TTSTAMP = _IOW('A', 0x03, int),
+	SNDRV_PCM_IOCTL_TTSTAMP = _IOW('A', 0x02, int),
 	SNDRV_PCM_IOCTL_HW_REFINE = _IOWR('A', 0x10, struct snd_pcm_hw_params),
 	SNDRV_PCM_IOCTL_HW_PARAMS = _IOWR('A', 0x11, struct snd_pcm_hw_params),
 	SNDRV_PCM_IOCTL_HW_FREE = _IO('A', 0x12),

-- 
	Miguel Botón
