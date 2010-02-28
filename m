Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936480Ab0B1TRH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 14:17:07 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:23360 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936423Ab0B1TRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 14:17:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=g1+tSoPz8P4U8kVAxxCcPENy+R3k48jIyPc+6H83sc6Y8u31//YRo3+bzJdis2cJFM
         97y41zpjTNHVxMtmLps9Nm/3uW70e1Zas0AfkSsjsysvHOrptMZtSyQV1gwFoH0bkbUn
         Da/eZOyUBn+jgjtksxQhvt3uPwJRuKRXQz9H4=
From: Norberto Lopes <nlopes.ml@gmail.com>
To: perex@perex.cz, tiwai@suse.de, fengguang.wu@intel.com
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Norberto Lopes <nlopes.ml@gmail.com>
Subject: [PATCH 1/1] sound/pci/hda/hda_codec.c: various coding style fixes
Date: Sun, 28 Feb 2010 20:16:53 +0100
Message-Id: <1267384613-20983-1-git-send-email-nlopes.ml@gmail.com>
X-Mailer: git-send-email 1.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Norberto Lopes <nlopes.ml@gmail.com>
---
 sound/pci/hda/hda_codec.c |   69 ++++++++++++++++++++++++--------------------
 1 files changed, 38 insertions(+), 31 deletions(-)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index f98b47c..444b989 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -955,8 +955,9 @@ static void hda_set_power_state(struct hda_codec *codec, hda_nid_t fg,
  *
  * Returns 0 if successful, or a negative error code.
  */
-int /*__devinit*/ snd_hda_codec_new(struct hda_bus *bus, unsigned int codec_addr,
-				    struct hda_codec **codecp)
+int /*__devinit*/ snd_hda_codec_new(struct hda_bus *bus,
+				unsigned int codec_addr,
+				struct hda_codec **codecp)
 {
 	struct hda_codec *codec;
 	char component[31];
@@ -1162,7 +1163,7 @@ EXPORT_SYMBOL_HDA(snd_hda_codec_cleanup_stream);
  */
 
 /* FIXME: more better hash key? */
-#define HDA_HASH_KEY(nid,dir,idx) (u32)((nid) + ((idx) << 16) + ((dir) << 24))
+#define HDA_HASH_KEY(nid, dir, idx) (u32)((nid) + ((idx) << 16) + ((dir) << 24))
 #define HDA_HASH_PINCAP_KEY(nid) (u32)((nid) + (0x02 << 24))
 #define HDA_HASH_PARPCM_KEY(nid) (u32)((nid) + (0x03 << 24))
 #define HDA_HASH_PARSTR_KEY(nid) (u32)((nid) + (0x04 << 24))
@@ -1332,7 +1333,8 @@ u32 snd_hda_pin_sense(struct hda_codec *codec, hda_nid_t nid)
 	if (!codec->no_trigger_sense) {
 		pincap = snd_hda_query_pin_caps(codec, nid);
 		if (pincap & AC_PINCAP_TRIG_REQ) /* need trigger? */
-			snd_hda_codec_read(codec, nid, 0, AC_VERB_SET_PIN_SENSE, 0);
+			snd_hda_codec_read(codec, nid, 0,
+					AC_VERB_SET_PIN_SENSE, 0);
 	}
 	return snd_hda_codec_read(codec, nid, 0,
 				  AC_VERB_GET_PIN_SENSE, 0);
@@ -1348,8 +1350,8 @@ EXPORT_SYMBOL_HDA(snd_hda_pin_sense);
  */
 int snd_hda_jack_detect(struct hda_codec *codec, hda_nid_t nid)
 {
-        u32 sense = snd_hda_pin_sense(codec, nid);
-        return !!(sense & AC_PINSENSE_PRESENCE);
+	u32 sense = snd_hda_pin_sense(codec, nid);
+	return !!(sense & AC_PINSENSE_PRESENCE);
 }
 EXPORT_SYMBOL_HDA(snd_hda_jack_detect);
 
@@ -1891,7 +1893,7 @@ int snd_hda_add_vmaster(struct hda_codec *codec, char *name,
 	err = snd_hda_ctl_add(codec, 0, kctl);
 	if (err < 0)
 		return err;
-	
+
 	for (s = slaves; *s; s++) {
 		struct snd_kcontrol *sctl;
 		int i = 0;
@@ -2378,27 +2380,27 @@ static struct snd_kcontrol_new dig_mixes[] = {
 	{
 		.access = SNDRV_CTL_ELEM_ACCESS_READ,
 		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-		.name = SNDRV_CTL_NAME_IEC958("",PLAYBACK,CON_MASK),
+		.name = SNDRV_CTL_NAME_IEC958("", PLAYBACK, CON_MASK),
 		.info = snd_hda_spdif_mask_info,
 		.get = snd_hda_spdif_cmask_get,
 	},
 	{
 		.access = SNDRV_CTL_ELEM_ACCESS_READ,
 		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-		.name = SNDRV_CTL_NAME_IEC958("",PLAYBACK,PRO_MASK),
+		.name = SNDRV_CTL_NAME_IEC958("", PLAYBACK, PRO_MASK),
 		.info = snd_hda_spdif_mask_info,
 		.get = snd_hda_spdif_pmask_get,
 	},
 	{
 		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-		.name = SNDRV_CTL_NAME_IEC958("",PLAYBACK,DEFAULT),
+		.name = SNDRV_CTL_NAME_IEC958("", PLAYBACK, DEFAULT),
 		.info = snd_hda_spdif_mask_info,
 		.get = snd_hda_spdif_default_get,
 		.put = snd_hda_spdif_default_put,
 	},
 	{
 		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-		.name = SNDRV_CTL_NAME_IEC958("",PLAYBACK,SWITCH),
+		.name = SNDRV_CTL_NAME_IEC958("", PLAYBACK, SWITCH),
 		.info = snd_hda_spdif_out_switch_info,
 		.get = snd_hda_spdif_out_switch_get,
 		.put = snd_hda_spdif_out_switch_put,
@@ -2549,7 +2551,7 @@ static int snd_hda_spdif_in_status_get(struct snd_kcontrol *kcontrol,
 static struct snd_kcontrol_new dig_in_ctls[] = {
 	{
 		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-		.name = SNDRV_CTL_NAME_IEC958("",CAPTURE,SWITCH),
+		.name = SNDRV_CTL_NAME_IEC958("", CAPTURE, SWITCH),
 		.info = snd_hda_spdif_in_switch_info,
 		.get = snd_hda_spdif_in_switch_get,
 		.put = snd_hda_spdif_in_switch_put,
@@ -2557,7 +2559,7 @@ static struct snd_kcontrol_new dig_in_ctls[] = {
 	{
 		.access = SNDRV_CTL_ELEM_ACCESS_READ,
 		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-		.name = SNDRV_CTL_NAME_IEC958("",CAPTURE,DEFAULT),
+		.name = SNDRV_CTL_NAME_IEC958("", CAPTURE, DEFAULT),
 		.info = snd_hda_spdif_mask_info,
 		.get = snd_hda_spdif_in_status_get,
 	},
@@ -2822,7 +2824,7 @@ int /*__devinit*/ snd_hda_build_controls(struct hda_bus *bus)
 		int err = snd_hda_codec_build_controls(codec);
 		if (err < 0) {
 			printk(KERN_ERR "hda_codec: cannot build controls"
-			       "for #%d (error %d)\n", codec->addr, err); 
+			       "for #%d (error %d)\n", codec->addr, err);
 			err = snd_hda_codec_reset(codec);
 			if (err < 0) {
 				printk(KERN_ERR
@@ -2918,8 +2920,12 @@ unsigned int snd_hda_calc_stream_format(unsigned int rate,
 	val |= channels - 1;
 
 	switch (snd_pcm_format_width(format)) {
-	case 8:  val |= 0x00; break;
-	case 16: val |= 0x10; break;
+	case 8:
+		val |= 0x00;
+		break;
+	case 16:
+		val |= 0x10;
+		break;
 	case 20:
 	case 24:
 	case 32:
@@ -3235,7 +3241,8 @@ static int get_empty_pcm_device(struct hda_bus *bus, int type)
 		if (!test_and_set_bit(audio_idx[type][i], bus->pcm_dev_bits))
 			return audio_idx[type][i];
 
-	snd_printk(KERN_WARNING "Too many %s devices\n", snd_hda_pcm_type_name[type]);
+	snd_printk(KERN_WARNING "Too many %s devices\n",
+		snd_hda_pcm_type_name[type]);
 	return -EAGAIN;
 }
 
@@ -3273,7 +3280,7 @@ int snd_hda_codec_build_pcms(struct hda_codec *codec)
 		err = codec->patch_ops.build_pcms(codec);
 		if (err < 0) {
 			printk(KERN_ERR "hda_codec: cannot build PCMs"
-			       "for #%d (error %d)\n", codec->addr, err); 
+			       "for #%d (error %d)\n", codec->addr, err);
 			err = snd_hda_codec_reset(codec);
 			if (err < 0) {
 				printk(KERN_ERR
@@ -3403,8 +3410,8 @@ EXPORT_SYMBOL_HDA(snd_hda_check_board_config);
 
 /**
  * snd_hda_check_board_codec_sid_config - compare the current codec
-				          subsystem ID with the
-					  config table
+					subsystem ID with the
+					config table
 
 	   This is important for Gateway notebooks with SB450 HDA Audio
 	   where the vendor ID of the PCI device is:
@@ -3542,7 +3549,7 @@ void snd_hda_update_power_acct(struct hda_codec *codec)
  *
  * Increment the power-up counter and power up the hardware really when
  * not turned on yet.
- */ 
+ */
 void snd_hda_power_up(struct hda_codec *codec)
 {
 	struct hda_bus *bus = codec->bus;
@@ -3571,7 +3578,7 @@ EXPORT_SYMBOL_HDA(snd_hda_power_up);
  *
  * Decrement the power-up counter and schedules the power-off work if
  * the counter rearches to zero.
- */ 
+ */
 void snd_hda_power_down(struct hda_codec *codec)
 {
 	--codec->power_count;
@@ -3597,7 +3604,7 @@ EXPORT_SYMBOL_HDA(snd_hda_power_down);
  *
  * This function is supposed to be set or called from the check_power_status
  * patch ops.
- */ 
+ */
 int snd_hda_check_amp_list_power(struct hda_codec *codec,
 				 struct hda_loopback_check *check,
 				 hda_nid_t nid)
@@ -3765,7 +3772,7 @@ static void setup_dig_out_stream(struct hda_codec *codec, hda_nid_t nid,
 {
 	/* turn off SPDIF once; otherwise the IEC958 bits won't be updated */
 	if (codec->spdif_status_reset && (codec->spdif_ctls & AC_DIG1_ENABLE))
-		set_dig_out_convert(codec, nid, 
+		set_dig_out_convert(codec, nid,
 				    codec->spdif_ctls & ~AC_DIG1_ENABLE & 0xff,
 				    -1);
 	snd_hda_codec_setup_stream(codec, nid, stream_tag, 0, format);
@@ -4024,13 +4031,13 @@ static int is_in_nid_list(hda_nid_t nid, hda_nid_t *list)
 /*
  * Sort an associated group of pins according to their sequence numbers.
  */
-static void sort_pins_by_sequence(hda_nid_t * pins, short * sequences,
+static void sort_pins_by_sequence(hda_nid_t *pins, short *sequences,
 				  int num_pins)
 {
 	int i, j;
 	short seq;
 	hda_nid_t nid;
-	
+
 	for (i = 0; i < num_pins; i++) {
 		for (j = i + 1; j < num_pins; j++) {
 			if (sequences[i] > sequences[j]) {
@@ -4058,7 +4065,7 @@ static void sort_pins_by_sequence(hda_nid_t * pins, short * sequences,
  * is detected, one of speaker of HP pins is assigned as the primary
  * output, i.e. to line_out_pins[0].  So, line_outs is always positive
  * if any analog output exists.
- * 
+ *
  * The analog input pins are assigned to input_pins array.
  * The digital input/output pins are assigned to dig_in_pin and dig_out_pin,
  * respectively.
@@ -4121,9 +4128,9 @@ int snd_hda_parse_pin_def_config(struct hda_codec *codec,
 		case AC_JACK_SPEAKER:
 			seq = get_defcfg_sequence(def_conf);
 			assoc = get_defcfg_association(def_conf);
-			if (! assoc)
+			if (!assoc)
 				continue;
-			if (! assoc_speaker)
+			if (!assoc_speaker)
 				assoc_speaker = assoc;
 			else if (assoc_speaker != assoc)
 				continue;
@@ -4221,7 +4228,7 @@ int snd_hda_parse_pin_def_config(struct hda_codec *codec,
 			      cfg->speaker_outs);
 	sort_pins_by_sequence(cfg->hp_pins, sequences_hp,
 			      cfg->hp_outs);
-	
+
 	/* if we have only one mic, make it AUTO_PIN_MIC */
 	if (!cfg->input_pins[AUTO_PIN_MIC] &&
 	    cfg->input_pins[AUTO_PIN_FRONT_MIC]) {
@@ -4371,7 +4378,7 @@ EXPORT_SYMBOL_HDA(snd_hda_resume);
 /**
  * snd_array_new - get a new element from the given array
  * @array: the array object
- * 
+ *
  * Get a new element from the given array.  If it exceeds the
  * pre-allocated array size, re-allocate the array.
  *
-- 
1.6.4

