Return-Path: <linux-kernel-owner+w=401wt.eu-S1756956AbYJQSbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956AbYJQSbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 14:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbYJQSbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 14:31:48 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:59786 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819AbYJQSbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 14:31:47 -0400
Message-ID: <48F8D93B.40601@oracle.com>
Date: Fri, 17 Oct 2008 11:28:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] sound: add missing pcm kernel-doc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix alsa kernel-doc warning in linux-next:

Warning(linux-next-20081016//sound/core/pcm_misc.c:327): No description found for parameter 'samples'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 sound/core/pcm_misc.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20081016.orig/sound/core/pcm_misc.c
+++ linux-next-20081016/sound/core/pcm_misc.c
@@ -319,6 +319,7 @@ EXPORT_SYMBOL(snd_pcm_format_physical_wi
 /**
  * snd_pcm_format_size - return the byte size of samples on the given format
  * @format: the format to check
+ * @samples: sampling rate
  *
  * Returns the byte size of the given samples for the format, or a
  * negative error code if unknown format.
