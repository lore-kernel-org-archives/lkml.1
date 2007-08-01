Return-Path: <linux-kernel-owner+w=401wt.eu-S1764043AbXHABa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764043AbXHABa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 21:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760579AbXHABah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 21:30:37 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:51914 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbXHABaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 21:30:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=NDKWPIAIzekSyxk8UgVMJE8cOoD0jPt/S7JPzTk0wqRyJucxbIKuY3O3W5M4e0xCu0O2qHUDC6NlbXIh6jxgB45XH5EI8hXndpt/tizd82NRTk2HTgcVFCP9BroPsaumy75K4hyiuaaXWABEMZYbVrwg2fwpkHE9SH5evqzvArA=
Message-ID: <46AFE229.3010802@googlemail.com>
Date: Wed, 01 Aug 2007 03:30:17 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix section mismatch warnings in  sound/pci/hda/
References: <46AE2459.7080905@googlemail.com> <20070730185124.GA29116@uranus.ravnborg.org> <46AE3C80.7010307@googlemail.com> <46AF9152.2050707@googlemail.com> <20070731204846.GA9985@uranus.ravnborg.org> <46AFB06E.2020401@googlemail.com>
In-Reply-To: <46AFB06E.2020401@googlemail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatch warnings in  sound/pci/hda/* 

...

WARNING: vmlinux.o(.text+0x2d6a77): Section mismatch: reference to .init.text:snd_hda_add_new_ctls (between 'alc_build_controls' and 'alc662_auto_set_output_and_unmute')
WARNING: vmlinux.o(.text+0x2d6aa1): Section mismatch: reference to .init.text:snd_hda_create_spdif_in_ctls (between 'alc_build_controls' and 'alc662_auto_set_output_and_unmute')
WARNING: vmlinux.o(.text+0x2d6abd): Section mismatch: reference to .init.text:snd_hda_create_spdif_out_ctls (between 'alc_build_controls' and 'alc662_auto_set_output_and_unmute')
WARNING: vmlinux.o(.text+0x2d994a): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'alc880_parse_auto_config' and 'alc882_gpio_mute')
WARNING: vmlinux.o(.text+0x2da2fe): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_alc268' and 'patch_alc662')
WARNING: vmlinux.o(.text+0x2da31c): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_alc268' and 'patch_alc662')
WARNING: vmlinux.o(.text+0x2da6e8): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_alc662' and 'alc_mux_enum_info')
WARNING: vmlinux.o(.text+0x2da7b5): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_alc662' and 'alc_mux_enum_info')
WARNING: vmlinux.o(.text+0x2dae6a): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_alc880' and 'patch_alc260')
WARNING: vmlinux.o(.text+0x2db036): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_alc260' and 'patch_alc882')
WARNING: vmlinux.o(.text+0x2db0cc): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_alc260' and 'patch_alc882')
WARNING: vmlinux.o(.text+0x2db4b0): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_alc882' and 'patch_alc883')
WARNING: vmlinux.o(.text+0x2db77a): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_alc883' and 'patch_alc262')
WARNING: vmlinux.o(.text+0x2db8ea): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_alc262' and 'patch_alc861')
WARNING: vmlinux.o(.text+0x2db9b7): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_alc262' and 'patch_alc861')
WARNING: vmlinux.o(.text+0x2dbca6): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_alc861' and 'patch_alc861vd')
WARNING: vmlinux.o(.text+0x2dbd3c): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_alc861' and 'patch_alc861vd')
WARNING: vmlinux.o(.text+0x2dc0c6): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_alc861vd' and 'cmi9880_build_pcms')
WARNING: vmlinux.o(.text+0x2dc195): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_alc861vd' and 'cmi9880_build_pcms')
WARNING: vmlinux.o(.text+0x2dc77d): Section mismatch: reference to .init.text:snd_hda_add_new_ctls (between 'cmi9880_build_controls' and 'cmi_ch_mode_put')
WARNING: vmlinux.o(.text+0x2dc796): Section mismatch: reference to .init.text:snd_hda_add_new_ctls (between 'cmi9880_build_controls' and 'cmi_ch_mode_put')
WARNING: vmlinux.o(.text+0x2dc7c6): Section mismatch: reference to .init.text:snd_hda_create_spdif_in_ctls (between 'cmi9880_build_controls' and 'cmi_ch_mode_put')
WARNING: vmlinux.o(.text+0x2dc7e6): Section mismatch: reference to .init.text:snd_hda_create_spdif_out_ctls (between 'cmi9880_build_controls' and 'cmi_ch_mode_put')
WARNING: vmlinux.o(.text+0x2dc93e): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_cmi9880' and 'cmi_mux_enum_get')
WARNING: vmlinux.o(.text+0x2dcab4): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_cmi9880' and 'cmi_mux_enum_get')
WARNING: vmlinux.o(.text+0x2dd301): Section mismatch: reference to .init.text:snd_hda_add_new_ctls (between 'ad198x_build_controls' and 'ad1988_laptop_unsol_event')
WARNING: vmlinux.o(.text+0x2dd32b): Section mismatch: reference to .init.text:snd_hda_create_spdif_in_ctls (between 'ad198x_build_controls' and 'ad1988_laptop_unsol_event')
WARNING: vmlinux.o(.text+0x2dd347): Section mismatch: reference to .init.text:snd_hda_create_spdif_out_ctls (between 'ad198x_build_controls' and 'ad1988_laptop_unsol_event')
WARNING: vmlinux.o(.text+0x2ddbad): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_ad1984' and 'patch_ad1882')
WARNING: vmlinux.o(.text+0x2ddcfb): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_ad1882' and 'ad198x_free')
WARNING: vmlinux.o(.text+0x2de7db): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_ad1986a' and 'patch_ad1983')
WARNING: vmlinux.o(.text+0x2deabb): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_ad1981' and 'patch_ad1988')
WARNING: vmlinux.o(.text+0x2debfd): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_ad1988' and 'stac92xx_dmux_enum_get')
WARNING: vmlinux.o(.text+0x2dede6): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_ad1988' and 'stac92xx_dmux_enum_get')
WARNING: vmlinux.o(.text+0x2e00dc): Section mismatch: reference to .init.text:snd_hda_add_new_ctls (between 'stac92xx_build_controls' and 'stac92xx_mux_enum_put')
WARNING: vmlinux.o(.text+0x2e0105): Section mismatch: reference to .init.text:snd_hda_add_new_ctls (between 'stac92xx_build_controls' and 'stac92xx_mux_enum_put')
WARNING: vmlinux.o(.text+0x2e012f): Section mismatch: reference to .init.text:snd_hda_create_spdif_in_ctls (between 'stac92xx_build_controls' and 'stac92xx_mux_enum_put')
WARNING: vmlinux.o(.text+0x2e014b): Section mismatch: reference to .init.text:snd_hda_create_spdif_out_ctls (between 'stac92xx_build_controls' and 'stac92xx_mux_enum_put')
WARNING: vmlinux.o(.text+0x2e06cf): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'stac92xx_parse_auto_config' and 'patch_stac9872')
WARNING: vmlinux.o(.text+0x2e0e79): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_stac9872' and 'vaio_master_sw_put')
WARNING: vmlinux.o(.text+0x2e11dc): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_stac9200' and 'patch_stac925x')
WARNING: vmlinux.o(.text+0x2e1251): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_stac9200' and 'patch_stac925x')
WARNING: vmlinux.o(.text+0x2e15bb): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_stac925x' and 'patch_stac922x')
WARNING: vmlinux.o(.text+0x2e172c): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_stac922x' and 'patch_stac927x')
WARNING: vmlinux.o(.text+0x2e195f): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_stac927x' and 'patch_stac9205')
WARNING: vmlinux.o(.text+0x2e1aef): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_stac9205' and 'si3054_switch_info')
WARNING: vmlinux.o(.text+0x2e2116): Section mismatch: reference to .init.text:snd_hda_add_new_ctls (between 'si3054_build_controls' and 'patch_si3054')
WARNING: vmlinux.o(.text+0x2e2248): Section mismatch: reference to .init.text:snd_hda_create_spdif_out_ctls (between 'atihdmi_build_controls' and 'patch_atihdmi')
WARNING: vmlinux.o(.text+0x2e2c51): Section mismatch: reference to .init.text:snd_hda_add_new_ctls (between 'conexant_build_controls' and 'patch_cxt5047')
WARNING: vmlinux.o(.text+0x2e2c7b): Section mismatch: reference to .init.text:snd_hda_create_spdif_in_ctls (between 'conexant_build_controls' and 'patch_cxt5047')
WARNING: vmlinux.o(.text+0x2e2c97): Section mismatch: reference to .init.text:snd_hda_create_spdif_out_ctls (between 'conexant_build_controls' and 'patch_cxt5047')
WARNING: vmlinux.o(.text+0x2e2d99): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_cxt5047' and 'cxt5047_hp_automic')
WARNING: vmlinux.o(.text+0x2e3329): Section mismatch: reference to .init.text:snd_hda_check_board_config (between 'patch_cxt5045' and 'via_build_pcms')
WARNING: vmlinux.o(.text+0x2e3617): Section mismatch: reference to .init.text:snd_hda_add_new_ctls (between 'via_build_controls' and 'via_mux_enum_put')
WARNING: vmlinux.o(.text+0x2e3641): Section mismatch: reference to .init.text:snd_hda_create_spdif_in_ctls (between 'via_build_controls' and 'via_mux_enum_put')
WARNING: vmlinux.o(.text+0x2e365d): Section mismatch: reference to .init.text:snd_hda_create_spdif_out_ctls (between 'via_build_controls' and 'via_mux_enum_put')
WARNING: vmlinux.o(.text+0x2e3ab3): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'vt1709_parse_auto_config' and 'patch_vt1709_6ch')
WARNING: vmlinux.o(.text+0x2e429d): Section mismatch: reference to .init.text:snd_hda_parse_pin_def_config (between 'patch_vt1708' and 'patch_vt1709_10ch')

...

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

---

Sam , please review.



 sound/pci/hda/hda_patch.h      |    2 +-
 sound/pci/hda/patch_analog.c   |   14 +++++++-------
 sound/pci/hda/patch_atihdmi.c  |    2 +-
 sound/pci/hda/patch_cmedia.c   |    6 +++---
 sound/pci/hda/patch_conexant.c |   10 +++++-----
 sound/pci/hda/patch_realtek.c  |   24 ++++++++++++------------
 sound/pci/hda/patch_si3054.c   |    2 +-
 sound/pci/hda/patch_sigmatel.c |   22 +++++++++++-----------
 sound/pci/hda/patch_via.c      |   12 ++++++------
 9 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/sound/pci/hda/hda_patch.h b/sound/pci/hda/hda_patch.h
index 9f9e9ae..c79e173 100644
--- a/sound/pci/hda/hda_patch.h
+++ b/sound/pci/hda/hda_patch.h
@@ -19,7 +19,7 @@ extern struct hda_codec_preset snd_hda_preset_conexant[];
 /* VIA codecs */
 extern struct hda_codec_preset snd_hda_preset_via[];
 
