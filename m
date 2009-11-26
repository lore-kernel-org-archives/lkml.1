Return-Path: <linux-kernel-owner+w=401wt.eu-S1760374AbZKZNPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760374AbZKZNPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 08:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbZKZNPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 08:15:32 -0500
Received: from mail.is74.ru ([83.142.161.14]:50553 "EHLO relay.intersvyaz.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbZKZNPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 08:15:32 -0500
X-Greylist: delayed 532 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Nov 2009 08:15:32 EST
Message-ID: <4B0E7D5E.3080906@chelcom.ru>
Date: Thu, 26 Nov 2009 18:06:38 +0500
From: "A. Porodko" <panda@chelcom.ru>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       Chaithrika U S <chaithrika@ti.com>,
       Troy Kisky <troy.kisky@boundarydevices.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kevin Hilman <khilman@deeprootsystems.com>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Subject: Sound support for Neuros OSD2 Davinci based board.
X-Enigmail-Version: 0.96.0
Content-Type: multipart/mixed;
 boundary="------------050305050402010500000508"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050305050402010500000508
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit

Hello,

Here is a patch for Neuros OSD2 Davinci (DM6446) based board sound support.
Patch made against 2.6.32-rc6 kernel.
------------------------------------------

-- 
Best regards
Andrey A. Porodko
 


--------------050305050402010500000508
Content-Type: text/x-patch;
 name="0005-Davinci-sound-soc-driver-patch-for-Neuros-OSD2-board.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0005-Davinci-sound-soc-driver-patch-for-Neuros-OSD2-board.pa";
 filename*1="tch"

>From 72b5b0efa71d0ca0bbe3a0c3ab577ee365385a28 Mon Sep 17 00:00:00 2001
From: Andrey Porodko <panda@chelcom.ru>
Date: Mon, 23 Nov 2009 13:56:53 +0500
Subject: [PATCH] Davinci sound soc driver patch for Neuros OSD2 board support.

Signed-off-by: Andrey Porodko <panda@chelcom.ru>
---
 sound/soc/davinci/davinci-evm.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/sound/soc/davinci/davinci-evm.c b/sound/soc/davinci/davinci-evm.c
index 67414f6..ffdd30e 100644
--- a/sound/soc/davinci/davinci-evm.c
+++ b/sound/soc/davinci/davinci-evm.c
@@ -55,6 +55,9 @@ static int evm_hw_params(struct snd_pcm_substream *substream,
 	else if (machine_is_davinci_evm())
 		sysclk = 12288000;
 
+	else if (machine_is_neuros_osd2())
+		sysclk = 27000000;
+
 	else if (machine_is_davinci_da830_evm() ||
 				machine_is_davinci_da850_evm())
 		sysclk = 24576000;
@@ -246,6 +249,9 @@ static int __init evm_init(void)
 	if (machine_is_davinci_evm()) {
 		evm_snd_dev_data = &evm_snd_devdata;
 		index = 0;
+	} else if (machine_is_neuros_osd2()) {
+		evm_snd_dev_data = &evm_snd_devdata;
+		index = 0;
 	} else if (machine_is_davinci_dm355_evm()) {
 		evm_snd_dev_data = &evm_snd_devdata;
 		index = 1;
-- 
1.5.6.5


--------------050305050402010500000508--
