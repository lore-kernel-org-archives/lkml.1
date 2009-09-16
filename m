Return-Path: <linux-kernel-owner+w=401wt.eu-S933641AbZIPWkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933641AbZIPWkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933602AbZIPWkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:40:21 -0400
Received: from kroah.org ([198.145.64.141]:48978 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760370AbZIPWkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:40:00 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:16 2009
Message-Id: <20090916223716.611135827@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [patch 23/45] ASoC: Fix WM835x Out4 capture enumeration
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=asoc-fix-wm835x-out4-capture-enumeration.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 87831cb660954356d68cebdb1406f3be09e784e9 upstream.

It's the 8th enum of a zero indexed array. This is why I don't let
new drivers use these arrays of enums...

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8350.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm8350.c
+++ b/sound/soc/codecs/wm8350.c
@@ -613,7 +613,7 @@ SOC_DAPM_SINGLE("Switch", WM8350_BEEP_VO
 
 /* Out4 Capture Mux */
 static const struct snd_kcontrol_new wm8350_out4_capture_controls =
-SOC_DAPM_ENUM("Route", wm8350_enum[8]);
+SOC_DAPM_ENUM("Route", wm8350_enum[7]);
 
 static const struct snd_soc_dapm_widget wm8350_dapm_widgets[] = {
 


