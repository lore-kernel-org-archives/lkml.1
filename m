Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbZFEIL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbZFEIL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755678AbZFEIFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:05:52 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37464 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167AbZFEIF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:28 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 15/62] Blackfin: set bf51x/bf52x to 0.0 rev by default and bf54x to 0.2
Date: Fri,  5 Jun 2009 04:04:24 -0400
Message-Id: <1244189111-19639-16-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the default revs based on what we actually support (bf54x-0.[01]
is too broken to use).

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 arch/blackfin/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 672b7b0..cea2bfd 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -263,8 +263,8 @@ config BF_REV_MAX
 
 choice
 	prompt "Silicon Rev"
-	default BF_REV_0_1 if (BF51x || BF52x || (BF54x && !BF54xM))
-	default BF_REV_0_2 if (BF534 || BF536 || BF537)
+	default BF_REV_0_0 if (BF51x || BF52x)
+	default BF_REV_0_2 if (BF534 || BF536 || BF537 || (BF54x && !BF54xM))
 	default BF_REV_0_3 if (BF531 || BF532 || BF533 || BF54xM || BF561)
 
 config BF_REV_0_0
-- 
1.6.3.1

