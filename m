Return-Path: <linux-kernel-owner+w=401wt.eu-S1761354AbZAOUCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761354AbZAOUCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:02:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761782AbZAOUAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:00:18 -0500
Received: from kroah.org ([198.145.64.141]:48719 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758708AbZAOUAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:16 -0500
Date: Thu, 15 Jan 2009 11:57:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [patch 04/94] ALSA: hda - Fix typos for AD1882 codecs
Message-ID: <20090115195720.GD14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-fix-typos-for-ad1882-codecs.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Clemens Fruhwirth <clemens@endorphin.org>

commit c247ed6f5205f9feebd276c4cbe45018b10f19fa upstream.

Fixed typos of codec-id checks for AD1882/AD1882A.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_analog.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -4222,13 +4222,13 @@ static int patch_ad1882(struct hda_codec
 	spec->num_adc_nids = ARRAY_SIZE(ad1882_adc_nids);
 	spec->adc_nids = ad1882_adc_nids;
 	spec->capsrc_nids = ad1882_capsrc_nids;
-	if (codec->vendor_id == 0x11d1882)
+	if (codec->vendor_id == 0x11d41882)
 		spec->input_mux = &ad1882_capture_source;
 	else
 		spec->input_mux = &ad1882a_capture_source;
 	spec->num_mixers = 2;
 	spec->mixers[0] = ad1882_base_mixers;
-	if (codec->vendor_id == 0x11d1882)
+	if (codec->vendor_id == 0x11d41882)
 		spec->mixers[1] = ad1882_loopback_mixers;
 	else
 		spec->mixers[1] = ad1882a_loopback_mixers;

