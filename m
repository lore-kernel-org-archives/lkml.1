Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYL2Nzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYL2Nzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 08:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754993AbYL2NwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 08:52:01 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:36128 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbYL2Nvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 08:51:51 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH 01/13] m68k: fix recursive dependency in Kconfig
Date: Mon, 29 Dec 2008 14:53:11 +0100
Message-Id: <1230558803-7168-1-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081229134402.GA7069@uranus.ravnborg.org>
References: <20081229134402.GA7069@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We had a recursive dependency between MMU_MOTOROLA and MMU_SUN3
Fix it by dropping the unused dependencies on MMU_MOTOROLA.

MMU_MOTOROLA is set to y only using select so any dependencies
are anyway ignored.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 arch/m68k/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 836fb66..c825bde 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -280,7 +280,6 @@ config M68060
 
 config MMU_MOTOROLA
 	bool
-	depends on MMU && !MMU_SUN3
 
 config MMU_SUN3
 	bool
-- 
1.6.0.2.GIT

