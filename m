Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbZFEIGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbZFEIGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbZFEIF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:05:27 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37449 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbZFEIFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:16 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 02/62] Blackfin: add some help text to the EBIU_AMBCTL settings
Date: Fri,  5 Jun 2009 04:04:11 -0400
Message-Id: <1244189111-19639-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 arch/blackfin/Kconfig |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 3640cdc..6b97aa8 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -1011,21 +1011,34 @@ endmenu
 
 menu "EBIU_AMBCTL Control"
 config BANK_0
-	hex "Bank 0"
+	hex "Bank 0 (AMBCTL0.L)"
 	default 0x7BB0
+	help
+	  These are the low 16 bits of the EBIU_AMBCTL0 MMR which are
+	  used to control the Asynchronous Memory Bank 0 settings.
 
 config BANK_1
-	hex "Bank 1"
+	hex "Bank 1 (AMBCTL0.H)"
 	default 0x7BB0
 	default 0x5558 if BF54x
+	help
+	  These are the high 16 bits of the EBIU_AMBCTL0 MMR which are
+	  used to control the Asynchronous Memory Bank 1 settings.
 
 config BANK_2
-	hex "Bank 2"
+	hex "Bank 2 (AMBCTL1.L)"
 	default 0x7BB0
+	help
+	  These are the low 16 bits of the EBIU_AMBCTL1 MMR which are
+	  used to control the Asynchronous Memory Bank 2 settings.
 
 config BANK_3
-	hex "Bank 3"
+	hex "Bank 3 (AMBCTL1.H)"
 	default 0x99B3
+	help
+	  These are the high 16 bits of the EBIU_AMBCTL1 MMR which are
+	  used to control the Asynchronous Memory Bank 3 settings.
+
 endmenu
 
 config EBIU_MBSCTLVAL
-- 
1.6.3.1

