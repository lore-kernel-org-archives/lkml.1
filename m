Return-Path: <linux-kernel-owner+w=401wt.eu-S1753607AbZK3HBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbZK3HBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 02:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbZK3HBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 02:01:53 -0500
Received: from mail-ew0-f215.google.com ([209.85.219.215]:62967 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbZK3HBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 02:01:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:openpgp:content-type:content-transfer-encoding;
        b=QGpDgFKQSzOW96cXM+BLXIbSrqhWv3MaWB2ZoqmpCRzD7O/XBAKmYAsC9U88hSOdax
         IdShou/I2N0ZhjgV/UZNMEyO4MOwCdIDtTApu1SyhDGj9TbsrZfPinfCe5rt72eni+WD
         cu8ihizOE0yu5WQQuqr8d9GwAIOywydpF//jA=
Message-ID: <4B136DE3.7070400@gmail.com>
Date: Mon, 30 Nov 2009 12:01:55 +0500
From: "Andrey A. Porodko" <andrey.porodko@gmail.com>
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
Subject: Patch for davinci soc for Neuros OSD2 board support.
X-Enigmail-Version: 0.96.0
OpenPGP: id=9E6A5CCE
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've generated patch against

git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound-2.6.git for-2.6.33

Please, consider if it fits now.
------------------------------------------------------------
>From ab231a2647569cd039380730bd7c2a68a084c6c4 Mon Sep 17 00:00:00 2001
From: Andrey Porodko <panda@chelcom.ru>
Date: Mon, 30 Nov 2009 11:57:03 +0500
Subject: [PATCH] Davinci sound soc driver patch for Neuros OSD2 board support.

Signed-off-by: Andrey Porodko <panda@chelcom.ru>
---
 sound/soc/davinci/davinci-evm.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/sound/soc/davinci/davinci-evm.c b/sound/soc/davinci/davinci-evm.c
index 7ccbe66..1017fba 100644
--- a/sound/soc/davinci/davinci-evm.c
+++ b/sound/soc/davinci/davinci-evm.c
@@ -56,6 +56,9 @@ static int evm_hw_params(struct snd_pcm_substream *substream,
 	else if (machine_is_davinci_evm())
 		sysclk = 12288000;
 
+	else if (machine_is_neuros_osd2())
+		sysclk = 27000000;
+
 	else if (machine_is_davinci_da830_evm() ||
 				machine_is_davinci_da850_evm())
 		sysclk = 24576000;
@@ -247,6 +250,9 @@ static int __init evm_init(void)
 	if (machine_is_davinci_evm() || machine_is_davinci_dm365_evm()) {
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

----------------------------------------------------------------------

-- 
Best regards
Andrey A. Porodko
 

