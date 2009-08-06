Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbZHFLJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbZHFLJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 07:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbZHFLJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 07:09:22 -0400
Received: from d1.icnet.pl ([212.160.220.21]:42621 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbZHFLJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 07:09:21 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] ASoC: AMS_DELTA: Use updated line discipline name
Date: Thu, 6 Aug 2009 13:08:51 +0200
User-Agent: KMail/1.9.10
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       e3-hacking@earth.li,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908061308.52693.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the tty line discipline name used in the Amstrad Delta
machine driver.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

---
--- linux-2.6.31-rc5/sound/soc/omap/ams-delta.c.orig	2009-08-05 21:44:35.000000000 +0200
+++ linux-2.6.31-rc5/sound/soc/omap/ams-delta.c	2009-08-05 23:30:53.000000000 +0200
@@ -519,7 +519,7 @@ static int ams_delta_cx20442_init(struct
 	}
 
 	/* Register optional line discipline for over the modem control */
-	ret = tty_register_ldisc(N_AMSDELTA, &cx81801_ops);
+	ret = tty_register_ldisc(N_V253, &cx81801_ops);
 	if (ret) {
 		dev_warn(card->dev,
 				"Failed to register line discipline, "
@@ -644,9 +644,9 @@ static void __exit ams_delta_module_exit
 		}
 	}
 
-	if (tty_unregister_ldisc(N_AMSDELTA) != 0)
+	if (tty_unregister_ldisc(N_V253) != 0)
 		dev_warn(&ams_delta_audio_platform_device->dev,
-			"failed to unregister AMSDELTA line discipline\n");
+			"failed to unregister V253 line discipline\n");
 
 	snd_soc_jack_free_gpios(&ams_delta_hook_switch,
 			ARRAY_SIZE(ams_delta_hook_switch_gpios),
