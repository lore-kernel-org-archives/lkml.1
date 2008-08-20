Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbYHTCmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbYHTCmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 22:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbYHTCmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 22:42:36 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:41443 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbYHTCmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 22:42:36 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Blackfin: fix/update .gitignore files
Date: Tue, 19 Aug 2008 22:42:33 -0400
Message-Id: <1219200153-19398-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.5.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure what happened in previous .gitignore commit ... maybe it was a
double patch or something ?  At any rate, remove bogus leading "+".

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/boot/.gitignore   |    2 +-
 arch/blackfin/kernel/.gitignore |    1 +
 include/asm-blackfin/.gitignore |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)
 create mode 100644 arch/blackfin/kernel/.gitignore

diff --git a/arch/blackfin/boot/.gitignore b/arch/blackfin/boot/.gitignore
index 3ae0399..64386a8 100644
--- a/arch/blackfin/boot/.gitignore
+++ b/arch/blackfin/boot/.gitignore
@@ -1 +1 @@
-+vmImage
+vmImage
diff --git a/arch/blackfin/kernel/.gitignore b/arch/blackfin/kernel/.gitignore
new file mode 100644
index 0000000..c5f676c
--- /dev/null
+++ b/arch/blackfin/kernel/.gitignore
@@ -0,0 +1 @@
+vmlinux.lds
diff --git a/include/asm-blackfin/.gitignore b/include/asm-blackfin/.gitignore
index 7858564..fc6ac35 100644
--- a/include/asm-blackfin/.gitignore
+++ b/include/asm-blackfin/.gitignore
@@ -1 +1 @@
-+mach
+mach
-- 
1.5.6.1

