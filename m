Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbYB1A71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbYB1A71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761738AbYB1A43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:56:29 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:50062 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761569AbYB1A41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:56:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=a8EM+NAnd2HsffChmwFKHpg+wcw1wcyjOMqKfCa7kNqt9QVZJa0g0rxkKkcDXTUxqNR6SrVVSH5r+zzAVFsEJpfbxPIFwTC3wNpliWIQPrP1QmUfHh7IJ+4h87Nqg4CPXHtixB0e86B0RtDJv9zNSkHLQBw4+ApF/W9TcwW4OUI=
Subject: [PATCH 10/12] sound: au88x0_pcm.c fix integer as NULL pointer
	warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 16:56:08 -0800
Message-Id: <1204160169.20280.58.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sound/pci/au88x0/au88x0_pcm.c:508:15: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/au88x0/au88x0_pcm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/au88x0/au88x0_pcm.c b/sound/pci/au88x0/au88x0_pcm.c
index 526c6c5..232eb80 100644
--- a/sound/pci/au88x0/au88x0_pcm.c
+++ b/sound/pci/au88x0/au88x0_pcm.c
@@ -505,7 +505,7 @@ static int __devinit snd_vortex_new_pcm(vortex_t * chip, int idx, int nr)
 	int i;
 	int err, nr_capt;
 
-	if ((chip == 0) || (idx < 0) || (idx >= VORTEX_PCM_LAST))
+	if ((chip == NULL) || (idx < 0) || (idx >= VORTEX_PCM_LAST))
 		return -ENODEV;
 
 	/* idx indicates which kind of PCM device. ADB, SPDIF, I2S and A3D share the 
-- 
1.5.4.3.342.g99e8


