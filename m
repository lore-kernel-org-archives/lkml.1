Return-Path: <linux-kernel-owner+w=401wt.eu-S933665AbZINUJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933665AbZINUJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933216AbZINUJC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:09:02 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54137 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933556AbZINUIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:54 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 49/72] Blackfin: fix BF522/BF523 max VCO mixup
Date: Mon, 14 Sep 2009 16:07:53 -0400
Message-Id: <1252958896-25150-50-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BF522 and BF523 had their real max VCO values swapped.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 6040aad..8d6b5ae 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -574,8 +574,8 @@ config MAX_VCO_HZ
 	default 400000000 if BF514
 	default 400000000 if BF516
 	default 400000000 if BF518
-	default 600000000 if BF522
-	default 400000000 if BF523
+	default 400000000 if BF522
+	default 600000000 if BF523
 	default 400000000 if BF524
 	default 600000000 if BF525
 	default 400000000 if BF526
-- 
1.6.4.2

