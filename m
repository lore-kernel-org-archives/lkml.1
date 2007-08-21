Return-Path: <linux-kernel-owner+w=401wt.eu-S1760071AbXHUAiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071AbXHUAiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 20:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbXHUAiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 20:38:14 -0400
Received: from iona.labri.fr ([147.210.8.143]:44467 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbXHUAiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 20:38:13 -0400
Date: Tue, 21 Aug 2007 02:38:03 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: linux-input@atrey.karlin.mff.cuni.cz
Subject: [PATCH] 10-dots braille keyboards
Message-ID: <20070821003803.GB3658@interface.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	linux-input@atrey.karlin.mff.cuni.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some braille keyboards have 10 dots, so extend the Input braille keys
definitions.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

diff --git a/include/linux/input.h b/include/linux/input.h
index e02c6a6..17df5a7 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -552,6 +552,8 @@ struct input_absinfo {
 #define KEY_BRL_DOT6		0x1f6
 #define KEY_BRL_DOT7		0x1f7
 #define KEY_BRL_DOT8		0x1f8
+#define KEY_BRL_DOT9		0x1f9
+#define KEY_BRL_DOT10		0x1fa
 
 /* We avoid low common keys in module aliases so they don't get huge. */
 #define KEY_MIN_INTERESTING	KEY_MUTE
diff --git a/include/linux/keyboard.h b/include/linux/keyboard.h
index de76843..7ddbc30 100644
--- a/include/linux/keyboard.h
+++ b/include/linux/keyboard.h
@@ -437,8 +437,10 @@ extern unsigned short plain_map[NR_KEYS];
 #define K_BRL_DOT6      K(KT_BRL, 6)
 #define K_BRL_DOT7      K(KT_BRL, 7)
 #define K_BRL_DOT8      K(KT_BRL, 8)
+#define K_BRL_DOT9      K(KT_BRL, 9)
+#define K_BRL_DOT10     K(KT_BRL, 10)
 
-#define NR_BRL		9
+#define NR_BRL		11
 
 #define MAX_DIACR	256
 #endif
