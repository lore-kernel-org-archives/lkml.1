Return-Path: <linux-kernel-owner+w=401wt.eu-S1751236AbZGOCSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236AbZGOCSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 22:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbZGOCSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 22:18:50 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:51442 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbZGOCSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 22:18:50 -0400
From: Subrata Modak <subrata@linux.vnet.ibm.com>
To: Jaroslav Kysela <erex@perex.cz>, alsa-devel@alsa-project.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Takashi Iwai <iwai@suse.de>
Cc: Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Wed, 15 Jul 2009 07:48:30 +0530
Message-Id: <20090715021826.4032.63752.sendpatchset@subratamodak.linux.ibm.com>
Subject: [PATCH 01/06] Fix compilation warning for sound/soc/codecs/wm8400.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following fix is inspired by David Howells fix few days back:
http://lkml.org/lkml/2009/7/9/109,

Signed-off-by: Subrata Modak<subrata@linux.vnet.ibm.com>,
---

--- a/sound/soc/codecs/wm8400.c	2009-06-15 07:52:31.000000000 +0530
+++ b/sound/soc/codecs/wm8400.c	2009-07-15 05:35:00.000000000 +0530
@@ -1015,7 +1015,7 @@ static int wm8400_set_dai_pll(struct snd
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
 	struct wm8400_priv *wm8400 = codec->private_data;
-	struct fll_factors factors;
+	struct fll_factors uninitialized_var(factors);
 	int ret;
 	u16 reg;
 

---
Regards--
Subrata

