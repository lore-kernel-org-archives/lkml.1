Return-Path: <linux-kernel-owner+w=401wt.eu-S1757770AbYHCQsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770AbYHCQsP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 12:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756440AbYHCQr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 12:47:59 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:35016 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277AbYHCQr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 12:47:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=CYHqCn2x7So8jlhNwSUJa79EL/WV0kR/ohkxUDuboWQxVPq15bsMF8pAA9iswAgKsI
         NAqtDlRMBxchwuzohzcUzdOaZTxJJhqfKoT7OxJvH/3GVClBOo3FSwc3EVZI2SDnDEBv
         qD8TpPdoTNiFw6YsHlBust2goJx/imvQLlRXk=
Date: Sun, 3 Aug 2008 18:47:23 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH] ALSA: pcm_native: remove unused label
Message-ID: <20080803164719.GA5414@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc warns about it:
sound/core/pcm_native.c: In function 'snd_pcm_fasync':
sound/core/pcm_native.c:3262: warning: label 'out' defined but not used

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>
---
 sound/core/pcm_native.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index c49b9d9..333cff6 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3259,7 +3259,6 @@ static int snd_pcm_fasync(int fd, struct file * file, int on)
 	runtime = substream->runtime;
 
 	err = fasync_helper(fd, file, on, &runtime->fasync);
-out:
 	unlock_kernel();
 	if (err < 0)
 		return err;
-- 
1.5.4.5

