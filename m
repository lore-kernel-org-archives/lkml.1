Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbXLJOAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbXLJOAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 09:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbXLJOA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 09:00:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45259 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbXLJOA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 09:00:27 -0500
Subject: [PATCH] Fix missing \n at checkpatch.pl
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andy Whitcroft <apw@shadowen.org>, Randy Dunlap <rdunlap@xenotime.net>,
       jschopp@austin.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 10 Dec 2007 12:00:07 -0200
Message-Id: <1197295207.5165.6.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix missing \n at checkpatch.pl

From: Mauro Carvalho Chehab <mchehab@infradead.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>


diff -r 4f5ded04887b -r af025fddc025 v4l/scripts/checkpatch.pl
--- a/v4l/scripts/checkpatch.pl	Mon Dec 10 11:55:54 2007 -0200
+++ b/v4l/scripts/checkpatch.pl	Mon Dec 10 11:56:37 2007 -0200
@@ -1074,7 +1074,7 @@ sub process {
 # 		}
 
 		if ($line =~ /\bLINUX_VERSION_CODE\b/) {
-			WARN("LINUX_VERSION_CODE should be avoided, code should be for the version to which it is merged" . $herecurr);
+			WARN("LINUX_VERSION_CODE should be avoided, code should be for the version to which it is merged\n" . $herecurr);
 		}
 
 # printk should use KERN_* levels.  Note that follow on printk's on the



