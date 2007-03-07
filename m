Return-Path: <linux-kernel-owner+w=401wt.eu-S1422743AbXCGR4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422743AbXCGR4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422774AbXCGROD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:14:03 -0500
Received: from mx1.suse.de ([195.135.220.2]:43500 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422750AbXCGRNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:13:49 -0500
Message-Id: <20070307171209.495799305@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:10:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@suse.cz>
Subject: [patch 016/101] hda-intel - Dont try to probe invalid codecs
Content-Disposition: inline; filename=hda-intel-don-t-try-to-probe-invalid-codecs.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ALSA] hda-intel - Don't try to probe invalid codecs

Fix the max number of codecs detected by HD-intel (and compatible)
controllers to 3.  Some hardware reports extra bits as if
connected, and the driver gets confused to probe unexisting codecs.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jaroslav Kysela <perex@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 sound/pci/hda/hda_intel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20.1.orig/sound/pci/hda/hda_intel.c
+++ linux-2.6.20.1/sound/pci/hda/hda_intel.c
@@ -199,7 +199,7 @@ enum { SDI0, SDI1, SDI2, SDI3, SDO0, SDO
 
 /* STATESTS int mask: SD2,SD1,SD0 */
 #define STATESTS_INT_MASK	0x07
-#define AZX_MAX_CODECS		4
+#define AZX_MAX_CODECS		3
 
 /* SD_CTL bits */
 #define SD_CTL_STREAM_RESET	0x01	/* stream reset bit */

--
