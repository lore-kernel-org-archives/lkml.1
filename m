Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbYKYPZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbYKYPZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 10:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbYKYPZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 10:25:05 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:14072 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbYKYPZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 10:25:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:bcc:subject:date:user-agent:message-id;
        b=VWgRb7xFIB9QlbW4h1qi0oIGV6gQgzZn3Q6xZFkHz2foxjq7MCEpDwMv3bHYiWMEIf
         dillT/MNdTzrqzR/rJ2wFb3stn9tlHC19i5v+1SS7CYbk18sKb5g1WsTvlZaSmhlSAJi
         S0E+NSpezrbirbG5K4OD3X7LQKdoODeEZL7Mo=
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>, Randy Dunlap <rdunlap@xenotime.net>,
       alsa-devel@alsa-project.org
Subject: [PATCH 2/2] sound/soc/soc-core.c: cleanup kernel-doc
Date: Tue, 25 Nov 2008 23:24:54 +0800
User-Agent: sniper-patch-carrier/1.06
Message-ID: <492c18cb.0c636e0a.1c1a.ffffb2b3@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no argument named @clk_id in snd_soc_dai_set_fmt,
remove its' comment.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 16c7453..81ee4ba 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1805,7 +1805,6 @@ EXPORT_SYMBOL_GPL(snd_soc_dai_set_pll);
 /**
  * snd_soc_dai_set_fmt - configure DAI hardware audio format.
  * @dai: DAI
- * @clk_id: DAI specific clock ID
  * @fmt: SND_SOC_DAIFMT_ format value.
  *
  * Configures the DAI hardware format and clocking.

