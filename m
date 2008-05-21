Return-Path: <linux-kernel-owner+w=401wt.eu-S934213AbYEUBLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934213AbYEUBLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 21:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760528AbYEUBLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 21:11:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38124 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757488AbYEUBLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 21:11:37 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] msnd_* is ISA-only
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1Jycrh-0000J1-2f@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 02:11:37 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Content-Length: 1025
Lines: 30

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 sound/oss/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/oss/Kconfig b/sound/oss/Kconfig
index 857008b..3be2dc1 100644
--- a/sound/oss/Kconfig
+++ b/sound/oss/Kconfig
@@ -79,7 +79,7 @@ config SOUND_TRIDENT
 
 config SOUND_MSNDCLAS
 	tristate "Support for Turtle Beach MultiSound Classic, Tahiti, Monterey"
-	depends on SOUND_PRIME && (m || !STANDALONE)
+	depends on SOUND_PRIME && (m || !STANDALONE) && ISA
 	help
 	  Say M here if you have a Turtle Beach MultiSound Classic, Tahiti or
 	  Monterey (not for the Pinnacle or Fiji).
@@ -143,7 +143,7 @@ config MSNDCLAS_IO
 
 config SOUND_MSNDPIN
 	tristate "Support for Turtle Beach MultiSound Pinnacle, Fiji"
-	depends on SOUND_PRIME && (m || !STANDALONE)
+	depends on SOUND_PRIME && (m || !STANDALONE) && ISA
 	help
 	  Say M here if you have a Turtle Beach MultiSound Pinnacle or Fiji.
 	  See <file:Documentation/sound/oss/MultiSound> for important information
-- 
1.5.3.GIT


