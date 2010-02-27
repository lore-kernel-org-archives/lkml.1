Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030514Ab0B0RBH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 12:01:07 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030445Ab0B0Q4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:56:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=x4MsO6mwMZ4a3nBQpmqps+ctCQhxPNJppMPUMsaWhheOgnOl4ewCEFX53Mb2BFEfLU
         g9wpRkW11W2Tza3BnDaQwGYhY5rPVKaySYSSv2MbPevpZxGHr4eBfYhoRvv0/QMg6UcU
         fdg8/UhoEs6Z8nXYmTm8HeCLWaJSjxavWv7eI=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       Daniel Mack <daniel@caiaq.de>, alsa-devel@alsa-project.org
Subject: [PATCH 48/66] sound/usb/caiaq/midi.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:29 +0100
Message-Id: <1267289508-31031-49-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sound/usb/caiaq/midi.h:6: ERROR: "foo* bar" should be "foo *bar"

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 sound/usb/caiaq/midi.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/usb/caiaq/midi.h b/sound/usb/caiaq/midi.h
index 9d16db0..380f984 100644
--- a/sound/usb/caiaq/midi.h
+++ b/sound/usb/caiaq/midi.h
@@ -3,6 +3,6 @@
 
 int snd_usb_caiaq_midi_init(struct snd_usb_caiaqdev *dev);
 void snd_usb_caiaq_midi_handle_input(struct snd_usb_caiaqdev *dev, int port, const char *buf, int len);
-void snd_usb_caiaq_midi_output_done(struct urb* urb);
+void snd_usb_caiaq_midi_output_done(struct urb *urb);
 
 #endif /* CAIAQ_MIDI_H */
-- 
1.7.0.90.g251a4

