Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbYH2UcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbYH2UcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 16:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757585AbYH2Ub7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 16:31:59 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:30516 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502AbYH2Ub6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 16:31:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=apCTXt5SKPiDQ9fmUHDOPfF2yHtC0rdd0K+jQccsC/eACVCjGwWzBep2yS/9ZyyoEn
         dHdKT0ZqShRFFCRkfKJJUUg6W0cPn3+X30FZXCziF+y3e4mrcnz/TAwOp4YhHL5DSKxX
         d+W1P1RpKrZHbvMkvOCYJZq+ZZN+RgWlmVSqI=
Subject: [PATCH] alsa: ac97_patch make functions static
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 29 Aug 2008 13:32:00 -0700
Message-Id: <1220041920.23563.0.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only used in ac97_codec by including ac97_patch.c directly, effectively static

Found by sparse:
sound/pci/ac97/ac97_patch.c:3551:5: warning: symbol 'patch_vt1617a' was not declared. Should it be static?
sound/pci/ac97/ac97_patch.c:3767:5: warning: symbol 'patch_vt1618' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/ac97/ac97_patch.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/ac97/ac97_patch.c b/sound/pci/ac97/ac97_patch.c
index d0cab1d..6ce3cbe 100644
--- a/sound/pci/ac97/ac97_patch.c
+++ b/sound/pci/ac97/ac97_patch.c
@@ -3548,7 +3548,7 @@ static const struct snd_kcontrol_new snd_ac97_controls_vt1617a[] = {
 	},
 };
 
-int patch_vt1617a(struct snd_ac97 * ac97)
+static int patch_vt1617a(struct snd_ac97 * ac97)
 {
 	int err = 0;
 	int val;
@@ -3764,7 +3764,7 @@ static const struct snd_kcontrol_new snd_ac97_controls_vt1618[] = {
 	}
 };
 
-int patch_vt1618(struct snd_ac97 *ac97)
+static int patch_vt1618(struct snd_ac97 *ac97)
 {
 	return patch_build_controls(ac97, snd_ac97_controls_vt1618,
 				    ARRAY_SIZE(snd_ac97_controls_vt1618));
-- 
1.6.0.366.gf9ffa8



