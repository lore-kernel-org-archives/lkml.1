Return-Path: <linux-kernel-owner+w=401wt.eu-S934448AbXGaUiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934448AbXGaUiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 16:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933906AbXGaUgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 16:36:49 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:31400 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934032AbXGaUgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 16:36:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=Xhx7cws8QQ86FTg2zVXO9gIXtTqtSRDOPCt6uhkyaepGO1+atGOayurpQ8zCObjqeuvK1G+5odGLtH/+8bXt3zOtGLNNDEHRw2A9hR2hyD5MtZ6z8DY/+mEy7RS1q0LoOuyGwwoSJ0uwrML33FIb+yqSTU+9u9yRZi3BrM1mrOw=
Message-ID: <46AF9D47.5090302@googlemail.com>
Date: Tue, 31 Jul 2007 22:36:23 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Jaroslav Kysela <perex@suse.cz>,
       alsa-devel@alsa-project.org, LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Get rid of dead code in sound/pci/ac97/ac97_patch.c
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

File /home/devel/linux-rdc/sound/pci/ac97/ac97_patch.c line 484
Unknown CONFIG option! CONFIG_TOUCHSCREEN_WM9705

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-rdc-clean/sound/pci/ac97/ac97_patch.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-rdc/sound/pci/ac97/ac97_patch.c	2007-07-31 17:26:32.000000000 +0200
@@ -481,10 +481,7 @@ static int patch_wolfson05(struct snd_ac
 {
 	/* WM9705, WM9710 */
 	ac97->build_ops = &patch_wolfson_wm9705_ops;
-#ifdef CONFIG_TOUCHSCREEN_WM9705
-	/* WM9705 touchscreen uses AUX and VIDEO for touch */
-	ac97->flags |= AC97_HAS_NO_VIDEO | AC97_HAS_NO_AUX;
-#endif
+
 	return 0;
 }
 
