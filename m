Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbYKZTRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbYKZTRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 14:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbYKZTRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 14:17:10 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:27564 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbYKZTRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 14:17:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=H+rdQQQ35eKVAbF6T8afvTpHHZr8FUcdS66YOx46ArWBfOQYlujGP5L05e53sMgWgi
         k2aOE1YY3QPkTcHzaDZaQckmHe8t1oKgGvX/98qWc3vj3l/L/1uVXHIb5s8Mr1TxUNRL
         LFldQIp2iZuk74NMkAmiUMYppC0VUPk+KROqc=
From: gorcunov@gmail.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, heukelum@fastmail.fm,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 1/5] x86: entry_64.S - use ENTRY to define child_rip
Date: Wed, 26 Nov 2008 22:17:00 +0300
Message-Id: <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.4.603.gbc9c0
In-Reply-To: <1227727024-2281-1-git-send-email-gorcunov@gmail.com>
References: <1227727024-2281-1-git-send-email-gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

child_rip is called not by its name but indirectly
rather so make it global and aligned.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/entry_64.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 64688db..098ba0b 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1322,7 +1322,7 @@ ENTRY(kernel_thread)
 	CFI_ENDPROC
 END(kernel_thread)
 
-child_rip:
+ENTRY(child_rip)
 	pushq $0		# fake return address
 	CFI_STARTPROC
 	/*
-- 
1.6.0.4.603.gbc9c0

