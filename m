Return-Path: <linux-kernel-owner+w=401wt.eu-S1762834AbZBNBoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762834AbZBNBoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763437AbZBNBQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:50 -0500
Received: from kroah.org ([198.145.64.141]:50680 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762707AbZBNBQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:38 -0500
Date: Fri, 13 Feb 2009 17:13:40 -0800
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
Subject: [patch 40/48] ALSA: hda - Add missing terminator in slave dig-out
	array
Message-ID: <20090214011340.GO17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-add-missing-terminator-in-slave-dig-out-array.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 3a08e30de2facffe8e1a25bf4fa62cbc920fbaf6 upstream.

Added the missing terminator for ad1989b_slave_dig_outs[].

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_analog.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -1873,8 +1873,8 @@ static hda_nid_t ad1988_capsrc_nids[3] =
 #define AD1988_SPDIF_OUT_HDMI	0x0b
 #define AD1988_SPDIF_IN		0x07
 
-static hda_nid_t ad1989b_slave_dig_outs[2] = {
-	AD1988_SPDIF_OUT, AD1988_SPDIF_OUT_HDMI
+static hda_nid_t ad1989b_slave_dig_outs[] = {
+	AD1988_SPDIF_OUT, AD1988_SPDIF_OUT_HDMI, 0
 };
 
 static struct hda_input_mux ad1988_6stack_capture_source = {