-static const struct hda_codec_preset *hda_preset_tables[] = {
+static const struct hda_codec_preset *hda_preset_tables[] __devinitdata = {
 	snd_hda_preset_realtek,
 	snd_hda_preset_cmedia,
 	snd_hda_preset_analog,
diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
index 4d7f8d1..094eb21 100644
--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -120,7 +120,7 @@ static int ad198x_init(struct hda_codec *codec)
 	return 0;
 }
 
-static int ad198x_build_controls(struct hda_codec *codec)
+static int __devinit ad198x_build_controls(struct hda_codec *codec)
 {
 	struct ad198x_spec *spec = codec->spec;
 	unsigned int i;
@@ -855,7 +855,7 @@ static struct snd_pci_quirk ad1986a_cfg_tbl[] = {
 	{}
 };
 
-static int patch_ad1986a(struct hda_codec *codec)
+static int __devinit patch_ad1986a(struct hda_codec *codec)
 {
 	struct ad198x_spec *spec;
 	int board_config;
@@ -1465,7 +1465,7 @@ static struct snd_pci_quirk ad1981_cfg_tbl[] = {
 	{}
 };
 
-static int patch_ad1981(struct hda_codec *codec)
+static int __devinit patch_ad1981(struct hda_codec *codec)
 {
 	struct ad198x_spec *spec;
 	int board_config;
@@ -2654,7 +2654,7 @@ static struct snd_pci_quirk ad1988_cfg_tbl[] = {
 	{}
 };
 
-static int patch_ad1988(struct hda_codec *codec)
+static int __devinit patch_ad1988(struct hda_codec *codec)
 {
 	struct ad198x_spec *spec;
 	int board_config;
@@ -3085,7 +3085,7 @@ static struct snd_pci_quirk ad1984_cfg_tbl[] = {
 	{}
 };
 
-static int patch_ad1984(struct hda_codec *codec)
+static int __devinit patch_ad1984(struct hda_codec *codec)
 {
 	struct ad198x_spec *spec;
 	int board_config, err;
@@ -3344,7 +3344,7 @@ static const char *ad1882_models[AD1986A_MODELS] = {
 };
 
 
-static int patch_ad1882(struct hda_codec *codec)
+static int __devinit patch_ad1882(struct hda_codec *codec)
 {
 	struct ad198x_spec *spec;
 	int board_config;
@@ -3398,7 +3398,7 @@ static int patch_ad1882(struct hda_codec *codec)
 /*
  * patch entries
  */
-struct hda_codec_preset snd_hda_preset_analog[] = {
+struct hda_codec_preset snd_hda_preset_analog[] __devinitdata = {
 	{ .id = 0x11d41882, .name = "AD1882", .patch = patch_ad1882 },
 	{ .id = 0x11d41884, .name = "AD1884", .patch = patch_ad1884 },
 	{ .id = 0x11d41981, .name = "AD1981", .patch = patch_ad1981 },
diff --git a/sound/pci/hda/patch_atihdmi.c b/sound/pci/hda/patch_atihdmi.c
index 72d3ab9..bb54cba 100644
--- a/sound/pci/hda/patch_atihdmi.c
+++ b/sound/pci/hda/patch_atihdmi.c
@@ -44,7 +44,7 @@ static struct hda_verb atihdmi_basic_init[] = {
 /*
  * Controls
  */
-static int atihdmi_build_controls(struct hda_codec *codec)
+static int __devinit atihdmi_build_controls(struct hda_codec *codec)
 {
 	struct atihdmi_spec *spec = codec->spec;
 	int err;
diff --git a/sound/pci/hda/patch_cmedia.c b/sound/pci/hda/patch_cmedia.c
index 3c722e6..f7a2faf 100644
--- a/sound/pci/hda/patch_cmedia.c
+++ b/sound/pci/hda/patch_cmedia.c
@@ -315,7 +315,7 @@ static struct hda_verb cmi9880_allout_init[] = {
 
 /*
  */
-static int cmi9880_build_controls(struct hda_codec *codec)
+static int __devinit cmi9880_build_controls(struct hda_codec *codec)
 {
 	struct cmi_spec *spec = codec->spec;
 	int err;
@@ -640,7 +640,7 @@ static struct hda_codec_ops cmi9880_patch_ops = {
 #endif
 };
 
-static int patch_cmi9880(struct hda_codec *codec)
+static int __devinit patch_cmi9880(struct hda_codec *codec)
 {
 	struct cmi_spec *spec;
 
@@ -753,7 +753,7 @@ static int patch_cmi9880(struct hda_codec *codec)
 /*
  * patch entries
  */
-struct hda_codec_preset snd_hda_preset_cmedia[] = {
+struct hda_codec_preset snd_hda_preset_cmedia[] __devinitdata = {
 	{ .id = 0x13f69880, .name = "CMI9880", .patch = patch_cmi9880 },
  	{ .id = 0x434d4980, .name = "CMI9880", .patch = patch_cmi9880 },
 	{} /* terminator */
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 4d8e8af..8cdb4b7 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -328,7 +328,7 @@ static int conexant_resume(struct hda_codec *codec)
 }
 #endif
 
-static int conexant_build_controls(struct hda_codec *codec)
+static int __devinit conexant_build_controls(struct hda_codec *codec)
 {
 	struct conexant_spec *spec = codec->spec;
 	unsigned int i;
@@ -808,7 +808,7 @@ static struct snd_pci_quirk cxt5045_cfg_tbl[] = {
 	{}
 };
 
-static int patch_cxt5045(struct hda_codec *codec)
+static int __devinit patch_cxt5045(struct hda_codec *codec)
 {
 	struct conexant_spec *spec;
 	int board_config;
@@ -1317,7 +1317,7 @@ static struct snd_pci_quirk cxt5047_cfg_tbl[] = {
 	{}
 };
 
-static int patch_cxt5047(struct hda_codec *codec)
+static int __devinit patch_cxt5047(struct hda_codec *codec)
 {
 	struct conexant_spec *spec;
 	int board_config;
@@ -1374,12 +1374,12 @@ static int patch_cxt5047(struct hda_codec *codec)
 		spec->mixers[0] = cxt5047_test_mixer;
 		spec->init_verbs[0] = cxt5047_test_init_verbs;
 		codec->patch_ops.unsol_event = cxt5047_hp_unsol_event;
-#endif	
+#endif
 	}
 	return 0;
 }
 
-struct hda_codec_preset snd_hda_preset_conexant[] = {
+struct hda_codec_preset snd_hda_preset_conexant[] __devinitdata = {
 	{ .id = 0x14f15045, .name = "CX20549 (Venice)",
 	  .patch = patch_cxt5045 },
 	{ .id = 0x14f15047, .name = "CX20551 (Waikiki)",
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 9a47eec..2f782d6 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1253,7 +1253,7 @@ static struct snd_kcontrol_new alc880_uniwill_p53_mixer[] = {
 /*
  * build control elements
  */
-static int alc_build_controls(struct hda_codec *codec)
+static int __devinit alc_build_controls(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
 	int err;
@@ -3269,7 +3269,7 @@ static void alc880_auto_init_analog_input(struct hda_codec *codec)
 /* return 1 if successful, 0 if the proper config is not found,
  * or a negative error code
  */
-static int alc880_parse_auto_config(struct hda_codec *codec)
+static int __devinit alc880_parse_auto_config(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
 	int err;
@@ -3331,7 +3331,7 @@ static void alc880_auto_init(struct hda_codec *codec)
  * OK, here we have finally the patch for ALC880
  */
 
-static int patch_alc880(struct hda_codec *codec)
+static int __devinit patch_alc880(struct hda_codec *codec)
 {
 	struct alc_spec *spec;
 	int board_config;
@@ -4702,7 +4702,7 @@ static struct alc_config_preset alc260_presets[] = {
 #endif
 };
 
-static int patch_alc260(struct hda_codec *codec)
+static int __devinit patch_alc260(struct hda_codec *codec)
 {
 	struct alc_spec *spec;
 	int err, board_config;
@@ -5630,7 +5630,7 @@ static void alc882_auto_init(struct hda_codec *codec)
 	alc882_auto_init_analog_input(codec);
 }
 
-static int patch_alc882(struct hda_codec *codec)
+static int __devinit patch_alc882(struct hda_codec *codec)
 {
 	struct alc_spec *spec;
 	int err, board_config;
@@ -6993,7 +6993,7 @@ static void alc883_auto_init(struct hda_codec *codec)
 	alc883_auto_init_analog_input(codec);
 }
 
-static int patch_alc883(struct hda_codec *codec)
+static int __devinit patch_alc883(struct hda_codec *codec)
 {
 	struct alc_spec *spec;
 	int err, board_config;
@@ -8057,7 +8057,7 @@ static struct alc_config_preset alc262_presets[] = {
 	},	
 };
 
-static int patch_alc262(struct hda_codec *codec)
+static int __devinit patch_alc262(struct hda_codec *codec)
 {
 	struct alc_spec *spec;
 	int board_config;
@@ -8575,7 +8575,7 @@ static struct alc_config_preset alc268_presets[] = {
 	},
 };
 
-static int patch_alc268(struct hda_codec *codec)
+static int __devinit patch_alc268(struct hda_codec *codec)
 {
 	struct alc_spec *spec;
 	int board_config;
@@ -9746,7 +9746,7 @@ static struct alc_config_preset alc861_presets[] = {
 };
 
 
-static int patch_alc861(struct hda_codec *codec)
+static int __devinit patch_alc861(struct hda_codec *codec)
 {
 	struct alc_spec *spec;
 	int board_config;
@@ -10679,7 +10679,7 @@ static void alc861vd_auto_init(struct hda_codec *codec)
 	alc861vd_auto_init_analog_input(codec);
 }
 
-static int patch_alc861vd(struct hda_codec *codec)
+static int __devinit patch_alc861vd(struct hda_codec *codec)
 {
 	struct alc_spec *spec;
 	int err, board_config;
@@ -11533,7 +11533,7 @@ static void alc662_auto_init(struct hda_codec *codec)
 	alc662_auto_init_analog_input(codec);
 }
 
-static int patch_alc662(struct hda_codec *codec)
+static int __devinit patch_alc662(struct hda_codec *codec)
 {
 	struct alc_spec *spec;
 	int err, board_config;
@@ -11593,7 +11593,7 @@ static int patch_alc662(struct hda_codec *codec)
 /*
  * patch entries
  */
-struct hda_codec_preset snd_hda_preset_realtek[] = {
+struct hda_codec_preset snd_hda_preset_realtek[] __devinitdata = {
 	{ .id = 0x10ec0260, .name = "ALC260", .patch = patch_alc260 },
 	{ .id = 0x10ec0262, .name = "ALC262", .patch = patch_alc262 },
 	{ .id = 0x10ec0268, .name = "ALC268", .patch = patch_alc268 },
diff --git a/sound/pci/hda/patch_si3054.c b/sound/pci/hda/patch_si3054.c
index 6d2ecc3..48d1841 100644
--- a/sound/pci/hda/patch_si3054.c
+++ b/sound/pci/hda/patch_si3054.c
@@ -143,7 +143,7 @@ static struct snd_kcontrol_new si3054_modem_mixer[] = {
 	{}
 };
 
-static int si3054_build_controls(struct hda_codec *codec)
+static int __devinit si3054_build_controls(struct hda_codec *codec)
 {
 	return snd_hda_add_new_ctls(codec, si3054_modem_mixer);
 }
diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 3f25de7..c9bf5af 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -417,7 +417,7 @@ static struct snd_kcontrol_new stac9205_mixer[] = {
 	{ } /* end */
 };
 
-static int stac92xx_build_controls(struct hda_codec *codec)
+static int __devinit stac92xx_build_controls(struct hda_codec *codec)
 {
 	struct sigmatel_spec *spec = codec->spec;
 	int err;
@@ -1575,7 +1575,7 @@ static void stac92xx_auto_init_hp_out(struct hda_codec *codec)
 	}
 }
 
-static int stac92xx_parse_auto_config(struct hda_codec *codec, hda_nid_t dig_out, hda_nid_t dig_in)
+static int __devinit stac92xx_parse_auto_config(struct hda_codec *codec, hda_nid_t dig_out, hda_nid_t dig_in)
 {
 	struct sigmatel_spec *spec = codec->spec;
 	int err;
@@ -1967,7 +1967,7 @@ static struct hda_codec_ops stac92xx_patch_ops = {
 #endif
 };
 
-static int patch_stac9200(struct hda_codec *codec)
+static int __devinit patch_stac9200(struct hda_codec *codec)
 {
 	struct sigmatel_spec *spec;
 	int err;
@@ -2017,7 +2017,7 @@ static int patch_stac9200(struct hda_codec *codec)
 	return 0;
 }
 
-static int patch_stac925x(struct hda_codec *codec)
+static int __devinit patch_stac925x(struct hda_codec *codec)
 {
 	struct sigmatel_spec *spec;
 	int err;
@@ -2089,7 +2089,7 @@ static int patch_stac925x(struct hda_codec *codec)
 	return 0;
 }
 
-static int patch_stac922x(struct hda_codec *codec)
+static int __devinit patch_stac922x(struct hda_codec *codec)
 {
 	struct sigmatel_spec *spec;
 	int err;
@@ -2190,7 +2190,7 @@ static int patch_stac922x(struct hda_codec *codec)
 	return 0;
 }
 
-static int patch_stac927x(struct hda_codec *codec)
+static int __devinit patch_stac927x(struct hda_codec *codec)
 {
 	struct sigmatel_spec *spec;
 	int err;
@@ -2269,7 +2269,7 @@ static int patch_stac927x(struct hda_codec *codec)
 	return 0;
 }
 
-static int patch_stac9205(struct hda_codec *codec)
+static int __devinit patch_stac9205(struct hda_codec *codec)
 {
 	struct sigmatel_spec *spec;
 	int err, gpio_mask, gpio_data;
@@ -2533,7 +2533,7 @@ static struct snd_pci_quirk stac9872_cfg_tbl[] = {
 	{}
 };
 
-static int patch_stac9872(struct hda_codec *codec)
+static int __devinit patch_stac9872(struct hda_codec *codec)
 {
 	struct sigmatel_spec *spec;
 	int board_config;
@@ -2544,7 +2544,7 @@ static int patch_stac9872(struct hda_codec *codec)
 	if (board_config < 0)
 		/* unknown config, let generic-parser do its job... */
 		return snd_hda_parse_generic_codec(codec);
-	
+
 	spec  = kzalloc(sizeof(*spec), GFP_KERNEL);
 	if (spec == NULL)
 		return -ENOMEM;
@@ -2565,7 +2565,7 @@ static int patch_stac9872(struct hda_codec *codec)
 		spec->input_mux = &vaio_mux;
 		spec->mux_nids = vaio_mux_nids;
 		break;
-	
+
 	case CXD9872AKD_VAIO:
 		spec->mixer = vaio_ar_mixer;
 		spec->init = vaio_ar_init;
@@ -2588,7 +2588,7 @@ static int patch_stac9872(struct hda_codec *codec)
 /*
  * patch entries
  */
-struct hda_codec_preset snd_hda_preset_sigmatel[] = {
+struct hda_codec_preset snd_hda_preset_sigmatel[] __devinitdata = {
  	{ .id = 0x83847690, .name = "STAC9200", .patch = patch_stac9200 },
  	{ .id = 0x83847882, .name = "STAC9220 A1", .patch = patch_stac922x },
  	{ .id = 0x83847680, .name = "STAC9221 A1", .patch = patch_stac922x },
diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index ba32d1e..c9a1d70 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -455,7 +455,7 @@ static struct hda_pcm_stream vt1708_pcm_digital_capture = {
 	.channels_max = 2,
 };
 
-static int via_build_controls(struct hda_codec *codec)
+static int __devinit via_build_controls(struct hda_codec *codec)
 {
 	struct via_spec *spec = codec->spec;
 	int err;
@@ -813,7 +813,7 @@ static int via_auto_init(struct hda_codec *codec)
 	return 0;
 }
 
-static int patch_vt1708(struct hda_codec *codec)
+static int __devinit patch_vt1708(struct hda_codec *codec)
 {
 	struct via_spec *spec;
 	int err;
@@ -1212,7 +1212,7 @@ static int vt1709_auto_create_analog_input_ctls(struct via_spec *spec,
 	return 0;
 }
 
-static int vt1709_parse_auto_config(struct hda_codec *codec)
+static int __devinit vt1709_parse_auto_config(struct hda_codec *codec)
 {
 	struct via_spec *spec = codec->spec;
 	int err;
@@ -1251,7 +1251,7 @@ static int vt1709_parse_auto_config(struct hda_codec *codec)
 	return 1;
 }
 
-static int patch_vt1709_10ch(struct hda_codec *codec)
+static int __devinit patch_vt1709_10ch(struct hda_codec *codec)
 {
 	struct via_spec *spec;
 	int err;
@@ -1341,7 +1341,7 @@ static struct hda_verb vt1709_6ch_volume_init_verbs[] = {
 	{ }
 };
 
-static int patch_vt1709_6ch(struct hda_codec *codec)
+static int __devinit patch_vt1709_6ch(struct hda_codec *codec)
 {
 	struct via_spec *spec;
 	int err;
@@ -1390,7 +1390,7 @@ static int patch_vt1709_6ch(struct hda_codec *codec)
 /*
  * patch entries
  */
-struct hda_codec_preset snd_hda_preset_via[] = {
+struct hda_codec_preset snd_hda_preset_via[] __devinitdata = {
 	{ .id = 0x11061708, .name = "VIA VT1708", .patch = patch_vt1708},
 	{ .id = 0x11061709, .name = "VIA VT1708", .patch = patch_vt1708},
 	{ .id = 0x1106170A, .name = "VIA VT1708", .patch = patch_vt1708},






