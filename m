Return-Path: <linux-kernel-owner+w=401wt.eu-S1758653AbYDAL6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653AbYDAL6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 07:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbYDAL6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 07:58:45 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48051 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbYDAL6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 07:58:44 -0400
Date: Tue, 1 Apr 2008 13:40:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@osdl.org>, Trivial patch monkey <trivial@kernel.org>
Cc: tiwai@suse.de, kernel list <linux-kernel@vger.kernel.org>, perex@perex.cz
Subject: fix comments in sound/core.h (fwd)
Message-ID: <20080401114011.GA10887@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do we have sound maintainers? Noone replies on trivial patches :-(.

							Pavel

----- Forwarded message from Pavel Machek <pavel@suse.cz> -----

From: Pavel Machek <pavel@suse.cz>
To: perex@perex.cz, kernel list <linux-kernel@vger.kernel.org>,
	Trivial patch monkey <trivial@kernel.org>, tiwai@suse.de
Subject: fix comments in sound/core.h
X-Warning: Reading this can be dangerous to your mental health.


Two sentences seem to be spliced into one in comment, fix that and fix
english. Also fix codingstyle.

Signed-off-by: Pavel Machek <pavel@suse.cz> 

diff --git a/include/sound/core.h b/include/sound/core.h
index 4fc0235..452000d 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -310,7 +310,7 @@ int snd_card_file_add(struct snd_card *c
 int snd_card_file_remove(struct snd_card *card, struct file *file);
 
 #ifndef snd_card_set_dev
-#define snd_card_set_dev(card,devptr) ((card)->dev = (devptr))
+#define snd_card_set_dev(card, devptr) ((card)->dev = (devptr))
 #endif
 
 /* device.c */
@@ -373,7 +373,7 @@ #ifdef CONFIG_SND_VERBOSE_PRINTK
  * snd_printd - debug printk
  * @fmt: format string
  *
- * Compiled only when Works like snd_printk() for debugging purpose.
+ * Works like snd_printk() for debugging purposes.
  * Ignored when CONFIG_SND_DEBUG is not set.
  */
 #define snd_printd(fmt, args...) \
@@ -417,7 +417,7 @@ #ifdef CONFIG_SND_DEBUG_DETECT
  * snd_printdd - debug printk
  * @format: format string
  *
- * Compiled only when Works like snd_printk() for debugging purpose.
+ * Works like snd_printk() for debugging purposes.
  * Ignored when CONFIG_SND_DEBUG_DETECT is not set.
  */
 #define snd_printdd(format, args...) snd_printk(format, ##args)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html


----- End forwarded message -----

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
