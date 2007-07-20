Return-Path: <linux-kernel-owner+w=401wt.eu-S1761625AbXGTDc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761625AbXGTDc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 23:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbXGTDct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 23:32:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35607 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbXGTDct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 23:32:49 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 1/8] m68k: teach modpost about .m68_fixup
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Message-Id: <E1IBjEW-0004k7-5t@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 20 Jul 2007 04:32:48 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 scripts/mod/modpost.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 04579a5..5ab7914 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1076,6 +1076,7 @@ static int initexit_section_ref_ok(const char *name)
 		".plt",			/* seen on ARCH=um build on x86_64. Harmless */
 		".smp_locks",
 		".stab",
+		".m68k_fixup",
 		NULL
 	};
 	/* Start of section names */
-- 
1.5.3.GIT


