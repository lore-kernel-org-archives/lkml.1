Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322Ab0AEAfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab0AEAfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:35:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224Ab0AEAew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:34:52 -0500
Received: from kroah.org ([198.145.64.141]:34125 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196Ab0AEAer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:34:47 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 13/97] ALSA: hda - Fix missing capsrc_nids for ALC88x
Date: Mon,  4 Jan 2010 16:32:26 -0800
Message-Id: <1262651630-7354-13-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 035eb0cff0671ada49ba9f3e5c9e7b0cb950efea upstream.

Some model quirks missed the corresponding capsrc_nids.  This resulted in
non-working capture source selection.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/pci/hda/patch_realtek.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 7058371..e40d31f 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9141,6 +9141,8 @@ static struct alc_config_preset alc882_presets[] = {
 		.dac_nids = alc883_dac_nids,
 		.num_adc_nids = ARRAY_SIZE(alc889_adc_nids),
 		.adc_nids = alc889_adc_nids,
+		.capsrc_nids = alc889_capsrc_nids,
+		.capsrc_nids = alc889_capsrc_nids,
 		.dig_out_nid = ALC883_DIGOUT_NID,
 		.dig_in_nid = ALC883_DIGIN_NID,
 		.slave_dig_outs = alc883_slave_dig_outs,
@@ -9187,6 +9189,7 @@ static struct alc_config_preset alc882_presets[] = {
 		.dac_nids = alc883_dac_nids,
 		.adc_nids = alc883_adc_nids_alt,
 		.num_adc_nids = ARRAY_SIZE(alc883_adc_nids_alt),
+		.capsrc_nids = alc883_capsrc_nids,
 		.dig_out_nid = ALC883_DIGOUT_NID,
 		.num_channel_mode = ARRAY_SIZE(alc883_3ST_2ch_modes),
 		.channel_mode = alc883_3ST_2ch_modes,
@@ -9333,6 +9336,7 @@ static struct alc_config_preset alc882_presets[] = {
 		.dac_nids = alc883_dac_nids,
 		.adc_nids = alc883_adc_nids_alt,
 		.num_adc_nids = ARRAY_SIZE(alc883_adc_nids_alt),
+		.capsrc_nids = alc883_capsrc_nids,
 		.num_channel_mode = ARRAY_SIZE(alc883_sixstack_modes),
 		.channel_mode = alc883_sixstack_modes,
 		.input_mux = &alc883_capture_source,
@@ -9394,6 +9398,7 @@ static struct alc_config_preset alc882_presets[] = {
 		.dac_nids = alc883_dac_nids,
 		.adc_nids = alc883_adc_nids_alt,
 		.num_adc_nids = ARRAY_SIZE(alc883_adc_nids_alt),
+		.capsrc_nids = alc883_capsrc_nids,
 		.num_channel_mode = ARRAY_SIZE(alc883_3ST_2ch_modes),
 		.channel_mode = alc883_3ST_2ch_modes,
 		.input_mux = &alc883_lenovo_101e_capture_source,
@@ -9573,6 +9578,7 @@ static struct alc_config_preset alc882_presets[] = {
 			alc880_gpio1_init_verbs },
 		.adc_nids = alc883_adc_nids,
 		.num_adc_nids = ARRAY_SIZE(alc883_adc_nids),
+		.capsrc_nids = alc883_capsrc_nids,
 		.dac_nids = alc883_dac_nids,
 		.num_dacs = ARRAY_SIZE(alc883_dac_nids),
 		.channel_mode = alc889A_mb31_6ch_modes,
-- 
1.6.6

