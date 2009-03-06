Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbZCFM3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbZCFM3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 07:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZCFM3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 07:29:32 -0500
Received: from 81-7-68-229.static.zebra.lt ([81.7.68.229]:59834 "EHLO
	teltonika.lt" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751497AbZCFM3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 07:29:32 -0500
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: [PATCH] Add documentation for "nohlt" kernel parameter
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-sh@vger.kernel.org
Cc: yanok@emcraft.com, wd@denx.de
Date: Fri, 06 Mar 2009 14:29:26 +0200
Message-ID: <20090306122925.9779.95415.stgit@Programuotojas>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per discussion in:
http://marc.info/?l=linux-arm-kernel&m=123633652517391&w=2

Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
---

 Documentation/kernel-parameters.txt |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)


diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 54f21a5..de06666 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1487,7 +1487,9 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	noclflush	[BUGS=X86] Don't use the CLFLUSH instruction
 
-	nohlt		[BUGS=ARM,SH]
+	nohlt		[BUGS=ARM,SH] Tells the kernel that the sleep(SH) or
+			wfi(ARM) instruction doesn't work correctly and not to
+			use it. This is also usefull when using JTAG debugger.
 
 	no-hlt		[BUGS=X86-32] Tells the kernel that the hlt
 			instruction doesn't work correctly and not to

