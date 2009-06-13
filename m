Return-Path: <linux-kernel-owner+w=401wt.eu-S1759328AbZFMMwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328AbZFMMwp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 08:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbZFMMwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 08:52:37 -0400
Received: from solo.fdn.fr ([80.67.169.19]:43684 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbZFMMwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 08:52:37 -0400
Date: Sat, 13 Jun 2009 14:52:33 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: akpm@linux-foundation.org, torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, Anton Zinoviev <anton@lml.bas.bg>
Subject: [PATCH] advertise KT_DEAD2
Message-ID: <20090613125233.GH5181@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	akpm@linux-foundation.org, torvalds@osdl.org,
	linux-kernel@vger.kernel.org, Anton Zinoviev <anton@lml.bas.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In addition to KT_DEAD which has limited support for diacriticals, there
is KT_DEAD2 that can support 256 criticals, so let's advertise it in
<linux/keyboard.h>.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

diff --git a/include/linux/keyboard.h b/include/linux/keyboard.h
index a3c984d..33a63f6 100644
--- a/include/linux/keyboard.h
+++ b/include/linux/keyboard.h
@@ -56,6 +56,7 @@ extern int unregister_keyboard_notifier(struct notifier_block *nb);
 #define KT_ASCII	9
 #define KT_LOCK		10
 #define KT_SLOCK	12
+#define KT_DEAD2	13
 #define KT_BRL		14
 
 #define K(t,v)		(((t)<<8)|(v))
