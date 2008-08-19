Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbYHSH4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbYHSH4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 03:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbYHSH4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 03:56:35 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38346 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbYHSH4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 03:56:35 -0400
Date: Tue, 19 Aug 2008 10:56:33 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: perex@perex.cz
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mpu401: reindent misindented spinlock
Message-ID: <Pine.LNX.4.64.0808191054210.4551@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-1656498423-1219132593=:4551"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-1656498423-1219132593=:4551
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT


Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
---
 sound/oss/mpu401.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/oss/mpu401.c b/sound/oss/mpu401.c
index a690ca5..6c0a770 100644
--- a/sound/oss/mpu401.c
+++ b/sound/oss/mpu401.c
@@ -1015,7 +1015,7 @@ int attach_mpu401(struct address_info *hw_config, struct module *owner)
 		mpu401_chk_version(m, devc);
 		if (devc->version == 0)
 			mpu401_chk_version(m, devc);
-			spin_unlock_irqrestore(&devc->lock,flags);
+		spin_unlock_irqrestore(&devc->lock, flags);
 	}
 
 	if (devc->version != 0)
-- 
1.5.2.2

---696208474-1656498423-1219132593=:4551--
