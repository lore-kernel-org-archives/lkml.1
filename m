Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbZFTSsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbZFTSsF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757539AbZFTSqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:46:13 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48084 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757826AbZFTSqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:46:12 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 11/25] Blackfin: allow people to select BF51x-0.1 silicon rev
Date: Sat, 20 Jun 2009 14:44:34 -0400
Message-Id: <1245523488-26536-12-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
References: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that 0.1 of the BF51x is coming out, allow people to build for it.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 8ea0d94..c2c4a62 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -274,7 +274,7 @@ config BF_REV_0_0
 
 config BF_REV_0_1
 	bool "0.1"
-	depends on (BF52x || (BF54x && !BF54xM))
+	depends on (BF51x || BF52x || (BF54x && !BF54xM))
 
 config BF_REV_0_2
 	bool "0.2"
-- 
1.6.3.1

