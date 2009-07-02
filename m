Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbZGBPYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbZGBPYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750864AbZGBPYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:24:13 -0400
Received: from ey-out-1920.google.com ([74.125.78.150]:9709 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbZGBPYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:24:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mg9CkSVZeZbk3A91MmHVYnKE+dKpwHv610CUUn7Ae5fJ91dfjCDINjWjzVrd//gVhI
         Ala8di2X4diqGQFnMoTNi+QulEMvtcs6tSTIi0D76WUZPDUOB+PQfs0Vbh1yKbirO3ky
         Z2XsCO/PKTiez7pb51Z7sIRqD8zSnZxDwk5G4=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       ralf@linux-mips.org
Cc: Wu Zhangjin <wuzj@lemote.com>, Yan Hua <yanh@lemote.com>,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Zhang Fuxin <zhangfx@lemote.com>,
       loongson-dev <loongson-dev@googlegroups.com>,
       Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>,
       Arnaud Patard <apatard@mandriva.com>
Subject: [PATCH v4 10/16] [loongson] rtc: enable legacy RTC driver on fulong
Date: Thu,  2 Jul 2009 23:24:01 +0800
Message-Id: <a9d4b1b8e508b28b93ba03fbeef161bc3ac3ff86.1246546684.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cover.1246546684.git.wuzhangjin@gmail.com>
References: <cover.1246546684.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzj@lemote.com>

RTC_LIB is selected by MIPS by default, and therefore, the legacy RTC
driver is disabled. but fortunately, RTC_LIB not works on fulong, so,
enabling the legcy RTC driver is needed, otherwise, the tools like
hwclock will not work.

Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 arch/mips/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 3ca0fe1..a383dac 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -6,7 +6,7 @@ config MIPS
 	select HAVE_ARCH_KGDB
 	# Horrible source of confusion.  Die, die, die ...
 	select EMBEDDED
-	select RTC_LIB
+	select RTC_LIB if !LEMOTE_FULONG
 
 mainmenu "Linux/MIPS Kernel Configuration"
 
-- 
1.6.2.1

