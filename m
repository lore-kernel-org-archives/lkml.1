Return-Path: <linux-kernel-owner+w=401wt.eu-S1759464AbZBYV3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464AbZBYV3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 16:29:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760303AbZBYV2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 16:28:52 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:41784 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606AbZBYV2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 16:28:51 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 3/7] sound/pci/hda: fix sparse warning: different signedness
To: Takashi Iwai <tiwai@suse.de>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Feb 2009 22:28:45 +0100
Message-ID: <20090225212834.9226.76824.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090225212551.9226.64699.stgit@vmbox.hanneseder.net>
References: <20090225212551.9226.64699.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:
  sound/pci/hda/hda_codec.c:1544:19: warning: incorrect type in assignment (different signedness)
  sound/pci/hda/hda_codec.c:1544:19:    expected unsigned long *vals
  sound/pci/hda/hda_codec.c:1544:19:    got long *<noident>

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 sound/pci/hda/hda_local.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/hda/hda_local.h b/sound/pci/hda/hda_local.h
index 4bd82a3..03ee9dd 100644
--- a/sound/pci/hda/hda_local.h
+++ b/sound/pci/hda/hda_local.h
@@ -136,7 +136,7 @@ extern struct hda_ctl_ops snd_hda_bind_sw;	/* for bind-switch */
 
 struct hda_bind_ctls {
 	struct hda_ctl_ops *ops;
-	long values[];
+	unsigned long values[];
 };
 
 int snd_hda_mixer_bind_ctls_info(struct snd_kcontrol *kcontrol,

