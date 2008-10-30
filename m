Return-Path: <linux-kernel-owner+w=401wt.eu-S1755056AbYJ3LKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbYJ3LKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 07:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbYJ3LKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 07:10:04 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37427 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbYJ3LKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 07:10:01 -0400
Date: Thu, 30 Oct 2008 13:09:55 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: perex@perex.cz, tiwai@suse.de
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 01/10] sound/ice1712: indentation & braces disagree - add
 braces
Message-ID: <Pine.LNX.4.64.0810301307160.7072@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-1087615928-1225364995=:7072"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-1087615928-1225364995=:7072
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT


Neither has any significance currently to the flow
because err is checked for the same condition before
the place of disagreement.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
---
 sound/pci/ice1712/ice1712.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index 5b44238..58d7cda 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -2688,12 +2688,13 @@ static int __devinit snd_ice1712_probe(struct pci_dev *pci,
 		return err;
 	}
 
-	if (ice_has_con_ac97(ice))
+	if (ice_has_con_ac97(ice)) {
 		err = snd_ice1712_pcm(ice, pcm_dev++, NULL);
 		if (err < 0) {
 			snd_card_free(card);
 			return err;
 		}
+	}
 
 	err = snd_ice1712_ac97_mixer(ice);
 	if (err < 0) {
@@ -2715,12 +2716,13 @@ static int __devinit snd_ice1712_probe(struct pci_dev *pci,
 		}
 	}
 
-	if (ice_has_con_ac97(ice))
+	if (ice_has_con_ac97(ice)) {
 		err = snd_ice1712_pcm_ds(ice, pcm_dev++, NULL);
 		if (err < 0) {
 			snd_card_free(card);
 			return err;
 		}
+	}
 
 	if (!c->no_mpu401) {
 		err = snd_mpu401_uart_new(card, 0, MPU401_HW_ICE1712,
-- 
1.5.2.2

---696208474-1087615928-1225364995=:7072--
