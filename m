Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbZAaDDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbZAaDDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbZAaCr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:28 -0500
Received: from kroah.org ([198.145.64.141]:55274 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753211AbZAaCrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:18 -0500
Date: Fri, 30 Jan 2009 18:42:38 -0800
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
       alan@lxorguk.ukuu.org.uk, Clemens Ladisch <clemens@ladisch.de>,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 12/43] sound: virtuoso: enable UART on Xonar HDAV1.3
Message-ID: <20090131024238.GM12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sound-virtuoso-enable-uart-on-xonar-hdav1.3.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 22c733788bbd4b75c00279119a83da5cd74b987a upstream.

This hardware has a better chance of working correctly if we don't
forget to enable it.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/oxygen/virtuoso.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/oxygen/virtuoso.c
+++ b/sound/pci/oxygen/virtuoso.c
@@ -908,6 +908,7 @@ static const struct oxygen_model model_x
 	.dac_channels = 8,
 	.dac_volume_min = 0x0f,
 	.dac_volume_max = 0xff,
+	.misc_flags = OXYGEN_MISC_MIDI,
 	.function_flags = OXYGEN_FUNCTION_2WIRE,
 	.dac_i2s_format = OXYGEN_I2S_FORMAT_LJUST,
 	.adc_i2s_format = OXYGEN_I2S_FORMAT_LJUST,

