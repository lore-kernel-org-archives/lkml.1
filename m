Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285Ab0AZXwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab0AZXwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754768Ab0AZXoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:44:00 -0500
Received: from kroah.org ([198.145.64.141]:35416 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692Ab0AZXn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:59 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:29 2010
Message-Id: <20100126233929.539417204@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>
Subject: [66/98] ALSA: hda - Add missing Line-Out and PCM switches as slave
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 23033b2bce4361f2859ee0331f97c9056dae7091 upstream.

Realtek codecs may have "PCM" and "Line-Out" playback switches, and
they can be slaves for vmaster.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2401,6 +2401,8 @@ static const char *alc_slave_sws[] = {
 	"Speaker Playback Switch",
 	"Mono Playback Switch",
 	"IEC958 Playback Switch",
+	"Line-Out Playback Switch",
+	"PCM Playback Switch",
 	NULL,
 };
 


