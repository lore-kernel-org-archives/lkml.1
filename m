Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030352Ab0B0QyN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:54:13 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46242 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030343Ab0B0QyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:54:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=UoFDZyygqzMAXnVZb/Tn+ACPRlTcJx3VbZonM5TsqIEzswbtDNMxqG4TbMIawobWhF
         CtTXt8eUgKpaU47JUuphG1jaqJanYuwQKTmPTJaXF913sOV/oLfz5oRPGEJRaGsCyzxh
         crtPFr6ooeaWap3Cy1T1bmmELX5NjCjM12Zv4=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org
Subject: [PATCH 22/66] sound/oss/v_midi.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:03 +0100
Message-Id: <1267289508-31031-23-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sound/oss/v_midi.h:5: ERROR: code indent should use tabs where possible
sound/oss/v_midi.h:7: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 sound/oss/v_midi.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/oss/v_midi.h b/sound/oss/v_midi.h
index 1b86cb4..08e2185 100644
--- a/sound/oss/v_midi.h
+++ b/sound/oss/v_midi.h
@@ -2,9 +2,9 @@ typedef struct vmidi_devc {
 	   int dev;
 
 	/* State variables */
- 	   int opened;
+	   int opened;
 	   spinlock_t lock;
-	
+
 	/* MIDI fields */
 	   int my_mididev;
 	   int pair_mididev;
@@ -12,4 +12,3 @@ typedef struct vmidi_devc {
 	   int intr_active;
 	   void (*midi_input_intr) (int dev, unsigned char data);
 	} vmidi_devc;
-
-- 
1.7.0.90.g251a4

