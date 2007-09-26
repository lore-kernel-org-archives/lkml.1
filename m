Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbXIZAym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbXIZAym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 20:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbXIZAyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 20:54:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46704 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268AbXIZAyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 20:54:19 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] hibernation doesn't even build on frv - tons of helpers are missing
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Message-Id: <E1IaLAK-00085D-92@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 26 Sep 2007 01:54:12 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 kernel/power/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index c8580a1..14b0e10 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -110,7 +110,7 @@ config SUSPEND
 
 config HIBERNATION_UP_POSSIBLE
 	bool
-	depends on X86 || PPC64_SWSUSP || FRV || PPC32
+	depends on X86 || PPC64_SWSUSP || PPC32
 	depends on !SMP
 	default y
 
-- 
1.5.3.GIT


