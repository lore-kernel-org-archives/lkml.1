Return-Path: <linux-kernel-owner+w=401wt.eu-S1760293AbYFLMsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760293AbYFLMsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757050AbYFLMr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:47:58 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2071 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374AbYFLMr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:47:57 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>, Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 16/23] checkpatch: correct spelling in kfree checks
Date: Thu, 12 Jun 2008 13:05:55 +0100
Message-Id: <1213272362-19457-17-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.rc0.140.ga9675
In-Reply-To: <1213272362-19457-1-git-send-email-apw@shadowen.org>
References: <1213272362-19457-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfram Sang <w.sang@pengutronix.de>

Correct spelling in the kfree reports.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index a4e8087..3961e75 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2075,7 +2075,7 @@ sub process {
 		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
 			my $expr = $1;
 			if ($line =~ /\bkfree\(\Q$expr\E\);/) {
-				WARN("kfree(NULL) is safe this check is probabally not required\n" . $hereprev);
+				WARN("kfree(NULL) is safe this check is probably not required\n" . $hereprev);
 			}
 		}
 # check for needless usb_free_urb() checks
-- 
1.5.6.rc0.140.ga9675

