Return-Path: <linux-kernel-owner+w=401wt.eu-S934371AbYEUAvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934371AbYEUAvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934084AbYEUAtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:49:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41627 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765844AbYEUAtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:49:03 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 6/6][uml] thanks to net/mac80211 we need to pull drivers/leds/Kconfig on uml
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
Message-Id: <E1JycVq-00068I-Ke@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 01:49:02 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Content-Length: 454
Lines: 21

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/um/Kconfig b/arch/um/Kconfig
index dba8e05..6976812 100644
--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -259,6 +259,8 @@ if BROKEN
 	source "drivers/mtd/Kconfig"
 endif
 
+source "drivers/leds/Kconfig"
+
 #This is just to shut up some Kconfig warnings, so no prompt.
 config INPUT
 	bool
-- 
1.5.3.GIT


