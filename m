Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbZEZJR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbZEZJR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 05:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbZEZJQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 05:16:02 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37419 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205AbZEZJQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 05:16:00 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 6/7] Blackfin: drop unneeded asm/.gitignore
Date: Tue, 26 May 2009 05:15:55 -0400
Message-Id: <1243329356-12644-7-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243329356-12644-1-git-send-email-vapier@gentoo.org>
References: <1243329356-12644-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't create a include/asm/mach/ symlink anymore, so we don't need the
.gitignore for it.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/.gitignore |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)
 delete mode 100644 arch/blackfin/include/asm/.gitignore

diff --git a/arch/blackfin/include/asm/.gitignore b/arch/blackfin/include/asm/.gitignore
deleted file mode 100644
index 7858564..0000000
--- a/arch/blackfin/include/asm/.gitignore
+++ /dev/null
@@ -1 +0,0 @@
-+mach
-- 
1.6.3.1

