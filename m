Return-Path: <linux-kernel-owner+w=401wt.eu-S1765117AbXG2QLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765117AbXG2QLu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 12:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761467AbXG2QLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 12:11:43 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2337 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762370AbXG2QLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 12:11:43 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: perex@suse.cz, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ac97/ac97_codec.c: make 2 functions stacic
Date: Sun, 29 Jul 2007 18:11:40 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707291811.41644.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	Fix sparc64 warnings.

sound/pci/ac97/ac97_patch.h:86: warning: 'snd_ac97_restore_status' declared 'static' but never defined
sound/pci/ac97/ac97_patch.h:87: warning: 'snd_ac97_restore_iec958' declared 'static' but never defined

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 sound/pci/ac97/ac97_codec.c | 93823 -> 93837 (+14 bytes)
 sound/pci/ac97/ac97_codec.o | 341841 -> 341841 (0 bytes)

 sound/pci/ac97/ac97_codec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.23-rc1-mm1-a/sound/pci/ac97/ac97_codec.c	2007-07-26 13:07:39.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/sound/pci/ac97/ac97_codec.c	2007-07-29 17:53:23.000000000 +0200
@@ -2436,7 +2436,7 @@ EXPORT_SYMBOL(snd_ac97_suspend);
 /*
  * restore ac97 status
  */
-void snd_ac97_restore_status(struct snd_ac97 *ac97)
+static void snd_ac97_restore_status(struct snd_ac97 *ac97)
 {
 	int i;

@@ -2457,7 +2457,7 @@ void snd_ac97_restore_status(struct snd_
 /*
  * restore IEC958 status
  */
-void snd_ac97_restore_iec958(struct snd_ac97 *ac97)
+static void snd_ac97_restore_iec958(struct snd_ac97 *ac97)
 {
 	if (ac97->ext_id & AC97_EI_SPDIF) {
 		if (ac97->regs[AC97_EXTENDED_STATUS] & AC97_EA_SPDIF) {
