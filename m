Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbYJVRdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbYJVRdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbYJVRct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:32:49 -0400
Received: from kroah.org ([198.145.64.141]:53003 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753208AbYJVRcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:32:47 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/42] Staging: W35UND should depend on USB
Date: Wed, 22 Oct 2008 10:28:43 -0700
Message-Id: <1224696563-5170-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081022172203.GA4000@kroah.com>
References: <20081022172203.GA4000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

W35UND should depend on USB

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/winbond/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/winbond/Kconfig b/drivers/staging/winbond/Kconfig
index 10d72be..425219e 100644
--- a/drivers/staging/winbond/Kconfig
+++ b/drivers/staging/winbond/Kconfig
@@ -1,6 +1,6 @@
 config W35UND
 	tristate "Winbond driver"
-	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL && !4KSTACKS
+	depends on MAC80211 && WLAN_80211 && USB && EXPERIMENTAL && !4KSTACKS
 	default n
 	---help---
 	  This is highly experimental driver for winbond wifi card on some Kohjinsha notebooks
-- 
1.6.0.2

