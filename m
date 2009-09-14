Return-Path: <linux-kernel-owner+w=401wt.eu-S933803AbZINURZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933803AbZINURZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933562AbZINUIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:08:43 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54070 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933546AbZINUIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:38 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Barry Song <barry.song@analog.com>
Subject: [PATCH 30/72] Blackfin: bf538: add bfin_clear_PPI_STATUS() helper
Date: Mon, 14 Sep 2009 16:07:34 -0400
Message-Id: <1252958896-25150-31-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Song <barry.song@analog.com>

Add the bf538 version of bfin_clear_PPI_STATUS() to match all other ports.

Signed-off-by: Barry Song <barry.song@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf538/include/mach/cdefBF538.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/mach-bf538/include/mach/cdefBF538.h b/arch/blackfin/mach-bf538/include/mach/cdefBF538.h
index 99ca3f4..1de6751 100644
--- a/arch/blackfin/mach-bf538/include/mach/cdefBF538.h
+++ b/arch/blackfin/mach-bf538/include/mach/cdefBF538.h
@@ -1310,6 +1310,7 @@
 #define bfin_write_PPI_CONTROL(val)    bfin_write16(PPI_CONTROL, val)
 #define bfin_read_PPI_STATUS()         bfin_read16(PPI_STATUS)
 #define bfin_write_PPI_STATUS(val)     bfin_write16(PPI_STATUS, val)
+#define bfin_clear_PPI_STATUS()        bfin_read_PPI_STATUS()
 #define bfin_read_PPI_DELAY()          bfin_read16(PPI_DELAY)
 #define bfin_write_PPI_DELAY(val)      bfin_write16(PPI_DELAY, val)
 #define bfin_read_PPI_COUNT()          bfin_read16(PPI_COUNT)
-- 
1.6.4.2

