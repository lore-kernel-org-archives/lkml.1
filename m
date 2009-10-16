Return-Path: <linux-kernel-owner+w=401wt.eu-S932787AbZJPRVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787AbZJPRVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757251AbZJPRVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:21:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:40568 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbZJPRVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:21:49 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] powerpc: clean up sound/ppc/Kconfig
Date: Fri, 16 Oct 2009 12:21:38 -0500
Message-Id: <1255713699-21852-5-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1255713699-21852-4-git-send-email-galak@kernel.crashing.org>
References: <1255713699-21852-1-git-send-email-galak@kernel.crashing.org>
 <1255713699-21852-2-git-send-email-galak@kernel.crashing.org>
 <1255713699-21852-3-git-send-email-galak@kernel.crashing.org>
 <1255713699-21852-4-git-send-email-galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can replace PPC32 || PPC64 as a dependancy with just PPC as all
powerpc platforms (32-bit and 64-bit) define PPC now.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 sound/ppc/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/ppc/Kconfig b/sound/ppc/Kconfig
index bd2338a..0519c60 100644
--- a/sound/ppc/Kconfig
+++ b/sound/ppc/Kconfig
@@ -2,7 +2,7 @@
 
 menuconfig SND_PPC
 	bool "PowerPC sound devices"
-	depends on PPC64 || PPC32
+	depends on PPC
 	default y
 	help
 	  Support for sound devices specific to PowerPC architectures.
-- 
1.6.0.6

