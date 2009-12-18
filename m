Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbZLRRWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbZLRRWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbZLRRWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:22:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:3369 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbZLRRWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:22:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=N1wmY4g0IvfoR7waM5qqP+MtBesuEGwJrsyoAc4OttqHuhiUit6yxeOnLrTEp4g2L6
         Bt7cCjubnUbXMux3WRf7k2RaBGMsRdUy8PgXKdPI8xgil74rojOBnGGzj8H2Kz22DcLA
         oburNZqyDH3p1cTs+mJqbhFzc8m2UQWLv0yYw=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] Staging: vt665x depend on WIRELESS
Date: Fri, 18 Dec 2009 20:23:08 +0300
Message-Id: <1261156988-14346-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build error when NET or/and WIRELESS are not enabled.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/vt6655/Kconfig |    2 +-
 drivers/staging/vt6656/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/Kconfig b/drivers/staging/vt6655/Kconfig
index 825bbc4..6a186be 100644
--- a/drivers/staging/vt6655/Kconfig
+++ b/drivers/staging/vt6655/Kconfig
@@ -1,6 +1,6 @@
 config VT6655
    tristate "VIA Technologies VT6655 support"
-   depends on PCI
+   depends on PCI && WIRELESS
    select WIRELESS_EXT
    select WEXT_PRIV
    ---help---
diff --git a/drivers/staging/vt6656/Kconfig b/drivers/staging/vt6656/Kconfig
index 87bcd26..6fceae4 100644
--- a/drivers/staging/vt6656/Kconfig
+++ b/drivers/staging/vt6656/Kconfig
@@ -1,6 +1,6 @@
 config VT6656
 	tristate "VIA Technologies VT6656 support"
-	depends on USB
+	depends on USB && WIRELESS
 	select WIRELESS_EXT
 	select WEXT_PRIV
 	---help---
-- 
1.6.6.rc3

