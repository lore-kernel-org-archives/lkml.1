Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbYI3Xa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbYI3Xa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 19:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbYI3XaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 19:30:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:39997 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbYI3XaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 19:30:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=aJnye8HAtxtDlCKPOiDexX1Wfp55l0XaA5384v50e6ivdN3LQfQwVaotzDv6Bkwgic
         2oZLPd/9Y50mmCTiOMntpFEargiM0bYhMRPmsC+5B76toVNJQyXht5kcY3WZX1QhB1T1
         0LPFziJ9+EFFqhACBTIxSupOJ4YFQoqIaTKX8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 3/3] x86: change MTRR_SANITIZER to def_bool y
Date: Tue, 30 Sep 2008 16:29:40 -0700
Message-Id: <1222817380-29481-3-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1222817380-29481-1-git-send-email-yhlu.kernel@gmail.com>
References: <1222817380-29481-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -1243,7 +1243,7 @@ config MTRR
 	  See <file:Documentation/x86/mtrr.txt> for more information.
 
 config MTRR_SANITIZER
-	bool
+	def_bool y
 	prompt "MTRR cleanup support"
 	depends on MTRR
 	help
@@ -1254,7 +1254,7 @@ config MTRR_SANITIZER
 	  The largest mtrr entry size for a continous block can be set with
 	  mtrr_chunk_size.
 
-	  If unsure, say N.
+	  If unsure, say Y.
 
 config MTRR_SANITIZER_ENABLE_DEFAULT
 	int "MTRR cleanup enable value (0-1)"
