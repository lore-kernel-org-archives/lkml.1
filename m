Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152Ab0AEAzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab0AEAzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984Ab0AEAzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:55:45 -0500
Received: from kroah.org ([198.145.64.141]:34120 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184Ab0AEAep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:34:45 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/97] ASoC: wm8974: fix a wrong bit definition
Date: Mon,  4 Jan 2010 16:32:24 -0800
Message-Id: <1262651630-7354-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

commit 48c03ce72f2665f79a3fe54fc6d71b8cc3d30803 upstream.

The wm8974 datasheet defines BUFIOEN as bit 2.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/soc/codecs/wm8974.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8974.c b/sound/soc/codecs/wm8974.c
index 98d663a..b0bd1c0 100644
--- a/sound/soc/codecs/wm8974.c
+++ b/sound/soc/codecs/wm8974.c
@@ -47,7 +47,7 @@ static const u16 wm8974_reg[WM8974_CACHEREGNUM] = {
 };
 
 #define WM8974_POWER1_BIASEN  0x08
-#define WM8974_POWER1_BUFIOEN 0x10
+#define WM8974_POWER1_BUFIOEN 0x04
 
 struct wm8974_priv {
 	struct snd_soc_codec codec;
-- 
1.6.6

