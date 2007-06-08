Return-Path: <linux-kernel-owner+w=401wt.eu-S939708AbXFHHy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939708AbXFHHy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938231AbXFHHZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:25:19 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55350 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932237AbXFHHZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:25:07 -0400
Message-Id: <20070608072213.196608000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:21:56 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 29/54] ALSA: wm8750 typo fix
Content-Disposition: inline; filename=alsa-wm8750-typo-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Andrew Morton <akpm@linux-foundation.org>

I quuestion the testing status of that patch!

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jaroslav Kysela <perex@suse.cz>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/soc/codecs/wm8750.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.21.4.orig/sound/soc/codecs/wm8750.c
+++ linux-2.6.21.4/sound/soc/codecs/wm8750.c
@@ -808,7 +808,7 @@ static int wm8750_init(struct snd_soc_de
 	codec->dai = &wm8750_dai;
 	codec->num_dai = 1;
 	codec->reg_cache_size = sizeof(wm8750_reg);
-	codec->reg_cache = kmemdup(wm8750_reg, sizeof(wm8750_reg), GFP_KRENEL);
+	codec->reg_cache = kmemdup(wm8750_reg, sizeof(wm8750_reg), GFP_KERNEL);
 	if (codec->reg_cache == NULL)
 		return -ENOMEM;
 

-- 
