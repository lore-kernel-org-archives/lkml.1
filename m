Return-Path: <linux-kernel-owner+w=401wt.eu-S933476AbZHWJIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476AbZHWJIE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 05:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933413AbZHWJID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 05:08:03 -0400
Received: from jack.hrz.tu-chemnitz.de ([134.109.132.46]:36509 "EHLO
	jack.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933398AbZHWJIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 05:08:02 -0400
From: Tobias Doerffel <tobias.doerffel@gmail.com>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Cc: Tobias Doerffel <tobias.doerffel@gmail.com>
Subject: [PATCH] x86: default X86_L1_CACHE_BYTES to 64 with MATOM
Date: Sun, 23 Aug 2009 11:07:37 +0200
Message-Id: <1251018457-19157-1-git-send-email-tobias.doerffel@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090823074831.GA32477@elte.hu>
References: <20090823074831.GA32477@elte.hu>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: e90a451e269f6704296cddf3d75231cf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building for Intel Atom/x86_64 no default value was set for
X86_L1_CACHE_BYTES causing a compile failure. Defaulting it to 64 fixes
the issue.
---
 arch/x86/Kconfig.cpu |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 8dba407..527519b 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -304,7 +304,7 @@ config X86_CPU
 config X86_L1_CACHE_BYTES
 	int
 	default "128" if MPSC
-	default "64" if GENERIC_CPU || MK8 || MCORE2 || X86_32
+	default "64" if GENERIC_CPU || MK8 || MCORE2 || MATOM || X86_32
 
 config X86_INTERNODE_CACHE_BYTES
 	int
-- 
1.6.3.3

