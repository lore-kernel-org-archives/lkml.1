Return-Path: <linux-kernel-owner+w=401wt.eu-S1762063AbYB1TMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762063AbYB1TMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760456AbYB1TLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:11:25 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:19675 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760302AbYB1TLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:11:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=B7NEPXuPG9e1V+020nZs/xVMD0HHrWypXZnLlz73W9OBSBlTOZfm2Ohyex+dQFPegu3iA8W1IaQ7yUv61fTOUNcHDNIZlso49Ev5eNIqR6jVoB6EpjkKb1emuUo5X1O/XK4syLkavSlwS5bl3LKRMWKAf6aRuh8B4oFybYK0NWQ=
Subject: [PATCH 8/8] sound: hdspm.c fix returning void expression warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 11:11:15 -0800
Message-Id: <1204225875.20280.89.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just drop the returns.
sound/pci/rme9652/hdspm.c:1031:3: warning: returning void-valued expression
sound/pci/rme9652/hdspm.c:1033:3: warning: returning void-valued expression

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/rme9652/hdspm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index 9a19ae6..38c931c 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -1028,9 +1028,9 @@ static inline void snd_hdspm_midi_write_byte (struct hdspm *hdspm, int id,
 {
 	/* the hardware already does the relevant bit-mask with 0xff */
 	if (id)
-		return hdspm_write(hdspm, HDSPM_midiDataOut1, val);
+		hdspm_write(hdspm, HDSPM_midiDataOut1, val);
 	else
-		return hdspm_write(hdspm, HDSPM_midiDataOut0, val);
+		hdspm_write(hdspm, HDSPM_midiDataOut0, val);
 }
 
 static inline int snd_hdspm_midi_input_available (struct hdspm *hdspm, int id)
-- 
1.5.4.3.342.g99e8

