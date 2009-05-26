Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbZEZKKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbZEZKKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 06:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbZEZKKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 06:10:34 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:55220 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754251AbZEZKKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 06:10:34 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: rtc-linux@googlegroups.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH] drivers/char/rtc: disable legacy RTC driver on Blackfin systems
Date: Tue, 26 May 2009 06:10:33 -0400
Message-Id: <1243332633-15258-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Blackfin platforms do not support the hardware which this driver drives.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/char/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 735bbe2..2f7363d 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -794,7 +794,7 @@ if RTC_LIB=n
 config RTC
 	tristate "Enhanced Real Time Clock Support (legacy PC RTC driver)"
 	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV \
-			&& !ARM && !SUPERH && !S390 && !AVR32
+			&& !ARM && !SUPERH && !S390 && !AVR32 && !BLACKFIN
 	---help---
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you
-- 
1.6.3.1

