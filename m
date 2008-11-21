Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbYKUPDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbYKUPDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 10:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYKUPD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 10:03:27 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:5701 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbYKUPD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 10:03:27 -0500
Message-ID: <154e089b0811210703h3b63273et77acddfc0e6612e8@mail.gmail.com>
Date: Fri, 21 Nov 2008 16:03:24 +0100
From: "Hannes Eder" <hannes@hanneseder.net>
To: "Takashi Iwai" <tiwai@suse.de>, "Jaroslav Kysela" <perex@perex.cz>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] ALSA: hda - fix sparse warning
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse warning:

sound/pci/hda/patch_nvhdmi.c:161:25: warning: symbol
'snd_hda_preset_nvhdmi' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 sound/pci/hda/patch_nvhdmi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/pci/hda/patch_nvhdmi.c b/sound/pci/hda/patch_nvhdmi.c
index 2eed2c8..1360d54 100644
--- a/sound/pci/hda/patch_nvhdmi.c
+++ b/sound/pci/hda/patch_nvhdmi.c
@@ -28,6 +28,7 @@
 #include <sound/core.h>
 #include "hda_codec.h"
 #include "hda_local.h"
+#include "hda_patch.h"

 struct nvhdmi_spec {
 	struct hda_multi_out multiout;
