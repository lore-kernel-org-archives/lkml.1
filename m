Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbZK1IvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbZK1IvO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 03:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbZK1IvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 03:51:13 -0500
Received: from iksaif.net ([88.191.73.63]:47241 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104AbZK1IvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 03:51:11 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Brian Swetland <swetland@google.com>,
       Chih-Wei Huang <cwhuang@linux.org.tw>,
       LKML <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 2/2] staging/android: remove BROKEN flag
Date: Sat, 28 Nov 2009 09:45:15 +0100
Message-Id: <1259397915-762-3-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1259397915-762-2-git-send-email-corentincj@iksaif.net>
References: <1259397915-762-1-git-send-email-corentincj@iksaif.net>
 <1259397915-762-2-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/staging/android/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
index eb67563..2471949 100644
--- a/drivers/staging/android/Kconfig
+++ b/drivers/staging/android/Kconfig
@@ -2,7 +2,6 @@ menu "Android"
 
 config ANDROID
 	bool "Android Drivers"
-	depends on BROKEN
 	default N
 	---help---
 	  Enable support for various drivers needed on the Android platform
-- 
1.6.5.2

