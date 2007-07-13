Return-Path: <linux-kernel-owner+w=401wt.eu-S933135AbXGMNxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135AbXGMNxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 09:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760139AbXGMNxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 09:53:07 -0400
Received: from sicnat2.emn.fr ([193.54.76.193]:53710 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759838AbXGMNxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 09:53:06 -0400
From: Yoann Padioleau <padator@wanadoo.fr>
To: linux-janitors@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] potential parse error
Date: Fri, 13 Jul 2007 15:52:16 +0200
Message-ID: <873azs9zsf.fsf@wanadoo.fr>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


parse error in ifdef or bad use of macro.


Signed-off-by: Yoann Padioleau <padator@wanadoo.fr> 

 drivers/media/dvb/ttpci/av7110.c      |    2 +-
 sound/aoa/codecs/snd-aoa-codec-onyx.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index ef1108c..0b4c6d6 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -2258,7 +2258,7 @@ static int frontend_init(struct av7110 *
 		FE_FUNC_OVERRIDE(av7110->fe->ops.diseqc_send_master_cmd, av7110->fe_diseqc_send_master_cmd, av7110_fe_diseqc_send_master_cmd);
 		FE_FUNC_OVERRIDE(av7110->fe->ops.diseqc_send_burst, av7110->fe_diseqc_send_burst, av7110_fe_diseqc_send_burst);
 		FE_FUNC_OVERRIDE(av7110->fe->ops.set_tone, av7110->fe_set_tone, av7110_fe_set_tone);
-		FE_FUNC_OVERRIDE(av7110->fe->ops.set_voltage, av7110->fe_set_voltage, av7110_fe_set_voltage;)
+		FE_FUNC_OVERRIDE(av7110->fe->ops.set_voltage, av7110->fe_set_voltage, av7110_fe_set_voltage);
 		FE_FUNC_OVERRIDE(av7110->fe->ops.dishnetwork_send_legacy_command, av7110->fe_dishnetwork_send_legacy_command, av7110_fe_dishnetwork_send_legacy_command);
 		FE_FUNC_OVERRIDE(av7110->fe->ops.set_frontend, av7110->fe_set_frontend, av7110_fe_set_frontend);
 
diff --git a/sound/aoa/codecs/snd-aoa-codec-onyx.c b/sound/aoa/codecs/snd-aoa-codec-onyx.c
index ded5167..2a909a6 100644
--- a/sound/aoa/codecs/snd-aoa-codec-onyx.c
+++ b/sound/aoa/codecs/snd-aoa-codec-onyx.c
@@ -713,7 +713,7 @@ #ifdef SNDRV_PCM_FMTBIT_COMPRESSED_16BE
 	if (substream->runtime->format == SNDRV_PCM_FMTBIT_COMPRESSED_16BE) {
 		/* mute and lock analog output */
 		onyx_read_register(onyx, ONYX_REG_DAC_CONTROL, &v);
-		if (onyx_write_register(onyx
+		if (onyx_write_register(onyx,
 					ONYX_REG_DAC_CONTROL,
 					v | ONYX_MUTE_RIGHT | ONYX_MUTE_LEFT))
 			goto out_unlock;

