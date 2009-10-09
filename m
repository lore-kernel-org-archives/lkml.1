Return-Path: <linux-kernel-owner+w=401wt.eu-S1761773AbZJIXSC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761773AbZJIXSC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:18:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761599AbZJIXR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:17:58 -0400
Received: from kroah.org ([198.145.64.141]:36857 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761755AbZJIXR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:17:56 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:10:02 2009
Message-Id: <20091009231001.998011541@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:08:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [patch 15/26] ASoC: WM8350 capture PGA mutes are inverted
References: <20091009230836.316410305@mini.kroah.org>
Content-Disposition: inline; filename=asoc-wm8350-capture-pga-mutes-are-inverted.patch
In-Reply-To: <20091009231249.GA31084@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 5b7dde346881b12246669ae97b3a2793c27b32b6 upstream.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8350.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/wm8350.c
+++ b/sound/soc/codecs/wm8350.c
@@ -580,7 +580,7 @@ static const struct snd_kcontrol_new wm8
 	SOC_DAPM_SINGLE_TLV("L3 Capture Volume",
 			    WM8350_INPUT_MIXER_VOLUME_L, 9, 7, 0, out_mix_tlv),
 	SOC_DAPM_SINGLE("PGA Capture Switch",
-			WM8350_LEFT_INPUT_VOLUME, 14, 1, 0),
+			WM8350_LEFT_INPUT_VOLUME, 14, 1, 1),
 };
 
 /* Right Input Mixer */
@@ -590,7 +590,7 @@ static const struct snd_kcontrol_new wm8
 	SOC_DAPM_SINGLE_TLV("L3 Capture Volume",
 			    WM8350_INPUT_MIXER_VOLUME_R, 13, 7, 0, out_mix_tlv),
 	SOC_DAPM_SINGLE("PGA Capture Switch",
-			WM8350_RIGHT_INPUT_VOLUME, 14, 1, 0),
+			WM8350_RIGHT_INPUT_VOLUME, 14, 1, 1),
 };
 
 /* Left Mic Mixer */


