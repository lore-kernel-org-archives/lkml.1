Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbYJCP1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbYJCP1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbYJCP0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:26:04 -0400
Received: from tallyho.bytemark.co.uk ([80.68.81.166]:57497 "EHLO
	tallyho.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbYJCP0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:26:00 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 05/13] checkpatch: accept any sized le/be type
Date: Fri,  3 Oct 2008 16:25:46 +0100
Message-Id: <1223047554-31111-6-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.1.451.gc8d31
In-Reply-To: <1223047554-31111-1-git-send-email-apw@shadowen.org>
References: <1223047554-31111-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are likely going to have 24 bit types.  Expand the type matcher to match
any size.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 6eceda7..bb88df2 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -159,7 +159,7 @@ our @typeList = (
 	qr{float},
 	qr{double},
 	qr{bool},
-	qr{(?:__)?(?:u|s|be|le)(?:8|16|32|64)},
+	qr{(?:__)?(?:u|s|be|le)(?:\d|\d\d)},
 	qr{struct\s+$Ident},
 	qr{union\s+$Ident},
 	qr{enum\s+$Ident},
-- 
1.6.0.1.451.gc8d31

