Return-Path: <linux-kernel-owner+w=401wt.eu-S1758108AbZBYV1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbZBYV1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 16:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbZBYV04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 16:26:56 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:55078 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760851AbZBYV0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 16:26:55 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 1/7] sound/usb/usx2y: fix sparse warning: Should it be static?
To: Takashi Iwai <tiwai@suse.de>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Feb 2009 22:26:48 +0100
Message-ID: <20090225212642.9226.10782.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090225212551.9226.64699.stgit@vmbox.hanneseder.net>
References: <20090225212551.9226.64699.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Move declaration to header file.

Fix this sparse warning:
  sound/usb/usx2y/usx2yhwdeppcm.c:739:5: warning: symbol 'usX2Y_hwdep_pcm_new' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 sound/usb/usx2y/usX2Yhwdep.c    |    3 ---
 sound/usb/usx2y/usx2yhwdeppcm.h |    2 ++
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/usb/usx2y/usX2Yhwdep.c b/sound/usb/usx2y/usX2Yhwdep.c
index a26d8d8..4af8740 100644
--- a/sound/usb/usx2y/usX2Yhwdep.c
+++ b/sound/usb/usx2y/usX2Yhwdep.c
@@ -30,9 +30,6 @@
 #include "usbusx2y.h"
 #include "usX2Yhwdep.h"
 
-int usX2Y_hwdep_pcm_new(struct snd_card *card);
-
-
 static int snd_us428ctls_vm_fault(struct vm_area_struct *area,
 				  struct vm_fault *vmf)
 {
diff --git a/sound/usb/usx2y/usx2yhwdeppcm.h b/sound/usb/usx2y/usx2yhwdeppcm.h
index c3382fd..9c4fb84 100644
--- a/sound/usb/usx2y/usx2yhwdeppcm.h
+++ b/sound/usb/usx2y/usx2yhwdeppcm.h
@@ -18,3 +18,5 @@ struct snd_usX2Y_hwdep_pcm_shm {
 	volatile unsigned captured_iso_frames;
 	int capture_iso_start;
 };
+
+int usX2Y_hwdep_pcm_new(struct snd_card *card);

